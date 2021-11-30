module Bannerbear

  class Client

    def initialize(api_key = nil)
      @api_key = api_key || ENV["BANNERBEAR_API_KEY"]
    end

    def account
      url = "https://api.bannerbear.com/v2/account"
      response = HTTParty.get(url, headers: { 'Authorization' => "Bearer #{@api_key}" })
      JSON.parse(response.body)
    end

  end

end