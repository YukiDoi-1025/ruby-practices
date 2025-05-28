#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

OPTION_KEY = { l: :line, w: :word, c: :size }.freeze

def word_count(contents, file_name = '')
  line_number = contents.size
  line_number -= 1 unless contents[-1].end_with?("\n", "\r")
  {
    line: line_number,
    word: contents.sum { |text| text.split.size },
    size: contents.sum(&:bytesize),
    name: file_name
  }
end

opt = OptionParser.new

params = {}

opt.on('-l') { |v| v }
opt.on('-w') { |v| v }
opt.on('-c') { |v| v }
opt.parse!(ARGV, into: params)

all_count_results = if FileTest.pipe?($stdin)
                      [word_count($stdin.readlines)]
                    elsif ARGV.empty?
                      [word_count(readlines)]
                    else
                      ARGV.map do |file_name|
                        File.open(file_name) do |file|
                          file_contents = file.readlines
                          word_count(file_contents, file_name)
                        end
                      end
                    end

total_count_results = {}
OPTION_KEY.each_value do |result_key|
  total_count_results[result_key] = all_count_results.sum { |optioned_count_result| optioned_count_result[result_key] }
end

total_size_digit = if params.size == 1 && ARGV.size <= 1
                     0
                   elsif ARGV.empty?
                     7
                   else
                     total_count_results.max_by { |a| a[1] }[1].to_s.size
                   end

all_count_results.each do |optioned_count_result|
  OPTION_KEY.each do |option, result_key|
    print "#{optioned_count_result[result_key].to_s.rjust(total_size_digit)} " if params.key?(option) || params.empty?
  end
  puts optioned_count_result[:name]
end

if all_count_results.size > 1
  OPTION_KEY.each { |option, result_key| print "#{total_count_results[result_key].to_s.rjust(total_size_digit)} " if params.key?(option) || params.empty? }
  puts 'total'
end
