require "./lib/player.rb"
require "./lib/board.rb"
require "pry-byebug"

class Game
  def initialize
    @player1 = Player.new
    @player2 = Player.new
  end

  def run
    ship_placement
    battle
  end

  private

  attr_reader :player1, :player2

  def ship_placement
    player1.display_boards
    puts "\nPlace your all your ships:"
    puts "\nExample: 'D, B4, down' for Destroyer to be placed on B4 and C4"

    place_ship until player1.list_available_ships.empty?

    puts "\nSuccessful placement"
    player2.automatic_ship_placement
  end

  def place_ship
    puts "\nAvailable ships:"
    puts player1.list_available_ships

    input = gets.chomp

    return player1.automatic_ship_placement if input == "auto"

    player1.place_ship(input: input)
    player1.display_boards
  rescue InputError => e
    puts e.message
  end

  def battle
    player2.display_boards # TODO: don't forget to remove
    player1.display_boards
    puts "\nFire upon opponent's battlefield (e.g. A5)\n"

    turn while player1.alive? && player2.alive?

    puts "GAME OVER!"
    puts player1.alive? ? "YOU WON! :)" : "You lost :("
  end

  def turn
    input = gets.chomp

    is_hit = player2.hit?(on: input)
    player1.log_hits(on: input, is_hit: is_hit)

    counter_attack = Board.random_cell
    is_hit = player1.hit?(on: counter_attack)
    player2.log_hits(on: counter_attack, is_hit: is_hit)

    player1.display_boards
  rescue InputError => e
    puts e.message
  end
end

InputError = Class.new(StandardError)

Game.new.run
