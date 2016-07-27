require 'base64'

module PrintNode
  # An object for printjob creation.
  # @author Jake Torrance
  # @author PrintNode
  class PrintJob
    attr_accessor :printer_id
    attr_accessor :title
    attr_accessor :content_type
    attr_accessor :content
    attr_accessor :source

    # Initializes the object with the variables required.
    def initialize(printer_id, title, content_type, content, source)
      @printer_id = printer_id
      @title = title
      @content_type = content_type
      @content = content
      @source = source
    end

    # Maps the object into a hash ready for JSON Encoding.
    def to_hash
      hash = {}
      hash['printerId'] = @printer_id
      hash['title'] = @title
      hash['contentType'] = @content_type
      # Used to be, we only supported file names for Base64, but it's actually better
      # to allow the user to send us a data string if they desire.  Testing the
      # content to see if it's a path allows for backwards compatibility
      if @content_type.match('base64$') && File.exist?(@content)
        hash ['content'] = Base64.encode64(IO.read(@content))
      else
        hash ['content'] = @content
      end
      hash['source'] = @source
      hash
    end
  end
end
