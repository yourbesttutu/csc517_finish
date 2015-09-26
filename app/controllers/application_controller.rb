class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def log_in(user)
    session[:id] = user.id
  end
  
  def current_user
    # @current_user ||= User.find_by_sql("SELECT * FROM users WHERE id = #{session[:id]}")
    if session[:id].nil?
      nil
    else
      User.find(session[:id]);
    end
    # @current_user ||= User.find(session[:id]);
  end

  def current_id
    session[:id]
  end
  
  # current_user == nil -> current_user.nil == true -> return false -> not logged in
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    # session.delete(session[:id])
    session[:id] = nil
    current_user = nil
    
    flash[:success] = 'Logout Successfully!'
    redirect_to login_url
  end
  
  def require_login
    unless logged_in?
      redirect_to login_url, notice: 'Please Login! Thank you!'
    end
  end
  
  def admin?
    current_user.permission < 2
  end
  
  def member?
    current_user.permission == 2
  end
  
  # define current_user function as helper_method to allow it be used in view level
  helper_method :current_user, :logged_in?, :admin?, :member?
end
