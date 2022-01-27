require "pry-byebug"
require "awesome_print"
require "./lib/cell.rb"

class Board
  COLUMNS = %w[A B C D E F G H I J].freeze

  attr_reader :board, :ships

  def initialize
    @board = build_board
    @ships = []
  end

  def display
    board.each { |row| p row }
  end

  def change_cell_value(row:, column:, to:)
    find_cell(row: row, column: column).value = to
    "Success!"
  end

  def add_ship(ship:, start_location:, direction:)
    column, row = start_location.split("")
    cells = collect_cells(row: row, column: column, count: ship.size, direction: direction)

    return unless cells.all? { |c| c.value == "-" }

    cells.each { |c| c.value = ship.initial }
    @ships << ship
  end

  def find_cell(row:, column:)
    column_index = COLUMNS.index(column)&.+ 1
    row_index = row.to_i

    return "Warning!" unless column_index&.between?(1, 11) && row_index.between?(1, 11)

    board[row_index][column_index]
  end

  private

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
