class CommentRatingsController < ApplicationController

  before_filter :authenticate
  
  def create
    @comment = Comment.find(params[:comment_id])
    @comment.rate(current_user, params[:value])
    respond_to do |format|
      format.html { redirect_to(@comment.commentable) }
      format.js do
        render :update do |page|
          page[@comment.dom_id + '-rating'].replace :partial => 'comments/rate', :locals => { :comment => @comment }
        end
      end
    end    
  end

end
