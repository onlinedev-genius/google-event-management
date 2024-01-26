class User < ApplicationRecord
  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
    end
  end

  def refresh_tokens(auth)
    self.full_name = auth.info.name # assuming the user model has a name
    self.avatar_url = auth.info.image # assuming the user model has an image

    self.access_token = auth.credentials.token
    self.expires_at = auth.credentials.expires_at
    self.refresh_token = auth.credentials.refresh_token
    save
  end

  def token_expired?
    expires_at.to_i < Time.now.to_i
  end
end
