class TagsController < ApplicationController

  before_filter :find_company_and_user
      
  def index
    if @user
      @tags = @user.tags
    elsif @company
      @tags = @company.tags
    else
      @tags = Tag.all_with_count
    end
  end

  # TODO make show method filter tags based on scoping
  # currently show renders all posts with the specified tags, but this method
  # can be called three ways: /tags/:id, /users/:user_id/tags/:id, and /companies/:companies_id/tags/:id
  # - changed /users/:user_id/tags/:id to only show posts by the user with that tag
  # - changed /companies/:companies_id/tags/:id to only show posts associated with the company with that tag
  def show
    @tag_name = params[:id]
    @tag = Tag.find_by_name(@tag_name)
    if @tag
      # this is a hack and should be replaced with custom SQL queries
      @taggings = @tag.taggings.by_type('Post')
      @news_taggings = @taggings.select {|tagging| tagging.taggable.news? }
      @gossip_taggings = @taggings.select {|tagging| tagging.taggable.gossip? }
      @question_taggings = @taggings.select {|tagging| tagging.taggable.question? }
    end
  end
  
  private
  
  def find_company_and_user
    @user = User.find_by_username(params[:user_id]) if params[:user_id]
    @company = Company.find(params[:company_id]) if params[:company_id]
  end

end
