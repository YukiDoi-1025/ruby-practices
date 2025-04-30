#!/usr/bin/env ruby

require 'optparse'
require 'date'

def make_calendar(year:, month:)
  tmp_day = Date.new(year, month, 1)
  day_last = Date.new(year, month, -1)
  wday_first = tmp_day.wday
  
  wdays = "Su Mo Tu We Th Fr Sa"
  puts tmp_day.strftime("%B %Y").center(wdays.length)
  puts wdays

  wday_first.times{print "   "} # 1日目以前の空白を表示
  
  while tmp_day <= day_last
    if tmp_day.saturday?
      puts tmp_day.strftime("%e") + " "
    else
      print tmp_day.strftime("%e") + " "
    end
    tmp_day += 1
  end
end

keys = {}
opt = OptionParser.new
opt.on('-m') {|v| v }
opt.on('-y') {|v| v }
opt.parse!(ARGV, into: keys)

params = {}
num = 0
keys.each_key do |key|
  params[key] = ARGV[num].to_i
  num += 1
end

if !params.has_key?(:y)
  params[:y] = Date.today.year
end
if !params.has_key?(:m)
  params[:m] = Date.today.mon
end

make_calendar(year: params[:y], month: params[:m])
