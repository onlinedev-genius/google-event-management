# frozen_string_literal: true

class Users::SessionsController < ActionController::Base
  before_action :redirect_if_authenticated!, only: [:new]

  def new; end

  def create
    user = User.from_omniauth(auth)
    if user.present?
      user.refresh_tokens(auth)
      log_in(user)
      flash[:success] = t 'omniauth_callbacks.success', kind: 'Google'
      redirect_to events_path
    else
      flash[:alert] =
        t 'omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = t('omniauth.session.successfully_logged_out')
    redirect_to root_path
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def redirect_if_authenticated!
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    redirect_to events_path if @current_user
  end
end
