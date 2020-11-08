class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :post
  belongs_to :comment
  has_many :comments, dependent: :destroy
  validates :body, length: { in: 2..400 }, presence: true
end
