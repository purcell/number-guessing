class ConsoleUI
  def initialize(input, output)
    @input, @output = input, output
  end

  def run_game!(game)
    while game.guesses_remaining > 0
      @output.puts("Please enter your guess:")
      user_input = @input.gets
      return if ['', nil].include?(user_input)
      guess = user_input.to_i
      game.guess?(guess)
      @output.puts("Sorry, that was wrong.")
    end
    @output.puts("No guesses remaining.")
  end
end
