class UserController < ApplicationController
  layout "standard-layout"

  def register
    @user = User.new(params[:user])
    if request.post?
      unless @user.save
        flash[:notice] = 'please correct the indicated errors'
      end
    end
  end

  def login
  end

  def logout
  end
end
