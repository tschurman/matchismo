//
//  CardGameHistoryViewController.h
//  Matchismo
//
//  Created by Tom Schurman on 10/4/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardRenderingHelper;

@interface CardGameHistoryViewController : UIViewController

@property (nonatomic, strong) NSArray *cardGameMatches;
@property (nonatomic, weak) CardRenderingHelper *cardRenderingHelper;

@end
