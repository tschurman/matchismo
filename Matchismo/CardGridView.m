//
//  CardGridView.m
//  Matchismo
//
//  Created by Tom Schurman on 10/8/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "CardGridView.h"
#import "CardView.h"

@interface CardGridView()

@property (nonatomic) NSMutableArray *cardViews; // of CardView

@end

@implementation CardGridView

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

// create the grid
- (void)createGridWithCount:(int)count
{

    // TODO: layout the full count. For now, prove we can create one
    CGRect rectFrame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 172, 256);
    CardView *cardView = [self createCardViewWithFrame:rectFrame];
    if (cardView) {
        [self addSubview:cardView];
        [self.cardViews addObject:cardView];
    }
    
    rectFrame.origin.x += 176;
    rectFrame.size.width /= 2;
    rectFrame.size.height /=2;
    cardView = [self createCardViewWithFrame:rectFrame];
    if (cardView) {
        [self addSubview:cardView];
        [self.cardViews addObject:cardView];
    }

    rectFrame.origin.y += rectFrame.size.height;
    rectFrame.size.width /= 2;
    rectFrame.size.height /=2;
    cardView = [self createCardViewWithFrame:rectFrame];
    if (cardView) {
        [self addSubview:cardView];
        [self.cardViews addObject:cardView];
    }

    if (self.cardViews.count > 0)
        [self setNeedsDisplay];
}

// access the cardViewArray directly
- (NSArray *)cardViewArray
{
    return [self.cardViews copy];
}

- (CardView *)createCardViewWithFrame:(CGRect)frame
{
    return nil;
}


@end
