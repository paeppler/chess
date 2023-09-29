require_relative 'chess_board'

class Game 
  def initialize(board = Board.new)
    @board = board
  end

  def play_game
    @board.make_board
    loop do
      @board.play_round
    end
  end

end


  game1 = Game.new
  game1.play_game