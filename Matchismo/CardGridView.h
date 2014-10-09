//
//  CardGridView.h
//  Matchismo
//
//  Created by Tom Schurman on 10/8/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardView;

@interface CardGridView : UIView

// create the grid
- (void)createGridWithCount:(int)count;

// access the cardViewArray directly
- (NSArray *)cardViewArray; // of CardView

// abstract - subclasses should override to create the desired CardView
- (CardView *)createCardViewWithFrame:(CGRect)frame;

@end
