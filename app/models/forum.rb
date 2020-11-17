# frozen_string_literal: true

class Forum < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :name, length: { in: 3..32 }, presence: true,
                   uniqueness: { case_sensitive: false }
  validate :subforums_check

  def subforums_check
    subforums.each do |subforum|
      trim_subforum = subforum.strip

      if trim_subforum.length < 3 || trim_subforum.length > 32
        errors
          .add "(#{subforum})", 'Length must be within the value of 3 and 32...'
      end
    end
  end

  # Grabs all posts by subforum, while also limiting the amount posts retrieved
  def subforum_posts(subforum, per_page = 10, page = 1)
    range_begin = (page * per_page) - (per_page - 1)
    range_end = page * per_page
    posts_range = range_begin..range_end
    retrieved_posts = posts.where(subforum: subforum, id: posts_range)

    truncate_posts(retrieved_posts)
  end

  private

  # Truncates posts title and body attribute returning a new array
  def truncate_posts(posts)
    returned_posts = []
    posts.each do |post|
      new_post = post.to_json(only: %i[user_id is_pinned created_at])
      new_post['title'] = post.title.slice(0..30)
      new_post['body'] = post.body.slice(0..32)
      returned_posts.push(new_post)
    end

    returned_posts
  end
end
