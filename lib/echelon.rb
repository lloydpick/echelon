$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "#{File.dirname(__FILE__)}/echelon/ride.rb"
require "#{File.dirname(__FILE__)}/echelon/park.rb"

require "#{File.dirname(__FILE__)}/echelon/parks/thorpe_park.rb"
require "#{File.dirname(__FILE__)}/echelon/parks/disneyland_paris.rb"

module Echelon
end