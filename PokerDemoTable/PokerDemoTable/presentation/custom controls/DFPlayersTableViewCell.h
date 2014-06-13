//
//  DFPlayersTableViewCell.h
//  PokerDemoTable
//
//  Created by DF on 6/13/14.
//
//

#import <UIKit/UIKit.h>

@interface DFPlayersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureIndicator;

@end
