require 'rubygems'
require 'xmlsimple'
require 'net/http'
require 'date'

module Echelon
  module Seaworld
    class SanDiego < Park

      attr_reader :xml_data

      def ride_list
        {
          1034 => 'Shipwreck Rapids',
          1024 => 'Skytower',
          1010 => 'Journey to Atlantis',
          1011 => 'Wild Arctic Ride',
          1122 => 'Elmo\'s Flying Fish',
          1029 => 'Skyride',
          1123 => 'Abby\'s Sea Star Spin',
          1121 => 'Oscar\'s Rocking Eel'
        }
      end

      def initialize
        # fetch the xml file
        http = Net::HTTP.new('lab.defimobile.com', 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        resp, data = http.get('/san_diego/rides')

        # were only interested in the ride data, throw everything else away
        xml_data = XmlSimple.xml_in(data)
        @xml_data = xml_data['ride']
      end

      private

      def create_ride_object(ref)
        self.xml_data.each do |ride|
          if ride["id"].to_s.to_i == ref
            active, queue_time = parse_wait_time(ride["waitTime"].to_s)
            updated_at = DateTime.parse(ride["lastModified"].to_s)
            return Ride.new(:name => self.ride_list[ref], :queue_time => queue_time, :active => active, :updated_at => updated_at)
          end
        end
      end

      def parse_wait_time(wait)
        if wait == "Closed"
          queue_time = 0
          active = 0
        elsif wait == "No Wait"
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