//
//  UIImage+Resizing.h
//  PokerDemoTable
//
//  Created by DF on 6/11/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Resizing)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIView *)imageViewWithGradient:(CAGradientLayer *)gradient size:(CGSize)size text:(NSString *)text;
@end
