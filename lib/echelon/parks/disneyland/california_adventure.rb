require 'rubygems'
require 'json'
require 'net/http'

module Echelon
  module Disneyland
    class CaliforniaAdventure < Park
      attr_reader :json_data

      def ride_list
        json_data.keys.inject({}) { |a, e| a[e] = e; a }
      end

      def initialize
        # fetch the json feed
        url = 'http://dparks.uiemedia.net/dmm_v2/jsondata/JsonUpdateData?version=14&p=336894'
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body

        # were only interested in the ride data, throw everything else away
        json_data = JSON.parse(data)
        ride_data = json_data['attractions']['homeLabels']
        queue_data = json_data['attractions']['homeValues'].map(&:to_i)
        @json_data = ride_data.each_with_index.inject({}) { |a, e| a[e.first.gsub("\302\240", '')] = queue_data[e.last]; a }
      end

      private

      def create_ride_object(ref)
        json_data.each do |ride|
          return Ride.new(name: ride[0], queue_time: ride[1]) if ride[0] == ref
        end
      end
    end
  end
end
