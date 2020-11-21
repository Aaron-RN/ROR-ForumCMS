ActionMailer::Base.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: 587,
  domain: 'arn-forum-api.herokuapp.com',
  user_name: 'apikey',
  password: ENV['SENDGRID_API_KEY'],
  authentication: :plain
}
