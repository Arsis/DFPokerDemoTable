//
//  DFRegistrationViewController.m
//  PokerDemoTable
//
//  Created by DF on 6/10/14.
//
//

#import "DFRegistrationViewController.h"
#import "DFDataModelController.h"
#import "UIImage+Resizing.h"
#import <SDImageCache.h>
@import QuartzCore;

static CGFloat const kDefaultNavigationBarHeight = 44.0f;
static CGFloat const kNavigationBarHeightIOS7 = 64.0f;
static CGFloat const kDefaultAvatarDimensions = 50.0f;
static CGFloat const kAnimationDistance = 5.0f;
static CGFloat const kAnimationSpeed = 10.0f;
static NSUInteger const kAnimationRepeatCount = 3;

@interface DFRegistrationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate, UITextFieldDelegate>
@property (nonatomic, weak) NSManagedObjectContext *currentContext;
@property (nonatomic, weak) UINavigationItem *currentNavigationItem;
- (void)registerButtonPressed:(id)sender;
- (void)cancelButtonPressed:(id)sender;
- (void)registerNewPlayer;
@end

@implementation DFRegistrationViewController

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
    [self setupNavigationBar];
    self.currentContext = [[DFDataModelController sharedInstance] mainContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar  {
    CGFloat navBarHeight = NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 ? kNavigationBarHeightIOS7 : kDefaultNavigationBarHeight;
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), navBarHeight)];
    [navigationBar setDelegate:self];
    UINavigationItem *navigationItem = [[UINavigationItem alloc]initWithTitle:@"Registration"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(cancelButtonPressed:)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Register"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(registerButtonPressed:)];
    navigationItem.leftBarButtonItem = leftBarButtonItem;
    navigationItem.rightBarButtonItem = rightBarButtonItem;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    self.currentNavigationItem = navigationItem;
    [self.view addSubview:navigationBar];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - Target/Action

- (IBAction)selectPhotoButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController
                           animated:YES
                         completion:nil];
    }
    else {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"Sorry"
                                                          message:@"camera is unavailable on this device"
                                                         delegate:nil cancelButtonTitle:@"Dismiss"
                                                otherButtonTitles:nil, nil];
        [alerView show];
    }
}

- (void)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)registerButtonPressed:(id)sender {
    if ([self validateDataInTextView:self.firstNameTextField] && [self validateDataInTextView:self.lastNameTextField]) {
        [self registerNewPlayer];
    }
}

-(void)registerNewPlayer {
    DFPlayer *player = [DFPlayer insertInManagedObjectContext:self.currentContext];
    player.firstName = self.firstNameTextField.text;
    player.lastNamae = self.lastNameTextField.text;
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@",player.firstName,player.lastNamae];
    player.avatarPath = cacheKey;
    if (self.avatarImageView.image) {
        [[SDImageCache sharedImageCache] storeImage:[UIImage imageWithImage:self.avatarImageView.image
                                                               scaledToSize:CGSizeMake(kDefaultAvatarDimensions, kDefaultAvatarDimensions)]
                                             forKey:cacheKey
                                             toDisk:YES];
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
    [self saveCurrentContext];
}

-(void)saveCurrentContext {
    NSError *saveContextError;
    if ([self.currentContext save:&saveContextError] == NO) {
        NSLog(@"error while saving player: %@",saveContextError.localizedDescription);
        abort();
    };
}

#pragma mark - ImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    self.avatarImageView.image = pickedImage;
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"image is not selected");
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
    }
    else if (textField == self.lastNameTextField) {
        [self registerButtonPressed:nil];
    }
    return YES;
}

-(BOOL)validateDataInTextView:(UITextField *)textField {
    if (textField.text.length == 0) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.autoreverses = YES;
        animation.speed = kAnimationSpeed;
        animation.repeatCount = kAnimationRepeatCount;
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(textField.frame) + kAnimationDistance, CGRectGetMidY(textField.frame))];
        [textField.layer addAnimation:animation forKey:nil];
        [textField becomeFirstResponder];
        return NO;
    }
    return YES;
}

@end
