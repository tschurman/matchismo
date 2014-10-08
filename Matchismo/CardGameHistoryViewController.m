//
//  CardGameHistoryViewController.m
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "CardGameHistoryViewController.h"
#import "CardRenderingHelper.h"
#import "CardMatchAttempt.h"

@interface CardGameHistoryViewController()

@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation CardGameHistoryViewController

- (void)viewWillLayoutSubviews
{
    // Set the text views attributed string with the matches provided, oldest at top of text
    // separate with newlines
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] init];
    int count = 1;
    if (self.cardGameMatches.count == 0) {
        [aString appendAttributedString:[[NSAttributedString alloc] initWithString:@"No history to report!"]];
        
    } else { // let's format the history
        
        for (CardMatchAttempt *matchAttempt in self.cardGameMatches) {
            [aString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d) ", count++]]];
            
            if (matchAttempt.isMatched) {
                NSMutableAttributedString *aLabelString = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
                [aLabelString appendAttributedString:[self.cardRenderingHelper attributedStringFromCards:matchAttempt.cards whenFaceUpOnly:NO]];
                NSString *endText = [NSString stringWithFormat:@" for %ld points.\n", (long)matchAttempt.score];
                [aLabelString appendAttributedString:[[NSAttributedString alloc] initWithString:endText]];
                
                [aString appendAttributedString:aLabelString];
                
            } else { // no match
                NSMutableAttributedString *aLabelString = [[NSMutableAttributedString alloc] initWithAttributedString:[self.cardRenderingHelper attributedStringFromCards:matchAttempt.cards whenFaceUpOnly:NO]];
                
                [aLabelString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %ld point penalty!\n", (long)matchAttempt.score]]];

                [aString appendAttributedString:aLabelString];
            }
        
        }
    }
    self.historyTextView.attributedText = aString;
    NSRange scrollEnd = {self.historyTextView.textStorage.length-1, 1};
    [self.historyTextView scrollRangeToVisible:scrollEnd];
}


@end
