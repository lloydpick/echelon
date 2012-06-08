require 'rubygems'
require 'json'
require 'net/http'

module Echelon
  class ThorpePark < Park

    attr_reader :json_data

    def ride_list
      {
        1 => 'SAW - The Ride',
        3 => 'Stealth',
        4 => 'Colossus',
        5 => 'Detonator',
        6 => 'Nemesis Inferno',
        7 => 'Rush',
        8 => 'Samurai',
        9 => 'Slammer',
        10 => 'Tidal Wave',
        11 => 'Vortex',
        12 => 'X:\No Way Out',
        13 => 'Time Voyagers',
        14 => 'Quantum',
        15 => 'Loggers Leap',
        16 => 'Flying Fish',
        17 => 'Rumba Rapids',
        18 => 'Zodiac',
        19 => 'Depth Charge',
        20 => 'SAW Alive',
        21 => 'Mr. Monkey\'s Banana Ride',
        22 => 'Storm in a Teacup',
        23 => 'Rocky Express',
        24 => 'Wet Wet Wet',
        25 => 'Neptune\'s Beach',
        26 => 'Chief Ranger\'s Carousel',
        27 => 'Storm Surge',
        28 => 'The Swarm'
      }
    end

    def initialize
      # fetch the json feed from the merlin site
      url = "http://www.merlincms.com/1.php"
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