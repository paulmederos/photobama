//
//  PhotoViewController.h
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/12/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIView *fullOverlay;
    UIImageView *obamaImageView;
    
    NSArray *obamas;
    int chosenObama;
}

@end
