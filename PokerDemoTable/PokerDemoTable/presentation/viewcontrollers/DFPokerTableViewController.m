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
@interface DFPokerTableViewController ()
@property (nonatomic, weak) DFPokerGame *currentGame;
@property (nonatomic, strong) id playerMoveObserver;
@property (weak, nonatomic) IBOutlet UITextView *textView;
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
    self.currentGame = [DFPokerGame sharedGame];
    CGFloat angle = 2 * M_PI / (double)self.currentGame.players.count;
    CGFloat radius = 100.0f;
    CGPoint center = self.view.center;
    
    NSArray *players = [[self.currentGame players] allObjects];
    for (int i = 0; i < players.count; i++) {
        UIImageView *view = [[UIImageView alloc]init];
        DFPlayer *player = players[i];
        view.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:player.avatarPath];
        if (!view.image) {
            view.image = [UIImage imageNamed:@"avatarPlaceholder"];
        }
        [view sizeToFit];
        CGFloat viewX = center.x + cos(angle * i) * radius;
        CGFloat viewY = center.y - sin(angle * i) * radius;
        view.center = CGPointMake(viewX, viewY);
        NSLog(@"View's center %@",NSStringFromCGPoint(view.center));
        [self.view addSubview:view];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.playerMoveObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"PlayerMovedNotification"
                                                                                object:nil
                                                                                 queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                                                                                     DFPlayerMove *move = note.object;
                                                                                     if (move) {
                                                                                         self.textView.text = [NSString stringWithFormat:@"Player: %@\rCommand:%@\rValue:%f",move.player, move.command,move.value];
                                                                                     }
                                                                                     else {
                                                                                         self.textView.text = nil;
                                                                                         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Pocker hand finished"
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playOrPauseButtonPressed:(id)sender {
    if ([self.currentGame isPlaying]) {
        [self.currentGame pause];
    }
    else {
        [self.currentGame play];
    }
}
@end
