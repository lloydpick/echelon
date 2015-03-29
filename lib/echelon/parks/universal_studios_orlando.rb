require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'openssl'
require 'base64'

module Echelon
  class UniversalStudiosOrlando
    attr_reader :access_token, :expires_at

    KEY    = 'AndroidMobileApp'.freeze
    SECRET = 'AndroidMobileAppSecretKey182014'.freeze
    SHARED_HEADERS = {
      'Accept'                          => 'application/json',
      'Accept-Language'                 => 'en-US',
      'X-UNIWebService-AppVersion'      => '1.2.1',
      'X-UNIWebService-Platform'        => 'Android',
      'X-UNIWebService-PlatformVersion' => '4.4.2',
      'X-UNIWebService-Device'          => 'samsung SM-N9005',
      'X-UNIWebService-ServiceVersion'  => '1',
      'User-Agent'                      => 'Dalvik/1.6.0 (Linux; U; Android 4.4.2; SM-N9005 Build/KOT49H)',
      'Connection'                      => 'Keep-Alive',
      'Accept-Encoding'                 => 'gzip'
    }.freeze

    def initialize
      uri = URI.parse('https://services.universalorlando.com/api')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # time is UTC, but their server expects to be told it's GMT
      date = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
      digest = OpenSSL::HMAC.digest('sha256', SECRET, "#{KEY}\n#{date}\n")
      signature = Base64.encode64(digest).strip.gsub(/\=$/, "\u003d")
      params = { apikey: 'AndroidMobileApp', signature: signature }.to_json

      headers = {
        'Date'         => date,
        'Content-Type' => 'application/json; charset=UTF-8'
      }.merge(SHARED_HEADERS)

      resp = http.post(uri.path, params, headers)
      data = JSON.parse(resp.body)
      @access_token = data['Token']
      @expires_at = DateTime.parse(data['TokenExpirationString']).to_time
    end

    def islands_of_adventure
      @islands_of_adventure ||= UniversalStudiosOrlando::IslandsOfAdventure.new(access_token)
    end

    def universal_studios
      @universal_studios ||= UniversalStudiosOrlando::UniversalStudios.new(access_token)
    end

    class Park < Echelon::Park
      attr_reader :json_data, :park_id

      def ride_list
        park_rides = json_data['Rides'].keep_if { |r| r['VenueId'] == park_id }
        park_rides.inject({}) { |a, e| a[e['Id'].to_i] = e['MblDisplayName']; a }
      end

      def initialize(access_token, park_id)
        @park_id = park_id
        uri = URI.parse('https://services.universalorlando.com/api/pointsOfInterest')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        headers = {
          'X-UNIWebService-ApiKey' => 'AndroidMobileApp',
          'X-UNIWebService-Token'  => access_token
        }.merge(SHARED_HEADERS)

        resp = http.get(uri.request_uri, headers)
        @json_data = JSON.parse(resp.body)
      end

      private

      def ride_status(time)
        case time
          when -1 then 'Out of operating hours'
          when -2 then 'Closed temporarily'
          when -3 then 'Closed long term'
          when -4 then 'Closed for inclement weather'
          when -5 then 'Closed for capacity'
          when -50 then 'Not available'
          else ''
        end
      end

      def create_ride_object(ref)
        ride = json_data['Rides'].find { |k, _v| k['Id'].to_i == ref }
        active = ride['WaitTime'].to_i >= 0 ? 1 : 0

        meta = {
          express_pass_accepted: ride['ExpressPassAccepted'],
          single_rider: ride['HasSingleRiderLine'],
          unavailable_reason: ride_status(ride['WaitTime'].to_i)
        }.delete_if { |key, value| value.is_a?(String) && value.empty? }

        wait_time = ride['WaitTime'].to_i < 0 ? 0 : ride['WaitTime'].to_i
        Ride.new(name: ride['MblDisplayName'], queue_time: wait_time, active: active, meta: meta)
      end

    end

    class IslandsOfAdventure < Park
      def initialize(access_token)
        super(access_token, 10_000)
      end
    end

    class UniversalStudios < Park
      def initialize(access_token)
        super(access_token, 10_010)
      end
    end
  end
end
