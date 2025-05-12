#!/usr/bin/env ruby

require 'optparse'
require 'date'

def make_calendar(year:, month:)
  day_first = Date.new(year, month, 1)
  day_last = Date.new(year, month, -1)
  wday_first = day_first.wday
  
  wdays = "Su Mo Tu We Th Fr Sa"
  puts day_first.strftime("%B %Y").center(wdays.length)
  puts wdays

  wday_first.times{print "   "} # 1日目以前の空白を表示
  
  (day_first..day_last).each do |date|
    print date.day.to_s.rjust(2) + " "
    puts if date.saturday?
  end
  puts
end

keys = {}
opt = OptionParser.new
opt.on('-m MONTH') {|v| v.to_i }
opt.on('-y YEAR') {|v| v.to_i }
opt.parse!(ARGV, into: keys)

keys[:y] = Date.today.year if !keys.has_key?(:y)
keys[:m] = Date.today.mon if !keys.has_key?(:m)

make_calendar(year: keys[:y], month: keys[:m])
