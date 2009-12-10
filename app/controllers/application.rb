# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  # turn sessions off for atom feed requests
  session :off, :if => Proc.new { |request| request.parameters[:format] == 'atom' }

  before_filter :verify_session

  helper_method :logged_in?, :current_user, :admin?

  def verify_session
    reset_session if session[:accessed_at] and Time.now - session[:accessed_at] > 24.hours
    session[:accessed_at] = Time.now
  end

  def logged_in?
    session[:user_id] != nil
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def admin?
    logged_in? and current_user.admin? 
  end

  def authenticate
    unless logged_in?
      session[:target_url] = request.request_uri
      redirect_to new_session_url
    end
  end

  def authenticate_admin
    if not logged_in?
      session[:target_url] = request.request_uri
      redirect_to new_session_url
    elsif not admin?
      redirect_to root_url
    end
  end
  
  protected
  
  def rescue_action_in_public(exception)
    logger.debug "#{exception.class.name}: #{exception.to_s}"
    exception.backtrace.each { |t| logger.debug " > #{t}" }
    puts exception.inspect
    case exception
    when ::ActiveRecord::RecordNotFound, ::ActionController::RoutingError, ::ActionController::UnknownController, ::ActionController::UnknownAction
      render :file => 'public/404.rhtml', :layout => 'application', :status => '404 Not Found'
    else
      render :file => 'public/500.rhtml', :layout => 'application', :status => '500 Error'
    end
  end

end
