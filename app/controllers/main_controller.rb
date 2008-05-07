class MainController < ApplicationController

  SYSTEM_MODE_CONF_KEY = 'system.mode'

  before_filter :authenticate, :except => [:index, :login]
  before_filter :check_viewability, :except => [:index, :login]

#
#  COMMENT OUT: filter in each action instead
#
#  before_filter :verify_time_limit, :only => [:submit]

  verify :method => :post, :only => [:submit],
         :redirect_to => { :action => :index }


  def index
    redirect_to :action => 'login'
  end

  def login
    saved_notice = flash[:notice]
    reset_session
    flash[:notice] = saved_notice

    #
    # These are for site administrator login
    #
    @countries = Country.find(:all)
    @country_select = @countries.collect { |c| [c.name, c.id] }

    @country_select_with_all = [['Any',0]]
    @countries.each do |country|
      @country_select_with_all << [country.name, country.id]
    end

    @site_select = []
    @countries.each do |country|
      country.sites.each do |site|
        @site_select << ["#{site.name}, #{country.name}", site.id]
      end
    end

    render :action => 'login', :layout => 'empty'
  end

  def list
    prepare_list_information
  end

  def help
    @user = User.find(session[:user_id])
  end

  def submit
    user = User.find(session[:user_id])

    @submission = Submission.new(params[:submission])
    @submission.user = user
    @submission.language_id = 0
    if params['file']!=''
      @submission.source = params['file'].read 
      @submission.source_filename = params['file'].original_filename
    end
    @submission.submitted_at = Time.new.gmtime

    if Configuration[SYSTEM_MODE_CONF_KEY]=='contest' and
        user.site!=nil and user.site.finished?
      @submission.errors.add_to_base "The contest is over."
      prepare_list_information
      render :action => 'list' and return
    end

    if @submission.valid?
      if @submission.save == false
	flash[:notice] = 'Error saving your submission'
      elsif Task.create(:submission_id => @submission.id, 
                        :status => Task::STATUS_INQUEUE) == false
	flash[:notice] = 'Error adding your submission to task queue'
      end
    else
      prepare_list_information
      render :action => 'list' and return
    end
    redirect_to :action => 'list'
  end

  def source
    submission = Submission.find(params[:id])
    if submission.user_id == session[:user_id]
      if submission.problem.output_only
        fname = submission.source_filename
      else
        fname = submission.problem.name + '.' + submission.language.ext
      end
      send_data(submission.source, 
		{:filename => fname, 
                  :type => 'text/plain'})
    else
      flash[:notice] = 'Error viewing source'
      redirect_to :action => 'list'
    end
  end

  def compiler_msg
    @submission = Submission.find(params[:id])
    if @submission.user_id == session[:user_id]
      render :action => 'compiler_msg', :layout => 'empty'
    else
      flash[:notice] = 'Error viewing source'
      redirect_to :action => 'list'
    end
  end

  def submission
    @user = User.find(session[:user_id])
    @problems = Problem.find_available_problems
    if params[:id]==nil
      @problem = nil
      @submissions = nil
    else
      @problem = Problem.find_by_name(params[:id])
      @submissions = Submission.find_all_by_user_problem(@user.id, @problem.id)
    end
  end

  def error
    @user = User.find(session[:user_id])
  end

  protected
  def prepare_list_information
    @problems = Problem.find_available_problems
    @prob_submissions = Array.new
    @user = User.find(session[:user_id])
    @problems.each do |p|
      sub = Submission.find_last_by_user_and_problem(@user.id,p.id)
      if sub!=nil
        @prob_submissions << { :count => sub.number, :submission => sub }
      else
        @prob_submissions << { :count => 0, :submission => nil }
      end
    end

    @announcements = Announcement.find(:all,
                                       :conditions => "published = 1",
                                       :order => "created_at DESC")
  end

  def check_viewability
    user = User.find(session[:user_id])
    if (!Configuration.show_tasks_to?(user)) and
        ((action_name=='submission') or (action_name=='submit'))
      redirect_to :action => 'list' and return
    end
  end

end

