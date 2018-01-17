require 'date'
require 'active_support/inflector'

class ItemCounter 
  
  attr_reader :rides

  def initialize
    @rides = []
  end 

  #Time Complexity: O(1)
  #Space Complexity: O(1)
  def process_ride(ride)
    if ride.is_a? Ride 
      @rides << ride
    else 
      raise "Not a Ride object"
    end 
  end   

  #Time Complexity: O(nk) where n == @rides.length and k == ride.items.length
  #Space Complexity: O(j) where j == total number of items in @rides 
  def find_items_in_interval(interval_start, interval_end)
    items_hash = Hash.new(0)
    @rides.each do |ride| 
      if overlap?(interval_start, interval_end, ride)
        update_hash(items_hash, ride.items)
      end 
    end 

    items_hash

  end

  #Time Complexity: O(1)
  #Space Complexity: O(1)
  def overlap?(interval_start, interval_end, ride)
    raise "Invalid interval" if interval_start>=interval_end
    if (ride.start_time > interval_end) || (ride.end_time<interval_start)
      return false 
    else 
      return true
    end 

  end 
  
  #Time Complexity: O(n) where n==new_items.length
  #Space Complexity: O(1)
  def update_hash(items_hash, new_items)
    new_items.each do |k, v| 
      items_hash[k.downcase] += v 
    end 
  end 

  #Time Complexity: O(nk + q) where q is the size of hash returned by find_items_in_interval and O(nk) is the time complexity of find_items_in_interval  (See above)
  #Space Complexity: O(j) where j is the size of hash (we must allocate slots in memory for our string proportional to the size of hash)
  def print_items_per_interval(interval_start, interval_end)
    hash = find_items_in_interval(interval_start, interval_end)
    str = ""
    hash.each do |k,v| 
      if v>1 
        str += "#{v} #{k.pluralize}, "
      else 
        str += "#{v} #{k}, "
      end 
    end
    puts str[0..-3]  
    str[0..-3]  
  end 

end 



class Ride
  attr_reader :start_time, :end_time, :items 

  #items is a hash of item strings mapped to their quantities
  def initialize(start_time, end_time, items)
    raise "Items needs to be a hash" if !items.is_a? Hash
    raise "start_time and end_time must be DateTime objects" if (!start_time.is_a?(DateTime) || !end_time.is_a?(DateTime))
    raise "start_time must be less than end_time" if start_time>=end_time

    @start_time = start_time 
    @end_time = end_time
    @items = items
  end 

end 