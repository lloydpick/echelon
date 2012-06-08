require 'rubygems'
require 'json'
require 'net/http'

module Echelon
  module DisneyWorld
    class AnimalKingdom < Park

      attr_reader :json_data

      def ride_list
        self.json_data.keys.inject({}) { |r,k| r[k] = k; r }
      end

      def initialize
        # fetch the json feed
        url = "http://dparks.uiemedia.net/dmm_v2/jsondata/JsonUpdateData?version=14&p=80007823"
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body[2..-1]

        # were only interested in the ride data, throw everything else away
        json_data = JSON.parse(data)
        ride_data = json_data["attractions"]["homeLabels"]
        queue_data = json_data["attractions"]["homeValues"].map { |v| v.to_i }
        @json_data = json_data["attractions"]["homeLabels"].each_with_index.inject({}) { |r,i| r[i.first] = queue_data[i.last]; r }
      end

      private

      def create_ride_object(ref)
        self.json_data.each do |ride|
          if ride[0] == ref
            return Ride.new(:name => ride[0], :queue_time => ride[1])
          end
        end
      end

    end
  end
end