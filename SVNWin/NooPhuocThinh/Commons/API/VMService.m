//
//  VMService.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/22/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "VMService.h"

@implementation VMService


/**
 *  fetchingNews
 */
+(void) fetchingNews:(void (^)(NSMutableArray *categories, NSError *error))cachingFetched
           serviceFetched:(void (^)(NSMutableArray *categories, NSError *error))serviceFetched
{
    NSMutableArray *results = nil;
    
    //-- fetch from the cache
    if (cachingFetched != nil) {
        results = [VMDataBase getAllNews];
        //-- callback
        cachingFetched(results,nil);
    }
    
    //-- fetch from server
    if (serviceFetched != nil) {
        results = nil;
        
        
        
        //-- callback
        serviceFetched(results,nil);
    }
}

@end
