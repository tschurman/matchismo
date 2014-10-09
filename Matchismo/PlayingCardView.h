//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Tom Schurman on 10/8/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) BOOL faceUp;

@end
