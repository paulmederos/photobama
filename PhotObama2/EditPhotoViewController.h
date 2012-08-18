//
//  EditPhotoViewController.h
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/18/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPhotoViewController : UIViewController  <UITextFieldDelegate, UIScrollViewDelegate, PF_FBRequestDelegate>

- (id)initWithImage:(UIImage *)aImage;

@end
