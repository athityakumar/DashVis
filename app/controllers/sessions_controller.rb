class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    if signed_in?
      if Identity.omniauth_exists?(auth)
        @identity = Identity.find_with_omniauth(auth)
        if @identity.user_id != current_user.id
          current_user.tables      << @identity.user.tables
          current_user.collections << @identity.user.collections

          @identity.user = current_user
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

  def unlink
    authenticate_user

    @identities = current_user.identities
    identity    = @identities.find_by_provider(params[:provider])

    if identity.nil?
      flash[:message] = "No such social media account linked before."
    else
      if @identities.count == 1
        flash[:message] = "Sorry, this is the only social media account linked to this profile."
      else
        flash[:message] = "Successfully unlinked your #{identity.provider_name} account."
        identity.delete
      end
    end

    redirect_to settings_path
  end
end
