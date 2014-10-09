//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "PlayingCardGameViewController.h"

#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
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

- (void)updateUICardView:(CardView *)cardView withCard:(Card *)card
{
    [super updateUICardView:cardView withCard:card];
    
    // see notes in base class
    if (![card isKindOfClass:[PlayingCard class]])
        return;

    if (![cardView isKindOfClass:[PlayingCardView class]])
        return;

    PlayingCard* playingCard = (PlayingCard *)card;
    PlayingCardView* playingCardView = (PlayingCardView *)cardView;
    
    playingCardView.suit = playingCard.suit;
    playingCardView.rank = playingCard.rank;
    
}

@end
