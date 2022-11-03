--[[
    Blackjack.lua
    By: Jacob Soto and Joe Katalinich
    Blackjack game
    5/4/22
]]

-- Card object
Card = {  
    value=0, -- default values: empty
    suit="",
    face="",
showValue = function (self)
    print(self.value)
end,
showSuit = function (self)
    print(self.suit)
end,
showFace = function (self)
    print(self.face)
end,
printSelf = function(self) -- card can display its own values. Ex: Card:printSelf() right now wopuld print none of ""
    if(self.face =="none") then io.write(self.value, " of ", self.suit)
    else io.write(self.face, " of ", self.suit)
    end
end
}
function Card:new (cardObj)
    cardObj = cardObj or {}   -- create object if user does not provide one
    setmetatable(cardObj, self) -- In this case, we are making
    self.__index = self
    return cardObj
  end


--Deck object, contains methods:
-- printDeck, makeDeck, and shuffleDeck
Deck = { 
    deckCards = {},
    cardsInDeck = 0,
    totalCards=52,
    suits = {"Spades", "Diamonds", "Hearts", "Clubs"},
    face = {"King", "Queen", "Jack"},
   
makeDeck = function (self)

    for i=1, 13, 1 do
        for key, suitValue in pairs(self.suits) do
            self.cardsInDeck = self.cardsInDeck + 1

            if(i==1) then self.deckCards[self.cardsInDeck] = Card:new{value=11, suit=suitValue, face="Ace"}
            elseif(i>1 and i<=10) then self.deckCards[self.cardsInDeck]= Card:new{value=i, suit=suitValue, face="none"}
            elseif(i==11) then self.deckCards[self.cardsInDeck]=Card:new{value=10, suit=suitValue, face="Jack"}
            elseif(i==12) then self.deckCards[self.cardsInDeck]=Card:new{value=10, suit=suitValue, face="Queen"}
            else self.deckCards[self.cardsInDeck]=Card:new{value=10, suit=suitValue, face="King"} end
        end
    end
    io.write("\nNew Deck Created with ", self.cardsInDeck, " cards")
    self:shuffleDeck()
end,

-- Creates a temp Deck and populates each index with a random card from the original Deck
-- Points original Deck to the temp Deck
shuffleDeck = function (self)
    local tempDeck = {}
    local shuffleCount = 0

    for j=1, 6, 1 do
        local tempCount = self.cardsInDeck
        shuffleCount = shuffleCount + 1

        for i=1, self.cardsInDeck, 1 do
            math.randomseed(os.time() * os.time())
            local index = math.random(tempCount);
            table.insert(tempDeck, i, table.remove(self.deckCards, index))
            tempCount = tempCount - 1
        end
        self.deckCards = tempDeck
    end
    --print(" & the deck has been shuffled ")

end,

-- If there are <6 cards in the deck, make a new shuffled deck
checkDeck = function (self)
    if (self.cardsInDeck < 6) then self:makeDeck() end
end,

printDeck = function (self)
    for i=1, self.cardsInDeck, 1 do 
        self.deckCards[i]:printSelf()
        io.write( " " ,i, "\n")
    end

end
}


function Deck:new (deckObj)
    deckObj = deckObj or {}
    setmetatable(deckObj, self)
    self.__index = self
    deckObj:makeDeck()
    return deckObj
end


