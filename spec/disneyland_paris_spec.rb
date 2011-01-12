require 'echelon/park'
require 'echelon/parks/disneyland_paris'

# Mosts of the test here are pretty generic, although you can test for specific
# cases, such as the active states may differ between parks, and queue times may
# not exceed a certain value etc etc.

describe Echelon::DisneylandParis do

  before do
    @park = Echelon::DisneylandParis.new()
  end

  it "should inherit from Park" do
    @park.should be_kind_of(Echelon::DisneylandParis)
  end

  it "should have some rides" do
    @park.ride_list.count.should satisfy { |v| v > 1 && v < 40 }
  end

  it "should return ride objects" do
    @park.find_by_name("Pirates of the Caribbean").should be_kind_of(Echelon::Ride)
    @park.find_by_id('P1AA04').should be_kind_of(Echelon::Ride)
  end

  it "should return ride object values correctly" do
    ride = @park.find_by_id("P1AA04")
    ride.name.should eql("Pirates of the Caribbean")
    ride.queue_time.should satisfy { |v| v >= 0 && v < 500 }
    ride.active.should satisfy { |v| v >= -1 && v < 3 }
  end

end