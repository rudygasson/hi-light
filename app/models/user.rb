class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tags
  has_many :highlights
  has_many :books
  has_one_attached :photo
  acts_as_favoritor
  acts_as_favoritable

  include PgSearch::Model
  pg_search_scope :search_by_user_name,
    against: [ :first_name, :last_name ],
    using: {
      tsearch: { prefix: true }
    }
end
