//
//  SetCard.m
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "SetCard.h"

@interface SetCard()
@property (nonatomic, readwrite) enum SetCardShape shape;
@property (nonatomic, readwrite) enum SetCardColor color;
@property (nonatomic, readwrite) enum SetCardShade shade;
@property (nonatomic, readwrite) enum SetCardNumber number;

@property (nonatomic) NSArray *propertyArray;

@end

@implementation SetCard

#pragma mark - Class methods

const int MAX_SET_NUMBER = 3;

+ (int)maxNumber
{
    return MAX_SET_NUMBER; // magic?
}


#pragma mark - Initializers
// Designated initializer -- note that once initialized, this card cannot be changed
- (instancetype)initWithShape:(enum SetCardShape)shape withColor:(enum SetCardColor)color withShade:(enum SetCardShade)shade withNumber:(enum SetCardNumber)number
{
    self = [super init];
    if (self) {
        // ensure that these cards are dealt face-up by default, this overrides super init
        self.faceUp = YES;
        
        self.shape = shape;
        self.color = color;
        self.shade = shade;
        self.number = number;
        
        _propertyArray = @[[NSNumber numberWithInt:self.shape],
                           [NSNumber numberWithInt:self.color],
                           [NSNumber numberWithInt:self.shade],
                           [NSNumber numberWithInt:self.number]];
    }

    return self;
}

#pragma mark - overrides
- (NSString *)contents
{
    return nil; // we're too complicated to be represented by a mere string
}


#pragma mark - Matching/Scoring Methods


- (BOOL)isSetWithCards:(NSArray *)otherCards
{
    BOOL isSet = YES;

    for (int propertyIndex=0; propertyIndex<self.propertyArray.count && isSet; propertyIndex++) {
        // for each property in the property array...
        BOOL isSame = self.propertyArray[propertyIndex] == [(SetCard *)otherCards propertyArray][propertyIndex]; // init to test for same/different

        // test each card for the same property comparison result -- if the result changes, we're not a set
        for (int cardIndex = 1; cardIndex<otherCards.count && isSet; cardIndex++) {
            if (isSame != (self.propertyArray[propertyIndex] == [(SetCard *)otherCards[cardIndex] propertyArray][propertyIndex])) {
                isSet = NO;
            }
        }
    }
    
    return isSet;
}

- (int)match:(NSArray *)otherCards
{
    // ignoring super implementation of match, overriding completely
    
    // Score based on possible matches according to the rules of SET
    // SET requires that in a given set of cards, each feature must be either all
    // the same or all different. If there is any n-1 of one property, but not the nth, it is not
    // a SET.
    
    // For scoring, we will score a point per card. It's simpler.
    
    // We will not assume a specific number of cards
    
    if ([otherCards count] > 0) {
       
        // We only score if there is a SET
        BOOL isSet = [self isSetWithCards:otherCards];
        
        // Now score it based on isSet
        self.score = isSet ? (int)otherCards.count + 1 : 0; // casting down to int for self.score - ok
        
    }

    return self.score;
}


@end

