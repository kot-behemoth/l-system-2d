#!/usr/bin/env ruby
require 'rubygems'
require 'chingu'
include Gosu
include Chingu

class Game < Chingu::Window

	def initialize
		super 640, 480, false
		self.input = { :esc => :exit }
	end

	def update
		super
		self.caption = "L-system demo"
	end

end

Game.new.show