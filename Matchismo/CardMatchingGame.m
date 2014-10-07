//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "CardMatchingGame.h"

static const int DEFAULT_REQUIRED_MATCHES = 2;

@interface CardMatchingGame()
{
    NSMutableArray *_curChosenCards;
    NSMutableArray *_lastChosenCards;
}
@property (nonatomic, readwrite) NSInteger totalScore;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, weak) Deck* deck;
@end

@implementation CardMatchingGame

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; // super's designated initializer
    
    if (self) {
        self.requiredMatches = DEFAULT_REQUIRED_MATCHES;
        if (YES == [self dealNewGameWithCardCount:count usingDeck:deck]){
            self.deck = deck;
        
        } else {
            // failure
            self = nil;
        }
    }
    
    return self;
}

- (BOOL)dealNewGameWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    BOOL ret = YES;
    
    if (self) {
        // iterate through the count of cards draw a random card from the deck, then
        // addObject to our cards array each time
        for (int i=0; i<count; ++i) {
            Card *card = [deck drawRandomCard];
            if (card) {
                // add
                [self.cards addObject:card];
            } else {
                ret = NO;
                break;
            }
        }
        self.gameStatus = NewDeal;
        if (!_curChosenCards) _curChosenCards = [[NSMutableArray alloc] init];
        if (!_lastChosenCards) _lastChosenCards = [[NSMutableArray alloc] init];
        
    } else {
        ret = NO;
    }
    return ret;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    
    return _cards;
}

- (NSMutableArray *)curChosenCards
{
    // alloc in initGameWithCardCount
    return _curChosenCards;
}

- (NSArray *)lastChosenCards
{
    // alloc in initGameWithCardCount
    return _lastChosenCards;
}

- (BOOL)resetGameWithCardCount:(NSUInteger)count
{
    // since we drew the current cards off the deck, we need to put them back.
    for (Card *card in self.cards) {
        [card reset];
        [self.deck addCard:card]; // we have to return the card we drew back to the deck
    }
    [self.cards removeAllObjects];
    
    BOOL ret = [self dealNewGameWithCardCount:count usingDeck:self.deck]; // reinitialize

    if (YES == ret) {
        // set totalScore to zero
        self.totalScore = 0;
        [_curChosenCards removeAllObjects];
        self.gameStatus = NewDeal;
    }
    
    return ret;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (BOOL)scoreChosenCards
{
    int matchScore = 0; // we'll select the maximum possible score in the set of chosen cards
    for (Card *chosenCard in self.curChosenCards){
        // this is simplified since chosenCards now has only unmatched but chosen cards
        // each card
        NSMutableArray *otherCards = [[NSMutableArray alloc] initWithArray:self.curChosenCards];
        [otherCards removeObject:chosenCard];
        
        matchScore = MAX(matchScore, [chosenCard match:otherCards]);
    }
    
    if (matchScore > 0) {
        // yes, we assume 0 is impossible to score, thus we consider all "out of play"
        for (Card* chosenCard in self.curChosenCards) {
            chosenCard.outOfPlay = YES;
        }
        self.lastScore = matchScore * MATCH_BONUS;
        self.totalScore += self.lastScore;
    } else {
        // set all but the very last chosenCard.chosen to NO, and turn them back face-down
        for (Card* chosenCard in self.curChosenCards) {
            if (chosenCard != [self.curChosenCards lastObject]) {
                chosenCard.chosen = NO;
                chosenCard.faceUp = NO;
            }
        }
        self.lastScore = MISMATCH_PENALTY;

        self.totalScore -= self.lastScore;
    }
    
    return (matchScore != 0);
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isOutOfPlay) {
        if (card.isChosen) {
            card.chosen = NO;
            // in this game, when a card is selected again, it is turned back "Face-down" - a state
            card.faceUp = NO;
            
            // remove from chosenCards
            [_curChosenCards removeObject:card];
            self.gameStatus = CardUnchosen;
            
        } else {
            card.chosen = YES;
            // In this game, when a card is chosen, it is turned "face-up" - a state
            card.faceUp = YES;
            
            // Add to chosenCards
            [_curChosenCards addObject:card];
            self.gameStatus = CardChosen;
        }
        
        if ([self.curChosenCards count] == self.requiredMatches){
            BOOL scoredMatches = [self scoreChosenCards];
            [_lastChosenCards removeAllObjects];
            [_lastChosenCards addObjectsFromArray:_curChosenCards];
            [_curChosenCards removeAllObjects];
            if (!scoredMatches) {
                // no match, but keep the last one chosen to make the game more interesting, add it back to our chosenCards
                [_curChosenCards addObject:card];
                self.gameStatus = ScoredNoMatch;
            } else {
                self.gameStatus = ScoredMatch;
            }
            
        }
        
        self.totalScore -= COST_TO_CHOOSE;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (NSArray *) getLastMatchedCards;
{
    Card* highestScoringCard;
    // iterate through lastChosenCards, find the highest scoring card and put that
    // one, plus its matches
    for (Card* card in self.lastChosenCards) {
        if (!highestScoringCard) highestScoringCard = card;
        else if (card.score > highestScoringCard.score) highestScoringCard = card;
    }
    NSMutableArray *lastMatchedCards = [NSMutableArray arrayWithArray:highestScoringCard.lastCardsMatched];
    [lastMatchedCards addObject:highestScoringCard]; // plus the card itself
    
    return lastMatchedCards;
}


@end
