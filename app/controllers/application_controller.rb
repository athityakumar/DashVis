class ApplicationController < ActionController::Base
  before_action :initialize_omniauth_state
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  protected

  def authenticate_user
    redirect_to root_path and return unless signed_in?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    !!current_user
  end
  helper_method :current_user, :signed_in?

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.nil? ? nil : user.id
  end

  def initialize_omniauth_state
    session['omniauth.state'] = response.headers['X-CSRF-Token']
    session['omniauth.time']  = Time.now.strftime('%b_%d_%Y_%H_%m_%S')
  end
end
