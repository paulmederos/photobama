//
//  AppDelegate.h
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/12/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"

@class PhotoViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate>
{
    PhotoViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
@property (strong, nonatomic) IBOutlet PhotoViewController *photoViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)isParseReachable;

- (void)presentLoginViewController;
- (void)presentLoginViewControllerAnimated:(BOOL)animated;
- (void)presentPhotoViewController;

- (void)logOut;

@end
