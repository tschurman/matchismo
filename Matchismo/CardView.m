//
//  CardView.m
//  Matchismo
//
//  Created by Tom Schurman on 10/8/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "CardView.h"

@implementation CardView

// Override designated initializer
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setup
{
    self.backgroundColor = nil; // same as clear
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.faceUp = NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawCardBackground];

}

const float CORNER_FONT_STANDARD_HEIGHT = 180.0;
const float CORNER_RADIUS = 12.0;

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

const float BACKGROUND_SELECTED_STROKE_WIDTH = 4.0;
const float BACKGROUND_DISABLED_ALPHA = 0.8;

- (void)drawCardBackground
{
    // Rounded corners on our white background card with a black line around
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    if (self.enabled) {
        [[UIColor whiteColor] setFill];
        self.alpha = 1.0f; // no alpha
    } else {
        self.alpha = BACKGROUND_DISABLED_ALPHA;
        [[UIColor grayColor] setFill];
    }
    
    UIRectFill(self.bounds);
    
    if (self.selected) {
        [[UIColor greenColor] setStroke];
        roundedRect.lineWidth = BACKGROUND_SELECTED_STROKE_WIDTH;
    } else {
        [[UIColor blackColor] setStroke];
    }
    [roundedRect stroke];
    
}


@end
