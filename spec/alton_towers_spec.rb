require 'echelon/park'
require 'echelon/parks/alton_towers'

# Mosts of the test here are pretty generic, although you can test for specific
# cases, such as the active states may differ between parks, and queue times may
# not exceed a certain value etc etc.

describe Echelon::AltonTowers do

  before do
    @park = Echelon::AltonTowers.new()
  end

  it "should inherit from Park" do
    @park.should be_kind_of(Echelon::AltonTowers)
  end

  it "should have some rides" do
    @park.ride_list.count.should satisfy { |v| v > 1 && v < 30 }
  end

  it "should return ride objects" do
    @park.find_by_name("Rita").should be_kind_of(Echelon::Ride)
    @park.find_by_id(3).should be_kind_of(Echelon::Ride)
  end

  it "should return ride object values correctly" do
    ride = @park.find_by_id(3)
    ride.name.should eql("Rita")
    ride.queue_time.should satisfy { |v| v >= 0 && v < 1000 }
    ride.active.should satisfy { |v| v == 0 || v == 1 }
  end

end