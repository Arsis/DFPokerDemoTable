//
//  DFPlayerView.h
//  PokerDemoTable
//
//  Created by DF on 6/14/14.
//
//

#import <UIKit/UIKit.h>
@class DFPlayer;
@interface DFPlayerView : UIView
-(id)initWithPlayer:(DFPlayer *)player;
-(void)displayCommand:(NSString *)command withValue:(double)value;
-(void)hideCommand;
-(DFPlayer *)player;
@end
