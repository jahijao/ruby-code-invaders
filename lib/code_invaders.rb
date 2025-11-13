require 'code_invaders/invader'
require 'code_invaders/radar'

# The CodeInvaders class is the main class of the application
# it needs to load the radar sample and the invaders patterns
# use the pattern matcher to try and find the invaders
# display the resulting coords
class CodeInvaders
  def initialize(radar_sample)
    @invaders = CodeInvaders::Invader.initialize_invaders
    @radar = CodeInvaders::Radar.new(radar_sample)
  end

  def run
    @radar.locate_invaders(@invaders)
    puts @radar.result
  end
end
