require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'date'

module Echelon
  module Seaworld
    class SanAntonio < Park

      attr_reader :xml_data

      def ride_list
        {
          10 => 'Shamu Express',
          11 => 'Steel Eel',
          12 => 'Texas Splashdown',
          13 => 'Great White',
          14 => 'Rio Loco',
          15 => 'Journey to Atlantis',
          164 => 'Lost Lagoon'
        }
      end

      def initialize
        # fetch the xml file
        http = Net::HTTP.new('lab.defimobile.com', 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        _resp, data = http.get('/seaworld/rides')

        # were only interested in the ride data, throw everything else away
        xml_data = Nokogiri::HTML(data)
        @xml_data = xml_data.xpath("//ride")
      end

      private

      def create_ride_object(ref)
        xml_data.each do |ride|
          if ride.xpath('id').inner_text.to_i == ref
            active, queue_time = parse_wait_time(ride.xpath('waittime').inner_text)
            updated_at = DateTime.parse(ride.xpath('lastmodified').inner_text)
            return Ride.new(name: ride_list[ref], queue_time: queue_time, active: active, updated_at: updated_at)
          end
        end
      end

      def parse_wait_time(wait)
        if wait == 'Closed'
          queue_time = 0
          active = 0
        elsif wait == 'No Wait'
          queue_time = 0
          active = 1
        elsif wait =~ /(\d*) min/
          queue_time = $1.to_i
          active = 1
        else
          queue_time = 0
          active = 0
        end

        return active, queue_time
      end
    end
  end
end
