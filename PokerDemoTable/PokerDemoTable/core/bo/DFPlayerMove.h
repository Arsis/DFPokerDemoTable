//
//  DFPlayerMove.h
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import <Foundation/Foundation.h>

@interface DFPlayerMove : NSObject
@property (nonatomic, copy) NSString *player;
@property (nonatomic, copy) NSString *command;
@property (nonatomic) double value;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)playerMoveWithDictionary:(NSDictionary *)dict;
- (NSUInteger)playerIndex;
@end
