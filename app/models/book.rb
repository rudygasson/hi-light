require "json"
require "open-uri"

class Book < ApplicationRecord
  belongs_to :author
  belongs_to :user
  has_many :highlights, dependent: :destroy
  validates :title, presence: true
  validates :title, uniqueness: { scope: :author }
  has_one_attached :cover

  # Set default cover before creation of new book
  after_create :set_default_cover

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

  def set_default_cover
    self.default_cover = (1..96).to_a.sample
  end

  def parse_cover(query)
    # key=AIzaSyBeIiOB3DaJflSRXWsB78kA6byzGydC_Vk

    url = "https://www.googleapis.com/books/v1/volumes?q=#{query}"
    data = JSON.parse(URI.open(url).read)
    image = URI.open(data["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"])
    self.cover.attach(io: image, filename: "cover.jpeg", content_type: "image/jpeg")
  end
end
