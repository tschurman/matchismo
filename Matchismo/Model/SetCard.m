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

#pragma mark - Overrides
- (NSString *)contents
{
    return nil; // we're too complicated to be represented by a mere string
}


#pragma mark - Matching/Scoring Methods


- (BOOL)isSetWithAllCards:(NSArray *)allCards
{
    BOOL isSet = YES;
    
    if (allCards.count < 2)
        return NO; // can't set with only 1 card
    
    for (int propertyIndex=0; propertyIndex<self.propertyArray.count && isSet; propertyIndex++) {
        
        // for each property in the property array...
        int test1, test2, test3;
        BOOL bTest;
        test1 = [[(SetCard *)allCards[0] propertyArray][propertyIndex] intValue];
        test2 = [[(SetCard *)allCards[1] propertyArray][propertyIndex] intValue];
        test3 = [[(SetCard *)allCards[2] propertyArray][propertyIndex] intValue];
        
        // Whether the property is the same or different - it must remain as such for all other card comparisons
        BOOL isSameDiff = ([(SetCard *)allCards[0] propertyArray][propertyIndex] == [(SetCard *)allCards[1] propertyArray][propertyIndex]);
        for (int primaryCardIndex = 0; primaryCardIndex<allCards.count-1 && isSet == YES; primaryCardIndex++) {
            // test each card for the same property comparison result -- if the result changes, we're not a set
            for (int secondaryCardIndex = 1; secondaryCardIndex<allCards.count && isSet; secondaryCardIndex++) {
                if (primaryCardIndex != secondaryCardIndex) {
                    bTest = ([(SetCard *)allCards[primaryCardIndex] propertyArray][propertyIndex] == [(SetCard *)allCards[secondaryCardIndex] propertyArray][propertyIndex]);
                    bTest = isSameDiff != bTest;
                    if (isSameDiff != ([(SetCard *)allCards[primaryCardIndex] propertyArray][propertyIndex] == [(SetCard *)allCards[secondaryCardIndex] propertyArray][propertyIndex])) {
                        isSet = NO;
                    }
                }
            }
        }
    }
    
    return isSet;
}

const int SET_BONUS_POINTS = 1;
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
        NSMutableArray *allCards = [NSMutableArray arrayWithArray:otherCards];
        [allCards addObject:self];
        
        // We only score if there is a SET
        BOOL isSet = [self isSetWithAllCards:allCards];
        
        // Now score it based on isSet.
        // Ideally all the scoring methodology is stored in one place and we use lookup messages to retrieve how we should score
        //
        self.score = isSet ? (int)allCards.count + SET_BONUS_POINTS : 0; // casting down to int for self.score - ok
        
    }

    return self.score;
}


@end

