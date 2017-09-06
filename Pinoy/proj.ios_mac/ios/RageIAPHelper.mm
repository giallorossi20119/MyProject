//
//  RageIAPHelper.h
//  Gameloe
//
//  Created by Rainy on 3/24/15.
//
//

#import "RageIAPHelper.h"

@implementation RageIAPHelper

+ (RageIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RageIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self alloc];
    });
    return sharedInstance;
}

@end
