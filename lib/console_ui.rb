require 'guessing_game'

class ConsoleUI
  def initialize(input, output, game)
    @input, @output, @game = input, output, game
  end

  def run!
    write("The answer is between #{@game.range.first} and #{@game.range.last}.")
    while @game.guesses_remaining > 0
      guess = read_guess
      return unless guess
      begin
        if @game.guess!(guess)
          write("That's correct!")
          return
        end
        write("Sorry, that was wrong. The answer is #{guess < @game.answer ? 'higher' : 'lower'}.")
      rescue GuessingGame::InvalidGuess
        write("Invalid guess.")
      end
    end
    write("No guesses remaining. The answer was #{@game.answer}.")
  end

  private

  def read_guess
    loop do
      write("Please enter your guess:")
      user_input = @input.gets
      return nil if ['', nil].include?(user_input)
      return user_input.to_i if user_input.strip =~ /\A\d+\z/
      write "Invalid input."
    end
  end

  def write(text)
    @output.puts(text)
  end
end
