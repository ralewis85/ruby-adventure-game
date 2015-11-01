class Battle
  def initialize(char1, char2)
    @hero = char1
    @monster = char2

    @winner = fight()
  end

  # The hero will fight with a given monster as a parameter
  # Return: False if the hero dies, true if the monster dies
  def fight
    puts
    puts "========FIGHT========"
    puts "#{@hero.name} Vs #{@monster.name}"
    puts

    # Populate an array with X number of levels Hero is and Y number of levels Monster is
    # This way whoever is a higher level has a better chance of attacking 
    attack_arr = []
    @hero.level.to_i.times { attack_arr.push("Hero") }
    @monster.level.to_i.times { attack_arr.push("Monster") }

    # Loop until one character dies
    while @hero.cur_health > 0 && @monster.cur_health > 0
      case attack_arr.shuffle.first
        when "Hero" then @monster.cur_health -= @hero.strength
        when "Monster" then @hero.cur_health -= @monster.strength
      end
    end

    return (@hero.cur_health > @monster.cur_health)
  end

  # Return the amount of experience gained if the monster is defeated
  def get_exp
      exp = 0
      exp = (((@hero.max_health - @hero.cur_health) * 0.85) * @monster.level).round if @winner
      return exp
  end

  def hero_wins
    return @winner
  end

end
