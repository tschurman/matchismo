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

const int SET_GAME_REQUIRED_MATCHES_DEFAULT = 3;
- (int)requiredCardsToMatch
{
    return SET_GAME_REQUIRED_MATCHES_DEFAULT;
}

#pragma mark - UI update methods and overrides

- (NSAttributedString *)attributedStringFromCards:(NSArray *)curChosenCards
{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *aSpace = [[NSAttributedString alloc] initWithString:@" "];
    
    for (Card* card in curChosenCards) {
        // validate that the card is indeed a SetCard
        if (![card isKindOfClass:[SetCard class]])
            continue; // continue looping to find SetCard
        
        SetCard *setCard = (SetCard *)card; // safe after check above
        
        // We need to get the attributed text for each card, then append them in a string (i.e. set a range in cardsDrawnString
        // that corresponds to the text we want to format).
        [aString appendAttributedString:[self attributedCardLabelFromSetCard:setCard]];
        [aString appendAttributedString:aSpace];
    }
    
    return aString;
}

- (void)updateUIButtons
{
    // Override the base class implementation to update the buttons
    
    // now update each button
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card* card = [self.game cardAtIndex:cardButtonIndex];
        
        // validate that the card is indeed a SetCard
        if (![card isKindOfClass:[SetCard class]])
            continue; // continue looping through the cardButtons to find SetCard
        
        SetCard *setCard = (SetCard *)card; // safe after check above
        
        NSAttributedString *aTitle = [self attributedCardLabelFromSetCard:setCard];
        
        [cardButton setAttributedTitle:aTitle forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];

        cardButton.enabled = !card.isOutOfPlay;
    }
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    // override
    return [UIImage imageNamed:card.isChosen ? @"cardfrontalt" : @"cardfront"];
}

- (NSAttributedString *)attributedCardLabelFromSetCard:(SetCard *)setCard
{
    // Set the shape temprorarily as the given ASCII shapes below.
    // define this here because it's not used anywhere else
    NSArray *shapeArray = @[@"■", @"◆", @"●"];
    
    // Note that we map here -- the "shape" is a state of the card, not UI
    NSMutableString *title = [[NSMutableString alloc] init];
    
    // We'll use newlines, if possible to show 1, 2 or 3 of them
    for (int n = 0; n<=setCard.number; n++)
        [title appendFormat:@"%@", shapeArray[setCard.shape]];
    
    // Now we need to set the color, shading and outlining via NSAttributedString
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
    // Color the shapes
    switch (setCard.color) {
        case SetCardColorRed:
            [attrs setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
            [attrs setObject:[UIColor redColor] forKey:NSStrokeColorAttributeName];
            break;
        case SetCardColorGreen:
            [attrs setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
            [attrs setObject:[UIColor greenColor] forKey:NSStrokeColorAttributeName];
            break;
        case SetCardColorPurple:
            [attrs setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
            [attrs setObject:[UIColor purpleColor] forKey:NSStrokeColorAttributeName];
            break;
            
        case SetCardColorEnd:
        default:
            // leave it black
            [attrs setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
            [attrs setObject:[UIColor blackColor] forKey:NSStrokeColorAttributeName];
            break;
    }
    
    // Set outline/shading
    switch (setCard.shade) {
        case SetCardShadeSolid:
            [attrs setObject:[[attrs objectForKey:NSForegroundColorAttributeName] colorWithAlphaComponent:1.0]
                      forKey:NSForegroundColorAttributeName];
            [attrs setObject:@0 forKey:NSStrokeWidthAttributeName];
            break;
        case SetCardShadeShaded:
            [attrs setObject:[[attrs objectForKey:NSForegroundColorAttributeName] colorWithAlphaComponent:0.2]
                      forKey:NSForegroundColorAttributeName];
            [attrs setObject:@0 forKey:NSStrokeWidthAttributeName];
            break;
        case SetCardShadeNone:
            // operate on the color at key NSForegroundColorAttributeName using UIColor selector: colorWithAlphaComponent:0.n -- see what happens...lol
            [attrs setObject:[[attrs objectForKey:NSForegroundColorAttributeName] colorWithAlphaComponent:0.0]
                      forKey:NSForegroundColorAttributeName];
            [attrs setObject:@5 forKey:NSStrokeWidthAttributeName];
            break;
            
        case SetCardShadeEnd:
        default:
            // This should probably throw an exception since there is no way to actually
            // present a non shaded thing
            break;
    }
    
    // For now we'll use symbols to map the cards defined
    return [[NSAttributedString alloc] initWithString:title attributes:attrs];
    
}

@end
