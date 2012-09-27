//
//  SettingsActionSheetDelegate.h
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsActionSheetDelegate : NSObject <UIActionSheetDelegate>

// Navigation controller of calling view controller
@property (nonatomic, strong) UINavigationController *navController;

- (id)initWithNavigationController:(UINavigationController *)navigationController;


@end
