//
//  WelcomeViewController.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/17/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "Utility.h"

@implementation WelcomeViewController

- (void)loadView {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [backgroundImageView setImage:[UIImage imageNamed:@"Default.png"]];
    self.view = backgroundImageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    // If not logged in, present login view controller
    if (![PFUser currentUser]) {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewControllerAnimated:NO];
        return;
    }
    // Present PhotObama UI
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentHomeViewController];
    
    // Refresh current user with server side data -- checks if user is still valid and so on
    [[PFUser currentUser] refreshInBackgroundWithTarget:self selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
}

#pragma mark - ()

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
    // A kPFErrorObjectNotFound error on currentUser refresh signals a deleted user
    if (error && error.code == kPFErrorObjectNotFound) {
        NSLog(@"User does not exist.");
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }
    
    [PFFacebookUtils extendAccessTokenIfNeededForUser:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
        // Check if user is missing a Facebook ID
        if ([Utility userHasValidFacebookData:[PFUser currentUser]]) {
            // User has Facebook ID.
            
            // refresh Facebook friends on each launch
            [[PFFacebookUtils facebook] requestWithGraphPath:@"me/friends" andDelegate:(AppDelegate*)[[UIApplication sharedApplication] delegate]];
            
        } else {
            NSLog(@"User missing Facebook ID");
            [[PFFacebookUtils facebook] requestWithGraphPath:@"me/?fields=name,picture,email" andDelegate:(AppDelegate*)[[UIApplication sharedApplication] delegate]];
        }
    }];
    
    
}

@end
