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

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        NSLog(@"invalid context");
        return nil;
    }
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIView *)imageViewWithGradient:(CAGradientLayer *)gradient size:(CGSize)size text:(NSString *)text {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    label.font = font;
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.center = bg.center;
    [bg.layer insertSublayer:gradient
                     atIndex:0];
    [bg addSubview:label];
    return bg;
}

@end
