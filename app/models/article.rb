class Article < ApplicationRecord
  belongs_to :category
  belongs_to :user
   validates :url,  presence: true
  validates :category, presence: true

  include PgSearch
  pg_search_scope :search_by_title_and_content,
    against: [ :title, :content ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
end
