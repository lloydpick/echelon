require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'

module Echelon
  class DisneyWorld

    attr_reader :access_token, :expires_at

    def initialize
      uri = URI.parse('https://authorization.go.com/token')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      params = Echelon::parameterize(grant_type: 'assertion', assertion_type: 'public', client_id: 'WDPRO-MOBILE.CLIENT-PROD')
      resp = http.post(uri.request_uri, params)

      data = JSON.parse(resp.body)
      @access_token = data['access_token']
      @expires_at = Time.now.to_i + data['expires_in'].to_i
    end

    def animal_kingdom
      @animal_kingdom ||= DisneyWorld::AnimalKingdom.new(access_token)
    end

    def magic_kingdom
      @magic_kingdom ||= DisneyWorld::MagicKingdom.new(access_token)
    end

    def hollywood_studios
      @hollywood_studios ||= DisneyWorld::HollywoodStudios.new(access_token)
    end

    def epcot
      @epcot ||= DisneyWorld::Epcot.new(access_token)
    end

    class Park < Echelon::Park
      attr_reader :json_data

      def ride_list
        json_data['entries'].inject({}) { |a, r| a[r['id'].split(';').first.to_i] = r['name']; a }
      end

      def initialize(access_token, park_id)
        uri = URI.parse("https://api.wdpro.disney.go.com/facility-service/theme-parks/#{park_id};entityType=theme-park/wait-times")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        headers = {
          'Authorization' => "BEARER #{access_token}",
          'Accept' => 'application/json;apiversion=1',
          'X-Conversation-Id' => '~WDPRO-MOBILE.CLIENT-PROD'
        }

        resp = http.get(uri.request_uri, headers)
        @json_data = JSON.parse(resp.body)
      end

      private

      def create_ride_object(ref)
        json_data['entries'].each do |ride|
          if ride['id'].split(';').first.to_i == ref

            ride_status = ride['waitTime']['status']
            status = 1 if ride_status == 'Operating'
            status = 0 if ride_status == 'Closed'
            status = -1 if ride_status == 'Down'

            queue_time = ride['waitTime']['postedWaitMinutes'].to_i

            meta = {
              fastpass_available: ride['waitTime']['fastPass']['available'],
              single_rider: ride['waitTime']['singleRider']
            }

            return Ride.new(name: ride_list[ref], queue_time: queue_time, active: status, meta: meta)
          end
        end
      end

    end

    class Epcot < Park
      def initialize(access_token)
        super(access_token, 80_007_838)
      end
    end

    class MagicKingdom < Park
      def initialize(access_token)
        super(access_token, 80_007_944)
      end
    end

    class HollywoodStudios < Park
      def initialize(access_token)
        super(access_token, 80_007_998)
      end
    end

    class AnimalKingdom < Park
      def initialize(access_token)
        super(access_token, 80_007_823)
      end
    end
  end
end
