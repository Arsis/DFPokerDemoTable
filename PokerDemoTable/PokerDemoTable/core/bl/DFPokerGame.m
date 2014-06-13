//
//  DFPokerGame.m
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import "DFPokerGame.h"
#import "DFPlayer.h"
#import "DFPokerHand.h"
#import "DFPlayerMove.h"
@interface DFPokerGame ()
@property (nonatomic, strong) NSTimer *moveTimer;
@end

@implementation DFPokerGame

+(instancetype)sharedGame {
    static dispatch_once_t onceToken;
    static DFPokerGame *game = nil;
    dispatch_once(&onceToken, ^{
        game = [[DFPokerGame alloc] init];
    });
    return game;
}

-(void)addPlayer:(DFPlayer *)player {
    if ([player isKindOfClass:[DFPlayer class]]) {
        if (!_players) {
            _players = [NSMutableSet set];
        }
        [_players addObject:player];
    }
}

-(void)removePlayer:(DFPlayer *)player {
    [_players removeObject:player];
}

-(BOOL)isPlaying {
    return self.moveTimer && [self.moveTimer isValid];
}

-(void)play {
    if (!self.moveTimer) {
        self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:self.selectedHand.moveDelay
                                                          target:self
                                                        selector:@selector(play)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    DFPlayerMove *move = [self.selectedHand nextMove];
    if (!move) {
        [self pause];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayerMovedNotification"
                                                        object:move];
    

}

-(void)pause {
    [self.moveTimer invalidate];
    self.moveTimer = nil;
}
@end
