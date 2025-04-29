#!/usr/bin/env ruby

(1..20).each do |time|
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
