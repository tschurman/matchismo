//
//  PlayingCardGridView.m
//  Matchismo
//
//  Created by Tom Schurman on 10/8/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "PlayingCardGridView.h"
#import "PlayingCardView.h"

@implementation PlayingCardGridView

- (CardView *)createCardViewWithFrame:(CGRect)frame
{
    return [[PlayingCardView alloc] initWithFrame:frame];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
