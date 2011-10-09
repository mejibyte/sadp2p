class Client < ActiveRecord::Base
  has_and_belongs_to_many :shared_files
  
  validates_presence_of :ip, :last_seen_at
  validates_uniqueness_of :ip
end
