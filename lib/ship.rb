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
    @hit_count = 0
  end

  attr_reader :type, :hit_count

  def initial
    type.to_s[0].upcase
  end

  def size
    TYPES[type]
  end

  def afloat?
    hit_count < size
  end

  def hit!
    @hit_count += 1
  end
end
