//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardRenderingHelper.h"

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (CardRenderingHelper *)createCardRenderingHelper
{
    return [[PlayingCardRenderingHelper alloc] init];
}


const int GAME_REQUIRED_MATCHES_DEFAULT = 2;
- (int)requiredCardsToMatch
{
    return GAME_REQUIRED_MATCHES_DEFAULT;
}

const int PLAYING_GAME_CARDS_DEALT_DEFAULT = 20;
- (int)cardsToDeal
{
    return PLAYING_GAME_CARDS_DEALT_DEFAULT;
}

@end
