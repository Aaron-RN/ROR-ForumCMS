module TokenGenerator
  def generate_token(user_id, token_size = 32)
    random_ascii = [
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, '!', '@', '#', '$', '%', '^', '&',
      '*', '(', ')', '-', '_', '+', '|', '~', '=',
      'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
      'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
      'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ]

    token = [user_id]

    (1..token_size - 1).each do
      token.push(random_ascii.sample)
    end

    token.join('')
  end
end
