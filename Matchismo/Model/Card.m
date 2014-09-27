//
//  Card.m
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "Card.h"

@implementation Card

- (void)reset
{
    self.chosen = NO;
    self.matched = NO;
    self.lastCardsMatched = nil;
    self.outOfPlay = NO;
    self.score = 0;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents])
            score = 1;
    }
    
    self.score = score;
    return score;
}

@end
