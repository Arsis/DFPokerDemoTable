//
//  DFPokerHandManager.h
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import <Foundation/Foundation.h>

typedef void(^DownloadCompletionHandler)(NSArray *scenarios, NSError *error);

@interface DFPokerHandManager : NSObject

-(NSArray *)availablePokerHandsWithNumberOfPlayers:(NSUInteger)numberOfPlayers;

-(void)downloadScenarios;
-(void)downloadScenariosWithCompletionHandler:(DownloadCompletionHandler)completionHandler;

@end
