require "./lib/board"

class Player
  DIRECTIONS = %i[down left].freeze

  attr_reader :opponent_board, :player_board

  def initialize
    @opponent_board = Board.new
    @player_board = Board.new
  end

  def list_available_ships
    player_board.new_ships.map(&:type).map(&:capitalize).join(", ")
  end

  def display_boards
    puts "\nOpponent's battlefield"
    opponent_board.display

    puts "\nYour battlefield"
    player_board.display
  end

  def place_ship(input:)
    ship_initial, start_location, direction = parse_placement_input(input)
    row, column = parse_cell_location_input(start_location)

    raise InputError, "\nIllegal direction" unless DIRECTIONS.include?(direction)

    ships = player_board.place_ship(ship_initial: ship_initial, row: row, column: column, direction: direction)
    raise InputError, "Incorrect placement" unless ships
  end

  def automatic_ship_placement
    while player_board.new_ships.any?
      ship = player_board.new_ships.sample
      column, row = Board.random_cell.split("")
      direction = DIRECTIONS.sample

      player_board.place_ship(ship_initial: ship.initial, row: row, column: column, direction: direction)
    end
  end

  def log_hits(on:, is_hit:)
    column, row = parse_cell_location_input(on)

    opponent_board.change_cell_value(row: row, column: column, to: is_hit ? "X" : "O")
  end

  def hit?(on:)
    column, row = parse_cell_location_input(on)
    player_board.fire(row: row, column: column) == "X"
  end

  def alive?
    !player_board.all_ships_sunk?
  end

  private

  def parse_placement_input(input)
    input.split(",").map.with_index do |i, index|
      index == 2 ? i.strip.downcase.to_sym : i.strip.upcase
    end
  end

  def parse_cell_location_input(input)
    input.split("").map(&:upcase)
  end
end
