//
//  AppDelegate.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/12/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "PhotoViewController.h"
#import "HomeViewController.h"
#import "LogInViewController.h"
#import "WelcomeViewController.h"
#import "Utility.h"
#import "UIImage+ResizeAdditions.h"

@interface AppDelegate () {
    NSMutableData *_data;
}

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) WelcomeViewController *welcomeViewController;
@property (nonatomic, strong) HomeViewController *homeViewController;

- (void)setupAppearance;
- (BOOL)shouldProceedToMainInterface:(PFUser *)user;

@end

@implementation AppDelegate

@synthesize window;
@synthesize navController;
@synthesize welcomeViewController;
@synthesize homeViewController;



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
    
    PFACL *defaultACL = [PFACL ACL];
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Set up our app's global UIAppearance
    [self setupAppearance];
    
    self.welcomeViewController = [[WelcomeViewController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
    self.navController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handledActionURL = [self handleActionURL:url];
    
    if (handledActionURL) {
        return YES;
    }
    
    return [PFFacebookUtils handleOpenURL:url];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
}

#pragma mark - PFLoginViewController

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    // user has logged in - we need to fetch all of their Facebook data before we let them in
    if (![self shouldProceedToMainInterface:user]) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.navController.presentedViewController.view animated:YES];
        [self.hud setLabelText:@"Loading"];
        [self.hud setDimBackground:YES];
    }
    
    [[PFFacebookUtils facebook] requestWithGraphPath:@"me/?fields=name,picture"
                                         andDelegate:self];
}

#pragma mark - PF_FBRequestDelegate
- (void)request:(PF_FBRequest *)request didLoad:(id)result {       
    [self.hud setLabelText:@"Creating Profile"];
    NSString *facebookId = [result objectForKey:@"id"];
    NSString *facebookName = [result objectForKey:@"name"];
    
    if (facebookName && facebookName != 0) {
        [[PFUser currentUser] setObject:facebookName forKey:kUserDisplayNameKey];
    }
    
    if (facebookId && facebookId != 0) {
        [[PFUser currentUser] setObject:facebookId forKey:kUserFacebookIDKey];
    }
    
    [[PFFacebookUtils facebook] requestWithGraphPath:@"me/friends" andDelegate:self];
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if ([PFUser currentUser]) {
        if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
             isEqualToString: @"OAuthException"]) {
            NSLog(@"The facebook token was invalidated");
            [self logOut];
        }
    }
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [Utility processFacebookProfilePictureData:_data];
}

#pragma mark - AppDelegate

- (void)presentHomeViewController
{
    self.homeViewController = [[HomeViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navController setViewControllers:[NSArray arrayWithObjects:self.welcomeViewController, self.homeViewController, nil] animated:NO];
    
    NSLog(@"Downloading user's profile picture");
    // Download user's profile picture
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kUserFacebookIDKey]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
}

- (void)presentLoginViewController
{
    [self presentLoginViewControllerAnimated:YES];
}

- (void)presentLoginViewControllerAnimated:(BOOL)animated
{
    LogInViewController *loginViewController = [[LogInViewController alloc] init];
    [loginViewController setDelegate:self];
    loginViewController.fields = PFLogInFieldsFacebook;
    
    loginViewController.facebookPermissions = [NSArray arrayWithObjects:@"user_about_me", nil];
    
    [self.welcomeViewController presentModalViewController:loginViewController animated:NO];
}


- (void)setupAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"BackgroundNavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)autoFollowTimerFired:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
    [MBProgressHUD hideHUDForView:self.homeViewController.view animated:YES];
    [self.homeViewController loadObjects];
}

- (BOOL)shouldProceedToMainInterface:(PFUser *)user {
    if ([Utility userHasValidFacebookData:[PFUser currentUser]]) {
        [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
        [self presentHomeViewController];
        
        [self.navController dismissModalViewControllerAnimated:YES];
        return YES;
    }
    
    return NO;
}


- (void)logOut {
    // clear cache
    [[Cache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    [self.navController popToRootViewControllerAnimated:NO];
    
    [self presentLoginViewController];
    self.homeViewController = nil;
}

- (BOOL)handleActionURL:(NSURL *)url {
    return NO;
}

- (BOOL)isParseReachable
{
    return YES;
}

@end
