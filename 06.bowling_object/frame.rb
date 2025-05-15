# frozen_string_literal: true

require_relative './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    if @third_shot
      [@first_shot, @second_shot, @third_shot].map(&:score).sum
    else
      [@first_shot, @second_shot].map(&:score).sum
    end
  end

  def bonus(next_frame, after_next_frame)
    if next_frame
      if @first_shot.score == 10 # ストライク
        [next_frame.first_shot, next_frame.second_shot].map(&:score).sum + \
          (next_frame.first_shot.score == 10 && after_next_frame ? after_next_frame.first_shot.score : 0)
      elsif score == 10 # スペア
        next_frame.first_shot.score
      end
    end.to_i
  end
end
