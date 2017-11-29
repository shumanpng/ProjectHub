class GroupRequestsController < ApplicationController
  before_action :set_group_request, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:index, :show, :edit, :update, :destroy, :new]

  # GET /group_requests
  # GET /group_requests.json
  def index
    @group_requests = GroupRequest.all
  end

  # GET /group_requests/1
  # GET /group_requests/1.json
  def show
  end

  # GET /group_requests/new
  def new
    @group_request = GroupRequest.new
    @group_request.status = 'pending'
    @group_request.save

    # find current group
    @curr_group = Group.find(params[:id])

    # associate new request with the group and the user
    @curr_group.group_requests << @group_request
    @current_user.group_requests << @group_request

    # re-load group#index
    redirect_to :controller => 'groups', :action => 'index'
  end

  # GET /group_requests/1/edit
  def edit
  end

  # POST /group_requests
  # POST /group_requests.json
  def create
    @group_request = GroupRequest.new(group_request_params)

    respond_to do |format|
      if @group_request.save
        format.html { redirect_to @group_request, notice: 'Group request was successfully created.' }
        format.json { render :show, status: :created, location: @group_request }
      else
        format.html { render :new }
        format.json { render json: @group_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_requests/1
  # PATCH/PUT /group_requests/1.json
  def update
    respond_to do |format|
      if @group_request.update(group_request_params)
        format.html { redirect_to @group_request, notice: 'Group request was successfully updated.' }
        format.json { render :show, status: :ok, location: @group_request }
      else
        format.html { render :edit }
        format.json { render json: @group_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_requests/1
  # DELETE /group_requests/1.json
  def destroy
    @group_request.destroy
    respond_to do |format|
      format.html { redirect_to group_requests_url, notice: 'Group request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def respond_to_request
    @curr_request = GroupRequest.find(params[:id])

    if params[:type] == 'accept'
      # change status of request
      @curr_request.update_attribute(:status, 'accepted')

      # find current group
      @curr_group = Group.find(params[:group_id])

      # find user who submitted the request
      @requester = User.find(@curr_request.user.id)

      # create new group membership for user who submitted the request
      @new_membership = GroupMembership.create(:group_id => @curr_group.id, :user_id => @requester.id, :is_admin => false)

      # associate new membership with the group and the user who submitted the request
      @curr_group.group_memberships << @new_membership
      @requester.group_memberships << @new_membership


      message = "#{@requester.name} joined the group #{@curr_group.name}"

      @notification_targets = Group.find(params[:group_id]).group_memberships
      @notification_targets.each do |notify|
        Notification.create(message: message, group_id: params[:group_id], user_id: notify.user_id,  status: false)
      end

      GroupNotification.create(message: message, group_id: params[:group_id], status: false)
    else
      # change status of request
      @curr_request.update_attribute(:status, 'denied')
    end

    # re-load group#show
    redirect_to :controller => 'groups', :action => 'show', :id => params[:group_id]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_request
      @group_request = GroupRequest.find(params[:id])
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
    def group_request_params
      params.require(:group_request).permit(:user_id, :group_id, :status)
    end
end
