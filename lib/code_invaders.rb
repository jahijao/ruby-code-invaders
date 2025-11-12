require 'code_invaders/invader'
require 'code_invaders/radar'

# CodeInvaders class needs to initialize the radar and the invaders
# and then run the scan and output the result
class CodeInvaders
  def initialize(radar_sample)
    @invaders = []
    @radar_sample = radar_sample
  end

  def run
    Dir.glob('assets/invaders/*.txt').map do |file|
      name = File.basename(file, '.txt')
      pattern = File.read(file)
      @invaders << CodeInvaders::Invader.new(name, pattern)
    end

    puts @invaders.count
  end
end
