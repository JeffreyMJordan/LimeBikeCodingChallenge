require 'rspec'
require_relative '../item_counter'
require 'date'

describe Ride do 
  describe "#initialize" do 
    it "accepts a start_time, end_time, and items hash" do 
      ride = Ride.new(DateTime.new(2002,2,3), DateTime.new(2003,2,3), {})
      expect(ride.start_time).to be == DateTime.new(2002,2,3)
      expect(ride.end_time).to be == DateTime.new(2003,2,3)
      expect(ride.items).to be == {}
    end 

    it 'requires start_time and end_time to be DateTime objects' do 
      expect{Ride.new("3", DateTime.new(2003,2,3), {})}.to raise_error "start_time and end_time must be DateTime objects"
      expect{Ride.new(DateTime.new(2003,2,3), "3", {})}.to raise_error "start_time and end_time must be DateTime objects"
    end 

    it 'requires items to be a hash' do 
      expect{Ride.new(DateTime.new(2002,2,3), DateTime.new(2003,2,3), "{}")}.to raise_error("Items needs to be a hash")
    end 

    it "require start_time to be less than end_time" do 
      expect{Ride.new(DateTime.new(2003,2,3), DateTime.new(2002,2,3), {})}.to raise_error("start_time must be less than end_time")
    end 
  end 
end 

describe ItemCounter do 
  subject(:counter) {ItemCounter.new}

  describe '#process_ride' do 
    it 'succesfully takes in rides' do 
      expect(counter.rides.length).to eq(0)
      counter.process_ride(Ride.new(DateTime.new(2002,2,3), DateTime.new(2003,2,3), {}))
      expect(counter.rides.length).to eq(1)
    end
    
    it 'only accepts ride objects' do 
      expect{counter.process_ride("a")}.to raise_error("Not a Ride object")
    end 
  end 

  describe '#overlap' do 
    subject(:interval_start){DateTime.new(2002, 2, 3, 4)}
    subject(:interval_end){DateTime.new(2002, 2, 3, 5)}

    it "returns true when ride is within range" do 
      ride = Ride.new(DateTime.new(2002, 2, 3, 4.5), DateTime.new(2002, 2, 3, 4.6), {})
      expect(counter.overlap?(interval_start, interval_end, ride)).to be(true)
      ride = Ride.new(DateTime.new(2002, 2, 3, 3.5), DateTime.new(2002, 2, 3, 4.5), {})
      expect(counter.overlap?(interval_start, interval_end, ride)).to be(true)
      ride = Ride.new(DateTime.new(2002, 2, 3, 4.5), DateTime.new(2002, 2, 3, 5.6), {})
      expect(counter.overlap?(interval_start, interval_end, ride)).to be(true)
    end 

    it "returns false when ride isn't within range" do 
      ride = Ride.new(DateTime.new(2002, 2, 3, 5.1), DateTime.new(2002, 2, 3, 5.2), {})
      expect(counter.overlap?(interval_start, interval_end, ride)).to be(false)
      ride = Ride.new(DateTime.new(2002, 2, 3, 3.1), DateTime.new(2002, 2, 3, 3.2), {})
      expect(counter.overlap?(interval_start, interval_end, ride)).to be(false)
    end
    
    it "raises error when interval_start>=interval_end" do
      ride = Ride.new(DateTime.new(2002, 2, 3, 5.1), DateTime.new(2002, 2, 3, 5.2), {})
      expect{counter.overlap?(interval_end, interval_start, ride)}.to raise_error("Invalid interval")
    end 
  end
  
  describe "#update_hash" do 
    
    it "updates original hash" do 
      hash1 = {"apple" => 1}
      hash2 = {"apple" => 2}
      counter.update_hash(hash1, hash2)
      expect(hash1["apple"]).to eq(3)
    end

    it "not case sensitive" do 
      hash1 = {"apple" => 1}
      hash2 = {"APPLE" => 2}
      counter.update_hash(hash1, hash2)
      expect(hash1["apple"]).to eq(3)
    end 

  end 

  subject(:ride1){Ride.new(DateTime.new(2002, 2, 3, 5.1), DateTime.new(2002, 2, 3, 5.5), {"apple" => 1, "pear" => 1})}
  subject(:ride2){Ride.new(DateTime.new(2002, 2, 3, 4.1), DateTime.new(2002, 2, 3, 5.2), {"apple" => 1, "pear" => 1})}

  describe "#find_items_in_interval" do 
    
    it "finds items within given interval" do 
      counter.process_ride(ride1)
      counter.process_ride(ride2)
      expect(counter.find_items_in_interval(DateTime.new(2002, 2, 3, 4.0), DateTime.new(2002, 2, 3, 6.0))).to be == {"apple" => 2, "pear" => 2}
      expect(counter.find_items_in_interval(DateTime.new(2002, 2, 3, 5.3), DateTime.new(2002, 2, 3, 6.0))).to be == {"apple" => 1, "pear" => 1}
      expect(counter.find_items_in_interval(DateTime.new(2002, 2, 3, 4.0), DateTime.new(2002, 2, 3, 4.2))).to be == {"apple" => 1, "pear" => 1}
    end 

    it "returns empty when no items within interval" do 
      counter.process_ride(ride1)
      counter.process_ride(ride2)
      expect(counter.find_items_in_interval(DateTime.new(2002, 2, 3, 6.1), DateTime.new(2002, 2, 3, 6.2))).to be == {}
    end 
  end 

  describe "#print_items_per_interval" do 
    it "prints correct number of items" do 
      counter.process_ride(ride1)
      counter.process_ride(ride2)
      expect(counter.print_items_per_interval(DateTime.new(2002, 2, 3, 4.0), DateTime.new(2002, 2, 3, 6.0))).to be == "2 apples, 2 pears"
    end 

    it "handles plurals correctly" do 
      counter.process_ride(ride1)
      counter.process_ride(ride2)
      expect(counter.print_items_per_interval(DateTime.new(2002, 2, 3, 5.3), DateTime.new(2002, 2, 3, 6.0))).to be == "1 apple, 1 pear"
    end 
  end 

end 