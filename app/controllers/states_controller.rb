class StatesController < ApplicationController
  def index
    if params[:country_id]
      @states = State.find(:all, :conditions => ['country_id = ?', params[:country_id]])
    else
      @states = State.find(:all)
    end
  end
end
