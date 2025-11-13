require 'code_invaders/invader'
require 'code_invaders/radar'
require 'awesome_print'

# The CodeInvaders class is the main class of the application
# it needs to load the radar sample and the invaders patterns
# use the pattern matcher to try and find the invaders
# display the resulting coords
class CodeInvaders
  def initialize(radar_sample_file)
    @invaders = CodeInvaders::Invader.initialize_invaders
    @radar = CodeInvaders::Radar.new(radar_sample_file)
  end

  def run
    @radar.locate_invaders(@invaders)
  end

  def print_results
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
  end
end
