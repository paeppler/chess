
require_relative 'colors'

class Board 
  def initialize
    @board = []
    # variables to help validate and make moves
    @move = ''
    @end_square = []
    @start_square = []
  end  

  def play_round
    loop do
      loop do
        @move = prompt_user_input_cyan
        if move_valid_cyan?(@move)
          make_move_cyan(@move)
          print_board
          break
        else
          puts 'wrong input. try again'
        end
      end
      
      loop do
        @move = prompt_user_input_red
        if move_valid_red?(@move)        
          make_move_red(@move)
          print_board
          break
        else
          puts 'wrong input. try again'
        end
      end
    end

  end

  def make_board 
    make_board_arr
    color_board
    set_pieces
    print_board
  end

  def make_board_arr
    @board = Array.new(64) { |i| [('a'.ord + i % 8).chr, 8 - (i/8), '   ',''] }
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


  def prompt_user_input_cyan
    puts 'Cyan, enter a move: '
    @move = gets.chomp
  end

  def prompt_user_input_red
    puts 'Red, enter a move: '
    @move = gets.chomp
  end


  def move_valid_cyan?(move) # return true or false, but also set @start_square and @end_square
    @start_square = find_start_square_cyan(move)
    @end_square = find_end_square_cyan(move)
    if @start_square == nil || @end_square == nil
      return false
    elsif pawn? && @end_square[2].include?('♟')
      return false
    elsif pawn? && @start_square[2].include?('36') 
      return true   
    elsif rook? && 
          (@start_square[0] == @end_square[0] || @start_square[1] == @end_square[1]) && 
          @start_square[2].include?('♜') &&
          @end_square[2].include?('   ') &&
          path_clear?
      puts 'rook move valid'
      return true
    else
      return false
    end
  end

  def move_valid_red?(move)
    @start_square = find_start_square_red(move)
    @end_square = find_end_square_red(move)
    if @start_square == nil || @end_square == nil
      return false
    elsif pawn? && @end_square[2].include?('♟')
      return false
    elsif pawn? && @start_square[2].include?('31') 
      return true

    else 
      return false
    end
  end

  # returns start square, regardless of validity of move. if input is invalid(off board or wrong notation), returns nil
  def find_start_square_cyan(move)
    if pawn?
      end_index = @board.find_index { |square| square[0] == move[0] && square[1] == move[1].to_i } # end_index = sq to which move goes
      @end_square = @board[end_index]
      input_square = @board[end_index]
      one_below = @board[end_index + 8]
      two_below = @board[end_index + 16]

      if one_below[2].include?('♟') && one_below[2].include?('36')# one square below input square
        return one_below
      elsif two_below[2].include?('♟') && two_below[2].include?('36') && two_below[1] == 2 && one_below[2].include?('   ') # two squares below input square
        return two_below
      else 
        return nil
      end
    elsif move.length == 3
      if rook?
        @board.each do |square|
          if square[2].include?('♜') && square[2].include?('36') && (square[0] == move[1] || square[1] == move[2].to_i)
            return square
          end
        end
      end

      # end_index =  @board.find_index { |square| square[0] == move[1] && square[1] == move[2].to_i }
    else
      return 'tbd'
    end
  end
  
  def find_start_square_red(move)
    if pawn?
      end_index = @board.find_index { |square| square[0] == move[0] && square[1] == move[1].to_i }
      @end_square = @board[end_index]
      input_square = @board[end_index]
      one_above = @board[end_index - 8]
      two_above = @board[end_index - 16]
      
      if one_above[2].include?('♟') && one_above[2].include?('31')  # one square above input square
        return one_above
      elsif two_above[2].include?('♟') && two_above[2].include?('31') && two_above[1] == 7 && one_above[2].include?('   ') # two squares above input square
        return two_above
      else 
        return nil
      end
    # elsif rook?
    # end
    else
      return 'tbd'
    end
  end

  
  def find_end_square_cyan(move)  # returns end square, regardless of validity of move. if input is invalid(off board or wrong notation), returns nil
    if pawn?
      # col = move[0].ord - 97
      # row = 9 - move[1].to_i - 1
      # return @board[row * 8 + col]#[2]
      return @end_square
    elsif move.length == 3
      end_index =  @board.find_index { |square| square[0] == move[1] && square[1] == move[2].to_i }
      return @board[end_index]
    end
  end
  
  def find_end_square_red(move)
    if pawn?
      # col = move[0].ord - 97
      # row = 9 - move[1].to_i - 1
      # return @board[row * 8 + col]#[2]
      return @end_square
    elsif move.length == 3
      end_index =  @board.find_index { |square| square[0] == move[1] && square[1] == move[2].to_i }
      return end_index
    end
  end

  
  def make_move_cyan(move)
    if pawn? # @start_square
      @start_square[2] = '   '
      @end_square[2] = ' ♟ '.cyan
    else
      print 'wrong input'
    end
    puts
  end   
  
  def make_move_red(move)
    if @start_square
      @start_square[2] = '   '
      @end_square[2] = ' ♟ '.red
    else
      print 'wrong input'
    end
  end

  def path_clear?
    if rook?
      if @start_square[0] == @end_square[0] # same column
        if @start_square[1] > @end_square[1] # move goes down
         p @board.select { |square| square[0] == @end_square[0] && square[1] < @start_square[1] && square[1] > @end_square[1]}.all? { |element| element[2].include?('   ') }
        elsif @start_square[1] < @end_square[1] # move goes up
         p @board.select { |square| square[0] == @end_square[0] && square[1] > @start_square[1] && square[1] < @end_square[1]}.all? { |element| element[2].include?('   ') }
         puts 'lulul'
        end      
      end
    end
  end


  # take? eigene methode.

  def pawn?
    @move.length == 2 ||  @start_square[2].include?('♟')
  end

  def rook?
    @move[0] == 'R'
  end


end


# elsif move.length == 3
#   col = move[1].ord - 97
#   row = move[2].to_i - 1
#   puts col, row
#   @board[row * 8 + col][2] = ' ♟ '.cyan



# old way to find start square:

      # col = move[0].ord - 97
      # row = 9 - move[1].to_i - 1
      # input_square = @board[row * 8 + col]
      # one_above = @board[(row * 8 + col) - 8]
      # two_above = @board[(row * 8 + col) - 16]