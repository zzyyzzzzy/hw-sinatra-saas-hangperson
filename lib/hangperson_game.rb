class HangpersonGame
  attr_accessor :word, :guesses, :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def new(word)
    initialize(word)
  end

  def guess(letter)
    if letter == nil
      raise ArgumentError
    end
    letter = letter.downcase
    is_letter = letter =~ /[A-Za-z]/
    if !is_letter
      raise ArgumentError
    end
    if !(@guesses.include?(letter)) && !(@wrong_guesses.include?(letter))
      if @word.include?(letter)
        @guesses += letter
      else
        @wrong_guesses += letter
      end
      return
    end
    return false
  end

  def word_with_guesses
    to_display = ""
    @word.split("").each do |i|
      if @guesses.include?(i)
        to_display += i
      else
        to_display += "-"
      end
    end
    return to_display
  end

  def check_win_or_lose
    change_rem = 7 - @wrong_guesses.length
    to_display = self.word_with_guesses()
    if (!to_display.include?("-")) && (change_rem > 0)
      return :win
    elsif change_rem > 0
      return :play
    else
      return :lose
    end
  end
end
