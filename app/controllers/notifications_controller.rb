class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:readNotification]
  before_action :authenticate, only: [:index, :getNotifications, :alertNotification, :readNotification, :getAllNotifications, :show, :edit, :update, :destroy, :new, :process_leave_grp]

  def index
    @all_notifications = @current_user.notifications.order(:id)
    @all_notifications.each do |notification|
      notification.update_attribute(:status, true)
    end
  end

  def getNotifications
    @user_notifications = @current_user.notifications.order(:id)
  end

  def getAllNotifications
    @all_notifications = @current_user.notifications.order(:id)
  end

  def alertNotification
    @user_notifications = @current_user.notifications.order(:id)
    @alert = false
    @user_notifications.each do |notification|
      if notification.status == false
        @alert = true
      end
    end
  end

  def readNotification
    respond_to do |format|
      format.js { render nothing: true }

      @updatenotification = Notification.where(:id => params[:notification_id]).take
      @updatenotification.update_attribute(:status ,true)
    end
  end

  def authenticate
    token = session[:current_user_token]
    @user_login = UserLogin.where('token = (?)', token).take
    if @user_login == nil
      respond_to do |format|
        format.html { redirect_to new_user_login_path, notice: '' }
      end
    else
      @current_user = User.where(:email => @user_login.email).take
      @user_notifications = @current_user.notifications.order(:id)
      alertNotification
    end
  end
end
