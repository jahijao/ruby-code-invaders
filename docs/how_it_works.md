# Basic info

We will take a look at the starting point, which is the `CodeInvaders` class.

```ruby
class CodeInvaders
  def initialize(radar_sample_file)
    @invaders = CodeInvaders::Invader.initialize_invaders
    @radar = CodeInvaders::Radar.new(radar_sample_file)
  end

  def run
    @radar.locate_invaders(@invaders)
  end
  ...
```

It takes a radar sample as an argument and initializes the invaders and the radar.
The `@invaders` holds all the invaders patterns (and other basic info) and the `@radar` holds the radar sample.
The run method is the starting point of the application, it calls the `locate_invaders` method on the radar.

# How it works

This is the method which does most of the work (located in the `Radar`):

```ruby
def locate_invaders(invaders)
  invaders.each do |invader|
    @result[invader.name] ||= []

    possible_x_coords = @width - invader.width
    possible_y_coords = @height - invader.height

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
          hit_percentage: precision_percentage
        }
      end
    end
  end
end
```

The basic idea is to use the sliding window algorithm to find the invaders.
It is most likely not the most efficient way to do it and it has many edge cases,
however it was the most straight forward approach for me.

Logical steps:

1. Get the width and height of the radar sample and the invader pattern
   (this info is held inside their respective classes)
2. Extract the possible x and y coordinates.
   This means that I extract each possible x and y coordinate (for the top left corner of the invader).
   However, I exclude coordinates that would place the invader off screen. (one of the edge cases of this approach)

```ruby
possible_x_coords = @width - invader.width
possible_y_coords = @height - invader.height

if possible_x_coords.negative? || possible_y_coords.negative?
  puts "[ERROR] Radar sample too small for #{invader.name}"
  next
end
```

`@width` and `@height` reference the radar sample dimensions.
I also check if the width and height of the invader pattern is larger than the radar sample, if so I skip the invader.

3. For each possible y coordinate, I loop through each possible x coordinate

```ruby
possible_y_coords.times do |y|
  possible_x_coords.times do |x|
```

4. Extract the sub pattern from the radar sample

```ruby
subpattern = @radar_sample[y, invader.height].map { |line| line[x, invader.width] }
```

The `subpattern` is extracted from the radar sample using the current x and y values
and the width and the height of the invader pattern. This means that the sub pattern
is the exact same size as the invader pattern.

```ruby
@radar_sample[y, invader.height]
```

This returns as many rows as the invaders height, starting from current y.
This is why I made sure that the largest possible x and y coordinates can never place the invader off screen (needs improvements).

```ruby
.map { |line| line[x, invader.width] }
```

This returns as many columns as the invaders width, starting from current x.

5. Check each cell of the sub pattern against the invader pattern and return the hit percentage

```ruby
precision_percentage = pattern_match(invader.pattern, subpattern)
next unless precision_percentage >= MINIMUM_HIT_PRECISION
```

## Pattern matching

```ruby
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
```

The `pattern_match` method is a simple method that compares two same sized patterns (emphasis on same sized).
(This also needs to be modified for off screen invaders)

In simple terms:

- Get the current cell count
- Loop each row of the invader pattern (the `pattern` variable)
- Loop each cell of the invader pattern
- Check if the cell of the invader is a match for the same positioned cell in the sub pattern
  (this step makes sense for me as the method will be called for each possible coordinate so we can ignore 'off by one' cases)
- If the cells match, count it
- Return the percentage of matching cells

```ruby
next unless precision_percentage >= MINIMUM_HIT_PRECISION
```

The `MINIMUM_HIT_PRECISION` is my personal magic number that determines how accurate the hits should be.

6. Optimize the results

```ruby
next if @result[invader.name].any? do |res|
  (res[:x] - x).abs < invader.width || (res[:y] - y).abs < invader.height
end
```

Since each possible coordinate is checked, there will be multiple hits for each invader (hits above my magic number)
This step filters out results too close to each other, meaning that we skip the found result if (.any?) there is already
a result close to the current one.

NOTE:
This step also needs to be improved, as only the first hit will be stored, even though the second or third iteration is more accurate
and has a higher matching cell count. This makes the exact invader location less accurate as well.

```ruby
(res[:x] - x).abs < invader.width && (res[:y] - y).abs < invader.height
```

Is there a result already in the results hash which has it's x and y coordinates within the distance equal to the width and height of the invader.
This means that no two invaders can ever overlap (another possible edge case). The closest two invaders can get is right next to each other.

7. Store the results

```ruby
@result[invader.name] << {
  x: x,
  y: y,
  hit_percentage: precision_percentage
}
```

8. Display the results

```ruby
AwesomePrint.defaults = {
  indent: 4, # spaces per indent level
  index: false,          # don’t show array indices
  multiline: true,       # wrap hashes and arrays nicely
  plain: false,          # enable color
  color: {
    hash: :cyan,
    string: :yellow,
    integer: :green,
    symbol: :magenta
  }
}

ap @radar.result
```

I use awesome print for this because I am too lazy.
