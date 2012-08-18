//
//  LogInViewController.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/18/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "LogInViewController.h"


@implementation LogInViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
    
    NSString *text = @"Everyday is a chance to hang out with Obama.";
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f] constrainedToSize:CGSizeMake( 255.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake( ([UIScreen mainScreen].bounds.size.width - textSize.width)/2.0f, 280.0f, textSize.width, textSize.height)];
    
    [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
    [textLabel setLineBreakMode:UILineBreakModeWordWrap];
    [textLabel setNumberOfLines:0];
    [textLabel setText:text];
    [textLabel setTextColor:[UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:UITextAlignmentCenter];
    
    [self.logInView setLogo:nil];
    [self.logInView addSubview:textLabel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
