require "json"
require "open-uri"

class Book < ApplicationRecord
  belongs_to :author
  belongs_to :user
  has_many :highlights, dependent: :destroy
  validates :title, presence: true
  # validates :title, uniqueness: { scope: :author } # TODO add scope user
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

  def set_default_cover
    self.default_cover = (1..96).to_a.sample
  end

  def parse_cover
    search = "#{self.title} #{self.author.name}"
    query = search.match(/(?<query>[\S ]+)[.:;?|]*/)[:query].parameterize
    url = "https://www.googleapis.com/books/v1/volumes?q=#{query}"
    data = JSON.parse(URI.open(url).read)
    if data
      return unless data["items"]
      return unless data["items"][0]["volumeInfo"]

      description = data["items"][0]["volumeInfo"]["description"]
      self.description = description[0,500] + "…" if description

      published_date = data["items"][0]["volumeInfo"]["publishedDate"]
      self.published_date = published_date.match(/^[\d]{4}/)[0] if published_date
      self.save

      return unless data["items"][0]["volumeInfo"]["imageLinks"]

      image_url = data["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"]
      return unless image_url

      self.cover.attach(io: URI.open(image_url), filename: "cover.jpeg", content_type: "image/jpeg")
    end
  end
end
