require 'highline/import'

module GameCalcs
  @@COLOURS = ['Y', 'B', 'R', 'G', 'O', 'P'] 

  def make_random_code
    @@COLOURS.sample(4).join
  end

  def clue(player_guess, computer_code)
    clue = ''
    player_guess.each_char.with_index { |e, i|
      if e == computer_code[i]
        clue += 'O'
      elsif computer_code.include?(e)
        clue += 'C'
      else
        clue += 'X'
      end
    }
    clue.split('').join('|')
  end
end

class Computer
  include GameCalcs
  attr_accessor :code

  def initialize
    self.code = make_random_code
  end
end

class Player
  attr_accessor :player_guess

  def initialize
    self.player_guess = '____'
  end
end

class Game
  include GameCalcs
  attr_accessor :player, :computer
  @@round_number = 0

  def initialize
    self.player = Player.new
    self.computer = Computer.new
  end

  def play_round
    self.player.player_guess = ask "Please enter your guess"
    until valid_guess?(self.player.player_guess)
      puts "You've entered an invalid guess\nYour options are Y B R G O P"
      self.player.player_guess = ask "Please enter your guess"
    end
    self.display_round
    @@round_number += 1
  end

  def play
    until game_over?
      self.play_round
      if code_broken?
        puts "Nice work! you cracked the code"
        break
      end
    end
    puts "Sorry you lose, 12 rounds are up" unless code_broken?
  end

  def display_round
    puts "CODE: #{self.computer.code}"
    puts "Current Guess: #{self.player.player_guess.split('').join('|')}"
    puts "Current Clue: #{clue(self.player.player_guess, self.computer.code)}"
  end

  def game_over?
    @@round_number == 12 || code_broken?
  end

  def code_broken?
    clue(self.player.player_guess, self.computer.code).split('|').all? { |e| e == 'O'}
  end

  def valid_guess?(guess)
    (@@COLOURS + guess.split('')).uniq.length == 6 && guess.length == 4
  end
end

new_game = Game.new
new_game.play
