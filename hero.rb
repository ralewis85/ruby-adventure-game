require './character'

# Global variable to save and load file
$FILE_NAME = 'adventure.sav'

# Hero inherited from Character
class Hero < Character
  attr_accessor :cur_exp, :max_exp
  def initialize(name, health = 100, strength = 1)
    super(name, health, strength)
    @max_exp = 100
    @cur_exp = 0
  end

  # Append the hero's experience to super
  def to_s
    super + "\n" +
    "Experience: #{@cur_exp}/#{@max_exp}"
  end
end
