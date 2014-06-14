//
//  DFGradientManager.m
//  PokerDemoTable
//
//  Created by DF on 6/14/14.
//
//

#import "DFGradientManager.h"
#import <QuartzCore/QuartzCore.h>
@implementation DFGradientManager

+ (CAGradientLayer *) greenGradient {
    UIColor *colorOne = [UIColor colorWithRed:90.0f/255.0f
                                        green:212.0f/255.0f
                                         blue:39.0f/255.0f
                                        alpha:1.0f];
    UIColor *colorTwo = [UIColor colorWithRed:164.0f/255.0f
                                        green:231.0f/255.0f
                                         blue:134.0f/255.0f
                                        alpha:1.0f];
    
    NSArray *colors =  @[(id)colorOne.CGColor, (id)colorTwo.CGColor];
    
    NSNumber *stopOne = @(0.0);
    NSNumber *stopTwo = @(1.0);
    
    NSArray *locations = @[stopOne, stopTwo];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    return headerLayer;
}

@end
