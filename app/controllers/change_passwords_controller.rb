class ChangePasswordsController < ApplicationController
  before_action :set_change_password, only: [:show, :edit]
  before_action :authenticate, only: [:index, :show, :edit, :new, :create]

  # GET /change_passwords
  # GET /change_passwords.json
  def index
    @change_passwords = ChangePassword.all
  end

  # GET /change_passwords/1
  # GET /change_passwords/1.json
  def show
  end

  # GET /change_passwords/new
  def new
    @change_password = ChangePassword.new
  end

  # GET /change_passwords/1/edit
  def edit
  end

  # POST /change_passwords
  # POST /change_passwords.json
  def create
    @change_password = ChangePassword.new(change_password_params)
    @change_password.token = session[:current_user_token]
    respond_to do |format|
      if @change_password.save
        require 'digest'
        md5 = Digest::MD5.new
        puts @current_user
        @current_user.password = md5.hexdigest @change_password.confirm_password
        @current_user.save
        format.html { redirect_to @change_password, notice: 'Change password was successfully created.' }
        format.json { render :show, status: :created, location: @change_password }
      else
        format.html { render :new }
        format.json { render json: @change_password.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_change_password
      @change_password = ChangePassword.find(params[:id])
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
    def change_password_params
      params.require(:change_password).permit(:current_password, :new_password, :confirm_password)
    end
end
