# LimeBikeCodingChallenge

## How to test my solution 
I built a simple rspec test suite to ensure the robustness of my code. 
I have a passion for unit-testing because it ensures that your code is bug-free, 
enhances the maintability of your code, and serves as documentation for other programmers.

To run my unit-tests, input the following commands in the terminal 

```
bundle install
bundle exec rspec 
```

## Approach 
My solution uses two classes; Ride and ItemCounter.

Ride takes in 3 variables: `start_time`, `end_time`, and `items`. `start_time` and `end_time` 
are DateTime objects, and `items` is a hash of strings to quantities. 

ItemCounter takes no variables on initialization. ItemCounter processes Ride objects by putting them into an array, `@rides`.
My `process_rides` method is as follows: 

```(ruby) 
  def process_ride(ride)
    if ride.is_a? Ride 
      @rides << ride
    else 
      raise "Not a Ride object"
    end 
  end
```
One of the key reasons I defined my own ride class was so I could ensure that all the objects in `@rides` has a standard set of methods. 
Other parts of my solution depend on being able to access a ride's `start_time`, `end_time`, and `items` variables, so I made sure 
to check for these before storing them in `@rides`.

To implement `print_items_per_interval`, ItemCounter uses the following process: 
```(ruby)
 def find_items_in_interval(interval_start, interval_end)
    items_hash = Hash.new(0)
    @rides.each do |ride| 
      if overlap?(interval_start, interval_end, ride)
        update_hash(items_hash, ride.items)
      end 
    end 

    items_hash

  end

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
```

Please note that `update_hash` and `overlap?` are defined in other parts of my code. 
