//
//  DFPokerHandManager.m
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import "DFPokerHandManager.h"
#import "DFPokerHand.h"

@interface DFPokerHandManager ()
@property (nonatomic, strong) NSMutableArray *pokerHands;
@end

@implementation DFPokerHandManager

-(NSArray *)availablePokerHandsWithNumberOfPlayers:(NSUInteger)numberOfPlayers {
    NSMutableArray *availablePokerHands = [NSMutableArray array];
    [self.pokerHands enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((DFPokerHand *)obj).numberOfPlayers == numberOfPlayers) {
            [availablePokerHands addObject:obj];
        }
    }];
    return availablePokerHands;
}

-(void)downloadScenarios {
    [self downloadScenariosWithCompletionHandler:nil];
}

-(void)downloadScenariosWithCompletionHandler:(DownloadCompletionHandler)completionHandler {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Scenarios" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    NSDictionary *pokerHandsInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions error:&error];
    if (error) {
        completionHandler(nil, error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadOperationFinished"
                                                            object:nil
                                                          userInfo:nil];
        return;
    }
    NSArray *rawPockerHands = pokerHandsInfo[@"scenarios"];
    NSMutableArray *parsedPockerHands = [NSMutableArray arrayWithCapacity:rawPockerHands.count];
    for (id rawPockerHand in rawPockerHands) {
        DFPokerHand *pokerHand = [DFPokerHand pokerHandWithDictionary:rawPockerHand[@"scenario"]];
        [parsedPockerHands addObject:pokerHand];
    }
    self.pokerHands = [NSMutableArray arrayWithArray:parsedPockerHands];
    completionHandler(self.pokerHands, nil);
}

@end
