//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
