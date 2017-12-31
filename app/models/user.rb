class User < ApplicationRecord
  has_many :identities

  has_many :tables
  has_many :collections

  PROVIDERS = %w[google_oauth2 facebook github linkedin]

  def self.create_with_omniauth(info)
    create!(
      name: info.name,
      email: info.email,
      image: info.image
    )
  end

  def platforms_link_message(show_pending: true)
    providers = identities.map(&:provider).uniq
    providers = PROVIDERS - providers

    if show_pending
      return '' if providers.empty?
      return "You are yet to link your #{Identity.provider_name(providers.first)} account." if providers.size == 1
      providers = providers.map { |provider| Identity.provider_name(provider) }.join(', ')
      "You are yet to link your #{providers} accounts."
    else
      return '' if providers.empty?
      return "You have already linked your #{Identity.provider_name(providers.first)} account." if providers.size == 1
      providers = providers.map { |provider| Identity.provider_name(provider) }.join(', ')
      "You have already linked your #{providers} accounts."
    end
  end

  def possible_names
    identities.map(&:name).uniq - [name]
  end

  def possible_emails
    identities.map(&:email).uniq - [email]
  end

  def possible_images
    identities.map { |i| [i.image, i.provider_name] }
  end

  def provider_linked_message(provider)
    provider_exists?(provider) ? 'Already linked' : 'Yet to be linked'
  end

  def has_read_access?(table)
    table.user_tables.find_by_user_id(self.id).read_access
  end

  def has_edit_access?(table)
    table.user_tables.find_by_user_id(self.id).edit_access
  end

  def has_read_access?(table)
    table.user_tables.find_by_user_id(self.id).admin_access
  end

  def provider_exists?(provider)
    identities.map(&:provider).uniq.include?(provider)
  end
end
