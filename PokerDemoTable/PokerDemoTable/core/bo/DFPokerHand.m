//
//  DFPokerHand.m
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import "DFPokerHand.h"
#import "DFPlayerMove.h"
NSString *const kDFPokerHandMoveDelay = @"moveDelay";
NSString *const kDFPokerHandId = @"id";
NSString *const kDFPokerHandName = @"name";
NSString *const kDFPokerHandNumberOfPlayers = @"numberOfPlayers";
NSString *const kDFPokerHandHandStakes = @"handStakes";
NSString *const kDFPokerHandPlayerMoves = @"playerMoves";
NSString *const kDFPokerHandSmallBlind = @"smallBlind";
NSString *const kDFPokerHandBigBlind = @"bigBlind";
NSString *const kDFPokerHands = @"scenarios";

@interface DFPokerHand ()
@property (nonatomic) NSInteger currentMove;
@end

@implementation DFPokerHand


- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        _currentMove  = NSNotFound;
        _name = dict[kDFPokerHandName];
        _moveDelay = [dict[kDFPokerHandMoveDelay] doubleValue];
        _scenarioIdentifier = dict[kDFPokerHandId];
        _numberOfPlayers = [dict[kDFPokerHandNumberOfPlayers] unsignedIntegerValue];
        _smallBlind = [dict[kDFPokerHandHandStakes][kDFPokerHandSmallBlind] doubleValue];
        _bigBlind = [dict[kDFPokerHandHandStakes][kDFPokerHandBigBlind] doubleValue];
        NSObject *receivedDFPlayerMoves = dict[kDFPokerHandPlayerMoves];
        NSMutableArray *parsedDFPlayerMoves = [NSMutableArray array];
        if ([receivedDFPlayerMoves isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedDFPlayerMoves) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedDFPlayerMoves addObject:[DFPlayerMove playerMoveWithDictionary:item]];
                }
            }
        } else if ([receivedDFPlayerMoves isKindOfClass:[NSDictionary class]]) {
            [parsedDFPlayerMoves addObject:[DFPlayerMove playerMoveWithDictionary:(NSDictionary *)receivedDFPlayerMoves]];
        }
        _playerMoves = [NSArray arrayWithArray:parsedDFPlayerMoves];
        
    }
    return self;
}

+ (instancetype)pokerHandWithDictionary:(NSDictionary *)dict {
    return [[[self class] alloc]initWithDictionary:dict];
}

- (DFPlayerMove *)nextMove {
    if (self.playerMoves.count > 0) {
        if (self.currentMove == NSNotFound) {
            self.currentMove = 0;
        }
        else if (self.currentMove < self.playerMoves.count - 1){
            self.currentMove++;
        }
        else {
            self.currentMove = NSNotFound;
            return nil;
        }
        DFPlayerMove *move = self.playerMoves[self.currentMove];
        return move;
    }
    return nil;
}

@end
