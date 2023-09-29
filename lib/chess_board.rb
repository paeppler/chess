
require_relative 'colors'

class Board 
  def initialize
    @board = []
  end  

  # @board[0][0] = 'A'  
  # @board[0][1] = 8
  # @board[0][2] = '♜' ♜♞♝♜♛♚♝♞♜ ♟️♟️♟️♟️♟️♟️♟️♟️
  # @board[0][3] = ' ' background color - bg_black or bg_white

  # def play_game
  #   make_board
  #   loop do
  #     play_round
  #   end
  # end

  def play_round
    loop do
      move = prompt_user_input_cyan
      make_move_cyan(move)
      print_board
      move = prompt_user_input_red
      make_move_red(move)
      print_board
    end
  end

  def make_board 
    make_board_arr
    color_board
    set_pieces
    print_board
  end

  def make_board_arr
    @board = Array.new(64) { |i| [('A'.ord + i % 8).chr, 8 - (i/8), '   ',''] }
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
    # puts @board[0][0], @board[0][1], @board[0][2], @board[0][3]
    # puts @board[0]
  end

  def prompt_user_input_cyan
    puts 'Cyan, enter a move: '
    move = gets.chomp
  end

  def prompt_user_input_red
    puts 'Red, enter a move: '
    move = gets.chomp
  end

  def make_move_cyan(move)
    print start_square = find_start_square_cyan(move)
    puts
    print end_square = find_end_square_cyan(move)
    puts
    print start_square[2]
    if start_square
      start_square[2] = '   '
      end_square[2] = ' ♟ '.cyan
    else
      print 'wrong input'
    end

    puts
  end   

  def make_move_red(move)
    print start_square = find_start_square_red(move)
    print end_square = find_end_square_red(move)
    if start_square
      start_square[2] = '   '
      end_square[2] = ' ♟ '.red
    else
      print 'wrong input'
    end

    puts
  end   
  
  def find_start_square_cyan(move)
    if move.length == 2
      col = move[0].ord - 97
      row = 9 - move[1].to_i - 1
      # input_square = @board[row * 8 + col]
      one_below = @board[(row * 8 + col) + 8]
      two_below = @board[(row * 8 + col) + 16]
      if one_below[2].include?('♟') && one_below[2].include?('36')# one square below input square
        puts 'pawn'
        return one_below
      elsif two_below[2].include?('♟') && two_below[2].include?('36') # two squares below input square
        puts 'pawn2'
        return two_below
      else 
        puts 'wrong input'
        return nil
      end
      #@board[row * 8 + col][2] = ' ♟ '.cyan
    end
  end

  def find_end_square_cyan(move)
    if move.length == 2
      col = move[0].ord - 97
      row = 9 - move[1].to_i - 1
      return @board[row * 8 + col]#[2]
    end
  end

  def find_start_square_red(move)
    if move.length == 2
      col = move[0].ord - 97
      row = 9 - move[1].to_i - 1
      # input_square = @board[row * 8 + col]
      one_above = @board[(row * 8 + col) - 8]
      two_above = @board[(row * 8 + col) - 16]
      if one_above[2].include?('♟') # one square above input square
        puts 'pawn'
        return one_above
      elsif two_above[2].include?('♟') # two squares above input square
        puts 'pawn2'
        return two_above
      end
      #@board[row * 8 + col][2] = ' ♟ '.cyan
    end
  end

  def find_end_square_red(move)
    if move.length == 2
      col = move[0].ord - 97
      row = 9 - move[1].to_i - 1
      return @board[row * 8 + col]#[2]
    end
  end

end


# elsif move.length == 3
#   col = move[1].ord - 97
#   row = move[2].to_i - 1
#   puts col, row
#   @board[row * 8 + col][2] = ' ♟ '.cyan