//
//  DFPlayerView.m
//  PokerDemoTable
//
//  Created by DF on 6/14/14.
//
//

#import "DFPlayerView.h"
#import <SDImageCache.h>
#import "DFPlayer.h"
#import "UIImage+Resizing.h"

static NSUInteger const kVerticalOffset = 10;
static NSUInteger const kHorizontalOffset = 10;
static CGFloat const kScaledAvatarDimensions = 32;
static NSUInteger const kFirstNameLabelFontSize = 9;
static NSUInteger const kCommandLabelFontSize = 10;
static CGFloat const kCommandLabelOffset = 5;
static CGFloat const kCommandLabelWidth = 100;
static CGFloat const kCommandLabelHeight = 32;

@interface DFPlayerView ()
@property (nonatomic, strong) DFPlayer *player;
@property (nonatomic, weak) UILabel *commandLabel;
@end

@implementation DFPlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithPlayer:(DFPlayer *)player {
    if (self = [super init]) {
        UIImageView *imageView = [[UIImageView alloc]init];
        _player = player;
        imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:player.avatarPath];
        if (!imageView.image) {
            imageView.image = [UIImage imageNamed:@"avatarPlaceholder"];
        }
        imageView.image = [UIImage imageWithImage:imageView.image
                                     scaledToSize:CGSizeMake(kScaledAvatarDimensions, kScaledAvatarDimensions)];
        [imageView sizeToFit];
        imageView.center = CGPointMake(CGRectGetMidX(imageView.bounds) + kHorizontalOffset, CGRectGetMidY(imageView.bounds) + kVerticalOffset);
        
        UILabel *firstNameLabel = [[UILabel alloc]init];
        firstNameLabel.textAlignment = NSTextAlignmentCenter;
        firstNameLabel.backgroundColor = [UIColor clearColor];
        firstNameLabel.text = player.firstName;
        firstNameLabel.font = [UIFont systemFontOfSize:kFirstNameLabelFontSize];
        [firstNameLabel sizeToFit];
        firstNameLabel.center = CGPointMake(CGRectGetMidX(imageView.frame), CGRectGetMaxY(imageView.frame) + kVerticalOffset);
        
        UILabel *commandLabel = [[UILabel alloc]init];
        commandLabel.font = [UIFont systemFontOfSize:kCommandLabelFontSize];
        commandLabel.numberOfLines = 2;
        commandLabel.frame = CGRectMake(kHorizontalOffset, CGRectGetMaxY(firstNameLabel.frame) + kCommandLabelOffset, kCommandLabelWidth, kCommandLabelHeight);
        commandLabel.backgroundColor = [UIColor clearColor];
        
        self.frame = CGRectMake(0, 0, kHorizontalOffset * 2 + CGRectGetWidth(imageView.frame), kVerticalOffset * 4 + CGRectGetHeight(imageView.frame) + CGRectGetHeight(firstNameLabel.frame) + CGRectGetHeight(commandLabel.frame));
        
        [self addSubview:imageView];
        [self addSubview:firstNameLabel];
        [self addSubview:commandLabel];
        
        self.commandLabel = commandLabel;
    }
    return self;
}

-(void)displayCommand:(NSString *)command withValue:(double)value {
    self.commandLabel.text = [NSString stringWithFormat:@"%@:\r%.0f",command,value];
//    [self.commandLabel sizeToFit];
}

-(void)hideCommand {
    self.commandLabel.text = nil;
}

-(DFPlayer *)player {
    return _player;
}

@end
