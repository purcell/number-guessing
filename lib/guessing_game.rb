class GuessingGame
  MAX_GUESSES = 6
  class NoMoreGuesses < StandardError; end
  class InvalidGuess < StandardError; end

  attr_reader :answer

  def initialize(range)
    @range = range
    @answer = rand(range)
    @guesses = []
  end

  def guess?(n)
    raise InvalidGuess.new("#{n} is not in the range #{@range}") unless @range === n
    raise NoMoreGuesses if @guesses.size >= MAX_GUESSES
    @guesses << n
    n == @answer
  end

  def guesses
    @guesses.dup
  end

  def guesses_remaining
    MAX_GUESSES - @guesses.size
  end
end
