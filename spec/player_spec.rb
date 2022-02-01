require "spec_helper"

RSpec.describe Player do
  let!(:player_instance) { Player.new }

  it { is_expected.to respond_to :log_board, :player_board }

  describe "#list_available_ships" do
    subject { player_instance.list_available_ships }

    it "returns ship types player hasn't yet placed" do
      expect(subject).to eq("Destroyer, Submarine, Cruiser, Battleship, Aircraft_carrier")
    end
  end

  describe "#display_boards" do
    subject { player_instance.display_boards }

    it "calls #display on both player boards" do
      expect(player_instance.log_board).to receive(:display)
      expect(player_instance.player_board).to receive(:display)
      subject
    end
  end

  describe "#put_ship_on_the_board" do
    subject { player_instance.put_ship_on_the_board(input: "s, f3, down") }

    it "parses input and calls #place_ship on player_board" do
      allow(player_instance.player_board).to receive(:place_ship)
      subject
      expect(player_instance.player_board).to have_received(:place_ship)
                                          .with(ship_initial: "S", row: "3", column: "F", direction: :down)
    end

    context "when input can't be correctly parsed" do
      subject { player_instance.put_ship_on_the_board(input: "foobar") }

      it "raises InputError" do
        expect { subject }.to raise_error(InputError, "Wrong input")
      end
    end
  end

  describe "#log" do
    subject { player_instance.log(on: "B3", is_hit: hit) }

    let(:hit) { true }

    it "parses input and sends #hit to log_board" do
      expect(player_instance.log_board).to receive(:hit).with(row: "3", column: "B")
      subject
    end

    context "when it's a miss" do
      let(:hit) { false }

      it "parses input and sends #miss to log_board" do
        expect(player_instance.log_board).to receive(:miss).with(row: "3", column: "B")
        subject
      end
    end
  end

  describe "#fire" do
    subject { player_instance.fire(on: "B10") }

    it "parses input and sends #fire to player_board" do
      expect(player_instance.player_board).to receive(:hit?).with(row: "10", column: "B")
      subject
    end
  end

  describe "#alive?" do
    subject { player_instance.alive? }

    before { allow(player_instance.player_board).to receive(:all_ships_sunk?).and_return(false) }

    it { is_expected.to be true }

    context "when all ships are lost" do
      before { allow(player_instance.player_board).to receive(:all_ships_sunk?).and_return(true) }

      it { is_expected.to be false }
    end
  end
end
