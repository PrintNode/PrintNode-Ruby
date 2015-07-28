module PrintNode
	# An error class for HTTP errors
	# @author Jake Torrance
	# @author PrintNode
	class APIError < StandardError
		attr_reader :object

		# Initializes an object or message to use in the error.
		# == Paramters:
		# object::
		# 	object to show error messages about.
		def initialize(object)
			@object = object
		end
	end
end
