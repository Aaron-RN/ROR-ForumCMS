# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def create
    user = User.create!(register_params)
    new_activation_key = generate_token(user.id, 52)
    user.update_attribute(:admin_level, 3) if User.all.size <= 1
    if user.update_attribute(:activation_key, new_activation_key)
      ActivationMailer.with(user: user).welcome_email.deliver_later
    end
    json_response({ user: user }, :created)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end

  def activate_account
    user = User.find(params[:id])

    if user.activation_key == params[:activation_key]
      user.update_attribute(:activated, true)
    end

    json_response({ user: user })
  end

  private

  def register_params
    # whitelist params
    params.require(:user)
          .permit(:username, :email, :password, :password_confirm)
  end
end
