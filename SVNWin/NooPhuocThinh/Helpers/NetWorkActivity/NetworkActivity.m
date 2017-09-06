//
//  NetworkActivity.m
//  AGKGlobal
//
//  Created by Thuy on 10/3/13.
//  Copyright (c) 2013 fountaindew. All rights reserved.
//

#import "NetworkActivity.h"

static NetworkActivity* _wknetwork = nil;
@implementation NetworkActivity

+ (NetworkActivity*)shared
{
    if (!_wknetwork) {
        static dispatch_once_t threeToken;
        dispatch_once(&threeToken, ^{
            _wknetwork = [[NetworkActivity alloc] init];
            _wknetwork.count = 0;
        });
    }
    return _wknetwork;
}

- (void)show
{
    self.count += 1;
    if (self.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
    }
}

- (void)hide
{
    self.count -= 1;
    if (self.count < 0) self.count = 0;
    if (self.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }
}

+ (void)show
{
    [[NetworkActivity shared] show];
}

+ (void)hide
{
    [[NetworkActivity shared] hide];
}

@end
