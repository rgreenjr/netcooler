class AvatarsController < ApplicationController

  before_filter :authenticate, :except => [:show]
  before_filter :find_user_and_avatar, :except => [:show]
  
  def show
    avatar = Avatar.find_by_id(params[:id])
    send_data(DbFile.find_by_id(avatar.db_file_id).data, :type => avatar.content_type, :disposition => 'inline')
  end
  
  def new
    @avatar = Avatar.new
  end
  
  def create
    @avatar = Avatar.new(:uploaded_data => params[:filename])
    if @avatar.valid?
      @user.avatar = @avatar
      if @user.save
        redirect_to @user
        return
      end
    end
    render :action => :new
  end
      
  def update
    @avatar = Avatar.new(:uploaded_data => params[:filename])
    if @avatar.valid?
      @user.avatar.destroy if @user.avatar
      @user.avatar = @avatar
      if @user.save
        redirect_to @user
        return
      end
    end 
    render :action => :edit
  end
  
  private

  def find_user_and_avatar
    @avatar = Avatar.find_by_id(params[:id])
    @user = User.find_by_username(params[:user_id])
    redirect_to root_url unless @avatar.editable_by?(@user) if @avatar
  end

end