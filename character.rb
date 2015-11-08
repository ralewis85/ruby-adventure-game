# Parent class that describes all heros and monsters in the game
# Is used to store common variables and have a to_s method
class Character
  attr_accessor :name, :cur_health, :max_health, :strength, :level
  def initialize(name, health, strength)
    # Default values that will be overwritten
    @name = name
    @level = 1
    @cur_health = health
    @max_health = health
    @strength = strength
    @cur_exp = 0
    @max_exp = 100
  end

  # Print to_s all variables that are in this class
  def status
    stat = Hash.new("Empty!")
    stat[:name] = @name
    stat[:level] = @level
    stat[:hp_cur] = @cur_health
    stat[:hp_max] = @max_health
    stat[:str] = @strength
    stat[:exp_cur] = @cur_exp
    stat[:exp_max] = @max_exp

    return stat

    #"Name: #{@name}\n" +
    #"Level: #{@level}\n" +
    #"Health: #{@cur_health}/#{@max_health}\n" +
    #"Strength: #{@strength}"
  end
end

