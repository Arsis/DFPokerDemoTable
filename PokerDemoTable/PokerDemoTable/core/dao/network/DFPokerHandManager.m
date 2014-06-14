//
//  DFPokerHandManager.m
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import "DFPokerHandManager.h"
#import "DFPokerHand.h"
#import "DFConnector.h"
#import <Reachability.h>

static NSString *const kHostName = @"cs539420.vk.me";

@interface DFPokerHandManager () <DFConnectorDelegate>
@property (nonatomic, strong) NSMutableArray *pokerHands;
@property (nonatomic, strong) DFConnector *connector;
@property (nonatomic, copy) DownloadCompletionHandler completionHandler;
@property (nonatomic, strong) Reachability *reach;
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
    self.completionHandler = completionHandler;
    if ([self.reach currentReachabilityStatus] == NotReachable) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Scenarios" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSError *error;
        NSDictionary *pokerHandsInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions error:&error];
        if (error) {
            [self handleError:error];
            return;
        }
        [self handleSuccess:pokerHandsInfo];
    }
    else {
        NSString *filePath = @"/u121786827/docs/2b04211c607d/Scenarios.json";
//        NSString *filePath = @"doc121786827_307880682";
        [self.connector downloadDataWithURLString:[NSString stringWithFormat:@"http://%@/%@",kHostName,filePath]];
    }
}

-(Reachability *)reach {
    if (!_reach) {
        _reach = [Reachability reachabilityWithHostname:kHostName];
    }
    return _reach;
}

-(DFConnector *)connector {
    if (!_connector) {
        _connector = [[DFConnector alloc] initWithDelegate:self];
    }
    return _connector;
}

#pragma mark - DFConnectorDelegate 

-(void)connectorDidFinishLoading:(id)response {
    [self handleSuccess:(NSDictionary *)response];
}

-(void)connectorDidFailWithError:(NSError *)error {
    [self handleError:error];
}

- (void)handleSuccess:(NSDictionary *)pokerHandsInfo {
    NSArray *rawPockerHands = pokerHandsInfo[@"scenarios"];
    NSMutableArray *parsedPockerHands = [NSMutableArray arrayWithCapacity:rawPockerHands.count];
    for (id rawPockerHand in rawPockerHands) {
        DFPokerHand *pokerHand = [DFPokerHand pokerHandWithDictionary:rawPockerHand[@"scenario"]];
        [parsedPockerHands addObject:pokerHand];
    }
    self.pokerHands = [NSMutableArray arrayWithArray:parsedPockerHands];
    self.completionHandler(self.pokerHands, nil);
    self.completionHandler = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadOperationFinished"
                                                        object:nil
                                                      userInfo:nil];
}

- (void)handleError:(NSError *)error {
    self.completionHandler(nil, error);
    self.completionHandler = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadOperationFinished"
                                                        object:nil
                                                      userInfo:nil];
}

@end
