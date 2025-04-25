#!/usr/bin/env ruby

20.times do |t|
  time = t + 1
  if time % 15 == 0
    puts "FizzBuzz"
  elsif time % 3 == 0
    puts "Fizz"
  elsif time % 5 == 0
    puts "Buzz"
  else
    puts time
  end
end
