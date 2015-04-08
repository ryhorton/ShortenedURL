class ShortenedUrl < ActiveRecord::Base

  validates :submitter_id,  presence: true
  validates :long_url, presence: true
  validates :short_url, uniqueness: true, presence: true


  belongs_to :submitter,
    :class_name => "User",
    :foreign_key => :submitter_id,
    :primary_key => :id

  has_many :visits,
    :class_name => "Visit",
    :foreign_key => :short_url_id,
    :primary_key => :id

  # has_many :visitors, through: :visits, source: :user

  has_many :visitors,
    Proc.new { distinct },  # to call distinct on the visitors
    through: :visits,
    source: :user



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

  # number of times a short url appears in Visits table
  def num_clicks
    self.visits.count

  end

  # number of distinct users who have clicked a link
  def num_uniques
    # self.visitors.distinct.count

    self.visitors.count
    #
    # SELECT
    #   COUNT(DISTINCT user_id)
    # FROM
    #   visits
    # WHERE
    #   visits.shortened_url_id = ?

  end

  # unique clicks in a recent time period
  def num_recent_uniques
    visits.select("visitor_id").where("visits.created_at < ?", 30.minutes.ago).count
  end

end
