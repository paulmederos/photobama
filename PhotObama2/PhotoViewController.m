//
//  PhotoViewController.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/12/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "PhotoViewController.h"
#import "AppDelegate.h"
#import "UIImage+ResizeAdditions.h"

@interface PhotoViewController ()

@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

@end

@implementation PhotoViewController

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
    backTextureView.frame = CGRectMake(0,0,320,146);
    
    // Create the scroll view to hold different Obama images
    UIScrollView *newView = [[UIScrollView alloc] initWithFrame: CGRectMake(0,0,320,146)];
    newView.backgroundColor = [UIColor colorWithRed: 0.2 green:0.2 blue:0.2 alpha:0.0];
    newView.contentSize = CGSizeMake(20 + 74 * obamas.count, 84);
    
    for (int i = 0; i < obamas.count; i++) {
        UIButton *touchView = [UIButton buttonWithType: UIButtonTypeCustom];
        [touchView setBackgroundColor:[self randomColor]];
        
        touchView.tag = i;
        touchView.frame = CGRectMake(10 + 74 * i, 10, 64, 64);
        
        [touchView addTarget:self action:@selector(changePhoto:) forControlEvents: UIControlEventTouchUpInside];
        [newView addSubview:touchView];
    }
    
    [fullOverlay addSubview: obamaImageView];
    [fullOverlay addSubview: backTextureView];
    [fullOverlay addSubview: newView];
    
    
    imagePicker.cameraOverlayView = fullOverlay;
    
    
    // Place image picker on screen modally
    NSLog(@"Class is: %@", sender);
    [sender presentModalViewController:imagePicker animated:YES];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];
    
    // Get picked photo from info dictionary
    UIImage *originalPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];

    // Pull the proper Obama image
    UIImage *obamaOverlay = [UIImage imageNamed:[obamas objectAtIndex:chosenObama] ];

    // Set the size of the photo
    CGSize targetSize = CGSizeMake(originalPhoto.size.width, originalPhoto.size.height);
    CGRect photoImageRect = CGRectMake(0, 0, originalPhoto.size.width, originalPhoto.size.height);

    // Position Obama's rect
    CGRect obamaImageRect = CGRectMake(originalPhoto.size.width - obamaOverlay.size.width*4,
                                       originalPhoto.size.height - obamaOverlay.size.height*4,
                                       obamaOverlay.size.width*4,
                                       obamaOverlay.size.height*4);

    UIGraphicsBeginImageContext(targetSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);

    [originalPhoto drawInRect:photoImageRect];
    [obamaOverlay drawInRect:obamaImageRect];

    UIGraphicsPopContext();

    // Grab the merged UIImage from the image context
    UIImage* savedImage = UIGraphicsGetImageFromCurrentImageContext();

    // Clean up drawing environment
    UIGraphicsEndImageContext();


    // Save merged image to Camera roll
    // UIImageWriteToSavedPhotosAlbum(SavedImage, nil, nil, nil);
    
    NSLog(@"Image is set to: %@", savedImage);
    
    // Resize the image using Trevor Harmon's algorithms (see UIImage+ResizeAdditions in External folder.
    UIImage *resizedImage = [savedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    
    // Compress the image to JPG quality for uploading.
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
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
        } else {
            NSLog(@"Photo failed to save: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    [self dismissModalViewControllerAnimated:YES];
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
    obamaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: [obamas objectAtIndex:chosenObama] ]];
    obamaImageView.frame = CGRectMake(120, 100, obamaImageView.image.size.width/1.5,
                                      obamaImageView.image.size.height/1.5);

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end


