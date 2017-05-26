class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(players = {})
    defaults = {
      guesser: 'guesser',
      referee: 'referee'
    }
    players = defaults.merge(players)
    @players = players
    @guesser = players[:guesser]
    @referee = players[:referee]
    @board = Array.new(0)
  end

  def setup
    secret_word_length = self.referee.pick_secret_word
    self.guesser.register_secret_length(secret_word_length)
    @board = Array.new(secret_word_length)
  end

  def take_turn
    letter_guess = self.guesser.guess
    correct_indices = self.referee.check_guess(letter_guess)
    self.update_board(correct_indices, letter_guess)
    self.guesser.handle_response(letter_guess, correct_indices)
  end

  def update_board(correct_indices, letter_guess)
    correct_indices.each { |idx| @board[idx] = letter_guess }
  end

  if __FILE__ == $PROGRAM_NAME
    puts 'Hello'
  end

end

class HumanPlayer

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def guess(board)
  end

end

class ComputerPlayer

  attr_accessor :dictionary, :name

  def initialize(dictionary, name)
    @name = name
    @dictionary = dictionary
    @word_length = 3
    @letter_index_hash = {}
    @board = []
  end

  def pick_secret_word
    self.dictionary[rand(dictionary.count)].length
  end

  def guess(board)
    words = self.candidate_words
    counter_hash = Hash.new(0)
    words.each do |word|
      word.each_char do |letter|
        counter_hash[letter] += 1 unless board.include?(letter)
      end
    end
    max_val = counter_hash.values.max
    max_keyval = counter_hash.select { |k, v| v == max_val }
    max_keyval.keys[0]
  end

  def check_guess(letter)
    word = self.dictionary[rand(dictionary.count)]
    arr = []
    word.chars.each_with_index do |ch, idx|
      arr << idx if ch == letter
    end
    arr
  end

  def register_secret_length(length)
    @word_length = length
    @board = Array.new(length)
  end

  def handle_response(letter, indicies)
    @letter_index_hash[letter] = indicies
    indicies.each do |idx|
      @board[idx] = letter
    end
  end

  def candidate_words
    ok_words = dictionary.select { |word| word.length == @word_length }
    ok_words.each do |word|
      @letter_index_hash.keys.each do |letter|
        unless @letter_index_hash[letter].all? { |idx| word[idx] == letter }
          ok_words.delete(word)
        end
        if @letter_index_hash[letter].empty?
          ok_words.reject! { |word| word.include?(letter) }
        end
      end
    end
    ok_words
  end

end
