class SubmissionsController < ApplicationController
  before_action :check_valid_login
  before_action :submission_authorization, only: [:show, :download, :edit]
  before_action :admin_authorization, only: [:rejudge]

  # GET /submissions
  # GET /submissions.json
  # Show problem selection and user's submission of that problem
  def index
    @user = @current_user
    @problems = @user.available_problems

    if params[:problem_id]==nil
      @problem = nil
      @submissions = nil
    else
      @problem = Problem.find_by_id(params[:problem_id])
      if (@problem == nil) or (not @problem.available)
        redirect_to list_main_path
        flash[:notice] = 'Error: submissions for that problem are not viewable.'
        return
      end
      @submissions = Submission.find_all_by_user_problem(@user.id, @problem.id).order(id: :desc)
    end
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @submission = Submission.find(params[:id])

    #log the viewing
    user = User.find(session[:user_id])
    SubmissionViewLog.create(user_id: session[:user_id],submission_id: @submission.id) unless user.admin?

    @task = @submission.task
  end

  def download
    @submission = Submission.find(params[:id])
    send_data(@submission.source, {:filename => @submission.download_filename, :type => 'text/plain'})
  end

  def compiler_msg
    @submission = Submission.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  #on-site new submission on specific problem
  def direct_edit_problem
    @problem = Problem.find(params[:problem_id])
    unless @current_user.can_view_problem?(@problem)
      unauthorized_redirect
      return
    end
    @source = ''
    if (params[:view_latest])
      sub = Submission.find_last_by_user_and_problem(@current_user.id,@problem.id)
      @source = @submission.source.to_s if @submission and @submission.source
    end
    render 'edit'
  end

  # GET /submissions/1/edit
  def edit
    @submission = Submission.find(params[:id])
    @source = @submission.source.to_s
    @problem = @submission.problem
    @lang_id = @submission.language.id
  end


  def get_latest_submission_status
    @problem = Problem.find(params[:pid])
    @submission = Submission.find_last_by_user_and_problem(params[:uid],params[:pid])
    respond_to do |format|
      format.js
    end
  end

  # GET /submissions/:id/rejudge
  def rejudge
    @submission = Submission.find(params[:id])
    @task = @submission.task
    @task.status_inqueue! if @task
    respond_to do |format|
      format.js
    end
  end

protected

  def submission_authorization
    #admin always has privileged
    if @current_user.admin?
      return true
    end

    sub = Submission.find(params[:id])
    if @current_user.available_problems.include? sub.problem
      return true if GraderConfiguration["right.user_view_submission"] or sub.user == @current_user
    end

    #default to NO
    unauthorized_redirect
    return false
  end

    
end
