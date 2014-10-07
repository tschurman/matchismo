//
//  CardRenderingHelper.h
//  Matchismo
//
//  Created by Tom Schurman on 10/7/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;
@interface CardRenderingHelper : NSObject

// Abstract call that must be implemented by the subclass
// Simply offers methods to help determine the representation of a Card
// Set whenFaceUp to YES when it matters if the card is face-up or face-down
//                to NO to get the card contents regardless of being shown or not
- (NSAttributedString *)attributedStringFromCards:(NSArray *)cards whenFaceUpOnly:(BOOL)whenFaceUp;


@end
