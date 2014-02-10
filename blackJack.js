
function Card(s,r) {
	var suit = s;
	var rank = r;
	this.getNumber = function(){
		return rank;
	};
	this.getSuit = function(){
		return suit;
	};
	this.getValue = function(){
		if(rank>=10){
			return 10;
		}
		else if(rank===1){
			return 11;
		}
		else{
			return rank;
		}
	};
};

function deal(){
	var s = Math.floor(Math.random()*4+1);
	var r = Math.floor(Math.random()*13+1);
	var dealt = new Card(s,r);
	return dealt;
}

function Hand(){
	var cards = [];
	cards[0] = deal();
	cards[1] = deal();
	this.getHand = function(){
		return cards;
	};
	this.score = function(){
		var sum = 0;
		var alt = 0;
		for(i=0;i<cards.length;i++){
			if(cards[i].getValue()===11){
				alt++;
			}
		sum+= cards[i].getValue();
		}
		if(sum>21||alt<0){
		return 	sum-=10;
		}
		else{
		return sum;
		}
	};
	this.printHand = function() {
		var fullHand = "";
		for(i=0;i<cards.length;i++){
		var value = cards[i].getNumber();
		var suit = cards[i].getSuit();
		var suitStr = ""
		var finVal = 0;

		switch(suit){
			case 1:
			suitStr = "diamonds";
			break;
			case 2:
			suitStr = "hearts";
			break;
			case 3:
			suitStr = "spades";
			break;
			case 4:
			suitStr = "clubs";
			break;
		}
		
		switch(value){
			case 1:
			finVal = 11;
			break;
			case 11:
			finVal = "jack";
			break;
			case 12:
			finVal = "queen";
			break;
			case 13:
			finVal = "king";
			break;
		}

	fullHand += finVal.toString()+" of "+suitStr;
}
	return fullHand;
	};
	this.hitMe = function() {
		var addCard = deal();
		cards.push(addCard);
	};
}

function playAsDealer(){
	var hand = new Hand();
	this.value = hand.score();
	while(this.value<17){
		console.log(this.value);
		hand.hitMe();
		console.log(hand.hitMe());
		this.value=hand.score();
	}
	return this.value;
}


function playAsUser(){
var phand = new Hand();
var decision=confirm("Your hand is "+phand.printHand()+" for a score of "+phand.score()+". Hit OK to hit, or CANCEL to stand.");
while(decision === true){
    phand.hitMe();
    decision=confirm(phand.score()+ "Do you want to hit again ?");
}
return phand.score();
}

function declareWinner(userHand,dealerHand){
	if(userHand<=21&&(dealerHand>21||dealerHand<userHand)){
	return "You win!";
	}
	else if(userHand<21&&dealerHand===userHand){
		return "You tied!";
	}
	else{
		return "You lose!";
	}
}


function playGame(){
	var playerHand = playAsUser();
	var dealHand = playAsDealer();
	console.log("dealer had "+dealerHand+
		"you had "+playerHand+
		declareWinner(playerHand,dealHand));
}

playGame();