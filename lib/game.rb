require "./lib/player.rb"

class Game
  def initialize
    @player1 = Player.new
    @player2 = Player.new
  end

  def run
    player1.display_boards
    puts "\nPlace your all your ships:"
    puts "\nExample: 'D, B4, down' for Destroyer to be placed on B4 and C4"

    deploy_a_ship until player1.list_available_ships.empty?

    puts "\nSuccessful placement"
    player2.player_board.automatic_ship_placement

    # Uncomment to view opponents board
    # player2.display_boards
    player1.display_boards

    turn while player1.alive? && player2.alive?

    puts "GAME OVER!"
    puts player1.alive? ? "YOU WON! :)" : "You lost :("
  end

  private

  attr_reader :player1, :player2

  def deploy_a_ship
    puts "\nAvailable ships:"
    puts player1.list_available_ships

    input = gets.chomp

    return player1.player_board.automatic_ship_placement if input == "auto"

    player1.put_ship_on_the_board(input: input)
    player1.display_boards
  rescue InputError => e
    puts e.message
  end

  def turn
    puts "\nFire upon opponent's ships (e.g. A5)\n"
    input = gets.chomp

    is_hit = player2.fire(on: input)
    player1.log(on: input, is_hit: is_hit)

    counter_attack = Board.random_location
    is_hit = player1.fire(on: counter_attack)
    player2.log(on: counter_attack, is_hit: is_hit)

    player1.display_boards
  rescue InputError => e
    puts e.message
  end
end

InputError = Class.new(StandardError)
