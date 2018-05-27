require 'open-uri'
require 'json'

class GamesController < ApplicationController

  LETTERS = []

  10.times {
    LETTERS.push(('A'..'Z').to_a.sample)
  }

  def new
     @letters = LETTERS
  end

  def score
    @result = {}
    @letters = params[:grid].split(//)
    if params[:word]
      word = params[:word].upcase
      word_array = word.split(//)
      url = "https://wagon-dictionary.herokuapp.com/#{word}"
      encoded_url = URI.encode(url)
      file = open(encoded_url).read

      grid_attempt = true
      word_array.each do |letter|
        if @letters
          if @letters.include?(letter)
            @letters.delete(letter)
          else
            grid_attempt = false
          end
        end
    end

    english_check = JSON.parse(file)

    if english_check["found"] == false
      @result[:message] = "Sorry but #{word} does not seem to be a valid English word"
      @result[:score] = 0
    elsif grid_attempt == false
      @result[:message] = "Sorry but #{word} can not be built out of #{@letters.join}"
      @result[:score] = 0
    else
      @result[:message] = "Congratulations! #{word} is a valid English word!"
      @result[:score] = english_check["length"]
    end
  end
end
end
