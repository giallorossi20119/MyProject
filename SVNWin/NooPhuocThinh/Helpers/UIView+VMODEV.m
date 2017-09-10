//
//  UIView+VMODEV.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/24/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "UIView+VMODEV.h"

@implementation UIView (VMODEV)


#pragma mark - animations

+ (void)animateView:(UIView *)aView options:(VMAnimationTransformation)animationTransformation                                                                                  withDuration:(CGFloat)duration
                           animations:(void(^)(void))animations
                           completion:(void(^)(BOOL finished))completion

{
    //-- run animation at place implementation
    animations();
    
    CGFloat goOutOffScreenToX, cameInToScreenFromX;
    switch (animationTransformation)
    {
        case VMAnimationTransformationRightToLeft:
        {
            goOutOffScreenToX = -1 * [UIScreen mainScreen].applicationFrame.size.width;
            cameInToScreenFromX = [UIScreen mainScreen].applicationFrame.size.width;
            break;
        }
            
        case VMAnimationTransformationLeftToRight:
        {
            goOutOffScreenToX = [UIScreen mainScreen].applicationFrame.size.width;
            cameInToScreenFromX = -1 * [UIScreen mainScreen].applicationFrame.size.width;
            break;
        }
            
        default:
            break;
    }
    
    CGRect originViewFrame = aView.frame;
    [UIView animateWithDuration:duration
                     animations:^{
                         [self view:aView setX:goOutOffScreenToX];
                     }
                     completion:^(BOOL finished)
     {
         [self view:aView setX:cameInToScreenFromX];
         [UIView animateWithDuration:duration
                          animations:^{
                              [self view:aView setX:originViewFrame.origin.x];
                          }
                          completion:nil];
     }];
    
    //-- excute completion block;
    if (completion)
        completion(YES);
}

#pragma mark - point

+ (void)view:(UIView *)view setX:(CGFloat)x
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

+ (void)view:(UIView *)view setY:(CGFloat)y
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

+ (void) view:(UIView *)view setHeight:(CGFloat)height
{
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

+ (void) view:(UIView *)view setWidth:(CGFloat)width
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}


@end
