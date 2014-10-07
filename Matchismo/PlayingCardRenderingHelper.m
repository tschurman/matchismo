//
//  PlayingCardRenderingHelper.m
//  Matchismo
//
//  Created by Tom Schurman on 10/7/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "PlayingCardRenderingHelper.h"
#import "Card.h"

@implementation PlayingCardRenderingHelper


- (NSAttributedString *)attributedStringFromCards:(NSArray *)cards whenFaceUpOnly:(BOOL)whenFaceUpOnly
{
    NSMutableString *cardsDrawnString = [NSMutableString stringWithString:@""];
    for (Card* card in cards) {
        [cardsDrawnString appendFormat:@"%@", (!card.isFaceUp && whenFaceUpOnly) ? @"" : card.contents];
        if (card != cards.lastObject)
            [cardsDrawnString appendFormat:@" "];
    }
    return [[NSAttributedString alloc] initWithString:cardsDrawnString];
}


@end
