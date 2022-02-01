# The service class collects cells with value '-' in a given direction for the full length of the ship
# If the ship is too long, and it reaches out of bounds, collection is unsuccessful and returns `nil`

class Board
  class CollectEmptyCells
    def initialize(board, row, column, ship_size, direction)
      @board = board
      @row = row
      @column = column
      @ship_size = ship_size
      @direction = direction
    end

    def call
      cells = collect_cells
      raise InputError, "Ship collision" unless all_cells_empty?(cells)

      cells
    end

    private

    attr_reader :board, :row, :column, :ship_size, :direction

    def collect_cells
      (1..ship_size).map do
        cell = board.find_cell(row: @row, column: @column)
        set_next_location
        cell
      end
    end

    def set_next_location
      case direction
      when :down then @row = row.next
      when :left then @column = column.next
      else
        raise InputError, "Illegal direction"
      end
    end

    def all_cells_empty?(cells)
      cells.all? { |c| c.value == Cell::EMPTY }
    end
  end
end
