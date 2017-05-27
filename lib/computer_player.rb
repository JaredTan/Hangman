class ComputerPlayer

  attr_accessor :name, :dictionary, :board, :guessed_letters

  def initialize(name)
    @name = name
    @dictionary = []
    File.readlines('dictionary.txt').each { |i| @dictionary << i }
    @letter_index_hash = {}
    @board = []
  end

  def pick_secret_word
    word = self.dictionary[rand(dictionary.count)]
    chars = word.chars.select { |ch| ('a'..'z').include?(ch) }
    chars.join
  end

  def guess
    words = candidate_words
    counter_hash = Hash.new(0)
    words.each do |word|
      word.each_char do |letter|
        counter_hash[letter] += 1 unless self.board.include?(letter)
      end
    end
    max_val = counter_hash.values.max
    max_keyval = counter_hash.select { |_, v| v == max_val }
    max_keyval.keys[0]
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
    # no need to include a guessed words instance variable
    # because candidate_words accounts for it in the hash already.
  end

  def candidate_words
    ok_words = @dictionary.select { |word| word.length == @word_length }
    ok_words.each do |word|
      @letter_index_hash.keys.each do |letter|
        unless @letter_index_hash[letter].all? { |idx| word[idx] == letter }
          ok_words.delete(word)
        end
        if @letter_index_hash[letter].empty?
          ok_words.reject! { |i| i.include?(letter) }
        end
      end
    end
    ok_words
  end

end
