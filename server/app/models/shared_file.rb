class SharedFile < ActiveRecord::Base
  has_and_belongs_to_many :clients
  validates_presence_of :filename
  
  def current?
    most_recent_timestamp = clients.collect(&:last_seen_at).max
    most_recent_timestamp >= 5.minutes.ago if most_recent_timestamp.present?
  end
end
