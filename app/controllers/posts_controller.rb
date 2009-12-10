class PostsController < ApplicationController

  before_filter :authenticate, :only => [:new, :create, :update, :edit]
  before_filter :find_company_and_user

  cache_sweeper :post_sweeper, :only => [:create, :update, :destroy]

  def index
    raise ArgumentError, "Must specify either company_id or user_id" if @user.nil? and @company.nil?
    if @user
      if @category
        conditions = ["category = '#{@category}' AND user_id = ? AND status = 'Approved'", @user.id]
      else
        conditions = ["user_id = ? AND status = 'Approved'", @user.id]
      end
    else
      conditions = ["category = '#{@category}' AND company_id = ? AND status = 'Approved'", @company.id]
    end  
    @posts = Post.paginate(:page => params[:page], :per_page => 10, :conditions => conditions, :order => 'created_at DESC')
    respond_to do |format|
      format.html { render :template => 'posts/index' }
      format.atom { render :template => 'posts/index.atom.builder', :layout => false }
    end
  end

  def show
    @post.hit! unless @post.author?(current_user)
    # invalid comments will be stored in the session and must be retrieved here to show their errors
    @comment = session[:comment] if session[:comment]
    render :template => 'posts/show'
  end

  def new
    @post = Post.new(:company_id => @company.id, :category => @category)
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user    
    @post.company = @company
    if @post.save
      redirect_to @post
    else
      render :template => 'posts/new'
    end 
  end

  def update
    if @post.editable_by?(current_user) and @post.update_attributes(params[:post])
      redirect_to(@post)
    else
      render :template => 'posts/edit'
    end
  end

  private

  def find_company_and_user
    @company = Company.find(params[:company_id]) if params[:company_id]
    @user = User.find_by_username(params[:user_id]) if params[:user_id]
    @post = Post.find(params[:id], :include => :user) if params[:id]
    @category = params[:category].singularize.capitalize if params[:category]
    @category = @post.category if @category.nil? and !@post.nil?
  end

end