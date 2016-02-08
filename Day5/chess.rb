
class Piece
  attr_reader :pos_x, :pos_y, :name
  def initialize name, x, y
    @pos_x = x
    @pos_y = y
    @name = name
  end

  def is_white?
    @name.index("w") ? true : false
  end

  def is_black?
    @name.index("b") ? true : false
  end

end


class Pawn < Piece
  def initialize name, x, y
    super name, x, y
    is_white? ? @value = -1 : @value = 1
  end

  def get_all_positions

    positions = [ [@pos_x + @value , @pos_y] ]

    if initial_position?
      positions << [@pos_x + (@value * 2) , @pos_y]      
    end

    positions
  end


  def initial_position?
    condition = false
    if is_white? && @pos_x == 6
      condition = true
    elsif is_black? && @pos_x == 1
      condition = true
    end
    condition
  end

  def check_enemy(board)
    positions = []
    
    if board.get_piece [@pos_x + @value , @pos_y + @value]
      positions << [@pos_x + @value , @pos_y + @value]
    end

    if board.get_piece [@pos_x + @value , @pos_y - @value]
      positions << [@pos_x + @value , @pos_y - @value]
    end

  end
end



class Knigth < Piece
  def get_all_positions

    [[@pos_x - 2, @pos_y + 1], [@pos_x - 2, @pos_y - 1],
    [@pos_x - 1, @pos_y - 2], [@pos_x - 1, @pos_y - 2], 
    [@pos_x + 1,@pos_y + 2], [@pos_x + 1,@pos_y - 2], 
    [@pos_x + 2,@pos_y +1],[@pos_x + 2,@pos_y - 1]]

  end

end

module Diagonal

  def diagonal_positions(x, y)
    positions = []

    8.times do |i|
      8.times do |j|

        if ((x-j).abs == (y-i).abs) && (j != x && i != y)
          positions << [j,i]
        end

      end
    end
    positions
  end

end


class Bishop < Piece
  include Diagonal

  def get_all_positions
    diagonal_positions(@pos_x, @pos_y)
  end

end

module Vertical

  def vertical_positions(x, y)

    positions = []

    8.times do |i|
      if y != i 
        positions << [x,i]
      end
    end
    positions
  end

end


module Horizontal
 def horizontal_positions(x, y)

    positions = []

    8.times do |i|
      if x != i
        positions << [i,y]
      end
    end
    positions
  end

end

class Rook < Piece
  include Vertical
  include Horizontal

  def get_all_positions
    positions = vertical_positions(@pos_x, @pos_y)
    positions << horizontal_positions(@pos_x, @pos_y)
  end

end

class Queen < Piece
  include Vertical
  include Horizontal
  include Diagonal

  def get_all_positions
    positions = diagonal_positions(@pos_x, @pos_y)
    positions << vertical_positions(@pos_x, @pos_y)
    positions << horizontal_positions(@pos_x, @pos_y)
  end

end

class King < Piece
  def get_all_positions

    [[@pos_x-1, @pos_y], [@pos_x+1, @pos_y], [@pos_x, @pos_y-1], [@pos_x, @pos_y+1], [@pos_x-1, @pos_y-1], [@pos_x+1, @pos_y+1], [@pos_x+1, @pos_y-1], [@pos_x-1, @pos_y+1]]

  end

end



module ChessValidator
  @@rows = 8
  @@columns = 8

  @@piece_equivalence = {
    bR: Rook, wR: Rook, bN: Knigth, wN: Knigth, bB: Bishop, wB: Bishop,
    bQ: Queen, wQ: Queen, bP: Pawn, wP: Pawn, bK: King, wK: King
  }

  def correct_move(all_positions, final_position)
    condition = false

    all_positions.each do |position|
      if(position[0] == final_position[0] && position[1] == (final_position[1]))
        condition = true
      end
    end

    condition
  end

end


module FileManager 

  def read_file file
    file = File.open(file, "r")
    lines = file.readlines
    file.close
    lines
  end

  def convert_move move
      move = move.reverse.split("")
      move = [move[0].to_i - 1, move[1].ord - "a".ord]
  end

end


class Game
  include ChessValidator
  include FileManager

  def initialize board
    @board = board
    @moves = []
  end

  def load_moves file

    file_moves = read_file file

    moves = []

    file_moves.each { |move| moves << move.split(" ") }

    moves.each do |move|
      @moves << [convert_move(move[0]),convert_move(move[1])]
    end

  end

  def create_object piece, position
    @@piece_equivalence[piece.to_sym].new piece, position[0], position[1]
  end


  def start

    @moves.each do |move|

      origin_piece = @board.get_piece move[0] 
      final_piece = @board.get_piece move[1]

      if(origin_piece)
        if( !final_piece || different_color?(origin_piece, final_piece))

          piece = create_object origin_piece, move[0]
          all_positions = piece.get_all_positions

          if(piece.class == "Pawn")
            all_positions << piece.check_enemy(@board)
          end

          if(correct_move(all_positions, move[1]) )
            puts "LEGAL"
          else
            puts "ILLEGAL"
          end

        end

      else
        puts "ILLEGAL"
      end

    end

  end

  def different_color? (origin, final)
    final ? origin[0] == final[0] : false
  end

end


class Board
  include FileManager

  @@rows_id = ["0", "1", "2", "3", "4", "5", "6", "7"]
  @@columns_id = ["0", "1", "2", "3", "4", "5", "6", "7"]

  def initialize 
    @board = {}
  end

  def get_piece pos
    @board[pos.join.to_sym]
  end

  def load file

    pieces_by_line = read_file file

    pieces_by_line.each_with_index do |pieces, i|
      pieces.split(" ").each_with_index do |piece, j|
        symbol = (@@rows_id[i] + @@columns_id[j] ).to_sym

        if(piece != "--")
          @board[symbol] = piece
        end

      end
    end
  end

end


board = Board.new
board.load "simple_board.txt"
#board.load "complex_board.txt"
game = Game.new board
game.load_moves "simple_moves.txt"
#game.load_moves "complex_moves.txt"
game.start



