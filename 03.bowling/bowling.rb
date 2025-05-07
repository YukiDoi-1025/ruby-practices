#!/usr/bin/env ruby

# frozen_string_literal: true

shots = ARGV[0].split(',').flat_map { |s| s == 'X' ? [10, 0] : s.to_i }

# フレームごとに分割
frames = shots.each_slice(2).to_a

point = 10.times.sum do |num| # ボウリングは必ず10フレームで固定
  frames[num].sum +
    if frames[num][0] == 10 # ストライク
      frames[num + 1].sum + (frames [num + 1][0] == 10 ? frames[num + 2][0] : 0)
    elsif frames[num].sum == 10 # スペア
      frames[num + 1][0]
    end.to_i
end

puts point
