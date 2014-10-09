//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "SetCardRenderingHelper.h"

@interface SetCardGameViewController()


// Outlets
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *playStatusLabel;

@end

@implementation SetCardGameViewController


- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (CardRenderingHelper *)createCardRenderingHelper
{
    return [[SetCardRenderingHelper alloc] init];
}

const int SET_GAME_REQUIRED_MATCHES_DEFAULT = 3;
- (int)requiredCardsToMatch
{
    return SET_GAME_REQUIRED_MATCHES_DEFAULT;
}

const int SET_GAME_CARDS_DEALT_DEFAULT = 20;
- (int)cardsToDeal
{
    return SET_GAME_CARDS_DEALT_DEFAULT;
}

#pragma mark - UI update methods and overrides


//- (void)updateUIButtons
//{
//    // Override the base class implementation to update the buttons
//    
//    // now update each button
//    for (UIButton *cardButton in self.cardButtons) {
//        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
//        Card* card = [self.game cardAtIndex:cardButtonIndex];
//        
//        // validate that the card is indeed a SetCard
//        if (![card isKindOfClass:[SetCard class]])
//            continue; // continue looping through the cardButtons to find SetCard
//        
//        SetCard *setCard = (SetCard *)card; // safe after check above
//        
//        NSAttributedString *aTitle = [self.renderingCardHelper attributedCardLabelFromSetCard:setCard];
//        
//        [cardButton setAttributedTitle:aTitle forState:UIControlStateNormal];
//        
//        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
//                              forState:UIControlStateNormal];
//
//        cardButton.enabled = !card.isOutOfPlay;
//    }
//}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    // override
    return [UIImage imageNamed:card.isChosen ? @"cardfrontalt" : @"cardfront"];
}


@end
