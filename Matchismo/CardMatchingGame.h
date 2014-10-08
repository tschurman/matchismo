//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"


@interface CardMatchingGame : NSObject

{
    NS_ENUM(char, Status) {
        NewDeal,
        CardChosen,
        CardUnchosen,
        ScoredMatch,
        ScoredNoMatch
    };
}

@property (nonatomic) NSInteger requiredMatches; // 2 - n; default is 2, can be changed via contoller if so desired

@property (nonatomic, readonly) enum Status gameStatus; // Current status of the game as presented by the game
@property (nonatomic, readonly) NSInteger totalScore; // current total score of the game
@property (nonatomic, readonly) NSArray *curChosenCards; // of Card, a copy of the current "chosen" cards that are not matched; i.e. part of a sequence of cards lifted from the table by the player

// Designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

// will end the current game and start a new game, returning all played cards to the deck set at initialization
- (BOOL)dealNewGameWithCardCount:(NSUInteger)count;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

- (NSInteger)lastScoreHistory; // the points +/- scored in the last match attempt; same as calling [cardMatchAttemptsHistory lastObject].score
- (NSArray *)lastMatchedCardsHistory; // of Card; a copy of the cards attempted in the last match; same as calling [cardMatchAttemptsHistory lastObject].cards
- (NSArray *)cardMatchAttemptsHistory; // of CardMatchAttempt; a copy of the history of all match/mis-matches -- this could be excessive copying, but this will change with every match

@end
