//
//  DFPlayersTableViewController.m
//  PokerDemoTable
//
//  Created by DF on 6/10/14.
//
//

#import "DFPlayersTableViewController.h"
#import "DFDataModelController.h"
#import "DFPokerGame.h"
#import <SDImageCache.h>
@interface DFPlayersTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) DFDataModelController *dataModelController;
@property (nonatomic, strong) DFPokerGame *nextGame;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pokerHandsButton;
@end

static NSString *const kRegistrationSegue = @"DFRegistrationSegue";
static NSString *const kDFPokerHandsSegue = @"DFPokerHandsSegue";
@implementation DFPlayersTableViewController

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
    self.dataModelController = [DFDataModelController sharedInstance];
    self.dataModelController.fetchedResultsController.delegate = self;
    [self performFetch];
}

- (void)performFetch
{
    NSError *error;
    if (![self.dataModelController.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataModelController.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
    [[self.dataModelController.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *object = [self.dataModelController.fetchedResultsController objectAtIndexPath:indexPath];
        [self.dataModelController.mainContext deleteObject:object];
        NSError *error;
        if ([self.dataModelController.mainContext save:&error] == NO) {
            NSLog(@"error occured: %@",error.localizedDescription);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    DFPlayer *player = [self.dataModelController.fetchedResultsController objectAtIndexPath:indexPath];
    UIImage *cachedImageInMemory = [[SDImageCache sharedImageCache]imageFromMemoryCacheForKey:player.avatarPath];
    if (!cachedImageInMemory) {
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:player.avatarPath
                                                         done:^(UIImage *image, SDImageCacheType cacheType) {
                                                             cell.imageView.image = image;
                                                             [cell setNeedsLayout];
                                                         }];
    }
    else {
        cell.imageView.image =cachedImageInMemory;
        [cell setNeedsLayout];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",player.firstName,player.lastNamae];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PlayerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    DFPlayer *player = [self.dataModelController.fetchedResultsController objectAtIndexPath:indexPath];
    if (!self.nextGame) {
        self.nextGame = [DFPokerGame sharedGame];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.nextGame.players containsObject:player]) {
        [self.nextGame removePlayer:player];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        [self.nextGame addPlayer:player];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (self.nextGame.players.count >= 2) {
        self.pokerHandsButton.enabled = YES;
    }
    else {
        self.pokerHandsButton.enabled = NO;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath  {
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - Target/Action

- (IBAction)pokerHandsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kDFPokerHandsSegue
                              sender:self];
}

- (IBAction)addPlayerButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kRegistrationSegue
                              sender:self];
}
@end
