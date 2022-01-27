class Cell
  attr_accessor :value
  attr_reader :row, :column

  def initialize(row:, column:, value: nil)
    @value = value
    @column = column
    @row = row
  end

  def inspect
    value
  end
end
