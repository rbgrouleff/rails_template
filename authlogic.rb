gem 'authlogic'

rake "gems:install", :sudo => true

generate :model, "user", "username:string", "email:string", "crypted_password:string", "password_salt:string", "persistence_token:string"

run "rm app/models/user.rb"
file "app/models/user.rb", <<-END
class User < ActiveRecord::Base
  acts_as_authentic
end
END

generate :controller, "users"

route "map.resources :users"

generate :session, "user_session"
generate :controller, "UserSessions", "new"

run "rm app/controllers/user_sessions_controller.rb"
file "app/controllers/user_sessions_controller.rb", <<-END
class UserSessionsController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def create
    @user_session = UserSession.new params[:user_session]
    if @user_session.save
      flash[:notice] = 'Successfully logged in.'
      redirect_back_or_default root_url
    else
      render :action => 'new'
    end
  end
  
  def new
    @user_session = UserSession.new
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = 'Successfully logged out'
    redirect_back_or_default root_url
  end

end
END

route "map.login 'login', :controller => 'user_sessions', :action => 'new'"
route "map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'"
route "map.resources :user_sessions"

run "rm app/controllers/application_controller.rb"
file "app/controllers/application_controller.rb", <<-END
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  helper_method :current_user, :logged_in?
  
private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    @current_user = current_user_session && current_user_session.record
  end
  
  def logged_in?
    current_user_session != nil
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def logged_in?
    current_user_session != nil
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end  
end
END