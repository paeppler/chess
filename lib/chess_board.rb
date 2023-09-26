

class Board 
  def initialize
    p '♔'
    p '⬜'
  end

  def print_board
    puts <<-HEREDOC

    ♜♞♝♜♛♚♝♞♜
    ♟️♟️♟️♟️♟️♟️♟️♟️
    ⬛⬜⬛⬜⬛⬜⬛⬜
    ⬜⬛⬜⬛⬜⬛⬜⬛
    ⬛⬜⬛⬜⬛⬜⬛⬜
    ⬜⬛⬜⬛⬜⬛⬜⬛
    ♙♙♙♙♙♙♙♙
    ♖♘♗♕♔♗♘♖

    HEREDOC
  end
end

Board.new.print_board