class Book < ApplicationRecord
  belongs_to :author
  has_many :highlights
  validates :title, presence: true
  # has_one_attached :cover # NEED TO ACTIVATE ACTIVE STORAGE FIRST
end