Hand = {
    handObj = {},
    cardsInHand = 0,
    totalValue = 0,

    addCard = function(self, theDeck)
        theDeck:checkDeck()
        self.cardsInHand = self.cardsInHand + 1
        table.insert(self.handObj, self.cardsInHand, table.remove(theDeck.deckCards, 1)) --insert (Table you're writing into, index, new value)
        theDeck.cardsInDeck = theDeck.cardsInDeck - 1
        self.totalValue = self.totalValue + self.handObj[self.cardsInHand].value
    end,

    returnCardsToDeck = function(self, theDeck)
        for index, card in pairs(self.handObj) do
            theDeck.cardsInDeck = theDeck.cardsInDeck + 1
            table.insert(theDeck.deckCards, theDeck.cardsInDeck, card) --insert (Table you're writing into, index, new value)
        end
        self.handObj = {}
        self.cardsInHand=0
        self.totalValue = 0
    end,

    calcHandValue = function(self)
        local tempVal = 0
        for i=1, self.cardsInHand, 1 do
            tempVal = tempVal + self.handObj[i].value
        end
        self.totalValue = tempVal
        if self.totalValue == 21 then return "Blackjack!!"
        --else if (self.totalValue >21 and)
        else return self.totalValue end
    end,





    showHand = function(self)
        for key, value in pairs(self.handObj) do
            value:printSelf();
            print();
        end
      --  end
     --   for i=1, self.cardsInHand, 1 do
    --        self.cardsInHand[i]:printSelf()
    --        io.write( " " ,i, "\n")
    --    end

        if self.totalValue == 21 then print("Blackjack!!")
        elseif self.totalValue > 21 then print("Bust!!")
        else io.write("Total Hand Value = ", self:calcHandValue()) end
        print()


    end

}

-- Hand object, contains a table of cards
function Hand:new (handObj)
    handObj = handObj or {}
    setmetatable(handObj, self)
    self.__index = self
    return handObj
end



Game = {
    startNewRound = function(deck,...)

        local hands = {...}
        io.write("Returning the cards of " .. #hands .. " hands.\n" )
        for index, hand in pairs(hands) do
            hand:returnCardsToDeck(deck)
            deck:shuffleDeck()
        end
        deck:shuffleDeck()
    end

}

local newDeck = Deck:new{}
local player = Hand:new{handObj={}, cardsInHand = 0, totalValue = 0}
local dealer = Hand:new{handObj={},cardsInHand = 0, totalValue = 0}
nextMove = ""
print("\nYou're now playing blackjack!")
while (nextMove~="quit") do
    player:addCard(newDeck)
    dealer:addCard(newDeck)
    player:addCard(newDeck)
    dealer:addCard(newDeck)
    print("--------------NEW ROUND----------------")
    --Hands are dealt, game begins
    print("\nDealers card: ")
    dealer.handObj[1]:printSelf()
    print("\n\nYour cards: ")
    player:showHand()
    while (player.totalValue < 21 and nextMove ~="quit") do
        print("\nHit or stay?")
        if(nextMove == "hit") then 
            player:addCard(newDeck)
            player:showHand()

            if(player.totalValue > 21) then 
                io.write("You and the dealer are getting new hands...")
                Game.startNewRound(newDeck, player, dealer)
                dealer:addCard(newDeck)
                player:addCard(newDeck)
                player:addCard(newDeck)
                print("\nDealers card: ")
                dealer.handObj[1]:printSelf()
                print("\n\nYour cards: ")
                player:showHand()
            end
        end
        if(nextMove == "stay") then 
            print("\nDealers hand: ")
            dealer:showHand()
            if (dealer.totalValue > player.totalValue) then
                io.write("The dealer's hand had value " .. dealer.totalValue .. " and yours had " .. player.totalValue .. " \n")
                print("\nThe dealer wins this round")
            else  io.write("The dealer's hand had value " .. dealer.totalValue .. " and yours had " .. player.totalValue .." \nYOU WIN!!!!!!!!\n\n\n")
                
            io.write("You and the dealer are getting new hands...")
            Game.startNewRound(newDeck, player, dealer)
            dealer:addCard(newDeck)
            player:addCard(newDeck)
            player:addCard(newDeck)
            print("\nDealers card: ")
            dealer.handObj[1]:printSelf()
            print("\n\nYour cards: ")
            player:showHand()
            end
        end
    print("What's your next move?\n")
    nextMove = io.read()
    end
    print("Round ended. Type quit to quit, otherwise you'll start a new round!\n")
    nextMove = io.read()
end

