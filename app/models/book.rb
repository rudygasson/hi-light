class Book < ApplicationRecord
  belongs_to :author
  belongs_to :user
  has_many :highlights, dependent: :destroy
  validates :title, presence: true
  validates :title, uniqueness: { scope: :author }
  # has_one_attached :cover # NEED TO ACTIVATE ACTIVE STORAGE FIRST

  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :title ],
    associated_against: {
      author: [ :name ],
      highlight: [ :quote ]
    },
    using: {
      tsearch: { prefix: true }
    }
end
