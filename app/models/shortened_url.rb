class ShortenedUrl < ActiveRecord::Base

  validates :submitter_id, uniqueness: true, presence: true
  validates :long_url, presence: true
  validates :short_url, uniqueness: true, presence: true


  def self.random_code
    code = SecureRandom.urlsafe_base64(12)

    until !ShortenedUrl.exists?(code)
      code = SecureRandom.urlsafe_base(12)
    end

    code
  end


  def self.create_for_user_and_long_url!(user, long_url)


    ShortenedUrl.create!(
      :submitter_id => user.id,
      :long_url => long_url,
      :short_url => self.random_code
    )

  end

end
