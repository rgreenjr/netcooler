class UsersController < ApplicationController

  before_filter :authenticate_admin, :only => [:index]
  before_filter :authenticate,       :only => [:edit, :update]
  before_filter :find_user,          :except => [:index, :new, :create, :check_username]
  before_filter :authorize,          :except => [:new, :create, :show, :check_username]

  def index
    @users = User.paginate(:page => params[:page])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      EmailNotifier.deliver_registration(@user)
      target = session[:target_url] || root_url
      session[:target_url] = nil
      redirect_to target 
    else
      render :action => :new 
    end
  end
  
  def update
    unless current_user.admin?
      # protect against unauthorized modification of sensitive attributes
      params[:user].delete(:admin)
      params[:user].delete(:status)
    end
    if @user.update_attributes(params[:user])
      flash.now[:notice] = "Your profile was successfully updated."
      render :action => :show 
    else
      render :action => :edit
    end
  end

  def check_username
    @hide_field = params[:username].nil?
    username = params[:username] || ""
    @available = RegexpUtil.valid_username?(username) && User.find_by_username(username).nil?
  end
  
  private
  
  def find_user
    @user = User.find_by_username(params[:id])
    raise ActiveRecord::RecordNotFound unless @user
  end

  def authorize
    unless current_user == @user || current_user.admin?    
      flash[:error] = "You may only edit your own profile."
      redirect_to current_user
    end
  end

end
