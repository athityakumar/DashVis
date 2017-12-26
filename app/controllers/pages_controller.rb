class PagesController < ApplicationController
  def sign_in
    redirect_to settings_path if signed_in?
  end
end
