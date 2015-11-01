# Parent class that describes all heros and monsters in the game
# Is used to store common variables and have a to_s method
class Character
  attr_accessor :name, :cur_health, :max_health, :strength, :level
  def initialize(name, health, strength)
    # Default values that will be overwritten
    @name = name 
    @max_health = health
    @cur_health = health
    @strength = strength
    @level = 1
  end

  # Print to_s all variables that are in this class
  def to_s
    "Name: #{@name}\n" +
    "Level: #{@level}\n" +
    "Health: #{@cur_health}/#{@max_health}\n" +
    "Strength: #{@strength}"
  end
end

