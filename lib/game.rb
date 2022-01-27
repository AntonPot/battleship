require "./lib/board.rb"
require "./lib/ship.rb"
require "pry-byebug"

class Game
  DIRECTIONS = %i[down left].freeze

  def initialize
    @board = Board.new
    @ships = build_ships
  end

  def run
    ship_placement
  end

  private

  attr_reader :board, :ships

  def ship_placement
    board.display

    while ships.any?
      puts "\nPlace your ships:"
      puts ships.map(&:type).map(&:capitalize).join(", ")
      puts "\nExample: 'D, B4, down' for Destroyer to be placed on B4 and C4"

      input = gets.chomp
      ship_initial, start_location, direction = parse_placement_input(input)

      next puts("\nIllegal direction") unless DIRECTIONS.include?(direction)

      ship = ships.find { |s| s.initial == ship_initial.strip.upcase }
      next puts("\nNo such ship") unless ship

      board_ships = board.add_ship(ship: ship, start_location: start_location.strip.upcase, direction: direction)
      next puts("\nIncorrect placement") unless board_ships

      ships.delete_if { |s| board_ships.include?(s) }
      board.display
    end
  end

  def battle
    loop do
      board.display
      puts "Enter cell location (e.g. A5)"

      input = gets.chomp.split("")
      column = input[0].upcase
      row = input[1..-1].join("")

      puts board.change_cell_value(column: column, row: row, to: "X")
    end
  end

  def build_ships
    Ship::TYPES.keys.map { |type| Ship.new(type) }
  end

  def parse_placement_input(input)
    input.split(",").map.with_index do |i, index|
      index == 2 ? i.strip.downcase.to_sym : i.strip.upcase
    end
  end
end

Game.new.run
