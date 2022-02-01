require "spec_helper"

RSpec.describe Board do
  let!(:board_instance) { Board.new }

  it { is_expected.to respond_to :matrix, :sunk_ships, :placed_ships, :sunk_ships }

  describe "#matrix" do
    subject { board_instance.matrix }

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

  describe "#find_cell" do
    subject { board_instance.find_cell(row: "3", column: "B") }

    it "returns expected Cell" do
      expect(subject).to be board_instance.matrix[3][2]
    end

    context "when `column` is invalid" do
      subject { board_instance.find_cell(row: "3", column: "Y") }

      it { expect { subject }.to raise_error(InputError, "No such location") }
    end

    context "when `row` is invalid" do
      subject { board_instance.find_cell(row: "11", column: "Y") }

      it { expect { subject }.to raise_error(InputError, "No such location") }
    end
  end

  describe "#place_ship" do
    let(:ship) { Ship.new(:cruiser) }

    subject { board_instance.place_ship(ship_initial: "C", row: "2", column: "A", direction: :down) }

    it "adds a Ship to the Board" do
      expect { subject }.to(change { board_instance.placed_ships.count }.by(1))
    end

    it "places correct Ship on the Board" do
      subject
      # binding.pry
      last_ship_cell = board_instance.find_cell(row: "4", column: "A")
      next_cell = board_instance.find_cell(row: "5", column: "A")

      expect(last_ship_cell.value).to eq("C")
      expect(next_cell.value).to eq("-")
    end

    context "when Ship collides another Ship" do
      let(:first_cell_for_second_ship) { board_instance.find_cell(row: "2", column: "A") }

      before do
        board_instance.place_ship(ship_initial: "B", row: "3", column: "A", direction: :left)
      end

      it { is_expected.to be_nil }
      it { expect { subject }.not_to(change { board_instance.placed_ships.count }) }
    end

    context "when Ship goes out of bounds" do
      subject { board_instance.place_ship(ship_initial: "C", row: "2", column: "J", direction: :left) }

      it { is_expected.to be_nil }
      it { expect { subject }.not_to(change { board_instance.placed_ships.count }) }
    end

    context "when `ship_initial` is wrong" do
      subject { board_instance.place_ship(ship_initial: "X", row: "2", column: "J", direction: :left) }

      it { expect { subject }.to raise_error(InputError, "No such ship") }
    end

    context "when `direction` is wrong" do
      subject { board_instance.place_ship(ship_initial: "A", row: "2", column: "J", direction: :foobar) }

      it { expect { subject }.to raise_error(InputError, "Illegal direction") }
    end
  end

  describe "#fire" do
    let!(:cell) { board_instance.find_cell(row: "2", column: "C") }

    subject { board_instance.fire(row: "2", column: "C") }

    it { expect { subject }.to change(cell, :value).from("-").to("O") }

    context "when Ship is hit" do
      let(:ship) { board_instance.placed_ships.first }

      before { board_instance.place_ship(ship_initial: "D", row: "2", column: "C", direction: :left) }

      it { expect { subject }.to change(cell, :value).from("D").to("X") }
      it { expect { subject }.to change(ship, :hit_count).from(0).to(1) }

      context "when Ship is sunk" do
        before { board_instance.fire(row: "2", column: "D") }

        it { expect { subject }.to(change { board_instance.placed_ships.count }.by(-1)) }
        it { expect { subject }.to(change { board_instance.sunk_ships.count }.by(1)) }
      end
    end
  end

  describe "#all_ships_sunk?" do
    subject { board_instance.all_ships_sunk? }

    it { is_expected.to be true }

    context "when ships are placed on board" do
      before { board_instance.place_ship(ship_initial: "A", row: "3", column: "D", direction: :down) }

      it { is_expected.to be false }
    end
  end

  describe "#hit" do
    let(:cell) { board_instance.find_cell(row: "2", column: "C") }

    subject { board_instance.hit(row: "2", column: "C") }

    it { expect { subject }.to change(cell, :value).from("-").to("X") }
  end

  describe "#splash" do
    let(:cell) { board_instance.find_cell(row: "2", column: "C") }

    subject { board_instance.splash(row: "2", column: "C") }

    it { expect { subject }.to change(cell, :value).from("-").to("O") }
  end
end
