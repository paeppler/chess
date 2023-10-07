
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
        if move_valid_cyan?
          make_move_cyan
          print_board
          break
        else
          puts 'invalid input. try again'
        end
      end
      
      loop do
        @move = prompt_user_input_red
        if move_valid_red?       
          make_move_red
          print_board
          break
        else
          puts 'invalid input. try again'
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


  def move_valid_cyan? # return true or false, but also set @start_square and @end_square
    @start_square = find_start_square_cyan(@move)
    p @start_square
    if @start_square == nil
      return false
    end
    p @end_square = find_end_square_cyan(@move)
    if @end_square == nil
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
      return true
    elsif knight?
      if @end_square[2].include?('   ') # alle anderen Bed. in find_start_square schon abgedeckt
        return true
      end
    elsif bishop?
      if @end_square[2].include?('   ') # alle anderen Bed. in find_start_square schon abgedeckt
        return true
      end
    else
      return false
    end
  end

  def move_valid_red?
    @start_square = find_start_square_red(@move)
    if @start_square == nil
      return false
    end
    @end_square = find_end_square_red(@move)
    if @end_square == nil
      return false
    elsif pawn? && @end_square[2].include?('♟')
      return false
    elsif pawn? && @start_square[2].include?('31') 
      return true
    elsif rook? && 
          (@start_square[0] == @end_square[0] || @start_square[1] == @end_square[1]) && 
          @start_square[2].include?('♜') &&
          @end_square[2].include?('   ') &&
          path_clear?
      puts 'rook move valid'
      return true
    elsif knight?
      if @end_square[2].include?('   ') # alle anderen Bed. in find_start_square schon abgedeckt
        return true
      end
    elsif bishop?
      if @end_square[2].include?('   ') # alle anderen Bed. in find_start_square schon abgedeckt
        return true
      end
    else 
      return false
    end
  end

  # returns start square, regardless of validity of move. if input is off board or wrong notation, returns nil
  def find_start_square_cyan(move)
    if move.length == 2
      end_index = @board.find_index { |square| square[0] == move[0] && square[1] == move[1].to_i } # end_index = sq to which move goes
      return nil if end_index == nil
      
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
      elsif knight?
        target_square = nil
        @board.each do |square|
          if square[2].include?('♞') && 
            square[2].include?('36') &&
            ((square[0].ord + 1 == move[1].ord && square[1] + 2 == move[2].to_i) || # oben rechts(1)
            (square[0].ord + 2 == move[1].ord && square[1] + 1 == move[2].to_i) || # oben rechts(2)
            (square[0].ord + 2 == move[1].ord && square[1] - 1 == move[2].to_i) || # unten rechts(3)
            (square[0].ord + 1 == move[1].ord && square[1] - 2 == move[2].to_i) || # unten rechts(4)
            (square[0].ord - 1 == move[1].ord && square[1] - 2 == move[2].to_i) || # unten links(5)
            (square[0].ord - 2 == move[1].ord && square[1] - 1 == move[2].to_i) || # unten links(6)
            (square[0].ord - 2 == move[1].ord && square[1] + 1 == move[2].to_i) || # oben links(7)
            (square[0].ord - 1 == move[1].ord && square[1] + 2 == move[2].to_i))    # oben links(8)
            puts 'execute'
            target_square = square          
          end
        end
        target_square
      elsif bishop?
        target_square = nil
        @board.each do |square|
          if square[2].include?('♝') &&
              square[2].include?('36')  &&
              ((1..7).any? do |i|
                square[0].ord == move[1].ord + i && square[1] == move[2].to_i + i || # nach oben rechts
                square[0].ord == move[1].ord + i && square[1] == move[2].to_i - i || # nach unten rechts
                square[0].ord == move[1].ord - i && square[1] == move[2].to_i + i || # nach unten links
                square[0].ord == move[1].ord - i && square[1] == move[2].to_i - i  # nach oben links 
              end)  
              print 'if bishop is true'          
            target_square = square
          end
        end
        target_square       
      end
    else
      return 'tbd'
    end
  end

  
  
  def find_start_square_red(move)
    if move.length == 2
      end_index = @board.find_index { |square| square[0] == move[0] && square[1] == move[1].to_i }
      return nil if end_index == nil
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
    elsif move.length == 3
      if rook?
        @board.each do |square|
          if square[2].include?('♜') && square[2].include?('31') && (square[0] == move[1] || square[1] == move[2].to_i)
            return square
          end
        end
      elsif knight?
        target_square = nil
        @board.each do |square|
          if square[2].include?('♞') && 
            square[2].include?('31') &&
            ((square[0].ord + 1 == move[1].ord && square[1] + 2 == move[2].to_i) || # oben rechts(1)
            (square[0].ord + 2 == move[1].ord && square[1] + 1 == move[2].to_i) || # oben rechts(2)
            (square[0].ord + 2 == move[1].ord && square[1] - 1 == move[2].to_i) || # unten rechts(3)
            (square[0].ord + 1 == move[1].ord && square[1] - 2 == move[2].to_i) || # unten rechts(4)
            (square[0].ord - 1 == move[1].ord && square[1] - 2 == move[2].to_i) || # unten links(5)
            (square[0].ord - 2 == move[1].ord && square[1] - 1 == move[2].to_i) || # unten links(6)
            (square[0].ord - 2 == move[1].ord && square[1] + 1 == move[2].to_i) || # oben links(7)
            (square[0].ord - 1 == move[1].ord && square[1] + 2 == move[2].to_i))    # oben links(8)
            target_square = square
          end
        end
        target_square
      elsif bishop?
        target_square = nil
        @board.each do |square|
          if square[2].include?('♝') &&
              square[2].include?('31')  &&
              ((1..7).any? do |i|
                square[0].ord == move[1].ord + i && square[1] == move[2].to_i + i || # nach oben rechts
                square[0].ord == move[1].ord + i && square[1] == move[2].to_i - i || # nach unten rechts
                square[0].ord == move[1].ord - i && square[1] == move[2].to_i + i || # nach unten links
                square[0].ord == move[1].ord - i && square[1] == move[2].to_i - i  # nach oben links 
              end)  
              print 'if bishop is true'          
            target_square = square
          end
        end
        target_square       
      end
    else
      return 'tbd'
    end
  end

  
  def find_end_square_cyan(move)  # returns end square, regardless of validity of move. if input is invalid(off board or wrong notation), returns nil
    if pawn?
      if @end_square != nil
        if @end_square[2].include?('   ')
          return @end_square
        else 
          return nil
        end
      end
      return end_square
    elsif move.length == 3
      end_index =  @board.find_index { |square| square[0] == move[1] && square[1] == move[2].to_i }
      return @board[end_index]
    end
  end
  
  def find_end_square_red(move)
    if pawn?
      if @end_square != nil
        if @end_square[2].include?('   ')
          return @end_square
        else 
          return nil
        end
      end
      return @end_square
    elsif move.length == 3
      end_index =  @board.find_index { |square| square[0] == move[1] && square[1] == move[2].to_i }
      return @board[end_index]
    end
  end

  
  def make_move_cyan
    @start_square[2] = '   '
    if pawn?
      @end_square[2] = ' ♟ '.cyan
    elsif rook?
      @end_square[2] = ' ♜ '.cyan
    elsif knight?
      @end_square[2] = ' ♞ '.cyan
    elsif bishop?
      @end_square[2] = ' ♝ '.cyan
    else
      print 'wrong input'
    end
    puts
  end   
  
  def make_move_red
    @start_square[2] = '   '
    if pawn?
      @end_square[2] = ' ♟ '.red
    elsif rook?
      @end_square[2] = ' ♜ '.red
    elsif knight?
      @end_square[2] = ' ♞ '.red
    elsif bishop?
      @end_square[2] = ' ♝ '.red
    else
      print 'wrong input'
    end
  end

  def path_clear?
    if rook?
      if @start_square[0] == @end_square[0] # check if same column
        if @start_square[1] > @end_square[1] && # move goes down
           @board.select { |square| square[0] == @end_square[0] && square[1] < @start_square[1] && square[1] > @end_square[1]}.all? { |element| element[2].include?('   ') }
          return true
        elsif @start_square[1] < @end_square[1] && # move goes up
              @board.select { |square| square[0] == @end_square[0] && square[1] > @start_square[1] && square[1] < @end_square[1]}.all? { |element| element[2].include?('   ') }
          puts 'lulul'
          return true
        end
      elsif @start_square[1] == @end_square[1] && # check if same row
        if @start_square[0].ord < @end_square[0].ord && # move goes right
           @board.select { |square| square[1] == @end_square[1] && square[0].ord > @start_square[0].ord && square[0].ord < @end_square[0].ord}.all? { |element| element[2].include?('   ') }
          return true
        elsif @start_square[0].ord > @end_square[0].ord &&
              @board.select { |square| square[1] == @end_square[1] && square[0].ord < @start_square[0].ord && square[0].ord > @end_square[0].ord}.all? { |element| element[2].include?('   ') }
          return true
        end      
      end
    end

    # if bishop?

  end


  # take? eigene methode.

  def pawn?
    return nil if @start_square.nil? # aenderung von: @start_square[2] (mög. break)

    @move.length == 2 ||  @start_square[2].include?('♟') # [2]
  end

  def rook?
    @move[0] == 'R'
  end

  def knight?
    @move[0] == 'N'
  end

  def bishop?
    @move[0] == 'B'
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