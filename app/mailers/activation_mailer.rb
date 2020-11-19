# frozen_string_literal: true

class ActivationMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    site = 'arn-forum-cms.herokuapp.com'
    @user = params[:user]
    @url  = "http://#{site}/registrations/#{@user.id}/activate_account/#{@user.activation_key}"
    mail(to: @user.email, subject: 'Welcome to the React.js Forum-CMS Demo')
  end
end