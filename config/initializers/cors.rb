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
  end
end
