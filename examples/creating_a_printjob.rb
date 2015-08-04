require 'printnode'

#Firstly, we'll make an authentication object.
auth = PrintNode::Auth.new('MyAuth')


#Now, we'll create a client with our new credentials.
client = PrintNode::Client.new(auth)

#We'll need a printer id to create a printjob. Let's get one.
my_printer_id = client.printers[0].id

options = {} #For options argument in create_printjob
options['options'] = {'bin' => '1'}
options['expireAfter'] = 120000
options['qty'] = 1

#create_printjob requires a PrintJob object, so let's make one.
my_printjob_info = PrintNode::PrintJob.new(my_printer_id, 'PrintJob_Ruby_Test', 'pdf_uri', 'https://some.pdf', 'PrintNode-Ruby')

#Now we can create our printjob.
my_printjob = client.create_printjob(my_printjob_info,options)

#We can now see our our the information of our printjob using the id we got from create_printjob.
my_printjob_info = client.printjobs(my_printjob)
