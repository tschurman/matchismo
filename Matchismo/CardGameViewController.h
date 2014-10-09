//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@class CardMatchingGame;
@class CardRenderingHelper;

@interface CardGameViewController : UIViewController

@property (strong, nonatomic, readonly) CardMatchingGame *game;


// Abstract class that subclasses must override. Will return nil otherwise.
- (Deck *)createDeck;

// Anstract class that sublcasses must override. Will return nil here.
- (CardRenderingHelper *)createCardRenderingHelper;

// These are game settings, unique to the subclass that also creates the deck
- (int)requiredCardsToMatch; // returns 0 by default, which breaks things - override for use
- (int)cardsToDeal; // probably based on the view, but we'll let the subclass tell us

@end
