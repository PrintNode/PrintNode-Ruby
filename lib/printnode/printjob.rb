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

    # Maps the object into a hash ready for JSON Encoding.
    def to_hash
      hash = {}
      hash['printerId'] = @printer_id
      hash['title'] = @title
      hash['contentType'] = @content_type
      hash['content'] = @content
      hash['source'] = @source
      hash
    end

    # Initializes the object with the variables required.
    def initialize(printer_id, title, content_type, content, source)
      @printer_id = printer_id
      @title = title
      @content_type = content_type
      @content = content
      @source = source
    end
  end
end
