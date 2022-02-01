require "spec_helper"

RSpec.describe Board::CollectEmptyCells do
  let(:board) { Board.new }
  let(:row) { "3" }
  let(:column) { "B" }
  let(:ship_size) { 3 }
  let(:direction) { :left }

  subject { described_class.new(board, row, column, ship_size, direction).call }

  describe "#call" do
    it { is_expected.to be_kind_of Array }
    it { expect(subject.size).to be ship_size }

    it "returns expected cells" do
      cells = [
        board.find_cell(row: "3", column: "B"),
        board.find_cell(row: "3", column: "C"),
        board.find_cell(row: "3", column: "D")
      ]
      expect(subject).to match_array(cells)
    end

    context "when all cells aren't empty" do
      before { board.place_ship(ship_initial: "D", row: "3", column: "C", direction: :down) }

      it { expect { subject }.to raise_error(InputError, "Ship collision") }
    end

    context "when direction is wrong" do
      let(:direction) { :foobar }

      it { expect { subject }.to raise_error(InputError, "Illegal direction") }
    end

    context "when ship reaches out of bounds" do
      let(:column) { "J" }

      it { expect { subject }.to raise_error(InputError, "No such location") }
    end
  end
end
