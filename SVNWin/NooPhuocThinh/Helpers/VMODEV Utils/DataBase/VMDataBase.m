//
//  VMDataBase.m
//  NooPhuocThinh
//
//  Created by HuntDo on 12/20/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "VMDataBase.h"

@implementation VMDataBase

//******************************************************************************************************

#pragma mark - fanzone

+ (NSMutableArray *) getAllMessagesFanZone:(FMDatabase *) database
{
    if (!database)
         database = [AppDelegate getNewDBConnection];
    
    NSMutableArray *arrMessages = nil;
    
    if (!database)
    {
        DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",DB_TABLE_SHOUTBOXDATA];
            FMResultSet *results=[database executeQuery:sql];
        
            //-- excute
            
            if (results)
            {
                DLog(@"select statement into %@ table successful",DB_TABLE_SHOUTBOXDATA);
                arrMessages = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    ShoutBoxData *aMessage      =  [ShoutBoxData new];
                    aMessage.shoutId            =  [results stringForColumn:@"shoutId"];
                    aMessage.userId             =  [results stringForColumn:@"userId"];
                    aMessage.userName           =  [results stringForColumn:@"userName"];
                    aMessage.userImage          =  [results stringForColumn:@"userImage"];
                    aMessage.fullName           =  [results stringForColumn:@"fullName"];
                    aMessage.text               =  [results stringForColumn:@"text"];
                    aMessage.timeStamp          =  [results stringForColumn:@"timeStamp"];
                    aMessage.timeStamp          =  [results stringForColumn:@"numberOfSubComment"];
                    
                    [arrMessages addObject:aMessage];
                }
            }else {
                DLog(@"select statement [%@] fails or table empty: %@ - %d", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                DLog(@"[select statement] database closed");
            } else {
                DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            DLog(@"Database can not open! [%@] Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrMessages;
}


+(NSInteger) insertMessageFanzone:(FMDatabase *)database withShoutBoxData:(ShoutBoxData*)aMessage
{
    if (!database)
        database = [AppDelegate getNewDBConnection];
    
    if (!database)
    {
        DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open
            DLog(@"Database opened!");
            
            //-- excuting
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (shoutId, userId, userName, userImage, fullName, text, timeStamp, numberComment) VALUES (\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')", DB_TABLE_SHOUTBOXDATA ,aMessage.shoutId, aMessage.userId, aMessage.userName, aMessage.userImage,aMessage.fullName, aMessage.text, aMessage.timeStamp, aMessage.numberOfSubComment];
            
            if ([database executeUpdateWithFormat:sql])
            {
                DLog(@"insert statement into %@ successful", DB_TABLE_SHOUTBOXDATA);
            }
            else
            {
                DLog(@"insert statement at %@ fails: %@ - %d", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                DLog(@"[insert statement into WorkDay] closed database");
            } else {
                DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            DLog(@"Database can not open! at %@ Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

@end
