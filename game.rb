require 'curses'


class Game
  SCREEN_HEIGHT = 20
  SCREEN_WIDTH  = 80
  HEADER_HEIGHT = 1
  HEADER_WIDTH  = SCREEN_WIDTH
  STATS_HEIGHT  = 4
  STATS_WIDTH   = SCREEN_WIDTH
  CMD_HEIGHT    = 1
  CMD_WIDTH     = SCREEN_WIDTH
  MAIN_HEIGHT   = SCREEN_HEIGHT - CMD_HEIGHT - STATS_HEIGHT - HEADER_HEIGHT
  MAIN_WIDTH    = SCREEN_WIDTH

  def initialize(save_file)
    @save_file = save_file
    @hero = Hero.new(nil)

    # Initialize Curses
    # Turn off echoing at the end of initization
    Curses.nonl # detect return/enter key with ::getch
    Curses.stdscr.keypad(false) # do not detect arrow keys
    Curses.stdscr.nodelay = true # getch does not block until a key is pressed
    Curses.init_screen # Init screen
    Curses.start_color
    Curses.init_pair(1, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
    Curses.init_pair(2, Curses::COLOR_BLACK, Curses::COLOR_GREEN)
    Curses.init_pair(3, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
    Curses.init_pair(4, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
    Curses.init_pair(5, Curses::COLOR_RED, Curses::COLOR_BLACK)

    # Create header window for title of game
    @header_window = Curses::Window.new( HEADER_HEIGHT, HEADER_WIDTH, 0, 0)
    @header_window.color_set(2)
    @header_window << "Adventure!".center(HEADER_WIDTH)
    @header_window.refresh

    # Create stats window for user stats
    @stats_window = Curses::Window.new(STATS_HEIGHT, STATS_WIDTH, HEADER_HEIGHT, 0)
    @stats_window.color_set(1)
    @stats_window.scrollok(false)
    @stats_window.refresh

    # Create main window for action to take place
    @main_window = Curses::Window.new(MAIN_HEIGHT, MAIN_WIDTH, STATS_HEIGHT+HEADER_HEIGHT, 0)
    @main_window.color_set(1)
    @main_window.scrollok(true) # Do not let the window scroll
    @main_window.setpos(MAIN_HEIGHT - 1, 0)
    @main_window.refresh

    # Create stats window for user stats
    @cmd_window = Curses::Window.new(CMD_HEIGHT, CMD_WIDTH, STATS_HEIGHT+HEADER_HEIGHT+MAIN_HEIGHT, 0)
    @cmd_window.color_set(4)
    @cmd_window.scrollok(false)
    @cmd_window.refresh

    # Attempt to load character file
    if save_exists()
      load_game()

      # Welcome hero back to the game
      @main_window.setpos(0,0)
      @main_window << "Welcome back #{@hero.name}!"
      @main_window.refresh
    else
      new_game()
    end
  end

  def play
    while true
      show_status()

      @cmd_window.setpos(0,0)
      @cmd_window << "[F]ight, [L]oad, [S]ave, [Q]uit?: "
      @cmd_window.refresh

      # Get user input and downcase if it is a string input
      answer = @main_window.getch
      answer.downcase! if answer.is_a? String

      # Decide what action to take based on user input
      case answer
        when "fight", "f" then start_fight()
        when "load", "l" then load_game()
        when "save", "s" then save_game()
        when "quit", "q" then quit_game()
        else
          @cmd_window.setpos(0,0)
          @cmd_window << "Not a valid command!".rjust(CMD_WIDTH)
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
      @hero.win_battle(battle.get_exp())
      @main_window << "\nYou win!  Gained #{battle.get_exp()} experience!"
      @main_window << " leveled up!" if @hero.leveled?
      @main_window.refresh
    when false
      game_over()
    end
  end

  def show_status
    stats = @hero.status() # hash of stats
    @stats_window.setpos(0, 0)
    @stats_window << (stats[:level].to_s + " LEVEL").rjust(MAIN_WIDTH)
    @stats_window << (stats[:hp_cur].to_s + "/" + stats[:hp_max].to_s + " HP").rjust(MAIN_WIDTH)
    @stats_window << (stats[:str].to_s + " STR").rjust(MAIN_WIDTH)
    @stats_window << (stats[:exp_cur].to_s + "/" + stats[:exp_max].to_s + " EXP").rjust(MAIN_WIDTH)
    @stats_window.refresh
  end

  def new_game
    # Turn on user input echoing for their name
    Curses.echo

    @cmd_window.clear # Clear command window while entering name
    @cmd_window.refresh

    @stats_window.clear # Clear status window while entering name
    @stats_window.refresh

    # Get hero's name from user input
    @main_window.clear
    @main_window.setpos(0,0)
    @main_window << "What is your character's name?: "
    @hero = Hero.new(nil)
    @hero.name = @main_window.getstr

    # Welcome hero to the game
    @main_window.clear
    @main_window << "Welcome #{@hero.name}!"
    @main_window.refresh

    # Turn off user input echoing after the user has entered their name
    Curses.noecho
  end

  # Load a saved file if it exists.  The saved file is a marshaled object of hero
  # Return true if file was able to be loaded, false otherwise
  def load_game
    if File.exists?(@save_file)
      File.open(@save_file, 'r') do |f|
        @hero = Marshal.load(f)
      end
      @cmd_window.setpos(0,0)
      @cmd_window << "Game loaded!".rjust(CMD_WIDTH)
    else
      @cmd_window.setpos(0,0)
      @cmd_window << "No save file found!".rjust(CMD_WIDTH)
    end
  end

  # Save a marshal object of hero
  def save_game
    File.open(@save_file, 'w') do |f|
      Marshal.dump(@hero, f)
    end
    @cmd_window.setpos(0,0)
    @cmd_window << "Game saved!".rjust(CMD_WIDTH)
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

    # Hero has died.  Print to main window and clear command window
    @main_window << "\nYou died!\n"
    @cmd_window.color_set(5) # Set to red
    @cmd_window.clear

    # Your hero lost!  Now you must load an old save or create a new character
    while true
      @cmd_window.setpos(0,0)
      @cmd_window << "New game or Load character? ([N]ew, [L]oad, [Q]uit]): "
      result = @cmd_window.getch
      result.downcase! if result.is_a? String

      case result
        when "new", "n"
          new_game()
          break
        when "load", "l"
          load_game()
          break if save_exists()
        when "quit", "q"
          quit_game()
        else
          @cmd_window.setpos(0,0)
          @cmd_window << "Not a valid command!".rjust(CMD_WIDTH)
      end
    end

    @cmd_window.color_set(4) # Set back to white if loop is broken
  end

end
