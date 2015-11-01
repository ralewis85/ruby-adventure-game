require './hero'
require './monster'
require './battle'
require './game'

FILE_NAME = "adventure.sav"

# Create an instance of game and pass the saved file location
# so the hero can be loaded or saved to
game = Game.new(FILE_NAME)
game.play # Continues to execute until player quits

puts
puts "Goodbye!"
