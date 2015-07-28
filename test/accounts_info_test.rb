require 'test/unit'
require 'printnode'

class Computers_Test < Test::Unit::TestCase

	attr_writer :client
	attr_reader :auth

	def setup
		@auth = PrintNode::Auth.new("MyAuth")
		@client = PrintNode::Client.new(@auth)
		@client.get("/test/data/generate")
	end

	def teardown
		@client = PrintNode::Client.new(@auth)
		@client.delete("/test/data/generate")
	end

	def test_whoami
		whoami = @client.whoami
		assert_instance_of(Fixnum,whoami.credits,"whoami.credits was not Fixnum")
	end

	def test_tags
		tagstate = @client.set_tag("ATag","ATagValue")
		assert_equal("created",tagstate,"tagstate did not equal 'created'")
		tagvalue = @client.tags("ATag")
		assert_equal("ATagValue",tagvalue, "tagvalue did not equal 'ATagValue'")
		tagdelete = @client.delete_tag?("ATag")
		assert(true,tagdelete)
	end

	def test_latest_client
		latest_client = @client.latest_client
		assert_equal("windows",latest_client.os,"client os was not 'windows'")
	end

	def test_clients
		clients = @client.clients
		assert_instance_of(Fixnum,clients[0].id,"clients[0].enabled was not a boolean")
		clients_id_array = @client.modify_client_downloads("10",false)
		assert_equal(10,clients_id_array[0],"clients_id_array[0] was not 10")
	end



end
