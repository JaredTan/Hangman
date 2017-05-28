class ComputerPlayer

  attr_accessor :name, :dictionary, :board, :guessed_letters, :incorrect_letters

  def initialize(name)
    @name = name
    @dictionary = []
    File.readlines('dictionary.txt').each { |i| @dictionary << i }
    @dictionary.map! { |word| word.delete("\n") }
    @letter_index_hash = {}
    @board = []
    @guessed_letters = []
    @incorrect_letters = []
  end

  def pick_secret_word
    word = self.dictionary[rand(dictionary.count)]
    chars = word.chars.select { |ch| ('a'..'z').include?(ch) }
    chars.join
  end

  def guess(answer_length)
    words = candidate_words(answer_length)
    counter_hash = Hash.new(0)
    words.each do |word|
      word.each_char do |letter|
        counter_hash[letter] += 1 unless self.board.include?(letter)
      end
    end
    p counter_hash
    max_val = counter_hash.values.max
    max_keyval = counter_hash.select { |_, v| v == max_val }
    p max_keyval.keys
    max_keyval.keys[rand(max_keyval.keys.length)]
  end

  def check_guess(answer, guess)
    arr = []
    answer.chars.each_with_index do |ch, idx|
      arr << idx if ch == guess
    end
    arr
  end

  def register_secret_length(length)
    @board = Array.new(length, '_')
  end

  def handle_response(letter, indicies)
    @letter_index_hash[letter] = indicies
    indicies.each { |idx| @board[idx] = letter }
    @guessed_letters << letter
    @incorrect_letters << letter if indicies.empty?
  end

  def candidate_words(answer_length)
    ok_words = @dictionary.select { |word| word.length == answer_length }
    @incorrect_letters.each do |ch|
      ok_words.reject! { |word| word.include?(ch) }
    end
    better_words = ok_words.dup
    ok_words.each do |word|
    @letter_index_hash.keys
      @letter_index_hash.keys.each do |letter|
        unless @letter_index_hash[letter].all? { |idx| word[idx] == letter }
          better_words.delete(word)
        end
      end
    end
    p better_words
    @dictionary = better_words
  end

end
