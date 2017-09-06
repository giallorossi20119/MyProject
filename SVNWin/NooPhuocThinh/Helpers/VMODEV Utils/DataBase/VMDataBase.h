//
//  VMDataBase.h
//  NooPhuocThinh
//
//  Created by HuntDo on 12/20/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    DBResultOpenSuccessful = 0,
    DBResultOpenFails,
    DBResultClose_Successful,
    DBResultCloseFails,
    DBResultStatementSuccessful,
    DBResultStatementFails
    
}DBResult;

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
#import "VMConstant.h"
#import "ShoutBoxData.h"


@interface VMDataBase : NSObject


#pragma mark - fanzone
+ (NSMutableArray *) getAllMessagesFanZone:(FMDatabase *) database;
+ (NSInteger) insertMessageFanzone:(FMDatabase *)database withShoutBoxData:(ShoutBoxData*)aMessage;

@end
