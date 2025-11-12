require 'code_invaders'

class CodeInvaders
  # The invader class is supposed to be responsible for the actual invader logic
  # his pattern, name and location (if he is found)
  class Invader
    def initialize(name, pattern)
      @name = name
      @pattern = pattern.lines
      @location = nil
      @accuracy = 0
    end
  end
end
