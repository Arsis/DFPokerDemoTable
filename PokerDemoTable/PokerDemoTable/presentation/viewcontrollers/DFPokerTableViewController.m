//
//  DFPokerTableViewController.m
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import "DFPokerTableViewController.h"
#import "DFPokerGame.h"
#import "DFPlayerMove.h"
#import <SDImageCache.h>
#import "DFPlayer.h"
#import "UIImage+Resizing.h"
#import "DFGradientManager.h"
#import "DFPlayerView.h"
#import "DFPokerHand.h"

static CGFloat const kRadius = 130.0f;

@interface DFPokerTableViewController ()
@property (nonatomic, weak) DFPokerGame *currentGame;
@property (nonatomic, strong) id playerMoveObserver;
@property (nonatomic,strong) NSMutableArray *playerViews;
@property (weak, nonatomic) IBOutlet UILabel *handStakesLabel;
@end

@implementation DFPokerTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer *greenGradientLayer = [DFGradientManager greenGradient];
    greenGradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:greenGradientLayer
                            atIndex:0];
    
    self.currentGame = [DFPokerGame sharedGame];
    CGFloat angle = 2 * M_PI / (double)self.currentGame.players.count;
    CGFloat radius = kRadius;
    CGPoint center = CGPointMake(self.view.center.x, self.view.center.y);
    
    self.playerViews = [NSMutableArray arrayWithCapacity:self.currentGame.players.count];
    
    NSArray *players = [[self.currentGame players] allObjects];
    for (int i = (int)players.count - 1; i >= 0; i--) {
        DFPlayer *player = players[i];
        DFPlayerView *view = [[DFPlayerView alloc]initWithPlayer:player];
        [self.playerViews addObject:view];
        CGFloat viewX = center.x + cos(angle * i) * radius;
        CGFloat viewY = center.y - sin(angle * i) * radius;
        view.center = CGPointMake(viewX, viewY);
        NSLog(@"View's center %@",NSStringFromCGPoint(view.center));
        [self.view addSubview:view];
    }
    
    self.handStakesLabel.text = [NSString stringWithFormat:@"Small blind: %.0f\rBig blind: %.0f",self.currentGame.selectedHand.smallBlind, self.currentGame.selectedHand.bigBlind];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.playerMoveObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"PlayerMovedNotification"
                                                                                object:nil
                                                                                 queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                                                                                     DFPlayerMove *move = note.object;
                                                                                     if (move) {
                                                        DFPlayerView *playerView = self.playerViews[[move playerIndex] - 1];
                                                                                         [playerView displayCommand:move.command
                                                                                                          withValue:move.value];
                                                                                         for (DFPlayerView *otherPlayerView in self.playerViews) {
                                                                                             if (otherPlayerView != playerView) {
                                                                                                 [otherPlayerView hideCommand];
                                                                                             }
                                                                                         }
                                                                                     }
                                                                                     else {                                                                                         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Pocker hand finished"
                                                                                                                                            message:nil
                                                                                                                                           delegate:nil
                                                                                                                                  cancelButtonTitle:@"OK"
                                                                                                                                  otherButtonTitles:nil, nil];
                                                                                         [alertView show];
                                                                                     }
                                                                                 }];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self.playerMoveObserver];
    self.playerMoveObserver = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playOrPauseButtonPressed:(id)sender {
    if ([self.currentGame isPlaying]) {
        [self.currentGame pause];
    }
    else {
        [self.currentGame play];
    }
}
@end
