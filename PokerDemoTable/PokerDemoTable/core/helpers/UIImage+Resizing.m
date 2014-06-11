//
//  UIImage+Resizing.m
//  PokerDemoTable
//
//  Created by DF on 6/11/14.
//
//

#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
