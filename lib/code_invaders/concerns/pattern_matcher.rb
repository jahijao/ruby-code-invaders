# The PatternMatcher module defines the methods needed to match the invader in a radar sample
module PatternMatcher
  # TODO: make it smarter by adding noise
  def match_pattern?(pattern, subpattern)
    return false if pattern.length != subpattern.length

    puts "matching patterns #{pattern} and #{subpattern}"
    pattern.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        return false if cell != subpattern[row_index][cell_index]
      end
    end
  end
end
