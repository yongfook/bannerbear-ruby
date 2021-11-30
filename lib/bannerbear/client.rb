module Bannerbear

  class Client

    def initialize(api_key = nil)
      @api_key = api_key || ENV["BANNERBEAR_API_KEY"]
    end

    def account
      get_response "/account"
    end

    # Templates

    def get_template(uid)
    	get_response "/templates/#{uid}"
    end

    def update_template(uid, payload = {})
    	patch_response "/templates/#{uid}", payload.slice(:name, :metadata, :tags)
    end

    def list_templates(params = {:page => 1, :tag => nil, :limit => 25, :name => nil})
    	get_response "/templates?#{URI.encode_www_form(params.slice(:page, :tag, :limit, :name))}"
    end

    # Template Sets

    def get_template_set(uid)
    	get_response "/template_sets/#{uid}"
    end

    def list_template_sets(params = {:page => 1})
    	get_response "/template_sets?#{URI.encode_www_form(params.slice(:page))}"
    end

    # Video Templates

    def get_video_template(uid)
    	get_response "/video_templates/#{uid}"
    end

    def list_video_templates(params = {:page => 1})
    	get_response "/video_templates?#{URI.encode_www_form(params.slice(:page))}"
    end




    private

    BB_API_ENDPOINT = "https://api.bannerbear.com/v2"

    def get_response(url)
    	response = HTTParty.get("#{BB_API_ENDPOINT}#{url}", timeout: 3, headers: { 'Authorization' => "Bearer #{@api_key}" })
    	JSON.parse(response.body)
    end

    def patch_response(url, payload)
    	response = HTTParty.patch("#{BB_API_ENDPOINT}#{url}", 
    		body: payload.to_json,
    		timeout: 3,
    		headers: { 
    			'Authorization' => "Bearer #{@api_key}",
    			'Content-Type' => 'application/json'
    		}
    	)
    	JSON.parse(response.body)
    end

  end

end