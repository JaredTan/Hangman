require_relative 'human_player'
require_relative 'computer_player'

class Hangman
  attr_reader :guesser, :referee

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
    puts "The word is #{@answer.length} characters long."
  end

  def take_turn
    display
    @guess_no += 1
    guess = @guesser.guess(@answer.length)
    puts "Guess: #{guess}"
    correct_guess?(guess)
    results_guess?(guess)
  end

  def results_guess?(guess)
    if guess.length == 1 && ('a'..'z').include?(guess)
      correct_indices = @referee.check_guess(@answer, guess)
      update_board(guess, correct_indices)
      @guesser.handle_response(guess, correct_indices)
    else
      if guess == @answer
        @guesser.board = @answer.chars
        @guess_no -= 1
        puts "#{@guesser.name} guessed the word!!!"
      else
        @guesser.incorrect_letters << guess
      end
    end
  end

  def update_board(letter_guess, correct_indices)
    correct_indices.each { |idx| @guesser.board[idx] = letter_guess }
  end

  def correct_guess?(guess)
    if @answer.include?(guess) && guess.length == 1 || guess.length == @answer.length
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
      puts "#{@guesser.name} guessed #{@answer} with #{@guess_no} mistakes."
      puts "#{@guesser.name} wins!"
    else
      puts "Sorry, the answer was #{@answer}. #{@referee.name} wins."
    end
  end

  def display
    puts "Board: #{@guesser.board.join('  ')}"
    puts "#{@guesser.name}, you have #{@mistakes - @guess_no} mistake(s) left."
    puts "This is your last guess!" if @mistakes - @guess_no == 0
    puts "Incorrect Letters: #{@guesser.incorrect_letters.sort.join('  ')}\n\n"
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
    print 'Would you like to guess or choose a word for the computer? g / c : '
    if gets.chomp == 'c'
      players = {
        guesser: p2,
        referee: p1
      }
    else
      players = {
        guesser: p1,
        referee: p2
      }
    end
    print 'How many mistakes? Recommended 10 : '
    mistakes = gets.chomp.to_i
    puts "\n\n"
    Hangman.new(players, mistakes).play
  end

end
