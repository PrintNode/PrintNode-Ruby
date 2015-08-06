module PrintNode
  # An object to deal with Account Creation.
  # @author Jake Torrance
  # @author PrintNode
  class Account
    attr_accessor :firstname
    attr_accessor :lastname
    attr_accessor :email
    attr_accessor :password
    attr_accessor :creator_ref

    # Map our object into a hash for JSON Encoding.
    def to_hash
      hash = {}
      hash['firstname'] = @firstname
      hash['lastname'] = @lastname
      hash['email'] = @email
      hash['password'] = @password
      hash['creatorRef'] = @creator_ref if @creator_ref
      hash
    end

    # Initialize our object ready for being mapped into a hash.
    def initialize(firstname, lastname, email, password)
      @firstname = firstname
      @lastname = lastname
      @email = email
      @password = password
    end
  end
end
