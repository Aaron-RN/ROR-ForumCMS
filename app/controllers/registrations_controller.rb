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

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end

  def activate_account
    # Set url variable to the front-end url
    url = 'https://arn-forum-cms.netlify.app/'
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
end
