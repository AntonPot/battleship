class Cell
  COLUMNS = %w[A B C D E F G H I J].unshift(nil).freeze
  EMPTY = "-".freeze

  attr_accessor :value

  def self.column_index(column)
    COLUMNS.index(column)
  end

  def initialize(row:, column:)
    @column = column
    @row = row
    @value = set_value
  end

  def inspect
    value
  end

  private

  attr_reader :row, :column

  def set_value
    if row.zero? && column.zero?
      "  "
    elsif row.zero?
      COLUMNS[column]
    elsif column.zero?
      row == 10 ? row.to_s : " #{row}"
    else
      EMPTY
    end
  end
end
