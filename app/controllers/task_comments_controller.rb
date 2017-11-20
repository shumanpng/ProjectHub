class TaskCommentsController < ApplicationController
  before_action :authenticate, only: [:index, :show, :edit, :update, :destroy, :new]
  before_action :set_task_comment, only: [:show, :edit, :update, :destroy]


  # GET /task_comments
  # GET /task_comments.json
  def index
    @task_comments = TaskComment.all
  end

  # GET /task_comments/1
  # GET /task_comments/1.json
  def show
  end

  # GET /task_comments/new
  def new
    @task_comment = TaskComment.new
  end

  # GET /task_comments/1/edit
  def edit
  end

  # POST /task_comments
  # POST /task_comments.json
  def create
    @task_comment = TaskComment.new(task_comment_params)
    respond_to do |format|
      if @task_comment.save
        format.html { redirect_to task_path(:id => task_comment_params[:task_id]), notice: 'Task comment was successfully created.' }
        format.json { render :show, status: :created, location: @task_comment }
      else
        format.html { render :new }
        format.json { render json: @task_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_comments/1
  # PATCH/PUT /task_comments/1.json
  def update
    respond_to do |format|
      if @task_comment.update(task_comment_params)
        format.html { redirect_to task_path(:id => task_comment_params[:task_id],:group_id => params[:group_id]), notice: 'Task comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_comment }
      else
        format.html { render :edit }
        format.json { render json: @task_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_comments/1
  # DELETE /task_comments/1.json
  def destroy
    @task_comment.destroy

    respond_to do |format|
      format.html { redirect_to task_path(:id => params[:task_id], :group_id => params[:group_id]), notice: 'Task comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_comment
      @task_comment = TaskComment.find(params[:id])
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
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_comment_params
      params.require(:task_comment).permit(:user_id, :user_name, :group_id, :task_id, :grp_admin, :task_comment, :isadmin)
    end
end
