class SessionsController < ApplicationController
  
  def new
    session[:user_id] = nil
    @user = User.new
  end
  
  def show
    puts 'show'
  end
  def create
    session[:user_id] = nil
    if request.post? 
      user = User.authenticate(params[:username], params[:password])
      if user
        target = session[:target_url] || root_url
        reset_session # prevents session fixation attacks
        session[:user_id] = user.id
        session[:accessed_at] = Time.now
        redirect_to target 
      else 
        @user = User.new(params[:user])
        @user.password = nil # blank the password so it is not sent back to the browser
        flash[:error] = 'Invalid username and password combination'
        render :action => :new 
      end 
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

end
