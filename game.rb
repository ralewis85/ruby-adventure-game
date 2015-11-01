class Game
  def initialize(save_file)
    @save_file = save_file
    @hero = Hero.new(nil)

    # Attempt to load character file
    unless save_exists()
      puts "What is your character's name?: "
      @hero.name = gets.chomp
    else
      load_game()
      puts "Welcome back #{@hero.name}!"
    end
  end

  def play
    while true

      print "[F]ight, [L]oad, [Sa]ve, [St]atus, or [Q]uit?: "
      answer = gets.chomp

      # Decide what action to take based on user input
      case answer.downcase
        when "fight", "f" then start_fight()
        when "load", "l" then load_game()
        when "save", "sa" then save_game()
        when "status", "st" then show_status() 
        when "quit", "q" then quit_game()
        else puts "That is not a valid command!"
      end
    end
  end

  private

  def start_fight
    monster = Monster.new(nil, 200, 1)

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
      game_over()
    end
  end

  def show_status
    # TODO: make this better
    puts
    puts @hero.to_s
  end

  # Load a saved file if it exists.  The saved file is a marshaled object of hero
  # Return true if file was able to be loaded, false otherwise
  def load_game
    if File.exists?(@save_file)
      File.open(@save_file, 'r') do |f|
        @hero = Marshal.load(f)
      end
      puts "Game loaded!"
    else
      puts "No save file found!"
    end
  end

  # Save a marshal object of hero
  def save_game
    File.open(@save_file, 'w') do |f|
      Marshal.dump(@hero, f)
    end
    puts "Game saved!"
  end

  def save_exists
    return File.exists?(@save_file)
  end

  def quit_game
    #For now do not prompt the user to save.  Just quit
    #print "Would you like to save first? [yes/no]: "
    #if gets.chomp.downcase == "yes"
    #  result = hero.save()
    #  puts result ? "Hero file saved!" : "Unable to save file!"
    #end

    puts
    puts "Goodbye #{@hero.name}!"
    exit 0
  end

  def game_over
    puts "You died!"
    puts
    # Your hero lost!  Now you must load an old save or create a new character
    while true
      print "New game or Load saved character? [New, Load, Quit]: "
      result = gets.chomp

      case result.downcase
        when "new"
          print "Welcome!  What is your name?: "
          @hero = Hero.new(gets.chomp)
          break
        when "load"
          load_game()
          break if save_exists()
        when "quit"
          quit_game()
        else puts "That is not a valid command!"
      end
    end
  end

end
