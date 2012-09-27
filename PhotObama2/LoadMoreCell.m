//
//  LoadMoreCell.m
//  PhotObama2
//
//  Created by Paul Mederos Jr on 8/18/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "LoadMoreCell.h"
#import "Utility.h"

@implementation LoadMoreCell

@synthesize cellInsetWidth;
@synthesize mainView;
@synthesize separatorImageTop;
@synthesize separatorImageBottom;
@synthesize loadMoreImageView;
@synthesize hideSeparatorTop;
@synthesize hideSeparatorBottom;


#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.cellInsetWidth = 0.0f;
        hideSeparatorTop = YES;
        hideSeparatorBottom = YES;
        
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        
        mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
        [mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
        
        self.loadMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellLoadMore"]];
        [mainView addSubview:self.loadMoreImageView];
        
        self.separatorImageTop = [[UIImageView alloc] init];
        [separatorImageTop setBackgroundColor:[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:0.3f]];
        [mainView addSubview:separatorImageTop];
        
//        self.separatorImageBottom = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake( 0.0f, 1.0f, 0.0f, 1.0f)]];
//        [mainView addSubview:separatorImageBottom];
        
        [self.contentView addSubview:mainView];
    }
    
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [mainView setFrame:CGRectMake( self.cellInsetWidth, self.contentView.frame.origin.y, self.contentView.frame.size.width-2*self.cellInsetWidth, self.contentView.frame.size.height)];
    
    // Layout load more text
    [self.loadMoreImageView setFrame:CGRectMake( -self.cellInsetWidth, -2.0f, 320.0f, 31.0f)];
    
    // Layout separator
    [self.separatorImageBottom setFrame:CGRectMake( 0.0f, self.frame.size.height - 2.0f, self.frame.size.width-self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageBottom setHidden:hideSeparatorBottom];
    
    [self.separatorImageTop setFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageTop setHidden:hideSeparatorTop];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.cellInsetWidth != 0.0f) {
        [Utility drawSideDropShadowForRect:mainView.frame inContext:UIGraphicsGetCurrentContext()];
    }
}


#pragma mark - PAPLoadMoreCell

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    cellInsetWidth = insetWidth;
    [mainView setFrame:CGRectMake( insetWidth, mainView.frame.origin.y, mainView.frame.size.width - 2.0f * insetWidth, mainView.frame.size.height)];
    [self setNeedsDisplay];
}

@end
