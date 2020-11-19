# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

user_list = [
  [Faker::Internet.username(specifier: 4..32), '12345678'],
  [Faker::Internet.username(specifier: 4..32), '12345678'],
  [Faker::Internet.username(specifier: 4..32), '12345678']
]

forum_list = [
  ['Announcements', %w[rules updates]], # id: 1
  ['Misc', []] # id: 2
]

announcements_post_list = [
  [
    'Rules of Engagement', Faker::Lorem.paragraph(sentence_count: 8), 'rules', 1
  ],
  [
    'Look Left Before Looking Right',
    Faker::Lorem.paragraph(sentence_count: 8),
    'updates',
    2
  ]
]

misc_post_list = [
  [
    'The Most Electrifying Individual in WWE History',
    'Finally, the most electrifying individual has come back, to Hackernoon!' +
      Faker::Lorem.paragraph(sentence_count: 8)
  ],
  ['Sunset Dawn', Faker::Lorem.paragraph(sentence_count: 8)]
]

comments_list = [
  [2, 1, Faker::TvShows::Buffy.quote],
  [3, 1, Faker::TvShows::Buffy.quote, 1]
]

user_list.each do |name, password|
  User.create(username: name,
              email: Faker::Internet.safe_email(name: name), password: password)
end

forum_list.each do |name, subforums|
  Forum.create(name: name, subforums: subforums)
end

announcements_post_list.each do |title, body, subforum, user_id|
  User.find(user_id).posts.create(title: title, body: body,
                                  subforum: subforum, forum_id: 1)
end

misc_post_list.each do |title, body|
  User.third.posts.create(title: title, body: body, forum_id: 2)
end

comments_list.each do |user_id, post_id, body, comment_id|
  post = Post.find(post_id)
  post.comments.create(body: body, user_id: user_id, comment_id: comment_id)
end
