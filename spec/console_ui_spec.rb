require 'console_ui'

RSpec.describe ConsoleUI, 'session' do
  def run_transcript(game, s)
    expected_output = s.scan(/^ *> ([^\n]*\n)/).flatten.join
    input  = StringIO.new(s.scan(/^ *< ([^\n]*\n)/).flatten.join)
    output = StringIO.new
    ConsoleUI.new(input, output).run_game!(game)
    expect(output.string).to eq(expected_output)
  end

  context "with well-formed input" do
    it "prompts for a guess" do
      game = instance_double("game", guesses_remaining: 1)
      run_transcript(game, <<-EOF)
        > Please enter your guess:
      EOF
    end

    it "doesn't prompt when no guesses remain" do
      game = instance_double("game", guesses_remaining: 0)
      run_transcript(game, <<-EOF)
        > No guesses remaining.
      EOF
    end

    it "handles a wrong guess" do
      game = instance_double("game", :guess? => false)
      expect(game).to receive(:guesses_remaining).and_return(1, 0)
      run_transcript(game, <<-EOF)
        > Please enter your guess:
        < 1
        > Sorry, that was wrong.
        > No guesses remaining.
      EOF
    end

    it "handles a correct guess" do
      game = instance_double("game", :guess? => true, guesses_remaining: 1)
      run_transcript(game, <<-EOF)
        > Please enter your guess:
        < 1
        > That's correct!
      EOF
    end
  end

  context "with malformed input" do
    it "halts on blank input" do
      game = instance_double("game", :guess? => true, guesses_remaining: 1)
      run_transcript(game, <<-EOF)
        > Please enter your guess:
      EOF
    end

    it "complains about non-numeric input" do
      game = instance_double("game", :guess? => true, guesses_remaining: 1)
      run_transcript(game, <<-EOF)
        > Please enter your guess:
        < BLAH
        > Invalid input.
        > Please enter your guess:
      EOF
    end

    it "complains about out-of-range input" do
      game = instance_double("game", guesses_remaining: 1)
      expect(game).to receive(:guess?).and_raise(GuessingGame::InvalidGuess)
      expect(game).to receive(:guesses_remaining).and_return(1, 1)
      run_transcript(game, <<-EOF)
        > Please enter your guess:
        < 300
        > Invalid input.
        > Please enter your guess:
      EOF
    end
  end
end
