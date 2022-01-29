require "spec_helper"

RSpec.describe Board do
  it { is_expected.to respond_to :board, :display, :change_cell_value }

  describe "#board" do
    subject { Board.new.board }

    it "returns 2D array" do
      expect(subject).to be_kind_of Array
      expect(subject.first).to be_kind_of Array
    end

    it "is filled with Cell objects" do
      expect(subject.dig(1, 2)).to be_kind_of Cell
    end
  end

  describe "#display" do
    it "prints each row" do
      expect(subject).to receive(:p).at_least(11).times
      subject.display
    end
  end

  # describe "#change_cell_value" do
  #   let(:cell) { subject.board[5][3] }

  #   it "changes value of correct cell" do
  #     expect do
  #       subject.change_cell_value(column: "C", row: 5, to: "X")
  #     end.to change(cell, :value).from("-").to("X")
  #   end

  #   context "when target is out of bounts" do
  #     it "responds with warning" do
  #       expect(subject.change_cell_value(column: "C", row: 12, to: "X")).to eq "Warning!"
  #       expect(subject.change_cell_value(column: "X", row: 2, to: "X")).to eq "Warning!"
  #     end
  #   end
  # end

  describe "#place_ship" do
    let(:ship) { Ship.new(:cruiser) }
    let(:board_instance) { Board.new }

    subject { board_instance.place_ship(ship: ship, start_location: "A2", direction: :down) }

    it "adds a Ship to the Board" do
      expect { subject }.to change { board_instance.placed_ships.count }.by(1)
    end

    it "places correct Ship on the Board" do
      subject
      last_ship_cell = board_instance.find_cell(row: "4", column: "A")
      next_cell = board_instance.find_cell(row: "5", column: "A")

      expect(last_ship_cell.value).to eq("C")
      expect(next_cell.value).to eq("-")
    end

    context "when Ship collides another Ship" do
      let(:first_cell_for_second_ship) { board_instance.find_cell(row: "2", column: "A") }

      before do
        board_instance.place_ship(ship: Ship.new(:battleship), start_location: "A3", direction: :left)
      end

      it { is_expected.to be_nil }

      it "doesn't place the ship on board" do
        expect(first_cell_for_second_ship.value).to eq("-")
      end
    end

    context "when Ship goes out of bounds" do
      pending
    end
  end

  describe "#find_cell" do
    pending
  end

  describe "#get_cell_value" do
    pending
    context "when cell doesn't exist"
  end

  describe "#change_cell_value" do
    
  end
end
