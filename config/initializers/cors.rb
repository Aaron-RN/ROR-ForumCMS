# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order
# to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # url = Rails.env == 'production' ? 'https://arn-forum-cms.netlify.app' : 'http://localhost:3000'
  url = Rails.env == 'production' ? '*' : 'http://localhost:3000'
  allowed_methods = %i[get options head]
  allow do
    origins url

    resource '*', headers: :any, methods: allowed_methods, credentials: false
    resource '/activate_account', headers: :any, methods: %i[patch]
#     resource '/users/*', headers: :any, methods: %i[get]
    resource '/users/set_admin_level', headers: :any, methods: %i[patch]
    resource '/users/suspend_comms', headers: :any, methods: %i[patch]
    resource '/sign_up', headers: :any, methods: %i[post]
#     resource '/logged_in', headers: :any, methods: %i[get]
    resource '/log_in', headers: :any, methods: %i[post]
    resource '/logout', headers: :any, methods: %i[patch]
    resource '/forums', headers: :any, methods: %i[get post patch delete]
#     resource '/forums/*', headers: :any, methods: %i[get]
#     resource '/forums/*/*', headers: :any, methods: %i[get]
    resource '/subforums', headers: :any, methods: %i[post patch delete]
    resource '/posts', headers: :any, methods: %i[get post patch delete]
    resource '/posts/pin_post', headers: :any, methods: %i[patch]
    resource '/posts/lock_post', headers: :any, methods: %i[patch]
    resource '/comments', headers: :any, methods: %i[get post patch delete]
  end
end
