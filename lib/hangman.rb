require_relative 'human_player'
require_relative 'computer_player'

class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(players, mistakes)
    @guesser = players[:guesser]
    @referee = players[:referee]
    @guess_no = 0
    @mistakes = mistakes
    @answer = ''
  end

  def setup
    @answer = @referee.pick_secret_word
    @guesser.register_secret_length(@answer.length)
  end

  def take_turn
    display
    @guess_no += 1
    guess = @guesser.guess
    correct_guess?(guess)
    if guess.length == 1 && ('a'..'z').include?(guess)
      correct_indices = @referee.check_guess(@answer, guess)
      update_board(correct_indices, guess)
      @guesser.handle_response(guess, correct_indices)
    else
      if guess == @answer
        @guesser.board = @answer.chars
        @guess_no -= 1
        puts "#{@guesser.name} guessed the word!!!"
      end
    end
  end

  def update_board(correct_indices, letter_guess)
    correct_indices.each { |idx| @guesser.board[idx] = letter_guess }
  end

  def correct_guess?(guess)
    if @answer.include?(guess)
      @guess_no -= 1
      puts 'Correct guess!'
    else
      puts 'Incorrect guess.'
    end
  end

  def over?
    return true if @guesser.board.none? { |ch| ch == '_'}
    return true if @guess_no > @mistakes
    false
  end

  def conclude
    if @guesser.board.none? { |ch| ch == '_'}
      puts "#{@guesser.name} guessed #{@answer} with #{@guess_no} mistakes!"
      puts "#{@guesser.name} wins!"
    else
      puts "You have 0 mistake(s) left."
      puts "Sorry, the answer was #{@answer}. #{@referee.name} wins."
    end
  end

  def display
    puts "Board: #{@guesser.board.join('  ')}"
    puts "You have #{@mistakes - @guess_no + 1} mistake(s) left."
    puts "Guessed Letters: #{@guesser.guessed_letters.sort.join('  ')}\n\n"
  end

  def play
    setup
    until over?
      take_turn
    end
    conclude
  end

  if __FILE__ == $PROGRAM_NAME
    print 'Player one name?: '
    p1 = HumanPlayer.new(gets.chomp)
    p2 = ComputerPlayer.new('King of Hangman')
    print 'Would you like to guess or referee? g / r : '
    if gets.chomp == 'g'
      players = {
        guesser: p1,
        referee: p2
      }
    else
      players = {
        guesser: p2,
        referee: p1
      }
    end
    print 'How many mistakes? Recommended 10 : '
    mistakes = gets.chomp.to_i
    Hangman.new(players, mistakes).play
  end

end
