class Book < ApplicationRecord
  belongs_to :author
  has_many :highlights
  validates :title, presence: true
  # has_one_attached :cover # NEED TO ACTIVATE ACTIVE STORAGE FIRST

  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :title ],
    associated_against: {
      author: [ :name, ]
    },
    using: {
      tsearch: { prefix: true }
    }
end
