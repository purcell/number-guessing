require 'console_ui'
require 'guessing_game'

RSpec.describe ConsoleUI, 'session' do
  def run_transcript(game, s)
    expected_output = s.scan(/^ *> ([^\n]*\n)/).flatten.join
    input  = StringIO.new(s.scan(/^ *< ([^\n]*\n)/).flatten.join)
    output = StringIO.new
    ConsoleUI.new(input, output, game).run!
    expect(output.string).to eq(expected_output)
  end

  context "with well-formed input" do
    it "prompts for a guess and halts on blank input" do
      game = GuessingGame.new(1..50)
      run_transcript(game, <<-EOF)
        > The answer is between 1 and 50.
        > Please enter your guess:
      EOF
    end

    it "doesn't prompt when no guesses remain" do
      game = GuessingGame.new(1..10, max_guesses: 0)
      run_transcript(game, <<-EOF)
        > The answer is between 1 and 10.
        > No guesses remaining.
      EOF
    end

    it "handles a guess which is too low" do
      game = GuessingGame.new(1..5, max_guesses: 1, answer: 5)
      run_transcript(game, <<-EOF)
        > The answer is between 1 and 5.
        > Please enter your guess:
        < 1
        > Sorry, that was wrong. The answer is higher.
        > No guesses remaining.
      EOF
    end

    it "handles a guess which is too high" do
      game = GuessingGame.new(1..5, max_guesses: 1, answer: 3)
      run_transcript(game, <<-EOF)
        > The answer is between 1 and 5.
        > Please enter your guess:
        < 5
        > Sorry, that was wrong. The answer is lower.
        > No guesses remaining.
      EOF
    end

    it "handles a correct guess" do
      game = GuessingGame.new(1..1)
      run_transcript(game, <<-EOF)
        > The answer is between 1 and 1.
        > Please enter your guess:
        < 1
        > That's correct!
      EOF
    end
  end

  context "with malformed input" do
    it "complains about non-numeric input" do
      game = GuessingGame.new(1..5)
      run_transcript(game, <<-EOF)
        > The answer is between 1 and 5.
        > Please enter your guess:
        < BLAH
        > Invalid input.
        > Please enter your guess:
      EOF
    end

    it "complains about out-of-range input" do
      game = GuessingGame.new(1..5)
      run_transcript(game, <<-EOF)
        > The answer is between 1 and 5.
        > Please enter your guess:
        < 300
        > Invalid guess.
        > Please enter your guess:
      EOF
    end
  end
end
