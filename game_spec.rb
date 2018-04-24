require './game.rb'

describe Game do
  let(:game) { Game.new }

  specify do
    game.print_board
    puts "--- break ---"
    game.print_user_board
  end

  # describe '`#is_won?`' do
  #   context 'when all non mines are visible' do
  #     it 'is won' do
  #
  #     end
  #   end
  # end
end
