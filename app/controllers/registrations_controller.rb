# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def create
    user = User.create!(register_params)
    json_response({ user: user }, :created)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end

  def register_params
    # whitelist params
    params.require(:user)
          .permit(:username, :email, :password, :password_confirm)
  end
end
