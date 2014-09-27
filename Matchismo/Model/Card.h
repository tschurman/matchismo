//
//  Card.h
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

// A card has contents that may or may not be the description
// by default, this is the description
// The contents can be anything, and operated on by owners
// for whatever purposes subclassed by design.
@property (strong, nonatomic) NSString *contents;

// A card can be "chosen" as a state in some context
@property (nonatomic, getter = isChosen) BOOL chosen;

// a card can be "matched" as a state in some context
// with other cards, or perhaps non-cards
@property (nonatomic, getter = isMatched) BOOL matched;
// A card keeps a weak link to other cards to which it may be matched, may be nil if no matches
@property (nonatomic, weak) NSMutableArray *lastCardsMatched;

// a card can be in-play or "out of play" in some context
@property (nonatomic, getter = isOutOfPlay) BOOL outOfPlay;

// A card also has a score
@property (nonatomic) int score;

- (void)reset;

- (int)match:(NSArray *)otherCards;



@end
