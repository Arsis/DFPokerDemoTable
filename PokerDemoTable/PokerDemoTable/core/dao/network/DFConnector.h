//
//  DFConnector.h
//  PokerDemoTable
//
//  Created by DF on 6/14/14.
//
//

#import <Foundation/Foundation.h>

@protocol  DFConnectorDelegate <NSObject>

-(void)connectorDidFinishLoading:(id)response;
-(void)connectorDidFailWithError:(NSError *)error;


@end

@interface DFConnector : NSObject

@property (nonatomic, weak) id <DFConnectorDelegate> delegate;

-(id)initWithDelegate:(id <DFConnectorDelegate>)delegate;

-(void)downloadDataWithURLString:(NSString *)urlString;

@end
