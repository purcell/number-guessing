class GuessingGame
  class NoMoreGuesses < StandardError; end
  class InvalidGuess < StandardError; end

  attr_reader :answer, :range, :max_guesses

  def initialize(range, max_guesses: 6)
    @range = range
    @answer = rand(range)
    @guesses = []
    @max_guesses = max_guesses
  end

  def guess?(n)
    raise InvalidGuess.new("#{n} is not in the range #{@range}") unless @range === n
    raise NoMoreGuesses if @guesses.size >= max_guesses
    @guesses << n
    n == answer
  end

  def guesses
    @guesses.dup
  end

  def guesses_remaining
    max_guesses - @guesses.size
  end
end
