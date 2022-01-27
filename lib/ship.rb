require "pry-byebug"

class Ship
  TYPES = {
    destroyer: 2,
    submarine: 3,
    cruiser: 3,
    battleship: 4,
    aircraft_carrier: 5
  }.freeze

  def initialize(type)
    @type = type
  end

  attr_reader :type

  def initial
    type.to_s[0].upcase
  end

  def size
    TYPES[type]
  end
end
