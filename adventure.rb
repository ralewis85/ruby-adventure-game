require './hero'
require './monster'
require './battle'
require './game'

FILE_NAME = "adventure.sav"
=begin
# Create a new hero
hero = Hero.new("No name")
if hero.load() == true
	puts "Welcome back #{hero.name}!"
else
	print "Welcome!  What is your name?: "
	hero.name = gets.chomp
end
=end

game = Game.new(FILE_NAME)
game.play
