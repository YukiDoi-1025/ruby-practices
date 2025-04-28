#!/usr/bin/env ruby

# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
# 数値に変換
scores.each do |s|
  if s == 'X' # ストライクの場合
    shots << 10
    shots << 0
  else # それ以外
    shots << s.to_i
  end
end

# フレームごとに分割
frames = shots.each_slice(2).to_a

# 合計計算
point = 0
# ボウリングは必ず10フレームで固定
10.times do |num|
  point +=
    if frames[num][0] == 10 # ストライク
      if frames [num + 1][0] == 10
        frames[num].sum + frames[num + 1].sum + frames[num + 2][0]
      else
        frames[num].sum + frames[num + 1].sum
      end
    elsif frames[num].sum == 10 # スペア
      frames[num].sum + frames[num + 1][0]
    else
      frames[num].sum
    end
end

puts point
