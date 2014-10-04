//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// Abstract class that subclasses must override. Will return NULL otherwise.
- (Deck *)createDeck;


@end
