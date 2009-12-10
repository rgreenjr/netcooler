class SiteController < ApplicationController

  def index
    @news = Post.find_most_recent(:category => 'News')
    @gossip = Post.find_most_recent(:category => 'Gossip')
    @questions = Post.find_most_recent(:category => 'Question')
  end

end
