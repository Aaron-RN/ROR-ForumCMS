# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :forum
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :comments, dependent: :destroy
  validates :title, length: { in: 3..48 }, presence: true
  validates :body, length: { in: 8..20_000 }, presence: true
  validates :subforum, length: { in: 3..48 }, allow_nil: true
  scope :pins, -> { where('is_pinned = true') }
  scope :not_pinned, -> { where('is_pinned = false') }
end
