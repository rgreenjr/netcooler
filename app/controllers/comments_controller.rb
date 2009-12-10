class CommentsController < ApplicationController

  before_filter :authenticate, :except => [:index]
  before_filter :find_comment_and_post_and_user
  
  def index
    @comments = Comment.paginate_by_user_id(@user, :page => params[:page], :order => 'created_at DESC')
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    if @post.comments << @comment
      session[:comment] = nil
      redirect_to(@post)
    else
      # stick comment in the session since we must redirect and can't lose comment content
      session[:comment] = @comment
      redirect_to(post_url(@post) + "#add-comment")
    end
  end
  
  def update
    if (@comment.author?(current_user) and @comment.fresh?) or current_user.admin?
      if @comment.update_attributes(params[:comment])
        redirect_to(@comment.commentable) and return
      end
    end
    render :action => :edit
  end
  
  private

  def find_comment_and_post_and_user
    @comment = Comment.find(params[:id]) if params[:id]
    @post = Post.find(params[:post_id]) if params[:post_id]
    @user = User.find_by_username(params[:user_id]) if params[:user_id]
  end

end
