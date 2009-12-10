class IndustriesController < ApplicationController
  
  def index
    @industries = Industry.find(:all, :order => 'name')
  end

  def show
    @industry  = Industry.find(params[:id])
    @news      = Post.find_most_recent(:industry => @industry, :category => 'News')
    @gossip    = Post.find_most_recent(:industry => @industry, :category => 'Gossip')
    @questions = Post.find_most_recent(:industry => @industry, :category => 'Question')
  end
  
end
