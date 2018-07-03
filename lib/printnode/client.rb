require 'net/https'
require 'uri'
require 'json'
require 'ostruct'
require 'cgi'

module PrintNode
  # Handles all requests and API access.
  # @author Jake Torrance
  # @author PrintNode
  class Client

    attr_reader :headers

    # If an argument is not a string, map it to a string so it can be escaped
    # and put into a URL.
    #
    # @param obj Object to be mapped into a string and escaped.
    #
    # == Returns:
    # CGI.escaped object.
    def escape_with_types(obj)
      obj = obj.to_s unless obj.is_a?(String)
      CGI.escape(obj)
    end

    # Initializes auth object, api url and headers.
    #
    # @param auth [PrintNode::Auth] auth object with credentials.
    # @param api_url [String] api_url to be used in requests.
    #
    # @see PrintNode::Auth
    def initialize(auth, api_url = 'https://api.printnode.com')
      @auth = auth
      @api_url = api_url
      @headers = {}
    end

    # parses any hashes in an array to OpenStructs.
    #
    # @param array [Array] the array we want to parse.
    #
    # == Returns:
    # An array with all hashes inside it made into OpenStructs.
    def parse_array_to_struct(array)
      output = []
      array.each do |h|
        if h.is_a?(Hash)
          output.push(parse_hash_to_struct(h))
        elsif h.is_a?(Array)
          output.push(parse_array_to_struct(h))
        else
          output.push(h)
        end
      end
      output
    end

    # parses any hashes in a hash to OpenStructs.  Parses any arrays to check if they have hashes to parse. Creates an OpenStruct for the hash.
    #
    # @param hash [Hash] the hash we want to parse.
    #
    # == Returns:
    # A hash that is an OpenStruct, with all hashes inside it made into OpenStructs.
    def parse_hash_to_struct(hash)
      hash.each do |(k, v)|
        hash[k] = parse_hash_to_struct(v) if v.is_a?(Hash)
        hash[k] = parse_array_to_struct(v) if v.is_a?(Array)
      end
      OpenStruct.new hash
    end

    # Sets authentication via an id of a Child Account.
    #
    # @param id [int] The id of the Child Account.
    def child_account_by_id(id)
      @headers = { 'X-Child-Account-By-Id' => id }
    end

    # Sets authentication via an email of a Child Account.
    #
    # @param email [String] the email of the Child Account.
    def child_account_by_email(email)
      @headers = { 'X-Child-Account-By-Email' => email }
    end

    # Sets authentication via the creator reference of a Child Account.
    #
    # @param creator_ref [String] the creator reference of the Child Account.
    def child_account_by_creator_ref(creator_ref)
      @headers = { 'X-Child-Account-By-CreatorRef' => creator_ref }
    end

    # Creates a response object out of a Net::HTTP::(request method).
    #
    # @param request [Net::HTTPGenericRequest] request to be done.
    #
    # == Returns:
    # The response of this request.
    def start_response(request, uri)
      response = Net::HTTP.start(uri.hostname,
                                 uri.port,
                                 use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end
      http_error_handler(response)
      response
    end

    # Sends a DELETE request to the specified URL.
    #
    # @param end_point_url [String] To be appended onto api_url to be used in the request.
    #
    # == Returns:
    # A response object of the request.
    def delete(end_point_url)
      uri = URI(@api_url + end_point_url)
      request = Net::HTTP::Delete.new(uri)
      @headers.each_with_index do |(k, v)|
        request[k] = v
      end
      request.basic_auth(@auth.credentials[0], @auth.credentials[1])
      start_response(request, uri)
    end

    # Sends a GET request to the specified URL.
    #
    # @param end_point_url [String] To be appended onto api_url to be used in the request.
    #
    # == Returns:
    # A response object of the request.
    def get(end_point_url)
      uri = URI(@api_url + end_point_url)
      request = Net::HTTP::Get.new(uri)
      @headers.each_with_index do |(k, v)|
        request[k] = v
      end
      request.basic_auth(@auth.credentials[0], @auth.credentials[1])
      start_response(request, uri)
    end

    # Sends a PATCH request to the specified URL.
    #
    # @param end_point_url [String] To be appended onto api_url to be used in the request.
    # @param data Data object to be encoded into JSON. If not used, nothing is put in the body of the request.
    #
    # == Returns:
    # A response object of the request.
    def patch(end_point_url, data = nil)
      uri = URI(@api_url + end_point_url)
      request = Net::HTTP::Patch.new uri
      @headers.each_with_index do |(k, v)|
        request[k] = v
      end
      request.basic_auth(@auth.credentials[0], @auth.credentials[1])
      request['Content-Type'] = 'application/json'
      request.body = data.to_json if data
      start_response(request, uri)
    end

    # Sends a POST request to the specified URL.
    #
    # @param end_point_url [String] To be appended onto api_url to be used in the request.
    # @param data Data object to be encoded into JSON. If not used, nothing is put in the body of the request.
    #
    # == Returns:
    # A response object of the request.
    def post(end_point_url, data = nil)
      uri = URI(@api_url + end_point_url)
      request = Net::HTTP::Post.new uri
      @headers.each_with_index do |(k, v)|
        request[k] = v
      end
      request.basic_auth(@auth.credentials[0], @auth.credentials[1])
      request['Content-Type'] = 'application/json'
      request.body = data.to_json if data
      start_response(request, uri)
    end

    # Sends a GET request to /whoami/.
    #
    # == Returns:
    # An OpenStruct object of the response. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see {https://www.printnode.com/docs/api/curl/#whoami Whoami on API Docs}
    def whoami
      OpenStruct.new JSON.parse(get('/whoami/').body)
    end

    # Sends a POST request to /account/.
    #
    # @param account [PrintNode::Account] Account object for new user.
    # @option options [Array[String]] :ApiKeys Array of apikey descriptions to be created for this account.
    # @option options [Hash] :Tags tag_name => tag_value hash of tags to be added for this user.
    #
    # == Returns:
    # An OpenStruct object of the response. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see http://www.printnode.com/docs/api/curl/#account-creation Account Creation on API Docs
    def create_account(account, options = {})
      hash = {}
      hash['Account'] = account.to_hash
      if options
        options.each do |(k, v)|
          hash[k] = v
        end
      end
      response_object = JSON.parse(post('/account/', hash).body)
      parse_hash_to_struct(response_object)
    end

    # Sends a PATCH request to /account/.
    #
    # @option options [String] :firstname new Firstname of user.
    # @option options [String] :lastname new Last+']')[0]ions [String] :password new Password of user.
    # @option options [String] :email new Email of user.
    # @option options [String] :creatorRef new creator reference of user.
    #
    # == Returns:
    # An OpenStruct object of the response. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see http://www.printnode.com/docs/api/curl/#account-modification Account Modification on API Docs
    def modify_account(options = {})
      hash = options.dup
      response_object = JSON.parse(patch('/account/', hash).body)
      parse_hash_to_struct(response_object)
    end

    # Sends a DELETE request to /account/.
    #
    # == Returns:
    # A boolean of whether the account was deleted or not.
    def delete_account?
      JSON.parse('[' + delete('/account/').body + ']')[0]
    end

    # Sends a GET request to /account/tag/(tag_name).
    #
    # @param tag_name [String] the name of the tag to be gotten.
    #
    # == Returns:
    # A string which is the value of the tag requested.
    def tags(tag_name)
      end_point_url = '/account/tag/' + escape_with_types(tag_name)
      JSON.parse('[' + get(end_point_url).body + ']')[0]
    end

    # Sends a POST request to /account/tag/(tag_name).
    #
    # @param tag_name [String] the name of the tag to be created.
    # @param tag_value [String] the name of the tag value to be created.
    # == Returns:
    # If this creates a tag,  a String 'created' will be returned. If it updates one,  'updated' will be returned.
    def set_tag(tag_name, tag_value)
      end_point_url = '/account/tag/' + escape_with_types(tag_name)
      JSON.parse('[' + post(end_point_url, tag_value).body + ']')[0]
    end

    # Sends a DELETE request to /account/tag/(tag_name).
    #
    # == Returns:
    # A boolean of whether the tag was deleted or not.
    def delete_tag?(tag_name)
      end_point_url = '/account/tag/' + escape_with_types(tag_name)
      JSON.parse('[' + delete(end_point_url).body + ']')[0]
    end

    # Sends a GET request to /account/apikey/(description).
    #
    # @param description [String] Description of the API-Key to be gotten.
    #
    # == Returns:
    # The API-Key itself.
    def apikeys(description)
      end_point_url = '/account/apikey/' + escape_with_types(description)
      JSON.parse('[' + get(end_point_url).body + ']')[0]
    end

    # Sends a POST request to /account/apikey/(description).
    #
    # @param description [String] Description of the API-Key to be made.
    #
    # == Returns:
    # The API-Key that was created.
    def create_apikey(description)
      end_point_url = '/account/apikey/' + escape_with_types(description)
      JSON.parse('[' + post(end_point_url).body + ']')[0]
    end

    # Sends a DELETE request to /account/apikey/(description).
    #
    # @param description [String] Description of the API-Key to be deleted.
    #
    # == Returns:
    # A boolean of whether the API-Key was deleted or not.
    def delete_apikey?(description)
      end_point_url = '/account/apikey/' + escape_with_types(description)
      JSON.parse('[' + delete(end_point_url).body + ']')[0]
    end

    # Sends a GET request to /client/key/(uuid)?edition=(edition)&version=(version)
    #
    # @param uuid [String] the UUID of the client
    # @param edition [String] the edition of the client
    # @param version [String] The version of the client
    #
    # == Returns:
    # The Client-key that was gotten.
    def clientkeys(uuid, edition, version)
      end_point_url = '/client/key/' +
                      escape_with_types(uuid) +
                      '?edition=' +
                      escape_with_types(edition) +
                      '&version=' +
                      escape_with_types(version)
      JSON.parse('[' + get(end_point_url).body + ']')[0]
    end

    # Sends a GET request to /download/client/(os)
    #
    # @param os [String] the OS of the client to be found.
    #
    # == Returns:
    # An OpenStruct object of the response. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see https://www.printnode.com/docs/api/curl/#account-download-management Client Downloads on API Docs
    def latest_client(os = 'windows')
      end_point_url = '/download/client/' + escape_with_types(os.downcase)
      OpenStruct.new JSON.parse(get(end_point_url).body)
    end

    # Sends a GET request to /download/clients/(client_set)
    #
    # @param client_set [String] a set of the clients to be got
    #
    # == Returns:
    # An Array of OpenStruct objects. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see https://www.printnode.com/docs/api/curl/#account-download-management Client Downloads on API Docs
    def clients(client_set = '')
      end_point_url = '/download/clients/' + escape_with_types(client_set)
      response_object = JSON.parse(get(end_point_url).body)
      parse_array_to_struct(response_object)
    end

    # Sends a PATCH request to /download/clients/(client_set)
    #
    # @param client_set [String] a set of have their settings changed
    # @param enabled [Boolean] whether we want to enable (true) or disable (false) the clients.
    #
    # == Returns:
    # An Array of ints that are ids that were changed.
    def modify_client_downloads(client_set, enabled)
      hash = { 'enabled' => enabled }
      end_point_url = '/download/clients/' + escape_with_types(client_set)
      JSON.parse(patch(end_point_url, hash).body)
    end

    # Sends a GET request to /computers/(computer_set)
    #
    # @param computer_set [String] a set of the computers to be got.
    #
    # == Returns:
    # An Array of OpenStruct objects. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see https://www.printnode.com/docs/api/curl/#computers Computers on API Docs
    def computers(computer_set = '')
      end_point_url = '/computers/' + escape_with_types(computer_set)
      response_object = JSON.parse(get(end_point_url).body)
      parse_array_to_struct(response_object)
    end

    # Sends a GET request to /computer/(computer_id)/scales
    #
    # @param computer_id [String] a set of computers to be got.
    #
    # == Returns:
    # An Array of OpenStruct objects. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see https://www.printnode.com/docs/api/curl/#scales Scales on API Docs
    def scales(computer_id)
      end_point_url = '/computer/' +
                      escape_with_types(computer_id) +
                      '/scales/'
      response_object = JSON.parse(get(end_point_url).body)
      parse_array_to_struct(response_object)
    end

    # Sends a GET request to /printers/(set_a), or:
    # /computers/(set_a)/printers/(set_b) if set_b is used.
    #
    # @param set_a [String] if set_b used: set of computers relative to printers set in set_b.
    # if set_b unused: set of printers to be got.
    #
    # @param set_b [String] set of printers.
    # == Returns:
    # An Array of OpenStruct objects. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see https://www.printnode.com/docs/api/curl/#printers Printers on API Docs
    def printers(set_a = '', set_b = nil)
      if set_b
        end_point_url = '/computers/' +
                        escape_with_types(set_a) +
                        '/printers/' +
                        escape_with_types(set_b)
      else
        end_point_url = '/printers/' + escape_with_types(set_a)
      end
      response_object = JSON.parse(get(end_point_url).body)
      parse_array_to_struct(response_object)
    end

    # Sends a GET request to /printjobs/(set_a), or:
    # /printers/(set_a)/printjobs/(set_b) if set_b is used.
    #
    # @param set_a [String] if set_b used: set of printers relative to printjobs set in set_b.
    # if set_b unused: set of printjobs to be got.
    #
    # @param set_b [String] set of printjobs.
    # == Returns:
    # An Array of OpenStruct objects. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see https://www.printnode.com/docs/api/curl/#printjob-viewing PrintJobs on API Docs
    def printjobs(set_a = '', set_b = nil)
      if set_b
        end_point_url = '/printers/' +
                        escape_with_types(set_a) +
                        '/printjobs/' +
                        escape_with_types(set_b)
      else
        end_point_url = '/printjobs/' + escape_with_types(set_a)
      end
      response_object = JSON.parse(get(end_point_url).body)
      parse_array_to_struct(response_object)
    end

    # Sends a POST request to /printjobs/.
    #
    # @param printjob [PrintNode::PrintJob] printjob object to be submitted.
    # @option options [Hash] :options a hash of any of the options available on the API docs.
    # @option options [int] :expireAfter Number of seconds until printjob expires.
    # @option options [int] :qty how many times this printjob will be sent to the server.
    # @option options [Hash] :authentication A hash of an authentication object found on the API docs.
    #
    # == Returns:
    # The id of the printjob that was created.
    # @see https://www.printnode.com/docs/api/curl#printjob-creating PrintJob creating on API Docs
    # @see https://www.printnode.com/docs/api/curl#printjob-options PrintJob options on API Docs
    def create_printjob(printjob, options = {})
      hash = printjob.to_hash
      if options
        options.each do |(k, v)|
          hash[k] = v
        end
      end
      JSON.parse('[' + post('/printjobs/', hash).body + ']')[0]
    end

    # sends a GET request to /printjobs/(printjob_set)/states
    #
    # @param printjob_set [String] set of printjobs that we will get states for.
    #
    # == Returns:
    # An Array of OpenStruct objects. The design of this Object will be the same as the ones on the PrintNode API docs.
    # @see https://www.printnode.com/docs/api/curl/#printjob-states PrintJob states on API Docs
    def states(printjob_set = '')
      if printjob_set == ''
        end_point_url = '/printjobs/states/'
      else
        end_point_url = '/printjobs/' +
                        escape_with_types(printjob_set) +
                        '/states/'
      end
      response_object = JSON.parse(get(end_point_url).body)
      parse_array_to_struct(response_object)
    end

    # Handles HTTP errors in the code.
    # If the HTTP status code is not 2xx (OK), it will raise an error.
    #
    # @param response [Net::HTTPResponse] A response from any of the request methods.
    def http_error_handler(response)
      begin
        unless response.code.to_s.match('^2..')
          fail APIError.new(response.code), response.body
        end
      rescue APIError => e
        puts 'HTTP Error found: ' + e.object
        puts 'This was the body of the response: '
        puts e.message
      end
    end
  end
end
