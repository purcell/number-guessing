require 'guessing_game'

RSpec.describe GuessingGame, 'basics' do
  it "should choose a number in a given range" do
    game = GuessingGame.new(1..100)
    expect(game.answer).to be >= 1
    expect(game.answer).to be <= 100

    game = GuessingGame.new(200..300)
    expect(game.answer).to be >= 200
    expect(game.answer).to be <= 300
  end

  it "shouldn't change the answer" do
    game = GuessingGame.new(1..100)
    answer1 = game.answer
    expect(game.answer).to eq(answer1)
  end

  it "should allow a winning guess" do
    game = GuessingGame.new(1..1)
    expect(game.guess?(1)).to eq(true)
  end

  it "should allow a losing guess" do
    game = GuessingGame.new(1..2)
    result1 = game.guess?(1)
    result2 = game.guess?(2)
    expect(result1).not_to eq(result2)
  end

  it "should limit guesses by raising an error" do
    game = GuessingGame.new(1..2)
    GuessingGame::MAX_GUESSES.times { game.guess?(1) }
    expect { game.guess?(2) }.to raise_error(GuessingGame::NoMoreGuesses)
  end

  it "should reject guesses out of the correct range" do
    game = GuessingGame.new(1..2)
    expect { game.guess?(3) }.to raise_error(GuessingGame::InvalidGuess)
  end

  it "shouldn't count invalid guesses towards the guess limit" do
    game = GuessingGame.new(1..2)
    (GuessingGame::MAX_GUESSES + 1).times do
      expect { game.guess?(3) }.to raise_error(GuessingGame::InvalidGuess)
    end
  end

  it "should remember guesses" do
    game = GuessingGame.new(1..2)
    game.guess?(1)
    game.guess?(2)
    expect(game.guesses).to eq([1, 2])
  end

  it "shouldn't allow remembered guesses to be spoofed" do
    game = GuessingGame.new(1..2)
    game.guess?(1)
    game.guess?(2)
    game.guesses.shift
    expect(game.guesses).to eq([1, 2])
  end
end
