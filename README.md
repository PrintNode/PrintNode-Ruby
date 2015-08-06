# PrintNode-Ruby

PrintNode is a cloud printing service which allows you to connect any printer to your applicatino using our PrintNode Client and easy to use JSON API.

This quick start guide covers using the Ruby API Library. There are examples to show how to use the API Library. It assumes that you have a [PrintNode](https://www.printnode.com) account.

##Installation

###Prerequisites

* Ruby 1.9.x or Ruby 2.x.x
* rubygems

###Installing from rubygems
Simply install via `gem install printnode` with root privileges.

###Building and installing from gemspec
Firstly, you need to build the gem via:
```bash
gem build printnode.gemspec
```
Then install it via `gem install printnode-x.x.x.gem` with root privileges.

##Quick Start

Firstly, make sure you require the library when using the code:

```Ruby
require 'printnode'
```

Then, you can start using the code:

```Ruby
auth = PrintNode::Auth.new("MyApiKey")
client = PrintNode::Client.new(auth)

myComputers = client.computers
myPrinters = client.printers
```

##Docs

a Ruby *yardoc* is included in PrintNode-Ruby/doc/
