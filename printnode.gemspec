Gem::Specification.new do |s|
  s.name          = "printnode"
  s.version       = "1.0.6"
  s.date          = "2015-08-19"
  s.summary       = "PrintNode-Ruby"
  s.description   = "Ruby API Library for PrintNode remote printing service."
  s.authors       = ["PrintNode","Jake Torrance"]
  s.email         = ["support@printnode.com"]
  s.files         = ["lib/printnode.rb","lib/printnode/client.rb","lib/printnode/api_exception.rb","lib/printnode/auth.rb","lib/printnode/account.rb","lib/printnode/printjob.rb"]
  s.homepage      = "https://www.printnode.com"
  s.license       = "MIT"
  s.required_ruby_version = '>=1.9'
  s.post_install_message  = "Happy Printing!"
  s.add_development_dependency 'json', '>=0'
  s.add_development_dependency 'test-unit', '>=0'
end
