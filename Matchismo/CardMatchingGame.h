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

// Designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

// will end the current game and start a new game using the deck of cards set when the game was created
- (BOOL)resetGameWithCardCount:(NSUInteger)count;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

- (NSArray *) getLastMatchedCards;

@property (nonatomic) NSInteger requiredMatches; // 2 - n; default is 2
@property (nonatomic) enum Status gameStatus;

@property (nonatomic, readonly) NSInteger totalScore;
@property (nonatomic) NSInteger lastScore;
@property (nonatomic, readonly) NSArray *lastChosenCards; // of Card, for a given round
@property (nonatomic, readonly) NSArray *curChosenCards; // of Card, for the current selections


@end
