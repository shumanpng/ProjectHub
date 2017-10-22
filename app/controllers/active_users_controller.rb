class ActiveUsersController < ApplicationController
  before_action :set_active_user, only: [:show, :edit, :update, :destroy]

  # GET /active_users
  # GET /active_users.json
  def index
    @active_users = ActiveUser.all
  end

  # GET /active_users/1
  # GET /active_users/1.json
  def show
  end

  # GET /active_users/new
  def new
    @active_user = ActiveUser.new
  end

  # GET /active_users/1/edit
  def edit
  end

  # POST /active_users
  # POST /active_users.json
  def create
    @active_user = ActiveUser.new(active_user_params)

    respond_to do |format|
      if @active_user.save
        format.html { redirect_to @active_user, notice: 'Active user was successfully created.' }
        format.json { render :show, status: :created, location: @active_user }
      else
        format.html { render :new }
        format.json { render json: @active_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /active_users/1
  # PATCH/PUT /active_users/1.json
  def update
    respond_to do |format|
      if @active_user.update(active_user_params)
        format.html { redirect_to @active_user, notice: 'Active user was successfully updated.' }
        format.json { render :show, status: :ok, location: @active_user }
      else
        format.html { render :edit }
        format.json { render json: @active_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /active_users/1
  # DELETE /active_users/1.json
  def destroy
    @active_user.destroy
    respond_to do |format|
      format.html { redirect_to active_users_url, notice: 'Active user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_active_user
      @active_user = ActiveUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def active_user_params
      params.require(:active_user).permit(:user_id, :token)
    end
end
