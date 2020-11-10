# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    json_response(users: User.all)
  end

  def show
    selected_user = User.find(params[:id])
    json_response(user: user_with_image(selected_user))
  end

  private

  def user_with_image(user)
    user_with_attachment = { id: user.id, username: user.username,
                             email: user.email, profile_image: nil,
                             can_post_date: user.can_post_date,
                             can_comment_date: user.can_comment_date,
                             created_at: user.created_at}
    unless user.profile_image_attachment.nil?
      user_with_attachment['profile_image'] = url_for(user.profile_image)
    end

    user_with_attachment
  end
end
