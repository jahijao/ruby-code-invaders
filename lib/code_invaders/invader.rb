require 'code_invaders'

class CodeInvaders
  # The Invader class represents an invader pattern
  # it holds basic information about the invader
  class Invader
    attr_reader :name, :pattern, :width, :height

    def initialize(name, pattern)
      @name = name
      @pattern = pattern.split("\n").map { |line| line.split('') }
      @width = @pattern.first.length
      @height = @pattern.length
    end

    def self.initialize_invaders
      Dir.glob('assets/invaders/*.txt').map do |file|
        name = File.basename(file, '.txt')
        pattern = File.read(file)
        CodeInvaders::Invader.new(name, pattern)
      end
    end
  end
end
