# The PatternMatcher module defines the methods needed to match the invader in a radar sample
module PatternMatcher
  def pattern_match(pattern, subpattern)
    return 0 if pattern.length != subpattern.length

    cell_count = pattern.first.length * pattern.length
    matching_cells = 0
    pattern.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        matching_cells += 1 if cell == subpattern[row_index][cell_index]
      end
    end

    ((matching_cells.to_f / cell_count) * 100).round
  end
end
