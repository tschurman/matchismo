//
//  CardView.h
//  Matchismo
//
//  Created by Tom Schurman on 10/8/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardView : UIView

@property (nonatomic) BOOL enabled; // set to NO to "disable" in appearance and action
@property (nonatomic) BOOL faceUp; // set to YES when the view should display the card contents - subclass implements drawing
@property (nonatomic) BOOL selected; // set to YES when the view should display a "selected" state

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;


@end
