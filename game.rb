class Game
  BOARD_SIZE_X = 5
  BOARD_SIZE_Y = 5

  def initialize
    @board = build_board!
    @board = fill_in_mines!
    @board = fill_in_numbers!

    @user_board = build_board!
  end

  def play
    puts welcome_message

    loop do
      if ENV['DEBUG'] || ENV['CHEATS']
        print_board
        puts "\n"
      end

      print_user_board

      if is_won?
        puts winner_message
        return
      end

      input = gets.chomp
      # TODO handle valid input
      coord_x, coord_y = input.split(',').map(&:to_i)

      if @board[coord_x][coord_y] == :m
        puts loser_message
        print_board
        return
      end

      fill_in_user_board!(coord_x, coord_y)
    end
  end

  def fill_in_user_board!(coord_x, coord_y)
    return if @user_board[coord_x][coord_y] == 1

    @user_board[coord_x][coord_y] = 1

    return if @board[coord_x][coord_y] != 0

    vectors = [
              [0, -1],
      [-1, 0],        [1, 0],
              [0, 1],
    ]

    vectors.each do |a, b|
      x_location = coord_x + a
      y_location = coord_y + b

      next if x_location < 0 || x_location >= BOARD_SIZE_X
      next if y_location < 0 || y_location >= BOARD_SIZE_Y

      fill_in_user_board!(x_location, y_location)
    end
  end

  def build_board!
    Array.new(BOARD_SIZE_X) { Array.new(BOARD_SIZE_Y) { 0 } }
  end

  def fill_in_mines!
    @board.map do |row|
      row.map { |_el| random_mine? ? :m : 0 }
    end
  end

  def fill_in_numbers!
    vectors = [
      [-1, -1], [0, -1], [1, -1],
      [-1, 0],           [1, 0],
      [-1, 1], [0, 1], [1, 1]
    ]

    @board.each_with_index do |row, i|
      row.each_with_index do |el, j|
        vectors.each do |a, b|
          row_location = i + a
          el_location = j + b

          next if row_location < 0 || row_location >= BOARD_SIZE_X
          next if el_location < 0 || el_location >= BOARD_SIZE_Y
          next if @board[row_location][el_location] == :m

          @board[row_location][el_location] += 1 if el == :m
        end
      end
    end
  end

  def print_board
    print_indices
    print_dashes
    @board.each_with_index do |row, i|
      puts index_buffer(i) + row.map { |el| el.to_s }.join(' | ')
      print_dashes
    end
  end

  def print_user_board
    print_indices
    print_dashes
    @user_board.each_with_index do |row, i|
      puts index_buffer(i) + row.map.with_index { |el, j| is_visible?(el) ? @board[i][j].to_s  : ' ' }.join(' | ')
      print_dashes
    end
  end

  def index_buffer(i)
    "#{i} | "
  end

  def is_visible?(el)
    el == 1
  end

  def print_indices
    i = -1
    puts "    " + Array.new(BOARD_SIZE_X) { i += 1 }.join(' | ')
  end

  def print_dashes
    puts "    " + Array.new(BOARD_SIZE_X) { '-' }.join('   ')
  end

  # TODO
  # private

  def random_mine?
    rand(7) == 0
  end

  def welcome_message
    <<-WELCOME
MINESWEEPER! Enter in the coordinate, eg. `0,1`. Good luck!
    WELCOME
  end

  def is_won?
    @user_board.each.with_index do |row, i|
      row.each.with_index do |el, j|
        is_mine = @board[i][j] == :m
        is_visible = is_visible?(el)

        return false if !is_visible && !is_mine
      end
    end

    true
  end

  def winner_message
    <<-WINNER
YOU WIN!
    WINNER
  end

  def loser_message
    <<-LOSER
YOU LOSE!
    LOSER
  end
end


# board
# user_board
# play
# improve print
# improve lost print

# TODO:
# handle private
# clean up variables / edge cases around fill_in_user_board and fill_in_mines
# handle validating user input