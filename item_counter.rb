require 'date'
require 'active_support/inflector'

class ItemCounter 


  #Takes in ride objects 
    #Ride objects have start/end times and items list 
  #Should be able to call print_items_per_interval()
  #I assume print_items_per_interval() should take in increments of time 
  #I think they're passing in the time objects like 07:00-07:10
  


  #Method 1: 
  #Put all rides into an array and iterate through it
  #If the (end_time is < interval_end_time && start_time>interval_start_time) or if (end_time>interval_end && start_time > interval_start), we count it
  #This requires O(n) where n is the number of rides
  #Also needs O(n) space complexity 
  #Doesn't seem like there's a better way to do this than O(n)
  #Can I do better? 
    #Finding ideal start and end time doesn't seem like it would work (because everything could just be in range)
  
  #I guess I also need a way to keep track of items I need to return
  #Ride could map item_str to number of items
  #Then when I'm iterating, I create a master items hash, updating the total for each items_hash I find within range 
  #Then I iterate through the master items hash and build the return_str 
    #One concern - in their examples they returned the items in alphabetical order... 
    #I'm going to assume that I don't need to sort it
    #Or maybe I could do it for the printing, and have some other method called "find_items_in_interval" which returns the hash
    #Yeah, I think I'll do that way, because then I can sort things
  

  
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

  #Time Complexity: O(nk) where n == @rides.length and k==ride.items.length
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

  #Time Complexity: O(nk) because find_items_in_interval takes O(nk) (See above)
  #Space Complexity: 
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