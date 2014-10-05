//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        // As long as Objectve C guarnatees enums start at zero -- this nesting-looping works
        for(enum SetCardNumber number=0; number < SetCardNumberEnd; number++) {
            for (enum SetCardShade shade = 0; shade < SetCardShadeEnd; shade++) {
                for (enum SetCardColor color = 0; color < SetCardColorEnd; color++) {
                    for (enum SetCardShape shape = 0; shape < SetCardShapeEnd; shape++) {
                        SetCard *card = [[SetCard alloc] initWithShape:shape withColor:color withShade:shade withNumber:number];
                        [self addCard:card];
                    }
                }
            }
        }
        
    }
    return self;
}

@end
