require 'echelon/park'
require 'echelon/parks/thorpe_park'

# Mosts of the test here are pretty generic, although you can test for specific
# cases, such as the active states may differ between parks, and queue times may
# not exceed a certain value etc etc.

describe Echelon::ThorpePark do
  
  before do
    @park = Echelon::ThorpePark.new()
  end

  it "should inherit from Park" do
    @park.should be_kind_of(Echelon::ThorpePark)
  end

  it "should have some rides" do
    @park.ride_list.count.should satisfy { |v| v > 1 && v < 30 }
  end

  it "should return ride objects" do
    @park.find_by_name("Stealth").should be_kind_of(Echelon::Ride)
    @park.find_by_id(3).should be_kind_of(Echelon::Ride)
  end

  it "should return ride object values correctly" do
    stealth = @park.find_by_id(3)
    stealth.name.should eql("Stealth")
    stealth.queue_time.should satisfy { |v| v >= 0 && v < 1000 }
    stealth.active.should satisfy { |v| v == 0 || v == 1 }
  end

end