# frozen_string_literal: true

class ActivationMailer < ApplicationMailer
  default from: 'forumCMS@notifications.com'

  def welcome_email
    # site = 'arn-forum-api.herokuapp.com'
    @user = params[:user]
    # @activation_key = @user.activation_key
    # @url = "https://#{site}/registrations/#{@user.id}/activate_account"
    mail(to: @user.email, subject: 'Welcome to the React.js Forum-CMS Demo')
  end
  
  def password_reset_email
    # site = 'arn-forum-api.herokuapp.com'
    @user = params[:user]
    # @activation_key = @user.activation_key
    # @url = "https://#{site}/registrations/#{@user.id}/activate_account"
    mail(to: @user.email, subject: 'Forgot your password?')
  end
end
