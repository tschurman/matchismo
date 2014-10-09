//
//  CardGridView.m
//  Matchismo
//
//  Created by Tom Schurman on 10/8/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "CardGridView.h"
#import "CardView.h"
#import "Grid.h"

@interface CardGridView()

@property (nonatomic) NSMutableArray *cardViews; // of CardView
@property (nonatomic) Grid *grid;

@end

@implementation CardGridView

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

- (Grid *)grid
{
    if (!_grid) _grid = [[Grid alloc] init];
    return _grid;
}

const float CARD_GRID_CELL_USE_PERCENTAGE_Y = 0.95; // leave some separation between cards, 1.0 means cards are touching edges
const float CARD_GRID_CELL_USE_PERCENTAGE_X = 0.92;
const NSUInteger CARD_GRID_IDEAL_ASPECT_WIDTH = 5; // 2 / 3 is ideal, but this seems to use space more judiciously
const NSUInteger CARD_GRID_IDEAL_ASPECT_HEIGHT = 6;

// create the grid
- (void)createGridWithCount:(int)count
{
    // set the grid parameters
    self.grid.size = self.bounds.size;
    self.grid.cellAspectRatio = (CGFloat)CARD_GRID_IDEAL_ASPECT_WIDTH / (CGFloat)CARD_GRID_IDEAL_ASPECT_HEIGHT;
    self.grid.minimumNumberOfCells = count; // TODO: Remove - TEst only code
    
    self.grid.maxColumns = [self idealMaxColumnsFromNumberOfCells:self.grid.minimumNumberOfCells];
    
    if (!self.grid.inputsAreValid) {
        NSLog(@"Grid inputs are invalid. Size(w:%f h:%f) Aspect(%f) Cells(%d)", self.bounds.size.width, self.bounds.size.height, self.grid.cellAspectRatio, count);
        return;
    }
    int rowIndex = 0;
    int colIndex = 0;
    for (int i=0; i<count; i++) {
        CGRect cardFrameRect = CGRectMake([self.grid frameOfCellAtRow:rowIndex inColumn:colIndex].origin.x,
                                          [self.grid frameOfCellAtRow:rowIndex inColumn:colIndex].origin.y,
                                          [self.grid frameOfCellAtRow:rowIndex inColumn:colIndex].size.width * CARD_GRID_CELL_USE_PERCENTAGE_X,
                                          [self.grid frameOfCellAtRow:rowIndex inColumn:colIndex].size.height * CARD_GRID_CELL_USE_PERCENTAGE_Y);
        CardView *cardView = [self createCardViewWithFrame:cardFrameRect];
        if (cardView) {
            [self addSubview:cardView];
            [self.cardViews addObject:cardView];

            if (YES == [self incrementGridRowIndex:&rowIndex byColumnIndex:&colIndex] && i+1<count) {
                NSLog(@"Unexpectedly out of grid slots at card index (%d) with count (%d)", i, count);
            }
        }
    }
    
    if (self.cardViews.count > 0)
        [self setNeedsDisplay];
}

// will return YES if incrementing wrapped around to 0,0
- (BOOL)incrementGridRowIndex:(int *)rowIndex byColumnIndex:(int *)colIndex
{
    BOOL ret = NO;
    (*colIndex)++;
    if (*colIndex == self.grid.columnCount) {
        *colIndex = 0;
        (*rowIndex)++;
        
        if (*rowIndex == self.grid.rowCount) {
            *rowIndex = 0;
            ret = YES;
        }
    }
    return ret;
}

const double GRID_CARD_FLOAT_ROUNDING_ERROR = 0.0001;
- (NSUInteger)idealMaxColumnsFromNumberOfCells:(NSUInteger)minimumNumberOfCells
{
    NSUInteger maxColumns = 0;
    const double idealRatio = (double)CARD_GRID_IDEAL_ASPECT_WIDTH / (double)CARD_GRID_IDEAL_ASPECT_HEIGHT;
    NSMutableArray *bigFactors = [NSMutableArray arrayWithObject:[NSNumber numberWithUnsignedInteger:minimumNumberOfCells]];
    NSMutableArray *smallFactors = [NSMutableArray arrayWithObject:[NSNumber numberWithUnsignedInteger:1]];
    
    // The best grid layout is screen relative, based on how we're configured.
    // Ideally this is based on the aspect ratio
    // so pick the two factors whose ratio is closest to the ideal aspect ratio
    
    NSUInteger n = 2;
    maxColumns = ((NSNumber *)[bigFactors firstObject]).unsignedIntegerValue;
    double lastBestRatioDifference = idealRatio - (((double)minimumNumberOfCells / (double)maxColumns) / (double)maxColumns);
    while(n < ((NSNumber *)[bigFactors lastObject]).unsignedIntegerValue) {
        NSUInteger test = minimumNumberOfCells % n;
        if (test == 0) {
            [bigFactors addObject:[NSNumber numberWithUnsignedInteger:minimumNumberOfCells / n]];
            [smallFactors addObject:[NSNumber numberWithUnsignedInteger:n]];
            
            if (ABS(idealRatio - (double)n / ((double)minimumNumberOfCells / (double)n)) <= lastBestRatioDifference + GRID_CARD_FLOAT_ROUNDING_ERROR) {
                maxColumns = (minimumNumberOfCells / n);
                lastBestRatioDifference = (double)n / (double)maxColumns;
            }
        }
        n++;
    }
    
    
    return maxColumns;
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
