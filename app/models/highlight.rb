class Highlight < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :hi_tags, dependent: :delete_all
  has_many :tags, through: :hi_tags, dependent: :delete_all
  validates :quote, presence: true
  acts_as_favoritable

  include PgSearch::Model
  pg_search_scope :search_by_highlight_content,
    against: [ :quote ],
    using: {
      tsearch: { prefix: true }
    }
end
