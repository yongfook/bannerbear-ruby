module Bannerbear
  module V5

    class Client

      def initialize(api_key = nil)
        @api_key = api_key || ENV["BANNERBEAR_API_KEY"]
      end

      def account
        get_response "/account"
      end

      # Image Templates

      def list_image_templates(params = {})
        get_response "/image_templates?#{URI.encode_www_form(params.slice(:page))}"
      end

      def get_image_template(uid)
        get_response "/image_templates/#{uid}"
      end

      def update_image_template(uid, payload = {})
        patch_response "/image_templates/#{uid}", payload.slice(:name, :description, :tags)
      end

      # Images

      def list_images(params = {})
        get_response "/images?#{URI.encode_www_form(params.slice(:page))}"
      end

      def get_image(uid)
        get_response "/images/#{uid}"
      end

      def create_image(uid, payload = {})
        post_response "/images", payload.slice(:modifications, :formats, :scale, :dpi, :quality, :proxy, :metadata, :version).merge({:template => uid}), payload[:sync]
      end

      # Batches

      def list_batches(params = {})
        get_response "/batches?#{URI.encode_www_form(params.slice(:page))}"
      end

      def get_batch(uid)
        get_response "/batches/#{uid}"
      end

      def create_batch(payload = {})
        post_response "/batches", payload.slice(:type, :items)
      end

      # Webhooks

      def list_webhooks(params = {})
        get_response "/webhooks?#{URI.encode_www_form(params.slice(:page))}"
      end

      def get_webhook(uid)
        get_response "/webhooks/#{uid}"
      end

      def create_webhook(payload = {})
        post_response "/webhooks", payload.slice(:name, :url, :resource, :event, :status, :scope, :templates)
      end

      def update_webhook(uid, payload = {})
        patch_response "/webhooks/#{uid}", payload.slice(:name, :url, :resource, :event, :status, :scope, :templates)
      end

      def delete_webhook(uid)
        delete_response "/webhooks/#{uid}"
      end

      # Instant URLs

      def list_instant_urls(params = {})
        get_response "/instant_urls?#{URI.encode_www_form(params.slice(:page))}"
      end

      def get_instant_url(uid)
        get_response "/instant_urls/#{uid}"
      end

      def create_instant_url(payload = {})
        post_response "/instant_urls", payload.slice(:name, :template, :mode, :security, :status, :scale, :rate_limit, :template_version, :max_renders, :expires_at)
      end

      def update_instant_url(uid, payload = {})
        patch_response "/instant_urls/#{uid}", payload.slice(:name, :template, :mode, :security, :status, :scale, :rate_limit, :template_version, :max_renders, :expires_at)
      end

      def delete_instant_url(uid)
        delete_response "/instant_urls/#{uid}"
      end

      def build_instant_url(base_url, payload = {})
        modifications = payload[:modifications]
        mode          = (payload[:mode] || "encoded").to_s

        url = case mode
              when "encoded"
                data =
                  if modifications.is_a?(Hash) && modifications.keys.map(&:to_s) == ["objects"]
                    modifications[:objects] || modifications["objects"]
                  else
                    modifications
                  end
                "#{base_url}?modifications=#{Base64.urlsafe_encode64(data.to_json, padding: false)}"
              when "named_params"
                template = modifications.is_a?(Hash) ? (modifications[:template] || modifications["template"]) : nil
                objects  = modifications.is_a?(Hash) ? (modifications[:objects]  || modifications["objects"])  : modifications
                parts = []
                (template || {}).each do |k, v|
                  parts << "template:#{k}=#{URI.encode_www_form_component(v)}"
                end
                (objects || []).each do |obj|
                  name = obj[:name] || obj["name"]
                  obj.each do |k, v|
                    key = k.to_s
                    next if key == "name"
                    parts << "#{name}:#{key}=#{URI.encode_www_form_component(v)}"
                  end
                end
                "#{base_url}?#{parts.join('&')}"
              else
                raise ArgumentError, "unknown instant URL mode: #{mode.inspect}"
              end

        signing_key = payload[:signing_key]
        return url if signing_key.nil? || signing_key.empty?
        sig = OpenSSL::HMAC.hexdigest("SHA256", signing_key, url)
        "#{url}&s=#{sig}"
      end


      private

      BB_API_ENDPOINT = "https://api.bannerbear.com/v5"
      BB_API_ENDPOINT_SYNCHRONOUS = "https://sync.api.bannerbear.com/v5"

      def get_response(url)
        response = HTTParty.get("#{BB_API_ENDPOINT}#{url}", timeout: 3, headers: { 'Authorization' => "Bearer #{@api_key}" })
        body = JSON.parse(response.body)
        return {"error" => body['message'], "code" => response.code} if response.code >= 400
        return body
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
        body = JSON.parse(response.body)
        return {"error" => body['message'], "code" => response.code} if response.code >= 400
        return body
      end

      def post_response(url, payload, sync = false)
        endpoint = BB_API_ENDPOINT
        timeout = 5
        if sync == true
          endpoint = BB_API_ENDPOINT_SYNCHRONOUS
          timeout = 10
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
        return {"error" => body['message'], "code" => response.code} if response.code >= 400
        return body
      end

      def delete_response(url)
        response = HTTParty.delete("#{BB_API_ENDPOINT}#{url}",
          timeout: 5,
          headers: { 'Authorization' => "Bearer #{@api_key}" }
        )
        body = response.body.to_s.empty? ? {} : JSON.parse(response.body)
        return {"error" => body['message'], "code" => response.code} if response.code >= 400
        return {"code" => response.code}
      end

    end

  end
end
