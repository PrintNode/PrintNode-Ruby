require 'test/unit'
require 'printnode'

class Computers_Test < Test::Unit::TestCase

	attr_writer :client
	attr_writer :account
	attr_reader :auth

	def setup
		@auth = PrintNode::Auth.new("MyAuth")
		@client = PrintNode::Client.new(@auth)
		@client.get("/test/data/generate")
		@account = @client.create_account("A","Person","someEmail@SomeEmailProvider.com","AnEpicPassword")
	end

	def teardown
		@client = PrintNode::Client.new(@auth)
		@client.delete("/test/data/generate")
		@client.child_account_by_email(@account.Account.email)
		@client.delete_account?
	end

	def test_modify_account
		@client.child_account_by_email(@account.Account.email)
		modified = @client.modify_account({"firstname" => "NotA"})
		assert_equal("NotA",modified.firstname,"modified.firstname did not equal 'NotA'")
	end

	def test_api_keys
		@client.child_account_by_email(@account.Account.email)
		api_key = @client.create_apikey("Development")
		assert_equal(api_key,@client.apikeys("Development"),"API-Key created did not equal API-Key gotten.")
		assert(true,@client.delete_apikey?("Development"))
	end

end
