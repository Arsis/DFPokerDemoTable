//
//  DFRegistrationViewController.h
//  PokerDemoTable
//
//  Created by DF on 6/10/14.
//
//

#import <UIKit/UIKit.h>

@interface DFRegistrationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

- (IBAction)selectPhotoButtonPressed:(id)sender;
@end
