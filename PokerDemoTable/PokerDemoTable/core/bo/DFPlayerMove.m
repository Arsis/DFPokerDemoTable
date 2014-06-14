//
//  DFPlayerMove.m
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import "DFPlayerMove.h"

@implementation DFPlayerMove

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        _player = [dict allKeys][0];
        _command = dict[_player][@"command"];
        _value = [dict[_player][@"value"] doubleValue];
    }
    return self;
}

+ (instancetype)playerMoveWithDictionary:(NSDictionary *)dict {
    return [[[self class] alloc]initWithDictionary:dict];
}

- (NSUInteger)playerIndex {
    NSRange whiteSpaceRange = [_player rangeOfString:@" "];
    NSString *numberString = [_player substringFromIndex:whiteSpaceRange.location + 1];
    return [numberString integerValue];
}

@end
