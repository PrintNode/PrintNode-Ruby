module PrintNode
  # Handles which credentials we are using
  # @author Jake Torrance
  # @author PrintNode
  class Auth
    # Initalizes our credentials
    #
    # @param value_a [String] two arguments : this will be an email address.
    # With one, it is an API-Key.
    # @param value_b [String] The password relative to the email set in value_a.
    def initialize(value_a, value_b = nil)
      if value_b
        @email = value_a
        @password = value_b
      else
        @apikey = value_a
      end
    end
    # Returns correctly formatted credentials for HTTP::Request.basic_auth
    #
    # == Returns:
    # An array of with our credentials.
    def credentials
      @apikey ? [@apikey, ''] : [@email, @password]
    end
  end
end
