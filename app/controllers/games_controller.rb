require 'open-uri'
require 'json'

class GamesController < ApplicationController
    def new
        @letters = Array.new(rand(3..10)) { ('a'..'z').to_a.sample }
    end

    def correct?(word)
        word.chars.all? { |char| params[:word].count(char) >= word.count(char) }
    end

    def score
        url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
        api_serialized = URI.open(url).read
        word_api = JSON.parse(api_serialized)
        if correct?(params[:word].downcase) == false
            @score = 0
            @message = "Sorry but the word '#{params[:word]}' can't be built using the grid..."
        elsif word_api["found"] == false
            @score = 0 
            @message = "Sorry but the word '#{params[:word]}' is not an english word..."
        elsif word_api["found"] == true
            @score = (params[:word].length**2)
            @message = "Congratulations the word '#{params[:word]}' is a valid english word!"
        end
    end
end
