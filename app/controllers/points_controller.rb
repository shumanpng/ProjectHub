class PointsController < ApplicationController
  before_action :set_point, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :authenticate, only: [:index, :show, :edit, :update, :destroy, :new, :upvote, :downvote]

  # GET /points
  # GET /points.json
  def index
    @points = Point.all
    groupid = params[:groupid]
    groupname = params[:groupname]
    @group = Group.where(name: groupname).take
    @tasks = Task.where(group: groupname)
  end

  # GET /points/1
  # GET /points/1.json
  def show
  end

  # GET /points/new
  def new
    @point = Point.new
  end

  # GET /points/1/edit
  def edit
  end

  # POST /points
  # POST /points.json
  def create
    @point = Point.new(point_params)

    respond_to do |format|
      if @point.save
        format.html { redirect_to @point, notice: 'Point was successfully created.' }
        format.json { render :show, status: :created, location: @point }
      else
        format.html { render :new }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /points/1
  # PATCH/PUT /points/1.json
  def update
    respond_to do |format|
      if @point.update(point_params)
        format.html { redirect_to @point, notice: 'Point was successfully updated.' }
        format.json { render :show, status: :ok, location: @point }
      else
        format.html { render :edit }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /points/1
  # DELETE /points/1.json
  def destroy
    @point.destroy
    respond_to do |format|
      format.html { redirect_to points_url, notice: 'Point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # upvote_from user
    def upvote
      @point = Point.find(params[:id])
      @point.upvote_from @current_user
      redirect_to :back
    end
    # downvote_from user
    def downvote
      @point = Point.find(params[:id])
      @point.downvote_from @current_user
      redirect_to :back
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_point
      @point = Point.find(params[:id])
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
    def point_params
      params.require(:point).permit(:level, :user_id, :task_id)
    end
end
