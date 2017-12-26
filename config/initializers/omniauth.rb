Rails.application.config.middleware.use OmniAuth::Builder do
  certificate = {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}

  provider :google_oauth2, Rails.application.secrets.google_client, Rails.application.secrets.google_secret, certificate
  provider :facebook, Rails.application.secrets.facebook_client, Rails.application.secrets.facebook_secret, certificate
  provider :linkedin, Rails.application.secrets.linkedin_client, Rails.application.secrets.linkedin_secret, certificate
  provider :github, Rails.application.secrets.github_client, Rails.application.secrets.github_secret, certificate
end
