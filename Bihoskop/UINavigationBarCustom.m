//
//  UINavigationBarCustom.m
//  bihoskop2
//
//  Created by Mihailo Gazda on 7/22/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "UINavigationBarCustom.h"

@implementation UINavigationBarCustom

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage *image = [UIImage imageNamed:@"top.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
