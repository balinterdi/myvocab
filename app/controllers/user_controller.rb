class UserController < ApplicationController
  layout "standard-layout"

  def register
    @user = User.new(params[:user])
    if request.post?
      unless @user.save
        flash[:notice] = 'please correct the indicated errors'
      else
        session[:user] = @user.id
        redirect_to home_url
      end
    end
  end

  def login
    if request.post?
      @user = User.authenticate(params[:login], params[:password])
      session[:user] = 'xxx' if @user
    end
  end

  def logout
  end
end
