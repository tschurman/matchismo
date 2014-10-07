//
//  CardMatchAttempt.m
//  Matchismo
//
//  Created by Tom Schurman on 10/7/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "CardMatchAttempt.h"

@implementation CardMatchAttempt

// Designated initializer
- (instancetype)initWithCards:(NSArray *)cards withScore:(int)score withMatch:(BOOL)matched
{
    self = [super init];
    
    if (self) {
        self.cards = cards;
        self.score = score;
        self.matched = matched;
    }
    
    return self;
}


@end
