//
//  DFPokerGame.h
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import <Foundation/Foundation.h>
@class DFPlayer;
@class DFPokerHand;
@interface DFPokerGame : NSObject
@property (nonatomic, copy) NSMutableSet *players;
@property (nonatomic, strong) DFPokerHand *selectedHand;

+(instancetype)sharedGame;

-(void)addPlayer:(DFPlayer *)player;
-(void)removePlayer:(DFPlayer *)player;


-(BOOL)isPlaying;
-(void)play;
-(void)pause;

@end
