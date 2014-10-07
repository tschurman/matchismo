//
//  CardMatchAttempt.h
//  Matchismo
//
//  Created by Tom Schurman on 10/7/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardMatchAttempt : NSObject

@property (nonatomic, copy) NSArray *cards; // of Card
@property (nonatomic) int score; // score of this particular match/mis-match
@property (nonatomic, getter=isMatched) BOOL matched;

// Designated initializer
- (instancetype)initWithCards:(NSArray *)cards withScore:(int)score withMatch:(BOOL)matched;

@end
