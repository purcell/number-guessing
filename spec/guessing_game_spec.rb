require 'guessing_game'

RSpec.describe GuessingGame do
  it "chooses a number in a given range" do
    game = GuessingGame.new(1..100)
    expect(game.answer).to be >= 1
    expect(game.answer).to be <= 100

    game = GuessingGame.new(200..300)
    expect(game.answer).to be >= 200
    expect(game.answer).to be <= 300
  end

  it "doesn't change the answer" do
    game = GuessingGame.new(1..100)
    answer1 = game.answer
    expect(game.answer).to eq(answer1)
  end

  it "allows a winning guess" do
    game = GuessingGame.new(1..1)
    expect(game.guess!(1)).to eq(true)
  end

  it "allows a losing guess" do
    game = GuessingGame.new(1..2)
    result1 = game.guess!(1)
    result2 = game.guess!(2)
    expect(result1).not_to eq(result2)
  end

  it "limits guesses by raising an error" do
    game = GuessingGame.new(1..2)
    game.max_guesses.times { game.guess!(1) }
    expect { game.guess!(2) }.to raise_error(GuessingGame::NoMoreGuesses)
  end

  it "rejects guesses out of the correct range" do
    game = GuessingGame.new(1..2)
    expect { game.guess!(3) }.to raise_error(GuessingGame::InvalidGuess)
  end

  it "doesn't count invalid guesses towards the guess limit" do
    game = GuessingGame.new(1..2, max_guesses: 1)
    2.times do
      expect { game.guess!(3) }.to raise_error(GuessingGame::InvalidGuess)
    end
  end

  it "remembers guesses" do
    game = GuessingGame.new(1..2)
    game.guess!(1)
    game.guess!(2)
    expect(game.guesses).to eq([1, 2])
  end

  it "allows remembered guesses to be spoofed" do
    game = GuessingGame.new(1..2)
    game.guess!(1)
    game.guess!(2)
    game.guesses.shift
    expect(game.guesses).to eq([1, 2])
  end

  it "reports whether any guesses remain" do
    game = GuessingGame.new(1..2)
    expect(game.guesses_remaining).to eq(game.max_guesses)
    game.guess!(1)
    expect(game.guesses_remaining).to eq(game.max_guesses - 1)
  end

  it "allows the range to be queried" do
    game = GuessingGame.new(1..50)
    expect(game.range).to eq(1..50)
  end

  it "allows the answer to be specified" do
    game = GuessingGame.new(1..50, answer: 5)
    expect(game.answer).to eq(5)
    expect(game.guess!(5)).to eq(true)
  end
end
