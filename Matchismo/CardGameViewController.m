//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "CardRenderingHelper.h"
#import "CardGameHistoryViewController.h"

@interface CardGameViewController ()
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic, readwrite) CardMatchingGame *game;

@property (strong, nonatomic) CardRenderingHelper *cardRenderingHelper;

// outlets
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playStatusLabel;

@end

@implementation CardGameViewController

#pragma mark - Accessors and Lazy Instantiation Helpers

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:self.deck];
    return _game;
}

- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck
{
    return nil; // This is now an abstract class
}

- (CardRenderingHelper *)cardRenderingHelper
{
    if (!_cardRenderingHelper) _cardRenderingHelper = [self createCardRenderingHelper];
    return _cardRenderingHelper;
}

- (CardRenderingHelper *)createCardRenderingHelper
{
    return nil; // This is now an abstract class
}

- (int)requiredCardsToMatch
{
    return 0; // this is not an abstract class
}

#pragma mark - View Notification Handlers nad IBActions

- (void)viewWillLayoutSubviews
{
    [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // The identifier itself is less relevent here, since this base class is handling multiple
    // views and their segues to a card game history view -- just check the kind of class on the
    // destination view controller
//    if ([segue.identifier isEqualToString:@"Match History"]) {
        if ([segue.destinationViewController isKindOfClass:[CardGameHistoryViewController class]]) {
            CardGameHistoryViewController *cardGameHistoryViewController = (CardGameHistoryViewController *)segue.destinationViewController;
            cardGameHistoryViewController.cardRenderingHelper = self.cardRenderingHelper;
            cardGameHistoryViewController.cardGameMatches = self.game.cardMatchAttemptsHistory; // todo: verify this .notation is legit at runtime
        }
//    }
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    if (0 == self.flipCount) {
        self.game.requiredMatches = [self requiredCardsToMatch];
    }
    
    NSUInteger chooseButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chooseButtonIndex];
    [self updateUI];
    
}
- (IBAction)touchResetButton:(UIButton *)sender {
    // reset the game and the UI
    self.flipCount = 0;
    [self.game dealNewGameWithCardCount:self.cardButtons.count];
    [self updateUI];
}

#pragma mark - UI Update and Helpers


- (void)updateUIStatusLabel
{
//    dd a text label somewhere which desribes the results of the last consideration by the CardMatchingGame of a card choice by the user. Examples: “Matched J♥ J♠ for 4 points.” or “6♦ J♣ don’t match! 2 point penalty!” or “8♦” if only one card is chosen or even blank if no cards are chosen.
//
    switch (self.game.gameStatus) {
        case NewDeal: self.playStatusLabel.text = @"";
            break;
            
        case CardChosen:
        case CardUnchosen:
        {
            self.playStatusLabel.attributedText = [self.cardRenderingHelper attributedStringFromCards:self.game.curChosenCards whenFaceUpOnly:YES];
            break;
        }
            
        case ScoredMatch:
        {
            // Builds the string
            NSMutableAttributedString *aLabelString = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
            [aLabelString appendAttributedString:[self.cardRenderingHelper attributedStringFromCards:[self.game lastMatchedCardsHistory] whenFaceUpOnly:NO]];
            NSString *endText = [NSString stringWithFormat:@" for %ld points.", (long)self.game.lastScoreHistory];
            [aLabelString appendAttributedString:[[NSAttributedString alloc] initWithString:endText]];
            
            self.playStatusLabel.attributedText = aLabelString;
            break;
        }
        
        case ScoredNoMatch:
        {
            NSMutableAttributedString *aLabelString = [[NSMutableAttributedString alloc] initWithAttributedString:[self.cardRenderingHelper attributedStringFromCards:[self.game lastMatchedCardsHistory] whenFaceUpOnly:NO]];

            [aLabelString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %ld point penalty!", (long)self.game.lastScoreHistory]]];
            self.playStatusLabel.attributedText = aLabelString;
            break;
        }
        
        default: self.playStatusLabel.text = @"???";
            break;
    }
    
}

- (void)updateUIScoreLabel
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",
                            (long)self.game.totalScore];
}

- (void)updateUIButtons
{
    // now update each button
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card* card = [self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setAttributedTitle:[self.cardRenderingHelper attributedStringFromCards:[NSArray arrayWithObject:card] whenFaceUpOnly:YES]
                              forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isOutOfPlay;
    }
}

- (void)updateUI
{
    [self updateUIStatusLabel];
    
    [self updateUIScoreLabel];
    
    [self updateUIButtons];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isFaceUp ? @"cardfront" : @"cardback"];
}

@end
