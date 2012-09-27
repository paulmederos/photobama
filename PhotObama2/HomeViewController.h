//
//  HomeViewController.h
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "TimelineViewController.h"

@interface HomeViewController : TimelineViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign, getter = isFirstLaunch) BOOL firstLaunch;

@end
