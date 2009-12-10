class PasswordsController < ApplicationController

  before_filter :authenticate, :except => [:new, :create]

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.reset_password
      @user.save!
      EmailNotifier.deliver_reset_password(@user)
      flash[:notice] = "An email with your new password has been sent to #{@user.email}."
      redirect_to new_session_url
    else
      flash.now[:error] = "A user with that email address could not be found."
      render :action => :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      EmailNotifier.deliver_change_password(@user)
      flash[:notice] = "Your password was successfully updated and a confirmation email has been sent to #{@user.email}."
      redirect_to @user
    else
      render :action => :edit
    end
  end
  
end
