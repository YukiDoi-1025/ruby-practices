# frozen_string_literal: true

require_relative './frame'
require_relative './shot'

class Game
  FINAL_FRAME = 9

  def initialize(game)
    shots = game.split(',').flat_map { |s| s == 'X' ? %w[X 0] : s }
    frames = shots.each_slice(2).to_a

    if frames[FINAL_FRAME][0] == 'X'
      frames[FINAL_FRAME][1] = frames[FINAL_FRAME + 1][0]
      frames[FINAL_FRAME][2] = frames[FINAL_FRAME + 1][0] == 'X' ? frames[FINAL_FRAME + 2][0] : frames[FINAL_FRAME + 1][1]
    elsif frames[FINAL_FRAME][0].to_i + frames[FINAL_FRAME][1].to_i == 10
      frames[FINAL_FRAME][2] = frames[FINAL_FRAME + 1][0]
    end

    @frames = (0..FINAL_FRAME).map do |frame_count|
      Frame.new(frames[frame_count][0], frames[frame_count][1], frames[frame_count][2])
    end
  end

  def score
    (0..FINAL_FRAME).sum do |frame_count|
      current_frame, next_frame, after_next_frame = @frames.slice(frame_count, 3)
      bonus_score = if next_frame
                      if current_frame.first_shot.score == 10 # ストライク
                        next_frame.score(frame_count) + (next_frame.first_shot.score == 10 && after_next_frame ? after_next_frame.first_shot.score : 0)
                      elsif current_frame.score(frame_count) == 10 # スペア
                        next_frame.first_shot.score
                      end
                    end.to_i
      current_frame.score(frame_count) + bonus_score
    end
  end
end
