# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def create
    user = User.create!(register_params)
    new_activation_key = generate_token(user.id, 62)
    user.update_attribute(:admin_level, 3) if User.all.size <= 1
    if user.update_attribute(:activation_key, new_activation_key)
      ActivationMailer.with(user: user).welcome_email.deliver_now
    end
    json_response({ message: 'Account registered but activation required' },
                  :created)
  end

  def change_password
    json_response(user: { logged_in: false }) if params['token'].blank?

    user = User.where(token: params['token']).first
    if user
      if user.try(:authenticate, params['user']['old_password'])
        if user.update(password_params)
          json_response({ message: 'Password changed successfully' })
        else
          json_response({ errors: user.errors.full_messages })
        end
      else
        json_response({ errors: 'Incorrect password' }, 401)
      end
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end

  def activate_account
    # Set url variable to the front-end url
    url = 'https://arn-forum-cms.netlify.app/login'
    user = User.find(params[:id])

    if user.activation_key == params[:activation_key]
      user.update_attribute(:is_activated, true)
    end

    # json_response(message: 'Successfully activated account')
    redirect_to url
  end

  private

  def register_params
    # whitelist params
    params.require(:user)
          .permit(:username, :email, :password, :password_confirmation)
  end

  def password_params
    # whitelist params
    params.require(:user)
          .permit(:password, :password_confirmation)
  end
end
