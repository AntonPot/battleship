require "pry-byebug"
require "awesome_print"
require "./lib/cell.rb"
require "./lib/ship"

class Board
  COLUMNS = %w[A B C D E F G H I J].freeze

  attr_reader :board, :new_ships, :placed_ships, :sunk_ships

  def self.random_cell
    COLUMNS.sample + rand(1..10).to_s
  end

  def initialize
    @board = build_board
    @new_ships = build_ships
    @placed_ships = []
    @sunk_ships = []
  end

  def display
    board.each { |row| p row }
  end

  def change_cell_value(row:, column:, to:)
    cell = find_cell(row: row, column: column)
    raise InputError, "No such location" unless cell

    cell.value = to
  end

  def place_ship(ship_initial:, row:, column:, direction:)
    ship = new_ships.find { |s| s.initial == ship_initial }
    raise InputError, "No such ship" unless ship

    cells = collect_cells(row: row, column: column, count: ship.size, direction: direction)
    return unless cells.all? { |c| c&.value == "-" }

    cells.each { |c| c.value = ship.initial }
    @placed_ships << ship

    new_ships.delete_if { |s| placed_ships.include?(s) }
  end

  def fire(row:, column:)
    cell = get_cell(row: row, column: column)
    raise InputError, "No such location" unless cell

    return if %w[X O].include?(cell.value)
    return cell.value = "O" if cell.value == "-"

    ship = placed_ships.find { |s| s.initial == cell.value }
    ship.hit!

    unless ship.afloat?
      @sunk_ships << ship
      placed_ships.delete_if { |s| sunk_ships.include?(s) }
      puts "sunk ships count #{sunk_ships.count}"
    end

    cell.value = "X"
  end

  def all_ships_sunk?
    placed_ships.empty?
  end

  private

  def get_cell(row:, column:)
    find_cell(row: row, column: column)
  end

  def find_cell(row:, column:)
    column_index = COLUMNS.index(column)&.+ 1
    row_index = row.to_i

    return unless column_index&.between?(1, 10) && row_index.between?(1, 10)

    board[row_index][column_index]
  end

  def build_ships
    Ship::TYPES.keys.map { |type| Ship.new(type) }
  end

  def collect_cells(row:, column:, count:, direction:)
    (1..count).map do |_|
      cell = find_cell(row: row, column: column)

      case direction
      when :down then row = row.next
      when :left then column = column.next
      end
      cell
    end
  end

  def build_board
    Array.new(11) do |row_index|
      Array.new(11) do |column_index|
        Cell.new(row: row_index, column: column_index, value: cell_value(row_index, column_index))
      end
    end
  end

  def cell_value(row, column)
    if row.zero? && column.zero?
      "  "
    elsif row.zero?
      COLUMNS[column - 1]
    elsif column.zero?
      row == 10 ? row.to_s : " #{row}"
    else
      "-"
    end
  end
end
