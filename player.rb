class Player
    attr_reader :name
    attr_accessor :record
    def initialize(name)
        @name = name
        @record = 0
    end

    def guess
        puts "#{@name}, enter a letter of the alphabet"
        input = gets.chomp
    end
end 