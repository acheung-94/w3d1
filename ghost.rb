require 'set'
require_relative './player.rb'
class Game
    attr_reader :dictionary, :players, :score
    attr_accessor :current_player, :previous_player

    def initialize(*players)
        @players = players.map {|player| Player.new(player)}
        @current_player = @players[0]
        @previous_player = @players[-1]
        @fragment = ""
        @dictionary = Set.new
        File.foreach("dictionary.txt") {|line| @dictionary.add line.chomp} #hooray google!!
        @score = {}
        @players.each {|player| @score[player] = player.record} #key is the instance, yeah?
    end

    def run #really just an extra step to determine if anyone is out. 
        until @players.length == 1 do 
            puts "~~~~~~~~~~~~~~"
            self.display_standings 
            self.play_round
            @score.each do |player, score| #here is a problem
                if score > 4
                    puts "*~*~*~*~*~*~*~"
                    puts "Sorry #{player.name}, you're out."
                    @score.delete(player)
                    @players.delete(player) #so harsh
                end
            end
        end
        puts " #{@current_player.name} has won, the game is over."
    end

    def play_round
        until @dictionary.include?(@fragment) == true do
            self.take_turn
            if dictionary.include?(@fragment)
                p "#{@current_player.name} wins! #{@previous_player.name} loses. :("
                @score[@previous_player] += 1
                #return true 
            else
                self.next_player!
                puts "------"
            end
        end
        @fragment = ""
    end

    def next_player!
        @players.rotate!
        self.current_player = @players[0]
        self.previous_player = @players[-1]
    end

    def take_turn
        input = @current_player.guess
        if !self.valid_play?(input)
            p "not a valid play, try again"
            raise StandardError 
        else
            @fragment += input
            p @fragment
        end

        rescue StandardError
        retry
    end

    def valid_play?(str) #what if potential frag = "abc" is a character but no words in dictionary start with "abc"
        return false if str.length > 1 
        potential_frag = @fragment + str
        alphabet = "abcedefghijklmnopqrstuvwxyz"
        return false if !alphabet.include?(str) 

        dictionary.each do |word|
            return true if word[0..@fragment.length] == potential_frag
        end
        return false
    end

    def display_standings
        @score.each {|player,score| puts "#{player} - #{score}"}
    end
end

if __FILE__ == $PROGRAM_NAME
game = Game.new("hello", "cats", "pinot")
 game.score[game.current_player] += 4
p game.run
end