//
//  UIView+DropShadow.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/27/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "UIView+DropShadow.h"

@implementation UIView (DropShadow)
- (void)addDropShadow:(UIColor *)color
           withOffset:(CGSize)offset
               radius:(CGFloat)radius
              opacity:(CGFloat)opacity
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
}

@end
