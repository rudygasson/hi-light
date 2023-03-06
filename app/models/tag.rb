class Tag < ApplicationRecord
  belongs_to :user
  has_many :hi_tags
  validates :name, presence: true
end
