class Book < ApplicationRecord
  belongs_to :author
  belongs_to :user
  has_many :highlights, dependent: :destroy
  validates :title, presence: true
  validates :title, uniqueness: { scope: :author }
  has_one_attached :cover

  # Set default cover before creation of new book
  before_create :set_default_cover

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

  private

  def set_default_cover
    self.default_cover = (1..96).to_a.sample
  end
end
