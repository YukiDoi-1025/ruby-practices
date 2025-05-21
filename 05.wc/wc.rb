#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

OPTION_KEY = { l: :line, w: :word, c: :size }.freeze

def word_count(file_name)
  File.open(file_name) do |file|
    file_contents = file.readlines
    line_number = file_contents.size
    line_number -= 1 unless file_contents[-1].end_with?("\n", "\r")
    {
      line: line_number,
      word: file_contents.sum { |text| text.split.size },
      size: file.size,
      name: file_name
    }
  end
end

opt = OptionParser.new

params = {}

opt.on('-l') { |v| v }
opt.on('-w') { |v| v }
opt.on('-c') { |v| v }
opt.parse!(ARGV, into: params)

all_count_results = ARGV.map { |file_name| word_count(file_name) }

total_count_results = {}
OPTION_KEY.each_value do |result_key|
  total_count_results[result_key] = all_count_results.sum { |optioned_count_result| optioned_count_result[result_key] }
end
total_size_digit = total_count_results.max_by { |a| a[1] }[1].to_s.size

all_count_results.map do |optioned_count_result|
  OPTION_KEY.each { |option, result_key| print "#{optioned_count_result[result_key].to_s.rjust(total_size_digit)} " if params.key?(option) || params.empty? }
  puts optioned_count_result[:name]
end

OPTION_KEY.each { |option, result_key| print "#{total_count_results[result_key].to_s.rjust(total_size_digit)} " if params.key?(option) || params.empty? }
puts 'total'
