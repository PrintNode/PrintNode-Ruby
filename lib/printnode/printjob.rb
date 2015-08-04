require 'base64'
module PrintNode
  class PrintJob
    attr_accessor :printer_id
    attr_accessor :title
    attr_accessor :content_type
    attr_accessor :content
    attr_accessor :source

    def to_hash
      hash = {}
      hash['printerId'] = @printer_id
      hash['title'] = @title
      hash['contentType'] = @content_type
      if @content_type.match('base64$')
        hash ['content'] = base64.encode(IO.read(@content))
      else
        hash ['content'] = @content
      end
      hash['source'] = @source
      hash
    end

    def initialize(printer_id, title, content_type, content, source)
      @printer_id = printer_id
      @title = title
      @content_type = content_type
      @content = content
      @source = source
    end
  end
end
