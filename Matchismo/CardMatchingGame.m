//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "CardMatchingGame.h"
#import "CardMatchAttempt.h"

static const int DEFAULT_REQUIRED_MATCHES = 2;

@interface CardMatchingGame()
{
    NSMutableArray *_curChosenCards; // of Card
}
@property (nonatomic, readwrite) NSInteger totalScore;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, weak) Deck* deck;

@property (nonatomic, strong) NSMutableArray *cardMatchAttempts; // of CardMatchAttempt
@property (nonatomic, readwrite) enum Status gameStatus; // Current status of the game as presented by the game

@end

@implementation CardMatchingGame

#pragma mark - Initializer

// Designated Initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; // super's designated initializer
    
    if (self) {
        self.requiredMatches = DEFAULT_REQUIRED_MATCHES;
        self.deck = deck;
        
        _curChosenCards = [[NSMutableArray alloc] init];

        if (NO == [self dealNewGameWithCardCount:count]){
            self = nil;
        }
    }
    
    return self;
}

#pragma mark - Accessors and Convenience Methods
- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    
    return _cards;
}

- (NSArray *)curChosenCards
{
    return [_curChosenCards copy]; // note that this is initialized in the desgnated initializer
}

- (NSMutableArray *)cardMatchAttempts
{
    if (!_cardMatchAttempts) _cardMatchAttempts = [[NSMutableArray alloc] init];
    return _cardMatchAttempts;
}



#pragma mark - Methods

- (void)resetDeck
{
    // since we drew the current cards off the deck, we need to put them back.
    for (Card *card in self.cards) {
        [card reset];
        [self.deck addCard:card]; // we have to return the card we drew back to the deck
    }
    [self.cards removeAllObjects];
}

- (BOOL)dealCardsWithCount:(NSUInteger)count
{
    BOOL ret = YES;
    
    // iterate through the count of cards draw a random card from the deck, then
    // addObject to our cards array each time to know what cards are on the "table"
    for (int i=0; i<count; ++i) {
        Card *card = [self.deck drawRandomCard];
        if (!card) {
            ret = NO;
            break;
        }
        
        [self.cards addObject:card];
    }
    
    return ret;
}

- (BOOL)dealNewGameWithCardCount:(NSUInteger)count
{
    BOOL ret = YES;

    [self resetDeck];
    
    ret = [self dealCardsWithCount:count];
    
    self.gameStatus = NewDeal;
    self.totalScore = 0;
    [_curChosenCards removeAllObjects];
    [self.cardMatchAttempts removeAllObjects];

    return ret;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (BOOL)scoreChosenCards
{
    int matchScore = 0; // we'll select the maximum possible score in the set of chosen cards
    BOOL isMatch;
    for (Card *chosenCard in self.curChosenCards){
        // this is simplified since chosenCards now has only unmatched but chosen cards
        // each card
        NSMutableArray *otherCards = [[NSMutableArray alloc] initWithArray:self.curChosenCards];
        [otherCards removeObject:chosenCard];
        
        matchScore = MAX(matchScore, [chosenCard match:otherCards]);
    }
    
    if (matchScore > 0) {
        // yes, we assume 0 is impossible to score when the cards actually match
        for (Card* chosenCard in self.curChosenCards) {
            chosenCard.outOfPlay = YES;
        }
        matchScore *= MATCH_BONUS;
        self.totalScore += matchScore;
        
        isMatch = YES;
        
    } else {
        // set all but the very last chosenCard.chosen to NO, and turn them back face-down
        for (Card* chosenCard in self.curChosenCards) {
            if (chosenCard != [self.curChosenCards lastObject]) {
                chosenCard.chosen = NO;
                chosenCard.faceUp = NO;
            }
        }
        matchScore = MISMATCH_PENALTY;
        
        self.totalScore -= matchScore;

        isMatch = NO;
    }
    
    [self.cardMatchAttempts addObject:[[CardMatchAttempt alloc] initWithCards:self.curChosenCards withScore:matchScore withMatch:isMatch]];

    return isMatch;
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
            for (Card* chosenCard in _curChosenCards) {
                chosenCard.chosen = NO; // not any more
            }
            [_curChosenCards removeAllObjects]; // these cards are now out of play
            if (!scoredMatches) {
                // no match, but keep the last one chosen to make the game more interesting, add it back to our chosenCards
                [_curChosenCards addObject:card];
                card.chosen = YES; // just this one we added back
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

- (NSArray *)lastMatchedCardsHistory;
{
    CardMatchAttempt * lastAttempt = [self.cardMatchAttempts lastObject];
    
    return lastAttempt.cards;
}

- (NSArray *)cardMatchAttemptsHistory
{
    return [self.cardMatchAttempts copy];
}

- (NSInteger)lastScoreHistory
{
    CardMatchAttempt * lastAttempt = [self.cardMatchAttempts lastObject];
    
    return lastAttempt.score;
    
}

@end
