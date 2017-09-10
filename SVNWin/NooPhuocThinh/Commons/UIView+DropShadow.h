//
//  UIView+DropShadow.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/27/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DropShadow)

- (void)addDropShadow:(UIColor *)color
           withOffset:(CGSize)offset
               radius:(CGFloat)radius
              opacity:(CGFloat)opacity;

@end
