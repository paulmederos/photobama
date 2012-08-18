//
//  AppDelegate.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/12/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoViewController.h"
#import "LogInViewController.h"
#import "WelcomeViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) WelcomeViewController *welcomeViewController;

- (void)setupAppearance;
@end

@implementation AppDelegate

@synthesize window;
@synthesize navController;

@synthesize welcomeViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // ****************************************************************************
    // Parse initialization
    // [Parse setApplicationId:@"APPLICATION_ID" clientKey:@"CLIENT_KEY"];
    
    [Parse setApplicationId:@"sL6mqSA3RJHa3t1IUpGNct09H0puvgioXtC2I5DL"
                  clientKey:@"VareO3RCTwZ9IVsuovUnfvlZDwg4gmR8krI8kviQ"];
    
    // Set up Facebook authentication
    [PFFacebookUtils initializeWithApplicationId:@"258920440891165"];
    
    // Set up Twitter authentication
    [PFTwitterUtils initializeWithConsumerKey:@"ReZfpjehWNIJsBlYqX1hRQ" consumerSecret:@"38ddBR6gUn1XDC48OSvXpt6z4El1KxuRpS33mRAX8"];
    
    PFACL *defaultACL = [PFACL ACL];
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Set up our app's global UIAppearance
    [self setupAppearance];
    
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.welcomeViewController = [[WelcomeViewController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
    self.navController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)presentPhotoViewController
{
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    photoViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.welcomeViewController presentModalViewController:photoViewController animated:YES];

}

- (void)presentLoginViewControllerAnimated:(BOOL)animated
{
    LogInViewController *loginViewController = [[LogInViewController alloc] init];
    [loginViewController setDelegate:self];
    loginViewController.fields = PFLogInFieldsFacebook + PFLogInFieldsTwitter;
    
    loginViewController.facebookPermissions = [NSArray arrayWithObjects:@"user_about_me", nil];
    
    [self.welcomeViewController presentModalViewController:loginViewController animated:NO];
}


- (void)presentLoginViewController
{
    [self presentLoginViewControllerAnimated:YES];
}

- (void)setupAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
}

- (BOOL)isParseReachable
{
    return YES;
}

- (void)logOut {
    // clear cache
    [[Cache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications
    [[PFInstallation currentInstallation] removeObjectForKey:kInstallationUserKey];
    [[PFInstallation currentInstallation] removeObject:[[PFUser currentUser] objectForKey:kUserPrivateChannelKey] forKey:kInstallationChannelsKey];
    [[PFInstallation currentInstallation] saveEventually];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    [self.navController popToRootViewControllerAnimated:NO];
    
    [self presentLoginViewController];
}

@end
