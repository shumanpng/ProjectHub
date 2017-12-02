class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :vote_for_points]
  before_action :authenticate, only: [:index, :show, :edit, :update, :destroy, :new, :vote_for_points]


  # GET /tasks
  # GET /tasks.json
  def index
    groupid = params[:groupid]
    groupname = params[:groupname]
    @group = Group.where(name: groupname).take
    @grouptasks = Task.where(group: groupname)
    @users = User.all
    # @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @comments = TaskComment.where(task_id: params[:id]).order(:id)
    #@isadmin = GroupMembership.where(group_id: params[:groupid], is_admin: true)
    # groupid = params[:groupid]
    #
    # # @task = Task.select("title, description, created_by, due_date, points, group,
    # #   state, task_type").where(:group_id => groupid)
    # @task = Task.where(group_id: groupid)

    # new task comment
    @task_comment = TaskComment.new()

    # find current group
    @group = Group.where(:name => @task.group).take
  end

  # GET /tasks/new
  def new
    groupname = params[:groupname]
    groupid = params[:groupid]
    # @groupmemberships = GroupMembership.where(:group_id => groupid)

    # @group = Group.where(name: groupname).take
    # @group = Group.find params[:groupname]
    # @task = Task.new({:group_id => '1', :group => 'CMPT276'})
    @group = Group.where(name: groupname).take
    @groupmemberships = @group.group_memberships
    @users = User.all


    @task = Task.new({:group_id => @group.id, :group => groupname, :created_by => @current_user.name})
    # @task = Task.new({:created_by => @user_name[:params]})


  end

  # GET /tasks/1/edit
  def edit
    groupname = params[:groupname]
    @group = Group.where(:name => groupname).take
    @groupmemberships = @group.group_memberships
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    groupname = params[:groupname]
    # @current_user.tasks << @task


    # # use the user login instance and match emails to find current user
    # @user_login = UserLogin.where(token: token).take
    # @curr_user = User.where(email: @user_login.try(:email)).take
    #
    # # use the group instance and match group name to find current group
    # @curr_group = Group.where(name: group).take

    respond_to do |format|
      if @task.save


        @point = Point.new
        @user_login = UserLogin.where('token = (?)', session[:current_user_token]).take
        @point.update_attribute(:user_email, @user_login.email)
        @point.update_attribute(:task_id, @task.id)
        @point.update_attribute(:voted_points, @task.points)

        @assigned_user = User.where(:id => @task.assigned_to).take

        @notification_targets = Group.find(@task.group_id).group_memberships
        @notification_targets.each do |notify|
          if @assigned_user.id == notify.user_id && @task.created_by != @assigned_user.name
            message = "Task #{@task.title} has been assigned to you by #{@task.created_by}"
          elsif @assigned_user.id == notify.user_id && @task.created_by == @assigned_user.name
            message = "You assigned task #{@task.title} to yourself"
          # elsif @assigned_user.id != notify.user_id && @current_user.id == notify.user_id
          #   message = "Task #{@task.title} has been assigned to #{@assigned_user.name} by you"
          else
            message = "Task #{@task.title} has been assigned to #{@assigned_user.name} by #{@task.created_by}"
          end
          Notification.create(message: message, group_id: @task.group_id, user_id: notify.user_id,  status: false)
        end

        message = "Task #{@task.title} has been assigned to #{@assigned_user.name} by #{@task.created_by}"
        GroupNotification.create(message: message, group_id: @task.group_id, status: false)

        # @group = Group.find(:id => groupID)
        # @task.group_id = group.id
        # # @group = Group.find(:id => groupID)
        # # # create a new task for group with current group as group name
        # @new_task = Task.create(group_id: @task.group_id)
        # # @new_task = Task.create(redirect_to :controller => 'groups',
        # #   :name => group_path(group_params))
        #
        # # associate new membership with the group and the user
        # @group.task << @new_task
        # @current_user.tasks << @task

        # add task to calendar
        new_event_url(:summary => @task.title, :calendar_id => 'primary')


        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        if @task.state == "Completed"
          message = "#{@task.title} has been completed"

          @notification_targets = Group.find(@task.group_id).group_memberships
          @notification_targets.each do |notify|
            Notification.create(message: message, group_id: @task.group_id, user_id: notify.user_id,  status: false)
          end

          GroupNotification.create(message: message, group_id: @task.group_id, status: false)
        else
          @assigned_user = User.where(:id => @task.assigned_to).take

          @notification_targets = Group.find(@task.group_id).group_memberships
          @notification_targets.each do |notify|
            if @assigned_user.id == notify.user_id && @current_user.id != @assigned_user.id
              message = "Task #{@task.title} has been edited and assigned to you by #{@current_user.name}"
            elsif @assigned_user.id == notify.user_id && @current_user.id == @assigned_user.id
              message = "Task #{@task.title} has been edited and assigned to you by yourself"
            elsif @assigned_user.id != notify.user_id && @current_user.id == notify.user_id
              message = "Task #{@task.title} has been edited and assigned to #{@assigned_user.name} by you"
            else
              message = "Task #{@task.title} has been edited and assigned to #{@assigned_user.name} by #{@current_user.name}"
            end
            Notification.create(message: message, group_id: @task.group_id, user_id: notify.user_id,  status: false)
          end

          message = "Task #{@task.title} has been edited and assigned to #{@assigned_user.name} by #{@current_user.name}"
          GroupNotification.create(message: message, group_id: @task.group_id, status: false)
        end
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    groupname = @task.group
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path(:groupname => groupname), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_vote
    @task = Task.find(params[:id])

    url = request.fullpath
    uri    = URI.parse(url)
    @params = CGI.parse(uri.query)

    @user_login = UserLogin.where('token = (?)', session[:current_user_token]).take

    # Check if user has voted
    @voted = Point.where('task_id = (?) AND user_email = (?)',@task.id , @user_login.email).first

    if @voted
      # let the users update their vote after their first voting but only count
      # their vote as only one entry in the points table
      @voted.update_attribute(:voted_points, @params['newpoints'].first)

    else
      # if not voted yet create a new instance in points table
      @point = Point.new
      @point.update_attribute(:user_email, @user_login.email)
      @point.update_attribute(:task_id, @task.id)
      @point.update_attribute(:voted_points, @params['newpoints'].first)
    end

    redirect_to :back
  end

  def vote_for_points
    @task = Task.find(params[:id])

    groupname = params[:groupname]
    @group = Group.where(:name => groupname).take

    @user_login = UserLogin.where('token = (?)', session[:current_user_token]).take



    # @voted = Point.where('task_id = (?) AND user_email = (?)',@task.id , @user_login.email).first

    # get the current value of points in tasks table
    @average = @task.points

    if @average == 0
      @point = Point.new
      @point.update_attribute(:user_email, @user_login.email)
      @point.update_attribute(:task_id, @task.id)
      @point.update_attribute(:voted_points, 0 )

    end

    # calculate the average of points based on users that has voted for the task
    @average = Point.where('task_id = (?)', @task.id).average(:voted_points).round



    @task.update_attribute(:points,@average)


  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
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
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, :created_by, :deadline, :points, :group, :state, :task_type, :group_id, :assigned_to, :total_points, :voters_count)
    end
end
