require "spec_helper"

RSpec.describe Player do
  let(:instance) { Player.new }

  it { is_expected.to respond_to :opponent_board, :player_board }

  describe "#list_available_ships" do
    subject { instance.list_available_ships }

    it "returns ship types player hasn't yet placed" do
      expect(subject).to eq("Destroyer, Submarine, Cruiser, Battleship, Aircraft_carrier")
    end
  end

  describe "#hit?" do
    before { instance.place_ship(input: "S, A5, left") }

    subject { instance.hit?(on: "A5") }

    it { is_expected.to be true }

    context "when it misses the ship" do
      subject { instance.hit?(on: "A4") }

      it { is_expected.to be false }
    end
  end
end
