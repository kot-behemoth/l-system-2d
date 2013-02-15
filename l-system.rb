#!/usr/bin/env ruby
require 'rubygems'
require 'chingu'
include Gosu
include Chingu

class LSystem
	attr_reader :input_string
	attr_reader :current_string

	def initialize(input_string)
		@input_string = input_string
		@current_string = @input_string
	end

	def next_iteration
		# "F-F-F-F"

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

	end

end

class Turtle < Chingu::GameObject
	trait :velocity # mainly for previous_x, previous_y
	attr_reader :step_size, :angle_increment
	attr_reader :lsystem

	def setup
		@x = $window.width / 2.0
		@y = $window.height / 2.0

		@lsystem = LSystem.new 'F-F-F-F'
	end

	def next_iteration
		@lsystem.next_iteration
		puts @lsystem.current_string
	end

end

class Game < Chingu::Window

	def initialize
		super 640, 480, false
		self.input = { :esc => :exit }

		@turle = Turtle.new
		@turle.input = ( { :released_space => :next_iteration} )
	end

	def update
		super
		self.caption = "L-system demo"
	end

end

Game.new.show