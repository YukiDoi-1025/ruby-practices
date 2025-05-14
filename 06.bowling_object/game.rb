# frozen_string_literal: true

require_relative './frame'
require_relative './shot'

class Game
  FINAL_FRAME = 9

  def initialize(game)
    shots = game.split(',').flat_map { |s| s == 'X' ? %w[X 0] : s }
    frames = shots.each_slice(2).to_a

    if frames[FINAL_FRAME][0] == 'X'
      (1..2).each do |i|
        frames[FINAL_FRAME][i] = frames[FINAL_FRAME + 1][0] == 'X' ? frames[FINAL_FRAME + i][0] : frames[FINAL_FRAME + 1][i - 1]
      end
    end

    frames[FINAL_FRAME][2] = frames[FINAL_FRAME + 1][0] if frames[FINAL_FRAME][0].to_i + frames[FINAL_FRAME][1].to_i == 10

    @frames = (0..FINAL_FRAME).map do |frame_count|
      Frame.new(*frames[frame_count][0..1], frames[frame_count][2])
    end
  end

  def score
    (0..FINAL_FRAME).sum do |frame_count|
      current_frame, next_frame, after_next_frame = @frames.slice(frame_count, 3)
      current_frame.score + current_frame.bonus(next_frame, after_next_frame)
    end
  end
end
