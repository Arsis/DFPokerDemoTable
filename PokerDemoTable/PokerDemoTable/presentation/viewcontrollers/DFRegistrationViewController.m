//
//  DFRegistrationViewController.m
//  PokerDemoTable
//
//  Created by DF on 6/10/14.
//
//

#import "DFRegistrationViewController.h"

@interface DFRegistrationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate>
- (void)registerButtonPressed:(id)sender;
- (void)cancelButtonPressed:(id)sender;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar  {
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
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
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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

@end
