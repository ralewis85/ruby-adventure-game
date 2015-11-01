class Game
  def initialize(save_file)
    @save_file = save_file
    @hero = Hero.new(nil)

    # Attempt to load character file
    unless load()
      puts "What is your character's name?: "
      @hero.name = gets.chomp
    else
      puts "Welcome back #{@hero.name}!"
    end
  end

  def play
    while true

      print "[F]ight, [L]oad, [Sa]ve, [St]atus, or [Q]uit?: "
      answer = gets.chomp
      hero_wins = nil

      monster = Monster.new(nil, 20, 1)

      # Decide what action to take based on user input
      case answer.downcase
        when "fight", "f"
          start_fight()
        when "load", "l"
          result = load()
          puts result ? "Hero file loaded!" : "Unable to load file!"
        when "save", "sa" 
          result = save()
          puts result ? "Hero file saved!" : "Unable to save file!"
        when "status", "st" 
          puts
          puts @hero.to_s
        when "quit", "q"
          # For now do not prompt the user to save.  Just quit
          #print "Would you like to save first? [yes/no]: "
          #if gets.chomp.downcase == "yes"
          #  result = hero.save()
          #  puts result ? "Hero file saved!" : "Unable to save file!"
          #end
          break
        else puts "That is not a valid command!"
      end
    end
  end

  private

  def start_fight
    monster = Monster.new(nil, 20, 1)

    battle = Battle.new(@hero, monster)
    hero_wins = battle.hero_wins()

    # This case will only execute if the user previous selected 'Fight'
    # otherwise 'hero_wins' will be equal to nil.
    # Decide what to do if the hero wins or dies from a fight
    case hero_wins
    when true
      # You won!
      puts "You win!  Gained #{battle.get_exp()} experience!"
      @hero.win_battle(battle.get_exp())
    when false
      puts "You died!"
      # Your hero lost!  Now you must load an old save or create a new character
      while true
        print "New game or Load saved character? [New, Load]: "
        result = gets.chomp

        case result.downcase
          when "new"
            print "Welcome!  What is your name?: "
            @hero = Hero.new(gets.chomp)
            break
          when "load"
            if load()
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

  # Load a saved file if it exists.  The saved file is a marshaled object of hero
  # Return true if file was able to be loaded, false otherwise
  def load
    if File.exists?(@save_file)
      File.open(@save_file, 'r') do |f|
        @hero = Marshal.load(f)
      end
      return true
    else
      return false
    end
  end

  # Save a marshal object of hero
  def save
    File.open(@save_file, 'w') do |f|
      Marshal.dump(@hero, f)
    end
    # TODO : Return false if unable to write to file
    return true
  end
end
