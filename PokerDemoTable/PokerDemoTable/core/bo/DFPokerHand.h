//
//  DFPokerHand.h
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import <Foundation/Foundation.h>

@class DFPlayerMove;

@interface DFPokerHand : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSTimeInterval moveDelay;
@property (nonatomic, copy) NSString *scenarioIdentifier;
@property (nonatomic) NSUInteger numberOfPlayers;
@property (nonatomic) double smallBlind;
@property (nonatomic) double bigBlind;
@property (nonatomic, copy) NSArray *playerMoves;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)pokerHandWithDictionary:(NSDictionary *)dict;
- (DFPlayerMove *)nextMove;
@end
