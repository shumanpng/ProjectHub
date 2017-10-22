class WelcomeController < ApplicationController

  # GET /welcome
  def index
    respond_to do |format|
        format.html { redirect_to new_user_login_path, notice: '' }
      end
  end

end
