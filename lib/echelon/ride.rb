module Echelon
  class Ride
    attr_reader :name, :queue_time, :active, :updated_at

    def initialize(*params)
      params.each do |key|
        key.each { |k, v| instance_variable_set("@#{k}", v) }
      end
    end
  end
end