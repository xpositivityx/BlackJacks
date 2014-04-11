$money = 200

class Card 
	def initialize
		@v = rand(12)+1
		@s = rand(3)+1
	end

	def value
		if @v>10
			return 10
		elsif @v==1
			return 11
		else
			return @v
		end
	end

	def face
		if @v == 11
			return "Jack"
		elsif @v == 12
			return "Queen"
		elsif @v == 13
			return "King"
		elsif @v == 1
			return "Ace"
		else
			return @v.to_s
		end
	end

	def suit
		if @s == 1
			return "hearts"
		elsif @s == 2
			return "clubs"
		elsif @s == 3
			return "spades"
		else
			return "diamonds"
		end
	end
end


class Hand
	def initialize
		@cards = Array.new
		@cards[0] = Card.new
		@cards[1] = Card.new
	end

	def sum
		sum = 0
		ace = 0
		@cards.each{|x| 
			sum += x.value
			if x.value == 11
				ace += 1
			end
		}
		if sum > 21 && ace > 0
			sum -= (ace * 10)
		else
		return sum
		end
	end

	def hit
		@cards << Card.new
		return self.sum
	end

	def read_it
		red = []
		finStr = String.new
		@cards.each{|x| 
			red<<x.face
			red<<x.suit
		}
		red.each_with_index { |x,i|
			if i%2==0
				finStr += x.to_s
			elsif i>(red.length-2)
				finStr += " of #{x.to_s}"
			else
				finStr += " of #{x.to_s} and a "
			end
		}
		return "You have a #{finStr}"
	end

	def read_it_dealer
		red = []
		finStr = String.new
		@cards.each{|x| 
			red<<x.face
			red<<x.suit
		}
		finStr = "#{red[0]} of #{red[1]}"
		return "Dealer shows a #{finStr}."
	end

	def is_blackjack?
		ace = 0
		jack = 0
		@cards.each{|x|
			if x.face == "Jack"
				jack += 1
			end
			if x.face == "Ace"
				ace += 1
			end
		}
		if ace<0 && jack <0
			return true
		end
	end
end


class Dealer
	def initialize
		@dealer = Hand.new
		@showCard = ' '
	end

	def play
		if @dealer.sum < 16
			@dealer.hit
			self.play
		else
			return @dealer.sum
		end
	end

	def show
		return @dealer.read_it_dealer
	end

	def blackjack?
		return @dealer.is_blackjack?
	end
end

class User < Dealer
	def play
		if @dealer.sum < 21
		puts "#{@dealer.read_it} for a score of #{@dealer.sum}.\nWould you like to hit? Y/N?"
		var = gets.chomp
			if var == "y"
				@dealer.hit
				self.play
			elsif var == "n"
				return @dealer.sum
			else
				puts "Not a valid input"
				self.play
			end
		else
			return @dealer.sum
		end
	end
end

class Play

	def initialize
	@u = User.new
	@d = Dealer.new
	@bet = 0
	end

	def game
		puts "You have $#{$money}. Place Your Bet!"
		@bet = gets.chomp.to_i
		if @bet == 0
			puts "That is not a valid bet!"
			self.game
		end
		if ($money - @bet) < 0
			puts "You do not have enough money"
			self.game		
		else
			$money -= @bet
		end

		x = @d.play
		puts "#{@d.show}"

		if 
			@d.blackjack? != true
			y = @u.play
			self.result(x,y)
		end

	end

	def result(x,y)
		if x>y && x<=21
			puts "The dealer had #{x}, you had #{y}. You lose"
		elsif x<y && y<=21
			puts "The dealer had #{x}, you had #{y}. You win"
			$money += (@bet * 2)
		elsif x>21 && y<=21
			puts "The dealer had #{x}, you had #{y}. You win"
			$money += (@bet * 2)
		elsif y>21 && x<=21
			puts "The dealer had #{x}, you had #{y}. You lose"
		else
			puts "The dealer had #{x}, you had #{y}. You push"
			$money += @bet
		end
		self.ending
	end

	def ending
		if $money == 0
			puts "You ran out of money. Goodbye!"
			Kernel.abort
		end
		puts "Play again? y/n?"
		x = gets.chomp.upcase
		if x=='Y'
			@u = User.new
			@d = Dealer.new
			self.game
		end
	end
end

game = Play.new
game.game
