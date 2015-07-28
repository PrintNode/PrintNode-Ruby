Gem::Specification.new do |s|
	s.name 					= "printnode"
	s.version				= "0.0.1"
	s.date					= "2015-07-28"
	s.summary				= "PrintNode-Ruby"
	s.description			= "Ruby API Library for PrintNode remote printing service."
	s.authors 				= ["PrintNode","Jake Torrance"]
	s.email					= ["support@printnode.com"]
	s.files					= ["lib/printnode.rb","lib/printnode/client.rb","lib/printnode/api_exception.rb","lib/printnode/auth.rb"]
	s.homepage				= "https://www.printnode.com"
	s.license				= "MIT"
	s.post_install_message 	= "Happy Printing!"
	s.add_development_dependency 'json'
	s.add_development_dependency 'test-unit'
end
