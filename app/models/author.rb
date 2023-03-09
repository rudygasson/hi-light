class Author < ApplicationRecord
  has_many :books
  has_many :highlights, through: :books
  validates :name, presence: true
  validates :name, uniqueness: true
end
