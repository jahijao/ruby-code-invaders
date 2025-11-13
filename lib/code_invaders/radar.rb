require 'code_invaders/concerns/pattern_matcher'

class CodeInvaders
  # The radar class loads the sample pattern and defines the dimensions
  # and the grid of the pattern
  class Radar
    include PatternMatcher

    attr_reader :result

    def initialize(radar_sample)
      @radar_sample = radar_sample.split('\n').map { |line| line.split('') }
      @width = @radar_sample.first.length
      @height = @radar_sample.length
      @result = {}
    end

    def locate_invaders(invaders)
      invaders.each do |invader|
        @result[invader.name] ||= []
        # we are referencing the top left coordinates of the invader
        possible_x_coords = @width - invader.width + 1
        possible_y_coords = @height - invader.height + 1

        if possible_x_coords.negative? || possible_y_coords.negative?
          puts "[ERROR] Radar sample to small for #{invader.name}"
          next
        end

        possible_y_coords.times do |y|
          possible_x_coords.times do |x|
            subpattern = @radar_sample[y..y + invader.height].map { |line| line[x..x + invader.width] }
            @result[invader.name] << [x, y] if match_pattern?(invader.pattern, subpattern)
          end
        end
      end
    end
  end
end
