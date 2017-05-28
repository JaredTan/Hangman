

class HumanPlayer

  attr_accessor :name, :board, :guessed_letters, :incorrect_letters

  def initialize(name)
    @name = name
    @board = []
    @dictionary = []
    File.readlines('dictionary.txt').each { |i| @dictionary << i }
    @dictionary.map! { |word| word.delete("\n") }
    @guessed_letters = []
    @incorrect_letters = []
  end

  def guess(_)
    print 'Guess a letter or the word: '
    input = gets.chomp.downcase
    until valid_guess?(input)
      print 'Please enter a valid guess: '
      input = gets.chomp.downcase
    end
    input
  end

  def valid_guess?(input)
    return false if @guessed_letters.include?(input)
    return false unless input.chars.all? { |ch| ('a'..'z').include?(ch) }
    true
  end

  def pick_secret_word
    print 'Pick a word in the dictionary: '
    word = gets.chomp
      until valid_word?(word)
        print 'Pick a word in the dictionary: '
        word = gets.chomp
      end
    word
  end

  def valid_word?(input)
    return false unless @dictionary.include?(input)
    true
  end

  def register_secret_length(length)
    @board = Array.new(length, '_')
  end

  def handle_response(letter, indicies)
    indicies.each { |idx| @board[idx] = letter }
    @guessed_letters << letter
    @incorrect_letters << letter unless @board.include?(letter)
  end

  def check_guess(answer, guess)
    arr = []
    answer.chars.each_with_index do |ch, idx|
      arr << idx if ch == guess
    end
    arr
  end

end
