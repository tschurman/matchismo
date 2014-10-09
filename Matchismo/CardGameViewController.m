//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "CardGameViewController.h"

#import "CardMatchingGame.h"
#import "CardGridView.h"

// TESTING ONLY
#import "PlayingCardView.h"

@interface CardGameViewController ()
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic, readwrite) CardMatchingGame *game;

// outlets
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playStatusLabel;
@property (weak, nonatomic) IBOutlet CardGridView *cardGridView;

@end

@implementation CardGameViewController

#pragma mark - Accessors and Lazy Instantiation Helpers

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self cardsToDeal]
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

- (int)requiredCardsToMatch
{
    return 0; // this is not an abstract class
}


- (int)cardsToDeal
{
    return 1;
}


#pragma mark - View Notification Handlers nad IBActions

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create the PlayingCardView objects here. This is called only once, and we want to create and init all of our views
    // Note that this is different than setting up the display of all the views, which is drawing and drawing is later.
    
    // tell cardGridView to create the grid of cards
    [self.cardGridView createGridWithCount:[self cardsToDeal]];
    
    // for each button
    for (CardView *cardView in self.cardGridView.cardViewArray) {
        // ensure the cardView is enabled
        cardView.enabled = YES;
        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCardButton:)]];
    }
    
    [self updateUI];
    
}


- (void)touchCardButton:(UITapGestureRecognizer *)gesture
{
    if (0 == self.flipCount) {
        self.game.requiredMatches = [self requiredCardsToMatch];
    }
    
    NSUInteger chooseButtonIndex = [self.cardGridView.cardViewArray indexOfObject:gesture.view];
    [self.game chooseCardAtIndex:chooseButtonIndex];
    [self updateUI];
    
}

- (IBAction)touchResetButton:(UIButton *)sender {
    // reset the game and the UI
    self.flipCount = 0;
    [self.game dealNewGameWithCardCount:[self cardsToDeal]];
    [self updateUI];
}

#pragma mark - UI Update and Helpers

- (void)updateUIScoreLabel
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",
                            (long)self.game.totalScore];
}

- (void)updateUICardView:(CardView *)cardView withCard:(Card *)card
{
    // is there a better way to tie data to a view -- this seems like an extra layer of abstraction
    // that could be done in a different way -- say notifications?
    // This requires that our CardGameViewControllers know how to translate to the playing cards -- not the worst offense
    if (cardView.enabled && card.isOutOfPlay) {
        // Disable the UITapGestureNotification for this card -- it's out of play
        for (UIGestureRecognizer *gesture in cardView.gestureRecognizers) {
            gesture.enabled = NO;
        }
    } else if (!cardView.enabled && !card.isOutOfPlay) {
        // Card is coming into play - nsure we ahve a UITabGestureNotification for this cardView
        for (UIGestureRecognizer *gesture in cardView.gestureRecognizers) {
            gesture.enabled = YES;
        }
    }
    // else - nothing to do but ensure state is set propertly
    cardView.enabled = !card.isOutOfPlay;
    
    cardView.faceUp = card.faceUp;

    cardView.selected = card.chosen;
    
    [cardView setNeedsDisplay];
}

- (void)updateUIButtons
{
    // now update each button
    for (CardView * cardView in self.cardGridView.cardViewArray) {
        NSUInteger cardButtonIndex = [self.cardGridView.cardViewArray indexOfObject:cardView];
        Card* card = [self.game cardAtIndex:cardButtonIndex];
        
        [self updateUICardView:cardView withCard:card];
    }
}

- (void)updateUI
{
    [self updateUIScoreLabel];
    
    [self updateUIButtons];
}

@end
