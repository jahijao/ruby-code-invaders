#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'code_invaders'

keyboard_input = ARGV
if keyboard_input.empty?
  puts 'No radar sample provided'
  exit
end

radar_sample_file = keyboard_input[0]
invaders = CodeInvaders.new(radar_sample_file)
invaders.run
invaders.print_results
