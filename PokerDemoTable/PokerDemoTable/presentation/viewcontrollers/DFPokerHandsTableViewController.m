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
    DFPokerHandManager *pokerHandManager = [[DFPokerHandManager alloc]init];
    typeof (self) weakSelf = self;
    [pokerHandManager downloadScenariosWithCompletionHandler:^(NSArray *scenarios, NSError *error) {
        if (!error) {
            weakSelf.availablePokerHands = [pokerHandManager availablePokerHandsWithNumberOfPlayers:self.game.players.count];
            [self.tableView reloadData];
        }
    }];
    self.tableView.editing = NO;
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
