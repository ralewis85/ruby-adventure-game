require './character'

# Monster inherited from Character
class Monster < Character
  attr_accessor :name, :health, :strength
  def initialize(name = nil, health = 100, strength = 1)
    # choose 10 random characters for a monster name if name not given
    name ||= (0...10).map { ('a'..'z').to_a[rand(26)] }.join
    super(name, health, strength)
  end

end

