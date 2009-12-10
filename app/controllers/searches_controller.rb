class SearchesController < ApplicationController

  def index
    @heading = "Companies in"
    @companies = @news = @gossip = @questions = []
    if params[:q]
      @heading = "Search results matching"
      @query = params[:q]
      if @query and @query.size > 1
        @companies = Company.search_by_name_and_city_and_state(@query)
        @news      = Post.search_by_category_title_and_body('News', @query)
        @gossip    = Post.search_by_category_title_and_body('Gossip', @query)
        @questions = Post.search_by_category_title_and_body('Question', @query)
      else
        flash.now[:error] = "Your query is too short."
      end
    elsif params[:city] and params[:state]
      @query = "#{params[:city]}, #{params[:state]}"
      @companies = Company.find_by_city_and_state(params[:city], params[:state])
    elsif params[:city]
      @query = "#{params[:city]}"
      @companies = Company.find_by_city(params[:city])
    elsif params[:state]
      @query = "#{params[:state]}"
      @companies = Company.find_by_state(params[:state])
    elsif params[:country]
      @query = "#{params[:country]}"
      @companies = Company.find_by_country(params[:country])
    else
      flash.now[:error] = "Couldn't parse query."
    end
  end
  
end
