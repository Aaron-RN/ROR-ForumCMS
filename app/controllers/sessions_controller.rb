# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.where(username: params['user']['username'])
               .or(User.where(email: params['user']['email']))
               .first

    json_response({ error: 'Incorrect login credentials' }, 401) unless user

    if user.try(:authenticate, params['user']['password'])
      new_token = generate_token(user.id)
      if user.update_attribute(:token, new_token)
        json_response({ logged_in: true, user: user })
      else
        json_response({ error: user.errors.full_messages })
      end
    else
      json_response({ error: 'Incorrect login credentials' }, 401)
    end
  end

  def destroy
    user = User.where(token: params['user']['token']).first
    return unless user

    user.update(token: nil)
    json_response({ logged_out: false })
  end

  def logged_in
    json_response({ logged_in: false }) if params['token'].blank?

    user = User.where(token: params['token']).first
    if user
      json_response({ logged_in: true, user: user })
    else json_response({ logged_in: false })
    end
  end
end
