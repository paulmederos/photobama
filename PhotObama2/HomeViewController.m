//
//  HomeViewController.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "PhotoViewController.h"
#import "SettingsActionSheetDelegate.h"
#import "MBProgressHUD.h"
#import "UIImage+ResizeAdditions.h"

@interface HomeViewController ()
{
    PhotoViewController *photoViewController;
    UIView *fullOverlay;
    UIImageView *obamaImageView;
    
    NSArray *obamas;
    int chosenObama;
}

@property (nonatomic, strong) SettingsActionSheetDelegate *settingsActionSheetDelegate;
@property (nonatomic, strong) UIView *blankTimelineView;

@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

@end

@implementation HomeViewController

@synthesize settingsActionSheetDelegate;
@synthesize blankTimelineView;

@synthesize photoFile;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId;

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        obamas =  [NSArray arrayWithObjects: @"obama-0", @"obama-1", nil];
        chosenObama = 0;
        fullOverlay = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 460)];
        
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    photoViewController = [[PhotoViewController alloc] init];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoNavigationBar"]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:62.0f/255.0f green:126.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Logout"
                                             style:UIBarButtonSystemItemAction
                                             target:self
                                             action:@selector(logOut:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                              target:self
                                              action:@selector(takePhoto:)];
    
    [[self navigationController] setNavigationBarHidden:NO];
//    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
}

#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult] & !self.firstLaunch) {
        self.tableView.scrollEnabled = NO;
        
        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;
            
            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
    }
}

#pragma mark - ()

- (void)settingsButtonAction:(id)sender
{
    self.settingsActionSheetDelegate = [[SettingsActionSheetDelegate alloc] initWithNavigationController:self.navigationController];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self.settingsActionSheetDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Log Out", nil];
    
    [actionSheet showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
}

- (void)takePhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If we have a camera, take a picture. If not, use Photo Library.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    // Overlay the chosen Obama image based on which button is pressed
    [self changeObamaView];
    
    // Create background texture to Obama scroll image selector
    UIImageView *backTextureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_linen"]];
    backTextureView.frame = CGRectMake(0,320,320,108);
    
    // Create the scroll view to hold different Obama images
    UIScrollView *newView = [[UIScrollView alloc] initWithFrame: CGRectMake(0,320,320,108)];
    newView.backgroundColor = [UIColor colorWithRed: 0.2 green:0.2 blue:0.2 alpha:0.0];
    newView.contentSize = CGSizeMake(28 + 74 * obamas.count, 80);
    
    
    for (int i = 0; i < obamas.count; i++) {
        UIButton *touchView = [UIButton buttonWithType: UIButtonTypeCustom];
        //  [touchView setBackgroundImage:[UIImage imageNamed:@"firstObama.png"] forState: UIControlStateNormal];
        
        [touchView setBackgroundColor:[self randomColor]];
        
        touchView.tag = i;
        touchView.frame = CGRectMake(10 + 74 * i, 22, 64, 64);
        [touchView addTarget:self action:@selector(changePhoto:) forControlEvents: UIControlEventTouchUpInside];
        [newView addSubview:touchView];
    }
    
    // Add all the subviews to image picker overlay, then display it.
    [fullOverlay addSubview: obamaImageView];
    [fullOverlay addSubview: backTextureView];
    [fullOverlay addSubview: newView];
    
    imagePicker.cameraOverlayView = fullOverlay;
    
    
    // Place image picker on screen modally
    [self presentModalViewController:imagePicker animated:YES];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    // Get picked photo from info dictionary
    UIImage *originalPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Pull the proper Obama image
    UIImage *obamaOverlay = [UIImage imageNamed:[obamas objectAtIndex:chosenObama]];
    
    // Set the size of the photo
    CGSize targetSize = CGSizeMake(320.0f, 320.0f);
    CGRect photoImageRect = CGRectMake(0, 0, 320.0f, 428.0f); // 480 height - 52 camera bar = 428 visible
    
    // Position Obama's rect
    int obamaWidth = [UIImage imageNamed: [obamas objectAtIndex:chosenObama]].size.width;
    int obamaHeight = [UIImage imageNamed: [obamas objectAtIndex:chosenObama]].size.height;
    CGRect obamaImageRect = CGRectMake(120, 100, obamaWidth, obamaHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    [originalPhoto drawInRect:photoImageRect];
    [obamaOverlay drawInRect:obamaImageRect];
    
    UIGraphicsPopContext();
    
    // Grab the merged UIImage from the image context
    UIImage* mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean up drawing environment
    UIGraphicsEndImageContext();
    
    // Save merged image to Camera roll
    // UIImageWriteToSavedPhotosAlbum(SavedImage, nil, nil, nil);
    
    // Compress the image to JPG quality for uploading.
    NSData *imageData = UIImageJPEGRepresentation(mergedImage, 1.0f);
    self.photoFile = [PFFile fileWithData:imageData];
    
    // Request a background task to upload the file in the background using Parse.
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    // Upload the file in the background using Parse.
    NSLog(@"Requested background expiration task with id %d for photo upload", self.fileUploadBackgroundTaskId);
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    // create a photo object
    PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
    [photo setObject:[PFUser currentUser] forKey:kPhotoUserKey];
    [photo setObject:self.photoFile forKey:kPhotoPictureKey];
    
    // Set Photo permissions - public, but may only be modified by the user who uploaded them
    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    photo.ACL = photoACL;
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    // Save the Photo object
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded");
            
            [[Cache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TabBarControllerDidFinishEditingPhotoNotification object:photo];
        } else {
            NSLog(@"Photo failed to save: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
}


- (void) changePhoto:(id) button
{
    int index = [button tag];
    NSLog(@"Chose Photo: %d", index);
    chosenObama = index;
    [self changeObamaView];
}

- (void)changeObamaView
{
    // Clear current Obama image
    [obamaImageView removeFromSuperview];
    
    // Get the current Obama image, position accordingly.
    obamaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:
                                                         [obamas objectAtIndex:chosenObama] ]];
    obamaImageView.frame = CGRectMake(120, 100,
                                      obamaImageView.image.size.width,
                                      obamaImageView.image.size.height);
    
    // Add the New Obama to the main overlay.
    [fullOverlay addSubview: obamaImageView];
}

- (void)logOut:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] logOut];
}

#pragma mark - Miscellaneous Methods

-(UIColor *)randomColor
{
    NSMutableArray *colors = [NSMutableArray array];
    
    float INCREMENT = 0.1;
    for (float hue = 0.0; hue < 1.0; hue += INCREMENT) {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colors addObject:color];
    }
    
    return [colors objectAtIndex:(arc4random() % 6)];
}

@end
