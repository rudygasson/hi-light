class Book < ApplicationRecord
  belongs_to :author
  has_many :highlights
  validates :title, presence: true
  has_one_attached :cover
end
