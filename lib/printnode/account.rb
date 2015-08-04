module PrintNode
  class Account
    attr_accessor :firstname
    attr_accessor :lastname
    attr_accessor :email
    attr_accessor :password
    attr_accessor :creator_ref

    def to_hash
      hash = {}
      hash['firstname'] = @firstname
      hash['lastname'] = @lastname
      hash['email'] = @email
      hash['password'] = @password
      hash['creatorRef'] = @creator_ref if @creator_ref
      hash
    end

    def initialize(firstname, lastname, email, password)
      @firstname = firstname
      @lastname = lastname
      @email = email
      @password = password
    end
  end
end
