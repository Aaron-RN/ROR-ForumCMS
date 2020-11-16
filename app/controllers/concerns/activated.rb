# frozen_string_literal: true

module IsActivated
  def activated(user)
    unless user.is_activated
      json_response({ errors: ['Account not activated'] }, 401)
      return false
    end

    true
  end
end
