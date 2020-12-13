# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_admin, only: %i[set_admin_level suspend_communication]
  before_action :set_user, only: %i[show set_admin_level suspend_communication]

  def index
    all_users = User.all
    users_array = []
    all_users.each do |user|
      users_array.push(user_with_image(user))
    end

    json_response(users: users_array)
  end

  def show
    json_response(user: user_with_image(@user))
  end

  # Change a user's administrative level
  def set_admin_level
    error_desc = 'Your admin level is too low'
    error_desc2 = "Can't change the administrative level of the site owner"

    return json_response({ errors: error_desc }, 401)  if @admin.admin_level < 2

    return json_response({ errors: error_desc2 }, 401) if @user.admin_level == 3

    @user.update_attribute(:admin_level, params[:user][:admin_level])
    json_response(user: user_with_image(@user))
  end

  def suspend_communication
    error_desc = 'You do not have the necessary privileges'

    return json_response({ errors: error_desc }, 401) if @admin.admin_level < 1

    post_ban = params[:user][:can_post_date]
    comment_ban = params[:user][:can_comment_date]

    suspend_comms(@user, post_ban, :can_post_date)
    suspend_comms(@user, comment_ban, :can_comment_date)

    json_response(user: user_with_image(@user))
  end

  private

  def set_admin
    @admin = User.find(params[:user][:admin_id])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def suspend_comms(user, comms, attr)
    return unless comms.nil?
    return unless comms.is_a?(Array)

    comms_i = comms.map(&:to_i)
    ban_date = DateTime.new(comms_i[0], comms_i[1], comms_i[2], comms_i[3], comms_i[4]);
    user.update_attribute(attr, ban_date)
  end

  # Returns a hash object of a user with their profile_image included
  def user_with_image(user)
    user_with_attachment = user.as_json(only: %i[id username is_activated
                                                 token admin_level can_post_date
                                                 can_comment_date])
    user_with_attachment['profile_image'] = nil
    user_with_attachment['posts'] = Post.author_posts_json(user.posts)
    user_with_attachment['comments'] = user.comments.last(3)
    user_with_attachment['can_post'] = DateTime.now > user.can_post_date
    user_with_attachment['can_comment'] = DateTime.now > user.can_comment_date
    user_with_attachment['server_date'] = DateTime.now

    unless user.profile_image_attachment.nil?
      user_with_attachment['profile_image'] = url_for(user.profile_image)
    end

    user_with_attachment
  end
end
