require_relative "tile"
require 'byebug'

class Board

  attr_reader :grid

  def initialize(grid = Array.new(9) { Array.new(9) } )
    @grid = grid
    populate
  end

  def populate
    (rand(20) + 10).times do
      # byebug
      pos = [rand(@grid.length),rand(@grid.length)]
      until self[pos].nil?
        pos = [rand(@grid.length),rand(@grid.length)]
      end
      self[pos] = Tile.new(:B)
    end

    @grid.each_with_index do |row, i|
      row.each_index do |j|
        # byebug
        pos = [i,j]
        next if self[pos] == :B
        self[pos] = Tile.new(count_bombs(pos))
      end
    end

  end

  def count_bombs(pos)
    count = 0
    (-1..1).each do |i|
      (-1..1).each do |j|
        x = pos.first
        y = pos.last
        check_pos = [x + i, y + j]
        next unless valid_pos?(check_pos)
        count += 1 if self[check_pos] == :B
      end
    end
    count
  end

  def valid_pos?(pos)
    x, y = pos
    (0...@grid.length).cover?(x) && (0...@grid.length).cover?(y)
  end

  def render
    puts "  #{(0..8).to_a.join(" ")}"
    @grid.each_with_index do |row, i|
      print "#{i} "
      row.each_index do |j|
        pos = [i,j]
        print "_ " unless self[pos].revealed
        print "#{self[pos].val} " if self[pos].revealed
      end
      print "\n"
    end
  end

  def reveal(pos)
    find_non_bombs(pos).each do |ps|
      self[ps].reveal
    end
  end

  def find_non_bombs(pos)
    all_non_bombs =[pos]
    (-1..1).each do |i|
      (-1..1).each do |j|
        x = pos.first
        y = pos.last
        check_pos = [x + i, y + j]
        next if check_pos == pos || !valid_pos?(check_pos)
        all_non_bombs << check_pos
        if self[check_pos].val == 0
          all_non_bombs += find_non_bombs(check_pos)
        end
      end
    end
    all_non_bombs
  end

  def won?
    @grid.flatten.any? { |tile| tile.val != :B && !tile.revealed } ? false : true

  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, val)
    x, y = pos
    @grid[x][y] = val
  end
end



board = Board.new
puts "Initial Board"
board.render
puts " Won ? : #{board.won?}"
board.grid.each do |row|
  row.each do |tile|
    tile.reveal unless tile.val == :B
  end
end
puts "Final Board"
board.render
puts " Won ? : #{board.won?}"
