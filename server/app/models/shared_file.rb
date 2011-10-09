class SharedFile < ActiveRecord::Base
  has_and_belongs_to_many :clients
  validates_presence_of :filename
end
