module Echelon
  class Park

    def ride_list
      {}
    end

    def rides
      ride_list.inject([]) do |r, e| r << create_ride_object(e[0]) end
    end

    def find_by_name(ride)
      raise ArgumentError, "Unknown ride name" unless ride_list.has_value?(ride)
      ref = ride_list.index(ride)
      create_ride_object(ref)
    end

    def find_by_id(ref)
      raise ArgumentError, "Unknown ride name" unless ride_list.has_key?(ref)
      create_ride_object(ref)
    end

  end
end