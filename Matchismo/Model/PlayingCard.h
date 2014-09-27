//
//  PlayingCard.h
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

// Our definition of a playing card is a traditional
// poker card with one of 4 suits, and one of the
// traditional ranks A, 2, 3, ... 10, J, Q, K
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

// Class methods to return the array of suits and ranks supported
// by this basic playing card
+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
