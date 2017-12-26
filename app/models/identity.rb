class Identity < ApplicationRecord
  belongs_to :user, optional: true

  def self.omniauth_exists?(auth)
    !!find_by(uid: auth.uid, provider: auth.provider)
  end

  def self.find_with_omniauth(auth)
    find_by(uid: auth.uid, provider: auth.provider)
  end

  def self.create_with_omniauth(auth)
    create!(
      uid: auth.uid,
      provider: auth.provider,
      name: auth.info.name,
      email: auth.info.email,
      image: auth.info.image,
      oauth_token: auth.credentials.token
    )
  end

  def self.update_with_omniauth(auth)
    find_by(uid: auth.uid, provider: auth.provider).update(
      name: auth.info.name,
      email: auth.info.email,
      image: auth.info.image,
      oauth_token: auth.credentials.token
    )

    find_by(uid: auth.uid, provider: auth.provider)
  end

  def self.provider_name(provider)
    case provider
    when 'google_oauth2' then 'Google'
    when 'facebook'      then 'Facebook'
    when 'github'        then 'GitHub'
    when 'linkedin'      then 'LinkedIn'
    end
  end

  def provider_name
    Identity.provider_name(self.provider)
  end
end
