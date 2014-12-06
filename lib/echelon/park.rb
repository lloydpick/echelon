module Echelon
  class Park
    def ride_list
      {}
    end

    def rides
      ride_list.inject([]) { |a, e| a << create_ride_object(e[0]) }
    end

    def find_by_name(ride)
      fail ArgumentError, 'Unknown ride name' unless ride_list.value?(ride)
      ref = ride_list.respond_to?(:key) ? ride_list.key(ride) : ride_list.index(ride)
      create_ride_object(ref)
    end

    def find_by_id(ref)
      fail ArgumentError, 'Unknown ride name' unless ride_list.key?(ref)
      create_ride_object(ref)
    end
  end
end
