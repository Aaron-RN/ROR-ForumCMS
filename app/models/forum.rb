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

  def subforum_posts(subforum)
    posts.where('subforum =?', subforum)
  end
end
