class WelcomeController < ApplicationController

  # GET /welcome
  def index
    puts "we are here"
    respond_to do |format|
        format.html { redirect_to new_user_login_path, notice: '' }
      end
  end

end
