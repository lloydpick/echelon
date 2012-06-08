require 'rubygems'
require 'json'
require 'net/http'

module Echelon
  class AltonTowers < Park

    attr_reader :json_data

    def ride_list
      {
        1 => 'Air',
        2 => 'Nemesis',
        3 => 'TH13TEEN',
        6 => 'Oblivion',
        8 => 'Rita',
        10 => 'Congo River Rapids',
        11 => 'Sonic Spinball',
        14 => 'Runaway Mine Train',
        15 => 'The Flume',
        31 => 'Nemesis Sub-Terra'
      }
    end

    def initialize
      # fetch the json feed from the merlin site
      url = "http://www.merlincms.com/2.php"
      resp = Net::HTTP.get_response(URI.parse(url))
      data = resp.body

      # were only interested in the ride data, throw everything else away
      json_data = JSON.parse(data)
      @json_data = json_data["Rides"]
    end

    private

    def create_ride_object(ref)
      self.json_data.each do |ride|
        if ride["ref"].to_i == ref
          return Ride.new(:name => self.ride_list[ref], :queue_time => ride["queue"].to_i, :active => ride["active"].to_i)
        end
      end
    end

  end
end