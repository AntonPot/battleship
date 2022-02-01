require "./lib/cell"
require "./lib/ship"
require "./lib/board/collect_empty_cells"

class Board
  DIRECTIONS = %i[down left].freeze
  FIRE_RESULTS = {
    hit: "X",
    miss: "O"
  }.freeze

  attr_reader :matrix, :new_ships, :placed_ships, :sunk_ships

  def self.random_location
    Cell::COLUMNS[1..-1].sample + rand(1..10).to_s
  end

  def initialize
    @matrix = build_matrix
    @new_ships = build_ships
    @placed_ships = []
    @sunk_ships = []
  end

  def display
    matrix.each { |row| p row }
  end

  def find_cell(row:, column:)
    column_index = Cell.column_index(column)
    row_index = row.to_i

    raise InputError, "No such location" unless column_index&.between?(1, 10) && row_index.between?(1, 10)

    matrix[row_index][column_index]
  end

  def place_ship(ship_initial:, row:, column:, direction:)
    ship = find_ship(ship_initial: ship_initial)
    cells = CollectEmptyCells.new(self, row, column, ship.size, direction).call

    commit_ship_to_location(cells: cells, ship: ship)
  end

  def automatic_ship_placement
    while new_ships.any?
      ship = new_ships.sample
      column, row = Board.random_location.split("")
      direction = DIRECTIONS.sample

      begin
        cells = CollectEmptyCells.new(self, row, column, ship.size, direction).call
      rescue InputError
        next
      end

      commit_ship_to_location(cells: cells, ship: ship)
    end
  end

  def hit?(row:, column:)
    cell = find_cell(row: row, column: column)

    return if FIRE_RESULTS.value?(cell.value)

    if cell.value == Cell::EMPTY
      cell.value = FIRE_RESULTS[:miss]
      return
    end

    ship = placed_ships.find { |s| s.initial == cell.value }
    ship.hit!
    sink_ship(ship: ship) unless ship.afloat?
    cell.value = FIRE_RESULTS[:hit]
  end

  def hit(row:, column:)
    find_cell(row: row, column: column).value = FIRE_RESULTS[:hit]
  end

  def miss(row:, column:)
    find_cell(row: row, column: column).value = FIRE_RESULTS[:miss]
  end

  def all_ships_sunk?
    placed_ships.empty?
  end

  private

  def commit_ship_to_location(cells:, ship:)
    cells.each { |c| c.value = ship.initial }
    @placed_ships << ship

    new_ships.delete_if { |s| placed_ships.include?(s) }
  end

  def find_ship(ship_initial:)
    ship = new_ships.find { |s| s.initial == ship_initial }
    raise InputError, "No such ship" unless ship

    ship
  end

  def sink_ship(ship:)
    @sunk_ships << ship
    placed_ships.delete_if { |s| sunk_ships.include?(s) }
  end

  def build_ships
    Ship::TYPES.keys.map { |type| Ship.new(type) }
  end

  def build_matrix
    Array.new(11) do |row_index|
      Array.new(11) do |column_index|
        Cell.new(row: row_index, column: column_index)
      end
    end
  end
end
