# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_admin, only: %i[set_admin_level suspend_communication]
  before_action :set_user, only: %i[show set_admin_level suspend_communication]

  def index
    json_response(users: User.all)
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

    json_response(user: @user)
  end

  private

  def set_admin
    @admin = User.find(params[:user][:admin_id])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def suspend_comms(user, comms, attr)
    user.update_attribute(attr, comms) unless comms.nil?
  end

  # Returns a hash object of a user with their profile_image included
  def user_with_image(user)
    user_with_attachment = { id: user.id, username: user.username,
                             email: user.email, profile_image: nil,
                             can_post_date: user.can_post_date,
                             can_comment_date: user.can_comment_date,
                             created_at: user.created_at }
    unless user.profile_image_attachment.nil?
      user_with_attachment['profile_image'] = url_for(user.profile_image)
    end

    user_with_attachment
  end
end
