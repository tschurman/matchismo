//
//  PlayingCard.m
//  Matchismo
//
//  Created by Tom Schurman on 9/16/14.
//  Copyright (c) 2014 Tom Schurman. All rights reserved.
//

#import "PlayingCard.h"


@implementation PlayingCard


// a LOT of assumptions here about the playing card deck....baaaaaad
// but the assignment says we shouldn't be changing multipliers, etc.
// let's assume then that "PlayingCard" - is a traditional 52-card poker card playing card.
static const int MAX_RANK_MATCHES = 3;
static const int MAX_SUIT_MATCHES = 13;
static const int rankMatchScores[MAX_RANK_MATCHES+1] = {0, 12, 50, 250};
static const int suitMatchScores[MAX_SUIT_MATCHES+1] = {0, 2, 4, 8, 15, 25, 50, 100, 175, 200, 300, 500, 750, 1000};
static const int DRAW_PENALTY_MULTIPLIER = 1; // plus draws >3

#pragma mark - Getter and Description overrides

- (NSString *)description
{
    return self.contents;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

#pragma mark - Class Methods

+ (NSUInteger)maxRank
{
    return [[PlayingCard rankStrings] count] - 1;
}

+ (NSArray *)validSuits
{
    return @[@"♤",@"♡",@"♧",@"♢"]; //
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
             @"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

#pragma mark - Scoring Methods

- (int)scoreSuitMatchesWithOtherCards:(NSArray *)otherCards
{
    // we know which cards are chosen
    // we are only called when all the choices have been made and it's time to score
    //
    int suitScore = 0;
    int numSuitMatches = 0;
    for (PlayingCard *otherCard in otherCards) {
        
        if (otherCard.suit == self.suit) {
            numSuitMatches++;
        }
    }
    
    // assert if numSuitMatches > 13
    if (numSuitMatches > MAX_SUIT_MATCHES) {
        NSLog(@"Somebody added more cards to the deck. Scoring is broken. numSuitMatches: %d",
              numSuitMatches);
        numSuitMatches = MAX_SUIT_MATCHES;
    }
    
    suitScore = suitMatchScores[numSuitMatches];
    
    //penalize based on total cards drawn
    int suitPenalty = ((int)[otherCards count] - numSuitMatches) * DRAW_PENALTY_MULTIPLIER;
    
    suitScore -= suitPenalty;
    
    return suitScore;
}

- (int)scoreRankMatchesWithOtherCards:(NSArray *)otherCards
{
    int rankScore = 0;
    
    // score only this card in relation to the otherCards given
    // thus we are scoring ourseves only based on the match
    
    int numRankMatches = 0;
    
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.rank == self.rank) {
            numRankMatches++;
        }
    }
    
    // assert if numRankMatches > 2
    if (numRankMatches > MAX_RANK_MATCHES){
        NSLog(@"Somebody added more cards to the deck. Scoring is broken. numRankMatches: %d",
              numRankMatches);
        numRankMatches =MAX_RANK_MATCHES;
    }
    rankScore = rankMatchScores[numRankMatches];
    
    // penalize based on total cards drawn - case is OK, until we have a game that exceeds 32k cards
    int rankPenalty = ((int)[otherCards count] - numRankMatches) * DRAW_PENALTY_MULTIPLIER;
    
    if ( 0 != rankPenalty)
        rankScore /= rankPenalty; // penalty is more severe for these matches than suits
    
    return rankScore;
}

#pragma mark - Matching Methods

- (void)setCardsMatchedBySuitWithCards:(NSArray *)otherCards
{
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.suit == self.suit) {
            [self.lastCardsMatched addObject:otherCard];
        }
    }
}

- (void)setCardsMatchedByRankWithCards:(NSArray *)otherCards
{
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.rank == self.rank) {
            [self.lastCardsMatched addObject:otherCard];
        }
    }
}

- (int)match:(NSArray *)otherCards
{
    // ignoring super implementation of match, overriding completely
    
    // score with new scoring system not just on one other single card
    // but on any number of passed cards
    if ([otherCards count] > 0) {
        int rankScore = [self scoreRankMatchesWithOtherCards:otherCards];
        int suitScore = [self scoreSuitMatchesWithOtherCards:otherCards];

        if (rankScore >= suitScore) {
            [self setCardsMatchedByRankWithCards:otherCards];
            self.score = rankScore;
            
        } else {
            [self setCardsMatchedBySuitWithCards:otherCards];
            self.score = suitScore;
        }
    }
    
//    // for now match only a single other card
//    if (1 == [otherCards count]) {
//        PlayingCard *otherCard = [otherCards firstObject];
//        if (otherCard.rank == self.rank) {
//            score = 4;
//        } else if ([otherCard.suit isEqualToString:self.suit]) {
//            score = 1;
//        }
//    }
    
    return self.score;
}

@end
