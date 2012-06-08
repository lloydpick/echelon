$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "#{File.dirname(__FILE__)}/echelon/ride.rb"
require "#{File.dirname(__FILE__)}/echelon/park.rb"

require "#{File.dirname(__FILE__)}/echelon/parks/thorpe_park.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/disneyland_paris.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/seaworld_san_antonio.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/seaworld_san_diego.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/seaworld_orlando.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/alton_towers.rb"

# Disney World
require "#{File.dirname(__FILE__)}/echelon/parks/disney_world/magic_kingdom.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/disney_world/epcot.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/disney_world/hollywood_studios.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/disney_world/animal_kingdom.rb"

module Echelon
end