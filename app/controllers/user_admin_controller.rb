class UserAdminController < ApplicationController

  include MailHelperMethods

  before_filter :admin_authorization

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, 
                                      :create, :create_from_list, 
                                      :update, 
                                      :manage_contest, 
                                      :bulk_mail 
                                    ],
         :redirect_to => { :action => :list }

  def list
    @user_count = User.count
    if params[:page] == 'all'
      @users = User.all
      @paginated = false
    else
      @users = User.paginate :page => params[:page]
      @paginated = true
    end
    @hidden_columns = ['hashed_password', 'salt', 'created_at', 'updated_at']
    @contests = Contest.enabled
  end

  def active
    sessions = ActiveRecord::SessionStore::Session.find(:all, :conditions => ["updated_at >= ?", 60.minutes.ago])
    @users = []
    sessions.each do |session|
      if session.data[:user_id]
        @users << User.find(session.data[:user_id])
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.activated = true
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end    
  end

  def create_from_list
    lines = params[:user_list]

    note = []

    lines.split("\n").each do |line|
      items = line.chomp.split(',')
      if items.length>=2
        login = items[0]
        full_name = items[1]

        added_random_password = false
        if items.length>=3
          password = items[2].chomp(" ")
          user_alias = (items.length>=4) ? items[3] : login
        else
          password = random_password
          user_alias = (items.length>=4) ? items[3] : login
          added_random_password = true
        end

        user = User.new({:login => login,
                          :full_name => full_name,
                          :password => password,
                          :password_confirmation => password,
                          :alias => user_alias})
        user.activated = true
        user.save

        if added_random_password
          note << "'#{login}' (+)"
        else
          note << login
        end
      end
    end
    flash[:notice] = 'User(s) ' + note.join(', ') + 
      ' were successfully created.  ' +
      '( (+) - created with random passwords.)'   
    redirect_to :action => 'list'
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def user_stat
    @problems = Problem.find_available_problems
    @users = User.find(:all, :include => [:contests, :contest_stat])
    @scorearray = Array.new
    @users.each do |u|
      ustat = Array.new
      ustat[0] = u
      @problems.each do |p|
	sub = Submission.find_last_by_user_and_problem(u.id,p.id)
	if (sub!=nil) and (sub.points!=nil) 
	  ustat << [(sub.points.to_f*100/p.full_score).round, (sub.points>=p.full_score)]
	else
	  ustat << [0,false]
	end
      end
      @scorearray << ustat
    end
  end

  def import
    if params[:file]==''
      flash[:notice] = 'Error importing no file'
      redirect_to :action => 'list' and return
    end
    import_from_file(params[:file])
  end

  def random_all_passwords
    users = User.find(:all)
    @prefix = params[:prefix] || ''
    @non_admin_users = User.find_non_admin_with_prefix(@prefix)
    @changed = false
    if request.request_method == :post
      @non_admin_users.each do |user|
        password = random_password
        user.password = password
        user.password_confirmation = password
        user.save
      end
      @changed = true
    end
  end
  
  # contest management

  def contests
    @contest, @users = find_contest_and_user_from_contest_id(params[:id])
    @contests = Contest.enabled
  end

  def assign_from_list
    contest_id = params[:users_contest_id]
    org_contest, users = find_contest_and_user_from_contest_id(contest_id)
    contest = Contest.find(params[:new_contest][:id])
    if !contest
      flash[:notice] = 'Error: no contest'
      redirect_to :action => 'contests', :id =>contest_id
    end

    note = []
    users.each do |u|
      u.contests = [contest]
      note << u.login
    end
    flash[:notice] = 'User(s) ' + note.join(', ') + 
      " were successfully reassigned to #{contest.title}." 
    redirect_to :action => 'contests', :id =>contest.id
  end

  def add_to_contest
    user = User.find(params[:id])
    contest = Contest.find(params[:contest_id])
    if user and contest
      user.contests << contest
    end
    redirect_to :action => 'list'
  end

  def remove_from_contest
    user = User.find(params[:id])
    contest = Contest.find(params[:contest_id])
    if user and contest
      user.contests.delete(contest)
    end
    redirect_to :action => 'list'
  end

  def contest_management
  end

  def manage_contest
    contest = Contest.find(params[:contest][:id])
    if !contest
      flash[:notice] = 'You did not choose the contest.'
      redirect_to :action => 'contest_management' and return
    end

    operation = params[:operation]

    if not ['add','remove','assign'].include? operation
      flash[:notice] = 'You did not choose the operation to perform.'
      redirect_to :action => 'contest_management' and return
    end

    lines = params[:login_list]
    if !lines or lines.blank?
      flash[:notice] = 'You entered an empty list.'
      redirect_to :action => 'contest_management' and return
    end

    note = []
    users = []
    lines.split("\n").each do |line|
      user = User.find_by_login(line.chomp)
      if user
        if operation=='add'
          if ! user.contests.include? contest
            user.contests << contest
          end
        elsif operation=='remove'
          user.contests.delete(contest)
        else
          user.contests = [contest]
        end

        if params[:reset_timer]
          user.contest_stat.forced_logout = true
          user.contest_stat.reset_timer_and_save
        end

        if params[:notification_emails]
          send_contest_update_notification_email(user, contest) 
        end

        note << user.login
        users << user
      end
    end

    if params[:reset_timer]
      logout_users(users)
    end

    flash[:notice] = 'User(s) ' + note.join(', ') + 
      ' were successfully modified.  ' 
    redirect_to :action => 'contest_management'    
  end

  # admin management

  def admin
    @admins = User.find(:all).find_all {|user| user.admin? }
  end

  def grant_admin
    login = params[:login]
    user = User.find_by_login(login)
    if user!=nil
      admin_role = Role.find_by_name('admin')
      user.roles << admin_role
    else
      flash[:notice] = 'Unknown user'
    end
    flash[:notice] = 'User added as admins'
    redirect_to :action => 'admin'
  end

  def revoke_admin
    user = User.find(params[:id])
    if user==nil
      flash[:notice] = 'Unknown user'
      redirect_to :action => 'admin' and return
    elsif user.login == 'root'
      flash[:notice] = 'You cannot revoke admisnistrator permission from root.'
      redirect_to :action => 'admin' and return
    end

    admin_role = Role.find_by_name('admin')
    user.roles.delete(admin_role)
    flash[:notice] = 'User permission revoked'
    redirect_to :action => 'admin'
  end

  # mass mailing

  def mass_mailing
  end

  def bulk_mail
    lines = params[:login_list]
    if !lines or lines.blank?
      flash[:notice] = 'You entered an empty list.'
      redirect_to :action => 'mass_mailing' and return
    end

    subject = params[:subject]
    if !subject or subject.blank?
      flash[:notice] = 'You entered an empty mail subject.'
      redirect_to :action => 'mass_mailing' and return
    end

    body = params[:email_body]
    if !body or body.blank?
      flash[:notice] = 'You entered an empty mail body.'
      redirect_to :action => 'mass_mailing' and return
    end

    note = []
    users = []
    lines.split("\n").each do |line|
      user = User.find_by_login(line.chomp)
      if user
        send_mail(user.email, subject, body)
        note << user.login
      end
    end
    
    flash[:notice] = 'User(s) ' + note.join(', ') + 
      ' were successfully modified.  ' 
    redirect_to :action => 'mass_mailing'
  end

  protected

  def random_password(length=5)
    chars = 'abcdefghijkmnopqrstuvwxyz23456789'
    newpass = ""
    length.times { newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def import_from_file(f)
    data_hash = YAML.load(f)
    @import_log = ""

    country_data = data_hash[:countries]
    site_data = data_hash[:sites]
    user_data = data_hash[:users]

    # import country
    countries = {}
    country_data.each_pair do |id,country|
      c = Country.find_by_name(country[:name])
      if c!=nil
        countries[id] = c
        @import_log << "Found #{country[:name]}\n"
      else
        countries[id] = Country.new(:name => country[:name])
        countries[id].save
        @import_log << "Created #{country[:name]}\n"
      end
    end

    # import sites
    sites = {}
    site_data.each_pair do |id,site|
      s = Site.find_by_name(site[:name])
      if s!=nil
        @import_log << "Found #{site[:name]}\n"
      else
        s = Site.new(:name => site[:name])
        @import_log << "Created #{site[:name]}\n"
      end
      s.password = site[:password]
      s.country = countries[site[:country_id]]
      s.save
      sites[id] = s
    end

    # import users
    user_data.each_pair do |id,user|
      u = User.find_by_login(user[:login])
      if u!=nil
        @import_log << "Found #{user[:login]}\n"
      else
        u = User.new(:login => user[:login])
        @import_log << "Created #{user[:login]}\n"
      end
      u.full_name = user[:name]
      u.password = user[:password]
      u.country = countries[user[:country_id]]
      u.site = sites[user[:site_id]]
      u.activated = true
      u.email = "empty-#{u.login}@none.com"
      if not u.save
        @import_log << "Errors\n"
        u.errors.each { |attr,msg|  @import_log << "#{attr} - #{msg}\n" } 
      end
    end

  end

  def logout_users(users)
    users.each do |user|
      contest_stat = user.contest_stat(true)
      if contest_stat and !contest_stat.forced_logout
        contest_stat.forced_logout = true
        contest_stat.save
      end
    end
  end

  def send_contest_update_notification_email(user, contest)
    contest_title_name = Configuration['contest.name']
    contest_name = contest.name
    subject = t('contest.notification.email_subject', {
                  :contest_title_name => contest_title_name,
                  :contest_name => contest_name })
    body = t('contest.notification.email_body', {
               :full_name => user.full_name,
               :contest_title_name => contest_title_name,
               :contest_name => contest.name,
             })

    logger.info body
    send_mail(user.email, subject, body)
  end

  def find_contest_and_user_from_contest_id(id)
    if id!='none'
      @contest = Contest.find(id)
    else
      @contest = nil
    end
    if @contest
      @users = @contest.users
    else
      @users = User.find_users_with_no_contest
    end
    return [@contest, @users]
  end
end
