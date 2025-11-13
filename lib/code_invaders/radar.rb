require 'code_invaders/concerns/pattern_matcher'

class CodeInvaders
  # The radar class loads the sample pattern and defines the dimensions
  # and the grid of the pattern
  class Radar
    include PatternMatcher
    MINIMUM_HIT_PRECISION = 75
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

        possible_x_coords = @width - invader.width + 1
        possible_y_coords = @height - invader.height + 1

        if possible_x_coords.negative? || possible_y_coords.negative?
          puts "[ERROR] Radar sample too small for #{invader.name}"
          next
        end

        possible_y_coords.times do |y|
          possible_x_coords.times do |x|
            subpattern = @radar_sample[y, invader.height].map { |line| line[x, invader.width] }
            precision_percentage = pattern_match(invader.pattern, subpattern)
            next unless precision_percentage >= MINIMUM_HIT_PRECISION

            next if @result[invader.name].any? do |res|
              (res[:x] - x).abs < invader.width || (res[:y] - y).abs < invader.height
            end

            @result[invader.name] << {
              x: x,
              y: y,
              hit: precision_percentage
            }
          end
        end
      end
    end
  end
end
