//
//  DFPokerHandsTableViewController.m
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import "DFPokerHandsTableViewController.h"
#import "DFPokerHandManager.h"
#import "DFPokerGame.h"
#import "DFPokerHand.h"

#import <math.h>

static NSString *const kPokerHandCellId = @"DFPokerHandCell";
static NSString *const kPokerTableSegue = @"DFPokerTableSegue";

@interface DFPokerHandsTableViewController ()
@property (nonatomic, weak) DFPokerGame *game;
@property (nonatomic, strong) NSArray *availablePokerHands;
@end

@implementation DFPokerHandsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.game = [DFPokerGame sharedGame];
    
    [self downloadConent];
    self.tableView.editing = NO;
}

- (void)downloadConent
{
    [self setupActivityIndicator];
    DFPokerHandManager *pokerHandManager = [[DFPokerHandManager alloc]init];
    typeof (self) weakSelf = self;
    [pokerHandManager downloadScenariosWithCompletionHandler:^(NSArray *scenarios, NSError *error) {
        if (!error) {
            weakSelf.availablePokerHands = [pokerHandManager availablePokerHandsWithNumberOfPlayers:self.game.players.count];
            self.navigationItem.rightBarButtonItem = nil;
            [self.tableView reloadData];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Something went wrong"
                                                               message:@"please reload later"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
            [self setupRefreshButton];
        }
    }];
}

- (void)setupActivityIndicator
{
    self.navigationItem.rightBarButtonItem = nil;
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:activityIndicatorView];
    [activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)setupRefreshButton {
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                  target:self
                                                                                  action:@selector(downloadConent)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.game.selectedHand = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.availablePokerHands.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPokerHandCellId
                                                            forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:kPokerHandCellId];
    }
    DFPokerHand *pokerHand = self.availablePokerHands[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %.0f/%.0f",pokerHand.name, pokerHand.smallBlind, pokerHand.bigBlind];
    return cell;
}


#pragma mark - Table view delegate 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DFPokerHand *selectedPokerHand = self.availablePokerHands[indexPath.row];
    self.game.selectedHand = selectedPokerHand;
    [self performSegueWithIdentifier:kPokerTableSegue
                              sender:nil];
}

@end
