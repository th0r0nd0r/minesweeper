require_relative "board"

class Game

  attr_reader :board

  def initialize(board = Board.new)
    @board = board
  end

  def select_tile
    puts "Pick a tile: "
    selection = parse_coord(gets.chomp)
  end

  def parse_coord(string)
    pos = string.split(',')
    pos.map(&:to_i)
  end

  def play_turn
    @board.reveal(select_tile)
    if @board[select_tile].val == :B
      puts "GAME OVER , You're a loser"
    else
      @board.reveal(select_tile)
      @board.render
    end
  end


end
