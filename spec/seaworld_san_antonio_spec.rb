require 'echelon/park'
require 'echelon/parks/seaworld/san_antonio'

# Mosts of the test here are pretty generic, although you can test for specific
# cases, such as the active states may differ between parks, and queue times may
# not exceed a certain value etc etc.

describe Echelon::Seaworld::SanAntonio do

  before do
    @park = Echelon::Seaworld::SanAntonio.new()
  end

  it "should inherit from Park" do
    @park.should be_kind_of(Echelon::Seaworld::SanAntonio)
  end

  it "should have some rides" do
    @park.ride_list.count.should satisfy { |v| v > 1 && v < 30 }
  end

  it "should return ride objects" do
    @park.find_by_name("Steel Eel").should be_kind_of(Echelon::Ride)
    @park.find_by_id(11).should be_kind_of(Echelon::Ride)
  end

  it "should return ride object values correctly" do
    ride = @park.find_by_id(11)
    ride.name.should eql("Steel Eel")
    ride.queue_time.should satisfy { |v| v >= 0 && v < 1000 }
    ride.active.should satisfy { |v| v == 0 || v == 1 }
  end

  describe "parse_wait_time" do

    it "should return a wait time and active state correctly" do
      @park.send(:parse_wait_time, "15 mins").should eql([1, 15])
      @park.send(:parse_wait_time, "Closed").should eql([0, 0])
      @park.send(:parse_wait_time, "No Wait").should eql([1, 0])
      @park.send(:parse_wait_time, "30 mins").should eql([1, 30])
      @park.send(:parse_wait_time, "Invalid").should eql([0, 0])
    end
  end

end