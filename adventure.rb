# Global variable for where files should be saved and loaded
$file_name = "unsavedadventure.sav"

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

# Hero inherited from Character
class Hero < Character
  attr_accessor :cur_exp, :max_exp
  def initialize(name, health = 100, strength = 1)
    super(name, health, strength)
    @max_exp = 100
    @cur_exp = 0
  end

  # The hero will fight with a given monster as a parameter
  # Return: False if the hero dies, true if the monster dies
  def fight(monster)
    puts    
    puts "========FIGHT========"
    puts "#{@name} Vs #{monster.name}"
    puts

    # Populate an array with X number of levels Hero is and Y number of levels Monster is
    # This way whoever is a higher level has a better chance of attacking  
    attack_arr = []
    @level.to_i.times { attack_arr.push("Hero") }
    monster.level.to_i.times { attack_arr.push("Monster") }
    
    # Loop until one character dies
    while @cur_health > 0 && monster.cur_health > 0
      case attack_arr.shuffle.first
        when "Hero" then monster.cur_health -= strength
        when "Monster" then @cur_health -= monster.strength
      end
    end

    return (@cur_health > monster.cur_health)
  end

  # Save the hero's progression
  def save
    open($file_name, 'w') do |f|
      f.puts @name
      f.puts @level
      f.puts @cur_health
      f.puts @max_health
      f.puts @strength
      f.puts @cur_exp
      f.puts @max_exp
    end
    return true
  end

  # Read each line from the saved text file, if it exists, and populate character
  # Return true if file was able to be loaded, false otherwise
  def load
    print "What's your hero name? "
    $file_name = gets.chomp+".sav"
    if File.exists?($file_name)
      text = File.readlines($file_name).map(&:chomp)
      @name = text[0].to_s
      @level = text[1].to_i
      @cur_health = text[2].to_i
      @max_health = text[3].to_i
      @strength = text[4].to_i
      @cur_exp = text[5].to_i
      @max_exp = text[6].to_i
      return true
    else
      return false
    end
  end

  # Append the hero's experience to super
  def to_s
    super + "\n" +
    "Experience: #{@cur_exp}/#{@max_exp}"
  end
end

# Monster inherited from Character
class Monster < Character
  attr_accessor :name, :health, :strength 
  def initialize(name = nil, health = 100, strength = 1)
    # choose 10 random characters for a monster name if name not given
    name ||= (0...10).map { ('a'..'z').to_a[rand(26)] }.join
    super(name, health, strength)
  end

end  

# Create a new hero
hero = Hero.new("No name")
if hero.load() == true
  puts "Welcome back #{hero.name}!"
else
  print "Welcome!  What is your name?: "
  hero.name = gets.chomp
end

# main loop.  Ask the user for an action and execute said action
while true

  print "[F]ight, [L]oad, [Sa]ve, [St]atus, or [Q]uit?: "
  answer = gets.chomp
  hero_wins = nil

  monster = Monster.new(nil, 20, 1)

  # Decide what action to take based on user input
  case answer.downcase
    when "fight", "f" then hero_wins = hero.fight(monster)
    when "load", "l"
      result = hero.load()
      puts result ? "Hero file loaded!" : "Unable to load file!"
    when "save", "sa" 
      result = hero.save()
      puts result ? "Hero file saved!" : "Unable to save file!"
    when "status", "st" 
      puts
      puts hero.to_s
    when "quit", "q"
      # For now do not prompt the user to save.  Just quit
      #print "Would you like to save first? [yes/no]: "
      #if gets.chomp.downcase == "yes"
      #  result = hero.save()
      #  puts result ? "Hero file saved!" : "Unable to save file!"
      #end

      puts
      puts "Goodbye!"    
      break
    else puts "That is not a valid command!"
  end

  # This case will only execute if the user previous selected 'Fight'
  # otherwise 'hero_wins' will be equal to nil.
  # Decide what to do if the hero wins or dies from a fight
  case hero_wins
    when true
      # You won!
      gain_exp = (((hero.max_health - hero.cur_health) * 0.85) * monster.level).round

      puts "You win!  Gained #{gain_exp} experience!"
      # Reward EXP to player.  Increase EXP and level if enough EXP is gained
      # if level increases, increase max health by 30%, restore current health
      # and let the user know the hero leveled up
      hero.cur_exp += gain_exp
      while hero.cur_exp > hero.max_exp
        hero.level += 1
        hero.cur_exp -= hero.max_exp
        hero.max_exp *= 2
        hero.max_health = (hero.max_health * 1.3).round
        hero.cur_health = hero.max_health
        puts "#{hero.name} leveled up!"
      end 

    when false
      puts "You lose!"

      # Your hero lost!  Now you must load an old save or create a new character
      while true
        print "New game or Load saved character? [New, Load]: "
        result = gets.chomp

        case result.downcase
          when "new"
            print "Welcome! What is your name?: "
            hero = Hero.new(gets.chomp)
            break
          when "load"
            if hero.load()
              puts "Hero file loaded!"
              break
            else
              puts "Unable to load file!"
            end
          else puts "That is not a valid command!"
        end
      end
  end
end
