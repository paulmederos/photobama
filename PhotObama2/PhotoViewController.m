//
//  PhotoViewController.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/12/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "PhotoViewController.h"
#import "AppDelegate.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)takePhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If we have a camera, take a picture. If not, use Photo Library.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    /* Create the scroll view to hold different Obama images */
    UIScrollView *newView = [[UIScrollView alloc] initWithFrame: CGRectMake(0,342,320,84)];
    newView.backgroundColor = [UIColor colorWithRed: 0.2 green:0.2 blue:0.2 alpha:0.5];
    newView.contentSize = CGSizeMake(320, 84);
    
    int numOfPhotos = 2;
    
    for (int i = 0; i < numOfPhotos; i++) {
        UIButton *touchView = [UIButton buttonWithType: UIButtonTypeCustom];
        //        [touchView setBackgroundImage:[UIImage imageNamed:@"firstObama.png"] forState: UIControlStateNormal];
        [touchView setBackgroundColor:[UIColor blueColor]];
        if (i == 0) {
            [touchView setBackgroundColor:[UIColor greenColor]];
        }
        
        touchView.tag = i;
        touchView.frame = CGRectMake(20 + 64 * i, 10, 64, 64);
        [touchView addTarget:self action:@selector(changePhoto:) forControlEvents: UIControlEventTouchUpInside];
        [newView addSubview:touchView];
    }
    
    UIView *fullOverlay = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    // Overlay the chosen obama image based on which button is pressed */
    UIImageView *obamaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"firstObama"]];
    obamaImageView.frame = CGRectMake(100, 215, obamaImageView.image.size.width/1.5,
                                      obamaImageView.image.size.height/1.5);
    
    [fullOverlay addSubview: obamaImageView];
    [fullOverlay addSubview: newView];
    
    
    imagePicker.cameraOverlayView = fullOverlay;
    
    
    // Place image picker on screen modally
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked photo from info dictionary
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Pull the proper Obama image
    UIImage *obamaOverlay = [UIImage imageNamed:@"firstObama.png"];
    
    // Set the size of the photo
    CGSize targetSize = CGSizeMake(photo.size.width, photo.size.height);
    CGRect photoImageRect = CGRectMake(0, 0, photo.size.width, photo.size.height);
    
    // Position Obama's rect
    CGRect obamaImageRect = CGRectMake(photo.size.width - obamaOverlay.size.width*4,
                                       photo.size.height - obamaOverlay.size.height*4,
                                       obamaOverlay.size.width*4,
                                       obamaOverlay.size.height*4);
    
    UIGraphicsBeginImageContext(targetSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    [photo drawInRect:photoImageRect];
    [obamaOverlay drawInRect:obamaImageRect];
    
    UIGraphicsPopContext();
    
    // Grab the merged UIImage from the image context
    UIImage* savedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean up drawing environment
    UIGraphicsEndImageContext();
    
    // Save image
    [self saveData:savedImage];
    
    // And load it up in the main view
    [self loadImages];
    
    // Save merged image to Camera roll
    // UIImageWriteToSavedPhotosAlbum(SavedImage, nil, nil, nil);
    
    // Set the imageView on the Share page, apply photo frame effect
//    [imageView setImage:savedImage];
//    [imageView applyPhotoFrameEffect];
    
    // Dismiss the imagePicker to show the Share screen
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveData:(UIImage *)photo {
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSString *formattedDateString = [dateFormatter stringFromDate:date];
//
//    NSManagedObject *newPhoto;
//    newPhoto = [NSEntityDescription
//                  insertNewObjectForEntityForName:@"Photos"
//                  inManagedObjectContext:context];
//    
//    [newPhoto setValue:formattedDateString forKey:@"name"];
//    [newPhoto setValue:UIImageJPEGRepresentation(photo,1) forKey:@"content"];
//    [newPhoto setValue:date forKey:@"date"];
//
//    NSError *error;
//    [context save:&error];
}

- (void)loadImages {
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Photos" inManagedObjectContext:context];
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDesc];
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:nil];
//    [request setPredicate:pred];
//    
//    NSManagedObject *matches = nil;
//    
//    NSError *error;
//    NSArray *objects = [context executeFetchRequest:request
//                                              error:&error];
//    if ([objects count] == 0) {
//        // No photos yet!
//        // Show the intro screen
//        NSLog(@"No photos in DB");
//    } else {        
//        int numPhotos = [objects count];
//        NSLog(@"We have %d photos in DB.", numPhotos);
//        
//        // Make the scroll view to hold images
//        UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0,44, 320, 436)];
//        mainScrollView.backgroundColor = [UIColor colorWithRed: 0.2 green:0.2 blue:0.2 alpha:0.5];
//        mainScrollView.contentSize = CGSizeMake(320, 310 * numPhotos + 10);
//        
//        // Loop through matches and add photos to scroll view
//        for (int i = 0; i < [objects count]; i++) {
//            NSLog(@"Matches = %@", [[objects objectAtIndex:i] name]);
////            UIImage *photo = [[objects objectAtIndex:i] valueForKey:@"content"];
//            UIImage *photo = [[UIImage alloc] initWithData:[[objects objectAtIndex:i] valueForKey:@"content"]];
//            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 + 310*i, 300, 300)];
//            [photoView setBackgroundColor:[UIColor colorWithRed: 0.3 green:0.2 blue:0.2 alpha:0.5]];
//            photoView.image = photo;
//            [mainScrollView addSubview:photoView];
//        }
//        
//        
//        // Add scroll view to main window
//        [self.view addSubview:mainScrollView];
//    }
}


-(void) changePhoto: (id) button {
    int index = [button tag];
    NSLog(@"Chose Photo: %d", index);
}


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
    // Do any additional setup after loading the view from its nib.
//    
    PFObject *testObject = [PFObject objectWithClassName:@"TestingNow"];
    [testObject setObject:@"cookies" forKey:@"Yes"];
    [testObject save];
    
    [self loadImages];
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
