//
//  AppDelegate.h
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/12/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"

@class PhotoViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navController;

- (BOOL)isParseReachable;

- (void)presentLoginViewController;
- (void)presentLoginViewControllerAnimated:(BOOL)animated;
- (void)presentPhotoViewController;

- (void)logOut;

@end
