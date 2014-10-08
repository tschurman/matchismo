//
//  SetCard.h
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
{
    // Each Set card is made up of a combination of these fixed properties
    // While they are "UI" in nature, we shall not use UI elements or contants
    // in our definition. These names here define the SetCard, and the controller will
    // determine how they should be rendered.
    
    NS_ENUM(char, SetCardShape) {
        SetCardShape1, // objective C guarantees this starts at 0
        SetCardShape2,
        SetCardShape3,
        
        SetCardShapeEnd // only for iteration, there are no cards with this value
    };
    
    NS_ENUM(char, SetCardColor) { // of the symbol
        SetCardColor1, // Objective C guarantees this starts at 0
        SetCardColor2,
        SetCardColor3,
        
        SetCardColorEnd // only for interation, is listed last, there are no cards with this value
    };

    NS_ENUM(char, SetCardShade) { // of the colored symbol
        SetCardShade1,  // Objective C guarnatees this starts at 0
        SetCardShade2, // Shaded between solid and no shading at all
        SetCardShade3,   // Just an outline
        
        SetCardShadeEnd     // only for iteration, is listed last, there are no cards with this value
    };
    
    NS_ENUM(char, SetCardNumber) { // o the colored shaded symbol
        SetCardNumber1,
        SetCardNumber2,
        SetCardNumber3,
        
        SetCardNumberEnd // only for iteration, is listed last, there are no cards with this value
    };

}

// The property array is made up of the following properties, set at initialization and unchanging after
@property (nonatomic, readonly) enum SetCardShape shape;
@property (nonatomic, readonly) enum SetCardColor color;
@property (nonatomic, readonly) enum SetCardShade shade;
@property (nonatomic, readonly) enum SetCardNumber number;

// Designated initializer -- note that once initialized, this card cannot be changed
- (instancetype)initWithShape:(enum SetCardShape)shape withColor:(enum SetCardColor)color withShade:(enum SetCardShade)shade withNumber:(enum SetCardNumber)number;

@end
