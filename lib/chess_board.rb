
require_relative 'colors'

class Board 
  def initialize
    @board = []
  end  

  # @board[0][0] = 'A'  
  # @board[0][1] = 1
  # @board[0][2] = '♜' ♜♞♝♜♛♚♝♞♜ ♟️♟️♟️♟️♟️♟️♟️♟️
  # @board[0][3] = ' ' background color - bg_black or bg_white

  def play_game
    make_board
    loop do
      play_round
    end
  end

  def play_round
    print_board
    prompt_user_input
  end

  def make_board 
    make_board_arr
    color_board
    set_pieces
    print_board
  end

  def make_board_arr
    @board = Array.new(64) { |i| [('A'.ord + i % 8).chr, 8 - (i/8), '   ',''] }
    # @board = Array.new(64) { |i| [('A'.ord + i / 8).chr, 8 - (i % 8), '   ',''] }
  end

  def color_board
    @board.each_with_index do |cell, i|
      row, col = i.divmod(8)
  
      if (row + col).odd?
        cell[3] = 'bg_black'
      else
        cell[3] = 'bg_white'
      end
    end
  end

  def set_pieces
    @board.each_slice(8) do |row|
      if row[0][1] == 8
        row[0][2] = row[7][2] = ' ♜ '.red
        row[1][2] = row[6][2] = ' ♞ '.red
        row[2][2] = row[5][2] = ' ♝ '.red
        row[3][2] = ' ♛ '.red
        row[4][2] = ' ♚ '.red

      elsif row[0][1] == 7
        (1..8).each { |i| row[i-1][2] = ' ♟ '.red }

      elsif row[0][1] == 1
        row[0][2] = row[7][2] = ' ♜ '.cyan
        row[1][2] = row[6][2] = ' ♞ '.cyan
        row[2][2] = row[5][2] = ' ♝ '.cyan
        row[3][2] = ' ♛ '.cyan
        row[4][2] = ' ♚ '.cyan

      elsif row[0][1] == 2
        (1..8).each { |i| row[i-1][2] = ' ♟ '.cyan }
      end
    end
  end

  def print_board
    puts "\e[2J"
    row_count = 8
    @board.each_slice(8) do |row|
      print '                   ' + row_count.to_s + ' '
      row.each do |element| 
        color = element[3]
        element[2] = element[2].send(color)
        print "#{element[2]}" 
      end
      row_count -= 1
      puts
    end
    print '                      a  b  c  d  e  f  g  h'
    10.times do puts end
  end

  def prompt_user_input
    puts 'Enter a move: '
    move = gets.chomp
    make_move(move)
  end

  def make_move(move)
    #d4
    puts
    set_pieces
    @board[51][2] = '   '
    @board[35][2] = ' ♟ '.cyan
    print_board
  end
    
end

board1 = Board.new
board1.play_game