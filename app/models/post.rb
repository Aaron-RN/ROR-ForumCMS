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
  
  def post_json
    if self.is_a? Array
      returned_posts = []
      postsArray.each do |post|
        new_post = post.as_json(only: %i[id user_id is_pinned subforum created_at])
        new_post['title'] = post.title.slice(0..30)
        new_post['body'] = post.body.slice(0..32)
        new_post['author'] = post.author.username
        new_post['forum'] = post.forum.name
        returned_posts.push(new_post)
      end

      return returned_posts
    else
      new_post = attributes
      new_post['author'] = author.username
      new_post['forum'] = forum.name
      new_post
    end
  end
  
  def self.pins_json
    results = []
    all_pins = Post.pins
    all_pins.each do |p|
      new_post = p.post_json
      results.push(new_post)
    end
    
    results
  end
end
