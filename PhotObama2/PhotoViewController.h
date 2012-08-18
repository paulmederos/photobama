//
//  PhotoViewController.h
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/12/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


- (void)loadImages;
- (void)saveData:(UIImage *)photo;

- (IBAction)takePhoto:(id)sender;

@end
