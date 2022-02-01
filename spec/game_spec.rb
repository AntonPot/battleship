require "spec_helper"

RSpec.describe Game do
  let!(:game_instance) { Game.new }
  let(:player1) { spy(Player, list_available_ships: [], alive?: false) }
  let(:player2) { spy(Player, alive?: false) }

  describe "#run" do
    subject { game_instance.run }

    let(:output_messages) do
      [
        "\nPlace your all your ships:",
        "\nExample: 'D, B4, down' for Destroyer to be placed on B4 and C4",
        "\nSuccessful placement",
        "GAME OVER!",
        "You lost :("
      ]
    end

    before do
      output_messages.each do |message|
        allow($stdout).to receive(:puts).with(message)
      end
      allow(game_instance).to receive(:player1).and_return(player1)
      allow(game_instance).to receive(:player2).and_return(player2)
      subject
    end

    it "outputs all expected messages" do
      output_messages.each do |message|
        expect($stdout).to have_received(:puts).with(message)
      end
    end

    it { expect(player1).to have_received(:display_boards).twice }
    it { expect(player2).to have_received(:player_board) }
  end

  describe "#deploy_a_ship" do
    subject { game_instance.send(:deploy_a_ship) }

    before do
      allow($stdout).to receive(:puts).with("\nAvailable ships:")
      allow($stdout).to receive(:puts).with([])
      allow(game_instance).to receive_message_chain(:gets, :chomp)
      allow(game_instance).to receive(:player1).and_return(player1)
      allow(game_instance).to receive(:player2).and_return(player2)

      subject
    end

    it { expect($stdout).to have_received(:puts).with("\nAvailable ships:") }
    it { expect(player1).to have_received(:display_boards) }
    it { expect(player1).to have_received(:list_available_ships) }
  end

  describe "#turn" do
    subject { game_instance.send(:turn) }

    before do
      allow($stdout).to receive(:puts).with("\nFire upon opponent's ships (e.g. A5)\n")
      allow(game_instance).to receive_message_chain(:gets, :chomp)
      allow(game_instance).to receive(:player1).and_return(player1)
      allow(game_instance).to receive(:player2).and_return(player2)

      subject
    end

    it { expect($stdout).to have_received(:puts).with("\nFire upon opponent's ships (e.g. A5)\n") }
    it { expect(player1).to have_received(:display_boards) }
    it { expect(player1).to have_received(:fire) }
    it { expect(player2).to have_received(:fire) }
    it { expect(player1).to have_received(:log) }
    it { expect(player2).to have_received(:log) }
  end
end
