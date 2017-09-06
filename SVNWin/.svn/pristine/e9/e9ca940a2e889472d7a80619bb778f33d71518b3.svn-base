//
//  UIView+VMODEV.h
//  NooPhuocThinh
//
//  Created by HuntDo on 12/24/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//


typedef enum {
    
    VMAnimationTransformationRightToLeft, //-- go out to left then get in from right.
    VMAnimationTransformationLeftToRight //-- go out to right then get in from left.
    
}VMAnimationTransformation;

#import <UIKit/UIKit.h>

@interface UIView (VMODEV)


#pragma mark - animations

/*
 * by HuntDo 24.12.2013
 * set animation for view with: left-to-right or right-to-left
 */

+ (void)animateView:(UIView *)aView options:(VMAnimationTransformation)animationTransformation                                                                                  withDuration:(CGFloat)duration
         animations:(void(^)(void))animations
         completion:(void(^)(BOOL finished))completion;


#pragma mark - point
/*
 * by HuntDo 24.12.2013
 * set x , y for view
 */

+ (void) view:(UIView *)view setX:(CGFloat)x;
+ (void) view:(UIView *)view setY:(CGFloat)y;

+ (void) view:(UIView *)view setHeight:(CGFloat)height;
+ (void) view:(UIView *)view setWidth:(CGFloat)width;

@end
