//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"

@interface SetCardGameViewController()

@property (strong, nonatomic) Deck *deck;


// Outlets
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation SetCardGameViewController


- (Deck *)createDeck
{
    _deck = [[SetCardDeck alloc] init];
    return _deck;
}

const int SET_GAME_REQUIRED_MATCHES_DEFAULT = 3;
- (int)requiredCardsToMatch
{
    return SET_GAME_REQUIRED_MATCHES_DEFAULT;
}

- (void)updateUIButtons // override the super class implementation
{
    
    // now update each button
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card* card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:@"Test" forState:UIControlStateNormal];
        

        //        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
//        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
//                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isOutOfPlay;
    }
}


@end
