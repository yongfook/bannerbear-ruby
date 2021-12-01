module Bannerbear

  class Client

    def initialize(api_key = nil)
      @api_key = api_key || ENV["BANNERBEAR_API_KEY"]
    end

    def account
      get_response "/account"
    end

    # Images

    def get_image(uid)
    	get_response "/images/#{uid}"
    end

    def list_images(params = {:page => 1, :limit => 25})
    	get_response "/images?#{URI.encode_www_form(params.slice(:page, :limit))}"
    end

    def create_image(uid, params = {:modifications => [], :webhook_url => nil, :transparent => nil, :render_pdf => nil, :metadata => nil, :synchronous => false})
    	post_response "/images", params.slice(:modifications, :webhook_url, :transparent, :render_pdf, :metadata).merge({:template => uid}), params[:synchronous]
    end

    # Videos

    def get_video(uid)
    	get_response "/videos/#{uid}"
    end

    def list_videos(params = {:page => 1})
    	get_response "/videos?#{URI.encode_www_form(params.slice(:page))}"
    end

    def create_video(uid, params = {:input_media_url => nil, :modifications => [], :blur => nil, :trim_to_length_in_seconds => nil, :webhook_url => nil, :metadata => nil, :frames => [], :frame_durations => [], :create_gif_preview => nil})
    	post_response "/videos", params.slice(:input_media_url, :modifications, :blur, :trim_to_length_in_seconds, :webhook_url, :transparent, :metadata, :frames, :frame_durations, :create_gif_preview).merge({:video_template => uid})
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
    BB_API_ENDPOINT_SYNCHRONOUS = "https://sync.api.bannerbear.com/v2"

    def get_response(url)
    	response = HTTParty.get("#{BB_API_ENDPOINT}#{url}", timeout: 3, headers: { 'Authorization' => "Bearer #{@api_key}" })
    	JSON.parse(response.body)
    end

    def patch_response(url, payload)
    	response = HTTParty.patch("#{BB_API_ENDPOINT}#{url}", 
    		body: payload.to_json,
    		timeout: 5,
    		headers: { 
    			'Authorization' => "Bearer #{@api_key}",
    			'Content-Type' => 'application/json'
    		}
    	)
    	JSON.parse(response.body)
    end

    def post_response(url, payload, sync = false)
    	endpoint = BB_API_ENDPOINT
    	timeout = 5
    	if sync == true
    		endpoint = BB_API_ENDPOINT_SYNCHRONOUS 
    		timeout = 15
    	end
    	response = HTTParty.post("#{endpoint}#{url}", 
    		body: payload.to_json,
    		timeout: timeout,
    		headers: { 
    			'Authorization' => "Bearer #{@api_key}",
    			'Content-Type' => 'application/json'
    		}
    	)
    	body = JSON.parse(response.body)
    	return {"error" => body['message']} if response.code >= 400
    	return body
    end

  end

end