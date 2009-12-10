class CompaniesController < ApplicationController

  before_filter :authenticate, :only => [:create]
  before_filter :find_company

  verify :method => :post, :only => :create, :redirect_to => { :action => :index }
  
  cache_sweeper :company_sweeper, :only => [:create, :update, :destroy]

  def index
    if params[:industry_id]
      @industry = Industry.find(params[:industry_id])
      @companies = Company.paginate(:page => params[:page], :order => "name", :conditions => ['industry_id = ?', @industry])
    else
      @companies = Company.paginate(:page => params[:page], :order => "name")
    end
  end
  
  def new
    @office = Office.new(:country => Country.default)
  end
  
  def show
    @news = @company.posts.most_recent("News")
    @gossip = @company.posts.most_recent("Gossip")
    @questions = @company.posts.most_recent("Question")
  end
  
  def create
    @company = Company.new(params[:company])
    @office = Office.new(params[:office])
    @office.company = @company
    @company.offices << @office
    if @company.save
      redirect_to(@company)
    else
      @matching_company = Company.find_by_domain(@company.domain) if @company.errors.invalid?(:domain)
      render :action => :new
    end
  end
  
  private
  
  def find_company
    @company = Company.find(params[:id]) if params[:id]
  end  

end
