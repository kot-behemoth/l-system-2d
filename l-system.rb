#!/usr/bin/env ruby
require 'rubygems'
require 'chingu'
include Gosu
include Chingu

class LSystem
	attr_reader :input_string, :current_string
	attr_reader :iteration

	def initialize(input_string)
		@input_string = input_string
		@current_string = @input_string
		@iteration = 0
	end

	def reset
		@current_string = @input_string
		@iteration = 0
	end

	def next_iteration
		tmp_string = ''
		@current_string.each_char do |c|
			case c
				when 'F'
					tmp_string << 'F-F+F+FF-F-F+F'
				else
					tmp_string << c
			end
		end
		@current_string = tmp_string
		@iteration += 1
		# puts @iteration
	end

end

class Turtle < Chingu::GameObject
	# d - step size
	# b - angle increment
	attr_reader :d, :b
	attr_reader :lsystem

	def setup
		super
		@d = 300
		@b = 90
		@origin_x = ($window.width - @d) / 2.0
		@origin_y = ($window.height - @d) / 2.0
		reset_state

		@lsystem = LSystem.new 'F-F-F-F'
	end

	def draw
		super
		@lsystem.current_string.each_char do |c|
			case c
				# Move forward a step of length d. The state of the turtle
				# changes to (x',y',α), where x' = x + d cosα and y' = y + d sinα. A line
				# segment between points (x, y)and (x',y') is drawn.
				when 'F'
					# move the turle
					@previous_x = @x
					@previous_y = @y
					@x -= Gosu.offset_x(@angle, @d)
					@y -= Gosu.offset_y(@angle, @d)

					# then draw the path
					$window.draw_line( @previous_x, @previous_y, Color::WHITE, @x, @y, Color::WHITE )

				# Turn left by angle δ. The next state of the turtle is (x, y,α+δ). The
				# positive orientation of angles is counter-clockwise.
				when '+'
					@angle += @b

				# Turn right by angle δ. The next state of the turtle is (x, y,α−δ).
				when '-'
					@angle -= @b

				else
					raise 'Unknown string symbol encountered!'

			end
		end

		reset_state
	end

	def reset_lsystem
		@lsystem.reset_lsystem
	end

	def reset_state
		@x = @origin_x
		@y = @origin_y
		@angle = 0
	end

	def next_iteration
		@lsystem.next_iteration
		@d /= 4.0
		# puts @lsystem.current_string
	end

end

class Game < Chingu::Window

	def initialize
		super 800, 800, false
		self.input = { :esc => :exit }

		@turle = Turtle.create
		@turle.input = ( { :released_space => :next_iteration} )
	end

	def update
		super
		self.caption = "L-system demo"
	end

end

Game.new.show