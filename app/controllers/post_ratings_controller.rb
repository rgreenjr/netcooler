class PostRatingsController < ApplicationController

  before_filter :authenticate
  
  def create
    @post = Post.find(params[:post_id])
    @post.rate(current_user, params[:value])
    respond_to do |format|
      format.html { redirect_to(@post) }
      format.js do
        render :update do |page|
          page[@post.dom_id + '-rating'].replace :partial => 'posts/rate', :locals => { :post => @post }
        end
      end
    end    
  end

end
