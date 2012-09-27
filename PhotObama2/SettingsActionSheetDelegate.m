//
//  SettingsActionSheetDelegate.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "SettingsActionSheetDelegate.h"
#import "AppDelegate.h"

// ActionSheet button indexes
typedef enum {
	kSettingsLogout = 0,
    kSettingsNumberOfButtons
} kSettingsActionSheetButtons;

@implementation SettingsActionSheetDelegate

@synthesize navController;

#pragma mark - Initialization

- (id)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        navController = navigationController;
    }
    return self;
}

- (id)init {
    return [self initWithNavigationController:nil];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!self.navController) {
        [NSException raise:NSInvalidArgumentException format:@"navController cannot be nil"];
        return;
    }
    
    switch ((kSettingsActionSheetButtons)buttonIndex) {
        case kSettingsLogout:
            // Log out user and present the login view controller
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            break;
        default:
            break;
    }
}


@end
