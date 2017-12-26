class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']

    if signed_in?
      if Identity.omniauth_exists?(auth)
        @identity = Identity.find_with_omniauth(auth)
        if @identity.user_id != current_user.id
          flash[:message] = "Sorry, this #{@identity.provider_name} profile has already been linked by another user (#{@identity.user.name}, id: #{@identity.user_id})"

          redirect_to settings_path and return
        else
          @identity = Identity.update_with_omniauth(auth)
        end
      else
        @identity = Identity.create_with_omniauth(auth)
      end
      @identity.user = current_user
      @identity.save
    else
      if Identity.omniauth_exists?(auth)
        @identity         = Identity.update_with_omniauth(auth)
        self.current_user = @identity.user
      else
        @identity         = Identity.create_with_omniauth(auth)
        @user             = User.create_with_omniauth(auth.info)
        self.current_user = @user
        @identity.user  ||= current_user
        @identity.save
      end
    end

    flash[:message] = "Your #{@identity.provider_name} profile has succesfully been linked to this account. #{@current_user.platforms_link_message(show_pending: true)}"

    redirect_to settings_path
  end

  def destroy
    self.current_user = nil

    flash[:message] = "Successfully logged out."
    redirect_to root_path
  end
end
