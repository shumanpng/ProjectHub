class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
    # @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    token = params[:token]
    groupname = params[:groupname]
    groupid = params[:groupid]

    # @group = Group.where(name: groupname).take
    # @group = Group.find params[:groupname]
    # @task = Task.new({:group_id => '1', :group => 'CMPT276'})
    @group = Group.where(id: groupid).take

    @user_login = UserLogin.where(token: token).take
    @curr_user = User.where(email: @user_login.try(:email)).take
    # @user_name = @curr_user
    @task = Task.new({:group_id => groupid, :group => groupname, :created_by => @curr_user.name})
    # @task = Task.new({:created_by => @user_name[:params]})


  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    token = params[:token]
    groupname = params[:groupname]


    # # use the user login instance and match emails to find current user
    # @user_login = UserLogin.where(token: token).take
    # @curr_user = User.where(email: @user_login.try(:email)).take
    #
    # # use the group instance and match group name to find current group
    # @curr_group = Group.where(name: group).take

    respond_to do |format|
      if @task.save


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
        # @curr_user.task << @new_task

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
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, :created_by, :due_date, :points, :group, :state, :type, :group_id)
    end
end
