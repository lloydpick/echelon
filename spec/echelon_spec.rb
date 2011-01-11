require 'echelon/ride'
require 'echelon/park'

describe Echelon::Ride do

  before do
    @ride = Echelon::Ride.new(:name => 'Ride', :queue_time => 10, :active => 1)
  end

  it "should return the name of the ride" do
    @ride.name.should eql('Ride')
  end

  it "should return the queue time" do
    @ride.queue_time.should eql(10)
  end

  it "should return the ride status" do
    @ride.active.should eql(1)
  end

end

describe Echelon::Park do

  before do
    @park = Echelon::Park.new
  end

  it "should provide a set of methods" do
    @park.should respond_to(:ride_list)
    @park.should respond_to(:rides)
    @park.should respond_to(:find_by_name)
    @park.should respond_to(:find_by_id)
  end

  it "should contain a blank ride list" do
    @park.ride_list.should eql({})
    @park.rides.should eql([])
  end

  describe 'find_by_name' do
    it "should raise if ride isn't available" do
      lambda { @park.find_by_name('Unknown Ride') }.should raise_error(ArgumentError)
    end
  end

  describe 'find_by_id' do
    it "should raise if ride isn't available" do
      lambda { @park.find_by_id(1) }.should raise_error(ArgumentError)
    end
  end

end