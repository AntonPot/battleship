require "./lib/board"

class Player
  attr_reader :log_board, :player_board

  def initialize
    @log_board = Board.new
    @player_board = Board.new
  end

  def list_available_ships
    player_board.new_ships.map(&:type).map(&:capitalize).join(", ")
  end

  def display_boards
    puts "\nOpponent's map"
    log_board.display

    puts "\nYour map"
    player_board.display
  end

  def put_ship_on_the_board(input:)
    ship_initial, start_location, direction = parse_placement_input(input)
    column, row = parse_cell_location_input(start_location)

    player_board.place_ship(ship_initial: ship_initial, row: row, column: column, direction: direction)
  end

  def log(on:, is_hit:)
    column, row = parse_cell_location_input(on)
    log_board.send(is_hit ? :hit : :miss, {row: row, column: column})
  end

  def fire(on:)
    column, row = parse_cell_location_input(on)
    player_board.hit?(row: row, column: column)
  end

  def alive?
    !player_board.all_ships_sunk?
  end

  private

  def parse_placement_input(input)
    parsed = input.split(",").map.with_index do |i, index|
      index == 2 ? i.strip.downcase.to_sym : i.strip.upcase
    end

    raise InputError, "Wrong input" if parsed.length != 3

    parsed
  end

  def parse_cell_location_input(input)
    parsed = input.split("").map(&:upcase)

    # Row "10" becomes a string with two characters so an exception is required
    parsed.length > 2 ? [parsed[0], parsed[1] + parsed[2]] : parsed
  end
end
