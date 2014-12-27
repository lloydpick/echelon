$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "#{File.dirname(__FILE__)}/echelon/ride.rb"
require "#{File.dirname(__FILE__)}/echelon/park.rb"

# UK Parks
require "#{File.dirname(__FILE__)}/echelon/parks/thorpe_park.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/alton_towers.rb"

# Seaworld
require "#{File.dirname(__FILE__)}/echelon/parks/seaworld/san_antonio.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/seaworld/san_diego.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/seaworld/orlando.rb"

# Disney World Resort
require "#{File.dirname(__FILE__)}/echelon/parks/disney_world.rb"

# Disneyland Resort California
require "#{File.dirname(__FILE__)}/echelon/parks/disneyland/disneyland.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/disneyland/california_adventure.rb"

# Disneyland Resort Paris
require "#{File.dirname(__FILE__)}/echelon/parks/disneyland_paris.rb"

# Universal Studios Orlando Resort
require "#{File.dirname(__FILE__)}/echelon/parks/universal_studios_orlando.rb"

module Echelon
  def self.parameterize(params)
    URI.escape(params.collect { |k, v| "#{k}=#{v}" }.join('&'))
  end
end
