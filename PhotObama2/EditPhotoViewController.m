//
//  EditPhotoViewController.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/18/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "UIImage+ResizeAdditions.h"

@interface EditPhotoViewController ()
    @property (nonatomic, strong) UIScrollView *scrollView;
    @property (nonatomic, strong) UIImage *image;
    @property (nonatomic, strong) PFFile *photoFile;
    @property (nonatomic, strong) PFFile *thumbnailFile;
    @property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
    @property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@end

@implementation EditPhotoViewController

@synthesize scrollView;
@synthesize image;
@synthesize photoFile;
@synthesize thumbnailFile;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId;

- (id)initWithImage:(UIImage *)aImage {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (!aImage) {
            return nil;
        }
        
        self.image = aImage;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
