# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    json_response(users: User.all)
  end

  def show
    json_response(user: User.find(params[:id]))
  end
end
