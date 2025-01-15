class ConfigurationsController < ApplicationController

  before_action :admin_authorization

  def index
    @configurations = GraderConfiguration.order(:key)
    @group = GraderConfiguration.pluck("grader_configurations.key").map{ |x| x[0...(x.index('.'))] }.uniq.sort
  end

  def reload
    GraderConfiguration.reload
    redirect_to :action => 'index'
  end

  def update
    @config = GraderConfiguration.find(params[:id])
    User.clear_last_login if @config.key == GraderConfiguration::MULTIPLE_IP_LOGIN_KEY and @config.value == 'true' and params[:grader_configuration][:value] == 'false'
    respond_to do |format|
      if @config.update(configuration_params)
        format.json { head :ok }
      else
        format.json { respond_with_bip(@config) }
      end
    end
  end

  def set_exam_right
    value = params[:value] || 'false'
    GraderConfiguration.where(key: "right.bypass_agreement").update(value: value);
    GraderConfiguration.where(key: "right.multiple_ip_login").update(value: value);
    GraderConfiguration.where(key: "right.user_hall_of_fame").update(value: value);
    GraderConfiguration.where(key: "right.user_view_submission ").update(value: value);
    GraderConfiguration.where(key: "right.view_testcase ").update(value: value);
    redirect_to :action => 'index'
  end

private
  def configuration_params
    params.require(:grader_configuration).permit(:key,:value_type,:value,:description)
  end

end
