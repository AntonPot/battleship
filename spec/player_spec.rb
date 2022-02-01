require "spec_helper"

RSpec.describe Player do
  let!(:player_instance) { Player.new }

  it { is_expected.to respond_to :opponent_board, :player_board }

  describe "#list_available_ships" do
    subject { player_instance.list_available_ships }

    it "returns ship types player hasn't yet placed" do
      expect(subject).to eq("Destroyer, Submarine, Cruiser, Battleship, Aircraft_carrier")
    end
  end

  describe "#display_boards" do
    subject { player_instance.display_boards }

    it "calls #display on both player boards" do
      expect(player_instance.opponent_board).to receive(:display)
      expect(player_instance.player_board).to receive(:display)
      subject
    end
  end

  describe "#place_ship" do
    # subject { player_instance }

    it "places a ship to players board"
  end
  # describe "#hit?" do
  #   before { player_instance.place_ship(input: "S, A5, left") }

  #   subject { player_instance.hit?(on: "A5") }

  #   it { is_expected.to be true }

  #   context "when it misses the ship" do
  #     subject { player_instance.hit?(on: "A4") }

  #     it { is_expected.to be false }
  #   end
  # end
end
