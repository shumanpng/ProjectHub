class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:index, :show, :edit, :update, :destroy, :new, :process_leave_grp]

  # GET /groups
  # GET /groups.json
  def index
    groupname = params[:groupname]
    @groups = Group.all
    @users = User.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    # get array of pending requests
    @pending_requests = @group.group_requests.where(:status => 'pending')

    # get array of tasks of the group
    @grouptasks = Task.where(:group => @group.name)
    # get array of tasks of the group where state = Open
    @opentasks = Task.where(:group => @group.name, :state => "Open")
    # get array of tasks of the group where state = In Progress
    @inprogresstasks = Task.where(:group => @group.name, :state => "In Progress")
    # get array of tasks of the group where state = Completed
    @completedtasks = Task.where(:group => @group.name, :state => "Completed")

    # check whether or not the user is the group admin
    if GroupMembership.where(:user_id => @current_user.id, :group_id => @group.id, :is_admin => true).exists?
      @is_grp_admin = true
    else
      @is_grp_admin = false
    end

    # variables for display of the project deadline progress bar
    if @group.deadline != nil
      project_length = (@group.deadline - @group.created_at.localtime.to_date).to_i
      @days_left = (@group.deadline - Date.today).to_i
      days_passed = (Date.today - @group.created_at.localtime.to_date).to_i

      if project_length == 0
        # eg. start and end on same day, calc would result in infinity
        @percent_completed = 100
      else
        @percent_completed = ((days_passed.to_f / project_length.to_f) * 100).round
        if @percent_completed < 1
          @percent_completed = 1  # so that progress bar is never totally empty
        end
      end

      # warning message inside popover (triggered by hovering over alert icon) if the project is overdue
      if @days_left <= 0
        @overdue = true

        if @days_left == 0
          @warning = 'The deadline to complete this project is today!'
        else
          @warning = 'The deadline for this project has passed!'
        end

        if @is_grp_admin
          @warning_addition = "If necessary, you may extend the deadline under 'Group Settings'."
        else
          @warning_addition = 'If necessary, please get the group admin to extend the deadline.'
        end

      else
        @overdue = false
      end
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit

    #@members = GroupMembership.all
    #@members = GroupMembership.joins("LEFT JOIN users ON users.id = group_memberships.user_id").select("group_memberships.*,users.name").where(:group_id => @group.id)
    #@members = GroupMembership.eager_load(:users)
    #@members = User.joins(:group_memberships).where(group_memberships:{group_id:@group.id}).select("group_memberships.id, users.name")
    @members = GroupMembership.joins(:user).where(group_memberships:{group_id:@group.id}).select("group_memberships.id, group_memberships.user_id, users.name")

    @non_members = []
    User.where(:is_admin => false).each do |u|
      if @group.users.exclude?(u)
        @non_members << u
      end
    end
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    token = params[:token]

    # use the user login instance and match emails to find current user
    @user_login = UserLogin.where(token: token).take
    @current_user = User.where(email: @user_login.email).take

    respond_to do |format|
      if @group.save

        # create a new group membership for new group w/ current user as admin
        @new_membership = GroupMembership.create(group_id: @group.id, user_id: @current_user.id, is_admin: true)

        # associate new membership with the group and the user
        @group.group_memberships << @new_membership
        @current_user.group_memberships << @new_membership

        format.html { redirect_to group_path(:id => @group.id), notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    token = params[:token]
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_path(:id => @group.id), notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def process_leave_grp
    # find current group using param from hidden field inside modal
    @current_group = Group.find(params[:id])

    # get status of user relative to group by calling method in group model
    @user_status = @current_group.get_user_status(@current_group, @current_user)

    if @user_status == 'not admin'
      # case a.: user is not the group admin, so can leave with no side-effects

      # destroy their group membership
      @membership = GroupMembership.where(:user_id => @current_user.id, :group_id => @current_group.id).take
      @membership.destroy

    elsif @user_status == 'one left'
      # case b.: user is the group admin and there is one other member, so
      # that member automatically becomes group admin.

      # get group membership of remaining member and make them the new admin
      @new_admin_membership = @current_group.group_memberships.where(:is_admin => false).first
      @new_admin_membership.update_attribute(:is_admin, true)

      # destroy current user's group membership
      @membership = GroupMembership.where(:user_id => @current_user.id, :group_id => @current_group.id).take
      @membership.destroy

    elsif @user_status == 'many left'
      # case c.: user is the group admin and there are multiple other members, so
      # they have to choose a new admin before they can leave.

      # get group membership of the member the user selected and make them the new admin
      @new_admin_membership = GroupMembership.where(:user_id => params[:new_admin_id], :group_id => @current_group.id).take
      @new_admin_membership.update_attribute(:is_admin, true)

      # destroy current user's group membership
      @membership = GroupMembership.where(:user_id => @current_user.id, :group_id => @current_group.id).take
      @membership.destroy

    else
      # case d.: user is the group admin but there are no other members, so the group
      # will be deleted once they leave.

      # destroy current user's group membership
      @membership = GroupMembership.where(:user_id => @current_user.id, :group_id => @current_group.id).take
      @membership.destroy

      # destroy group and all its child objects (i.e. group memberships and group requests)
      @current_group.destroy
    end

    # re-load groups#index
    redirect_to :action => :index
  end

  def add_member
    # get new member and current group
    current_group = Group.find(params[:id])
    new_member = User.find(params[:user_id])

    # create new membership and associate it with the group and the user
    new_membership = GroupMembership.create(:user_id => new_member.id, :group_id => current_group.id, :is_admin => false)
    current_group.group_memberships << new_membership
    new_member.group_memberships << new_membership

    # re-load group settings
    redirect_to edit_group_path(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
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
    def group_params
      params.require(:group).permit(:name,:description,:deadline)
    end
end
