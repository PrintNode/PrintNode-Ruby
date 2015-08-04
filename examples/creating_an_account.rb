require 'printnode'

#Firstly we'll create a new Auth object, and set our credentials using it.
#Here, we are authenticating with an API-Key, but we can also authenticate by putting an email and password as arguments:
#(auth = PrintNode::Auth.new("MyEmail@Emailprovider.com","MyPasswordForPrintNode"))
auth = PrintNode::Auth.new("MyAuth")


#Now, we'll create a client with our new credentials.
client = PrintNode::Client.new(auth)

#Now that we've created a client, let's build some objects for our new account.
options = {} # This is for an options = {} argument in create_account.

options["ApiKeys"] = ["dev"]
options["Tags"] = {"likes" => "PrintNode"}

#We have to make an account object to put in our client.
child_account_info = PrintNode::Account.new("A","Person","MyEmail@Emailprovider.com","AStrongPassword")
child_account_info.creator_ref = "MyCreatorRef"

#We can now create our account using PrintNode::Client.create_account.
child_info = client.create_account(child_account_info,options)

#Let's make a new client for the Child Account.
child_client = PrintNode::Client.new(auth)

#Using the info we got from the the create_acocunt method, we can now set our child account by the Id of the Child Account we created.
child_client.child_account_by_id(child_info.Account.id)

puts child_client.headers
#Now we can use the Child Account however we want!
child_whoami = child_client.whoami
child_firstname = child_whoami.firstname #Should be "A"

#Let's delete the account.
child_client.delete_account? #Returns a boolean - true if the account was deleted!


