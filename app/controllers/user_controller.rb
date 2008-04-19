class UserController < ApplicationController
  layout "standard-layout"
  before_filter :check_authentication, :except => [:register, :login]

  def register
    @user = User.new(params[:user])
    if request.post?
      if @user.save
        session[:user] = @user.id
        redirect_to user_home_url
      else
        flash[:error] = 'please correct the indicated errors'
      end
    end
  end

  def login
    if request.post?
      @user = User.authenticate(params[:login], params[:password])
      if @user
        session[:user] = @user.id
        redirect_to user_home_url
      else
        flash[:error] = 'Bad username or password'
      end
    end
  end

  def logout
    session[:user] = nil
    redirect_to home_url
  end

  def edit
  end

end
