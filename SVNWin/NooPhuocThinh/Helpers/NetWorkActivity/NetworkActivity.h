//
//  NetworkActivity.h
//  AGKGlobal
//
//  Created by Thuy on 10/3/13.
//  Copyright (c) 2013 fountaindew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkActivity : NSObject
{
}

@property(nonatomic,assign) NSInteger count;

- (void)show;
- (void)hide;

+ (NetworkActivity*)shared;
+ (void)show;
+ (void)hide;

@end
