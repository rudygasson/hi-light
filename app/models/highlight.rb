class Highlight < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :hi_tags, dependent: :destroy
  has_many :tags, through: :hi_tags
  validates :quote, presence: true
end
