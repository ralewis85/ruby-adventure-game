require './character'

# Hero inherited from Character
class Hero < Character
  attr_accessor :cur_exp, :max_exp
  def initialize(name, health = 100, strength = 1)
    super(name, health, strength)
    @max_exp = 100
    @cur_exp = 0
  end

  def win_battle(exp)
    # Reward EXP to player.  Increase EXP and level if enough EXP is gained
    # if level increases, increase max health by 30%, restore current health
    # and let the user know the hero leveled up
    @cur_exp += exp
    while @cur_exp > @max_exp
      @level += 1
      @cur_exp -= @max_exp
      @max_exp *= 2
      @max_health = (@max_health * 1.3).round
      @cur_health = @max_health
      puts "#{@name} leveled up!"
    end
  end

  # Append the hero's experience to super
  def stats
    super + "\n" +
    "Experience: #{@cur_exp}/#{@max_exp}"
  end
end
