$file_name = "adventure.sav"

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

	def to_s
		"Name: #{@name}\n" +
		"Level: #{@level}\n" +
		"Health: #{@cur_health}/#{@max_health}\n" +
		"Strength: #{@strength}"
	end
end


class Hero < Character
	attr_accessor :cur_exp, :max_exp
	def initialize(name, health = 100, strength = 1)
		super(name, health, strength)
		@max_exp = 100
		@cur_exp = 0
	end

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
		puts attack_arr
		
		while @cur_health > 0 && monster.cur_health > 0
			case attack_arr.shuffle.first
				when "Hero" then monster.cur_health -= strength
				when "Monster" then @cur_health -= monster.strength
			end
		end

		return (@cur_health > monster.cur_health)
	end

	def save
		open(file_nam, 'w') do |f|
			f.puts @name
			f.puts @level
			f.puts @cur_health
			f.puts @max_health
			f.puts @strength
			f.puts @cur_exp
			f.puts @max_exp
		end
	end

	# Read each line from the saved text file, if it exists, and populate character
	# Return true if file was able to be loaded, false otherwise
	def load
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

	def to_s
		super + "\n" +
		"Experience: #{@cur_exp}/#{@max_exp}"
	end
end

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
			print "Would you like to save first? [yes/no]: "
			if gets.chomp.downcase == "yes"
				result = hero.save()
				puts result ? "Hero file saved!" : "Unable to save file!"
			end

			puts
			puts "Goodbye!"		
			break
		else puts "That is not a valid command!"
	end

	# Decide what to do if you win or die
	case hero_wins
		when true
			# You won!
			gain_exp = (((hero.max_health - hero.cur_health) * 0.85) * monster.level).round

			# Reward EXP to player.  Increase EXP and level if enough EXP is gained
			hero.cur_exp += gain_exp
			while hero.cur_exp > hero.max_exp
				hero.level += 1
				hero.cur_exp -= hero.max_exp
				hero.max_exp *= 2
			end 

			puts "You win!  Gained #{gain_exp} experience!"
		when false
			puts "You lose!"
	end
end


