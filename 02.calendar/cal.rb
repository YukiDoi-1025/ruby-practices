#!/usr/bin/env ruby

require 'optparse'
require 'date'

# カレンダー作成用のメソッド
def make_calendar(year:, month:)
  # 月の始めの日と最終日を取得。
  day_first = Date.new(year, month, 1)
  day_last = Date.new(year, month, -1)
  # 月の始めの日の曜日を取得。日曜日がゼロ
  wday_first = day_first.wday
  
  # 1行目を描画。
  # スペース数を月の名前の文字数から決定。
  month_name_length = day_first.strftime("%B").length
  space_num = 10 - ((month_name_length+5)/2.0).ceil
  space_num.times {print " "}
  puts day_first.strftime("%B %Y")

  # 2行目
  puts "Su Mo Tu We Th Fr Sa"

  # 3行目
  # 空白を入れる
  wday_first.times{print "   "}
  # 土曜日まで描画
  tmp_day = 1
  (7-wday_first).times do
    # 空白埋め2文字で描画
    print tmp_day.to_s.rjust(2) + " "
    tmp_day += 1
  end
  # 改行
  print("\n")

  # 4行目以降
  while tmp_day <= day_last.day
    7.times do
      print tmp_day.to_s.rjust(2) + " "
      tmp_day += 1
      # 月の最後の日を超えたらループから抜け出す
      if tmp_day > day_last.day
        break
      end
    end
    print("\n")
  end
  
end

# パラメータのキー保存用
keys = {}
# パラメータ取得
opt = OptionParser.new
opt.on('-m') {|v| v }
opt.on('-y') {|v| v }
opt.parse!(ARGV, into: keys)

# キーと値を組み合わせる
params = {}
num = 0
keys.each_key do |key|
  # 整数に変換
  params[key] = ARGV[num].to_i
  num += 1
end

# -y が設定されていないときは本日の西暦
if !params.has_key?(:y)
  params[:y] = Date.today.year
end
# -m が設定されていないときは本日の月
if !params.has_key?(:m)
  params[:m] = Date.today.mon
end

# カレンダー作成
make_calendar(year: params[:y], month: params[:m])
