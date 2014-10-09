//
//  PlayingCardView.m
//  Matchismo
//
//  Created by Tom Schurman on 10/8/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation PlayingCardView

#pragma mark - Initialization

-(void)setup
{
    self.backgroundColor = nil; // same as clear
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

// Override designated initializer
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
    }
    
    return self;
}

#pragma mark - Accessors
- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

@synthesize faceCardScaleFactor = _faceCardScaleFactor;
const float DEFAULT_FACE_CARD_SCALE_FACTOR = 0.85;
- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.faceUp) {
        [self drawCardBackground];
        
        [self drawCardCornerLabels];
        
        [self drawCardFace];
        
    } else {
        // Just draw the back of the card
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
    
}

// These numbers and the supporting methods are estimates, subject to visual inspection and adjustment accordingly
const float CORNER_FONT_STANDARD_HEIGHT = 180.0;
const float CORNER_RADIUS = 12.0;

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawCardBackground
{
    // Rounded corners on our white background card with a black line around
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];

}

- (NSString *)rankAsString
{
    NSArray * rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    if (self.rank < rankStrings.count)
        return rankStrings[self.rank];
    else
        return @"";
}

- (void)drawCardCornerLabels
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    // flip it and move it down to the opposite corner
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI); // flip half a circle
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawCardFace
{
    UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], [self suit]]];
    if (faceImage) {
        CGRect imageRect = CGRectInset(self.bounds,
                                        self.bounds.size.width * (1.0-self.faceCardScaleFactor), // a nice offset from the corner labels
                                        self.bounds.size.height * (1.0-self.faceCardScaleFactor)); // a nice offset from the corner labels
        [faceImage drawInRect:imageRect];
    } else {
        [self drawCardPips];
    }
}

#pragma mark - Pips

const float PIP_HOFFSET_PERCENTAGE = 0.165;
const float PIP_VOFFSET1_PERCENTAGE = 0.090;
const float PIP_VOFFSET2_PERCENTAGE = 0.175;
const float PIP_VOFFSET3_PERCENTAGE = 0.270;

- (void)drawCardPips
{
    // The course leture has this built with long if statements. I thought this was simpler to follow with mini switch statements
    //
    switch (self.rank) {
        case 1: case 3: case 5: case 9:
            [self drawPipsWithHorizontalOffset:0
                                verticalOffset:0
                            mirroredVertically:NO];
            break;
            
        case 6: case 7: case 8:
            [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                                verticalOffset:0
                            mirroredVertically:NO];
            break;
        default: break; // do nothing
    }
    
    switch (self.rank) {
        case 2: case 3: case 7: case 8: case 10:
            [self drawPipsWithHorizontalOffset: 0
                                verticalOffset:PIP_VOFFSET2_PERCENTAGE
                            mirroredVertically:(self.rank != 7)];
            break;
        default: break; // do nothing
    }
    
    switch (self.rank) {
        case 4: case 5: case 6: case 7: case 8: case 9: case 10:
            [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                                verticalOffset:PIP_VOFFSET3_PERCENTAGE
                            mirroredVertically:YES];
            break;
        default: break; // do nothing
    }
    
    switch (self.rank) {
        case 9: case 10:
            [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                               verticalOffset:PIP_VOFFSET1_PERCENTAGE
                           mirroredVertically:YES];
            break;
        default: break; // do nothing
    }
}

const float PIP_FONT_SCALE_FACTOR = 0.012;

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset upsideDown:(BOOL)upsideDown
{
    if (upsideDown) [self pushContextAndRotateUpsideDown];
    
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{NSFontAttributeName : pipFont}];
    CGSize pipSize = attributedSuit.size;
    CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width/2.0 - hoffset*self.bounds.size.width,
                                    middle.y - pipSize.height/2.0 - voffset*self.bounds.size.height);
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
    }
}

@end
