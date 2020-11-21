# frozen_string_literal: true

class ActivationMailer < ApplicationMailer
  default from: 'forumCMS@notifications.com'

  def welcome_email
    site = 'arn-forum-api.herokuapp.com'
    @user = params[:user]
    @url  = "https://#{site}/registrations/#{@user.id}/activate_account/#{@user.activation_key}"
    mail(to: @user.email, subject: 'Welcome to the React.js Forum-CMS Demo')
  end
end
