//
//  VMDataBase.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/20/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "VMDataBase.h"

static FMDatabase *database = nil;

@implementation VMDataBase


//**************************************************************************************************
//longnh add
#pragma mark - clear cache
+ (FMDatabase *) deleteAllDataInDB
{
    [self deleteAllMesaageFanZoneDataBase];
    [self deleteAllNews];
    [self deleteAllAlbumFromDB];
    return nil;
}

#pragma mark - connection

+ (FMDatabase *) getNewDBConnection
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
    NSLog(@"Path DataBase: %@",path);
    
    FMDatabase *newDBconnection = [FMDatabase databaseWithPath:path];
    
    if (newDBconnection)
        NSLog(@"Database created successfully!");
    else
        NSLog(@"Error in opening database ");
    
    return newDBconnection;
}

//***************************************************************************************************

#pragma mark - fanzone

+ (NSMutableArray *)getAllMessagesFanZone
{
    if (!database)
         database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrMessages = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",DB_TABLE_SHOUTBOXDATA];
            FMResultSet *results=[database executeQuery:sql];
        
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_SHOUTBOXDATA);
                arrMessages = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    Profile *profile    = [Profile new];
                    profile.userId      = [results stringForColumn:@"profileId"];
                    profile.userName    = [results stringForColumn:@"userName"];
                    profile.fullName    = [results stringForColumn:@"fullName"];
                    profile.userImage   = [results stringForColumn:@"userImage"];
                    
                    Comment *comment                = [Comment new];
                    comment.commentId               = [results stringForColumn:@"commentId"];
                    comment.commentSuperId          = [results stringForColumn:@"commentSuperId"];
                    comment.content                 = [results stringForColumn:@"content"];
                    comment.timeStamp               = [results stringForColumn:@"timestamp"];
                    comment.numberOfSubcommments    = [results stringForColumn:@"numberOfSubComments"];
                    comment.arrSubComments          = [NSMutableArray new];
                    comment.profileUser             = profile;
                    
                    [arrMessages addObject:comment];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrMessages;
}


+ (NSMutableArray *)getAllMessagesFanZoneWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrMessages = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE timestamp >= \'%d\' AND timestamp <= \'%d\' ORDER BY timestamp DESC",DB_TABLE_SHOUTBOXDATA,startTime, endTime];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_SHOUTBOXDATA);
                arrMessages = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    Profile *profile    = [Profile new];
                    profile.userId      = [results stringForColumn:@"profileId"];
                    profile.userName    = [results stringForColumn:@"userName"];
                    profile.fullName    = [results stringForColumn:@"fullName"];
                    profile.userImage   = [results stringForColumn:@"userImage"];
                    
                    Comment *comment                = [Comment new];
                    comment.commentId               = [results stringForColumn:@"commentId"];
                    comment.commentSuperId          = [results stringForColumn:@"commentSuperId"];
                    comment.content                 = [results stringForColumn:@"content"];
                    comment.timeStamp               = [results stringForColumn:@"timestamp"];
                    comment.numberOfSubcommments    = [results stringForColumn:@"numberOfSubComments"];
                    comment.arrSubComments          = [NSMutableArray new];
                    comment.profileUser             = profile;
                    
                    [arrMessages addObject:comment];
                
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrMessages;
}

+ (NSMutableArray *)getAllMessagesFanZoneBeforeTime:(NSInteger)time
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrMessages = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE timestamp <= \'%d\'",DB_TABLE_SHOUTBOXDATA, time];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_SHOUTBOXDATA);
                arrMessages = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    Profile *profile    = [Profile new];
                    profile.userId      = [results stringForColumn:@"profileId"];
                    profile.userName    = [results stringForColumn:@"userName"];
                    profile.fullName    = [results stringForColumn:@"fullName"];
                    profile.userImage   = [results stringForColumn:@"userImage"];
                    
                    Comment *comment                = [Comment new];
                    comment.commentId               = [results stringForColumn:@"commentId"];
                    comment.commentSuperId          = [results stringForColumn:@"commentSuperId"];
                    comment.content                 = [results stringForColumn:@"content"];
                    comment.timeStamp               = [results stringForColumn:@"timestamp"];
                    comment.numberOfSubcommments    = [results stringForColumn:@"numberOfSubComments"];
                    comment.arrSubComments          = [NSMutableArray new];
                    comment.profileUser             = profile;
                    
                    [arrMessages addObject:comment];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrMessages;
}




+(DBResult) insertShoutBoxData:(Comment*)aMessage
{
    if (!database)
         database = [VMDataBase getNewDBConnection];
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened!");
            
            //-- excuting
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (commentId, commentSuperId, content, timestamp, numberOfSubComments, profileId, userName, userImage, fullName) VALUES (\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\', \'%@\')", DB_TABLE_SHOUTBOXDATA ,
                             aMessage.commentId,
                             aMessage.commentSuperId,
                             aMessage.content,
                             aMessage.timeStamp,
                             aMessage.numberOfSubcommments,
                             aMessage.profileUser.userId,
                             aMessage.profileUser.userName,
                             aMessage.profileUser.userImage,
                             aMessage.profileUser.fullName];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", DB_TABLE_SHOUTBOXDATA);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement] closed database");
            } else {
                //DLog(@"[insert statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

+(DBResult)updateShoutBoxData:(Comment*)aMessage
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened!");
       
            //-- excuting
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET numberOfSubComments = \'%@\' WHERE commentId = \'%@\' ",
                             DB_TABLE_SHOUTBOXDATA,
                             aMessage.numberOfSubcommments,
                             aMessage.commentId];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"update statement into %@ successful", DB_TABLE_SHOUTBOXDATA);
            }
            else
            {
                NSLog(@"DBERR: update statement at %@ fails: %@ - %d", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[update statement] closed database");
            } else {
                //DLog(@"[update statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}



+ (DBResult)deleteAllMesaageFanZoneDataBase
{
    if (!database)
         database = [VMDataBase getNewDBConnection];
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",DB_TABLE_SHOUTBOXDATA];

            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", DB_TABLE_SHOUTBOXDATA);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}



+ (DBResult)deleteMessageFanzoneWithShoutBoxData:(Comment*)aMessage
{
    if (!database)
         database = [VMDataBase getNewDBConnection];
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //CORRECT?
            //BOOL susccessful = [database executeUpdate:@"DELETE FROM %@ WHERE commentId = ?", DB_TABLE_SHOUTBOXDATA,aMessage.commentId];
            
            BOOL susccessful;
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE commentId = %@", DB_TABLE_SHOUTBOXDATA, aMessage.commentId];
            susccessful = [database executeUpdate:sql];

            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", DB_TABLE_SHOUTBOXDATA);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult)deleteMessagesFanZoneWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_SHOUTBOXDATA,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            NSString *stringSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE timestamp >= \'%d\' AND timestamp <= \'%d\'",DB_TABLE_SHOUTBOXDATA,startTime,endTime];
            
            //-- excuting db
            BOOL susccessful = [database executeUpdate:stringSQL];
            
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", DB_TABLE_SHOUTBOXDATA);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", DB_TABLE_SHOUTBOXDATA, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

//***************************************************************************************************
#pragma mark - Feeds

+ (DBResult)deleteAllFeedsFromDB
{
    NSLog(@"%s", __func__);
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_FEED;
    
    if (!database)
    {
        NSLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //NSLog(@"Delete all table name: %@", tableName);
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //NSLog(@"[delete statement] closed database");
            } else {
                //NSLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

+ (DBResult) insertFeedBySinger:(ListFeedData*)feedBySinger
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_FEED;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (feedId, feedParentId, feedType, feedTimeStamp, feedTimeUpdate, feedUserId, feedUsername, feedUserImage, feedLink, feedImage, feedTitle, albumId, NoPhoto, feedDescription, snsTotalComment, snsTotalLike, snsTotalShare, snsTotalView, isLiked) VALUES (\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%lu\', \'%@\',\'%@\', \'%@\', \'%@\', \'%@\', \'%@\')",
                             tableName,
                             feedBySinger.feedId,
                             feedBySinger.feedParentId,
                             feedBySinger.feedType,
                             feedBySinger.feedTimeStamp,
                             feedBySinger.feedTimeUpdate,
                             feedBySinger.feedUserId,
                             feedBySinger.feedUserName,
                             feedBySinger.feedUserImage,
                             feedBySinger.feedLink,
                             feedBySinger.feedImage,
                             feedBySinger.feedTitle,
                             feedBySinger.albumId,
                             (unsigned long)feedBySinger.NoPhoto,
                             feedBySinger.feedDescription,
                             feedBySinger.snsTotalComment,
                             feedBySinger.snsTotalLike,
                             feedBySinger.snsTotalShare,
                             feedBySinger.snsTotalView,
                             feedBySinger.isLiked];
            
            if ([database executeUpdateWithFormat:sql])
            {
                DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                DLog(@"insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

+ (NSMutableArray *) getAllFeeds:(NSString *)feedParentId
{
    NSLog(@"%s feedParentId=%@", __func__, feedParentId);
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrFeeds = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE feedParentId = \'%@\'",DB_TABLE_FEED, feedParentId];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_NEWS);
                arrFeeds = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    ListFeedData *aNews             = [ListFeedData new];
                    aNews.feedId                    = [results stringForColumn:@"feedId"];
                    aNews.feedParentId              = [results stringForColumn:@"feedParentId"];
                    aNews.feedType                  = [results stringForColumn:@"feedType"];
                    aNews.feedTimeStamp             = [results stringForColumn:@"feedTimeStamp"];
                    aNews.feedTimeUpdate            = [results stringForColumn:@"feedTimeUpdate"];
                    aNews.feedUserId                = [results stringForColumn:@"feedUserId"];
                    aNews.feedUserName              = [results stringForColumn:@"feedUsername"];
                    aNews.feedUserImage             = [results stringForColumn:@"feedUserImage"];
                    aNews.feedLink                  = [results stringForColumn:@"feedLink"];
                    aNews.feedImage                 = [results stringForColumn:@"feedImage"];
                    aNews.feedTitle                 = [results stringForColumn:@"feedTitle"];
                    aNews.albumId                   = [results stringForColumn:@"albumId"];
                    aNews.NoPhoto                   = [results intForColumn:@"NoPhoto"];
                    aNews.feedDescription           = [results stringForColumn:@"feedDescription"];
                    aNews.snsTotalComment           = [results stringForColumn:@"snsTotalComment"];
                    aNews.snsTotalLike              = [results stringForColumn:@"snsTotalLike"];
                    aNews.snsTotalShare             = [results stringForColumn:@"snsTotalShare"];
                    aNews.snsTotalView              = [results stringForColumn:@"snsTotalView"];
                    aNews.isLiked                   = [results stringForColumn:@"isLiked"];
                    NSLog(@"isLiked = %@",[results stringForColumn:@"isLiked"]);
                    
                    [arrFeeds addObject:aNews];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_FEED,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_FEED,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrFeeds;
}

//photolist feed

+ (DBResult) insertPhotoListFeedBySinger:(PhotoListFeedData*)feedBySinger
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_PHOTOLIST_FEED;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (albumId, photoId, photoTitle, imagePath, photoDescription, snsTotalView, snsTotalLike, snsTotalComment, snsTotalShare,indexcell) VALUES (\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\')",
                             tableName,
                             feedBySinger.albumId,
                             feedBySinger.photoId,
                             feedBySinger.photoTitle,
                             feedBySinger.imagePath,
                             feedBySinger.photoDescription,
                             feedBySinger.snsTotalView,
                             feedBySinger.snsTotalLike,
                             feedBySinger.snsTotalComment,
                             feedBySinger.snsTotalShare,
                             feedBySinger.indexcell];
            
            if ([database executeUpdateWithFormat:sql])
            {
                DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                DLog(@"insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

+ (NSMutableArray *) getAllPhotoFeeds:(NSString *)albumId
{
    NSLog(@"%s feedalbumId=%@", __func__, albumId);
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrFeeds = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE albumId = \'%@\'",DB_TABLE_PHOTOLIST_FEED, albumId];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_NEWS);
                arrFeeds = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    PhotoListFeedData *aNews            = [PhotoListFeedData new];
                    aNews.albumId                       = [results stringForColumn:@"albumId"];
                    aNews.photoId                       = [results stringForColumn:@"photoId"];
                    aNews.photoTitle                    = [results stringForColumn:@"photoTitle"];
                    aNews.imagePath                     = [results stringForColumn:@"imagePath"];
                    aNews.photoDescription              = [results stringForColumn:@"photoDescription"];
                    aNews.snsTotalView                  = [results stringForColumn:@"snsTotalView"];
                    aNews.snsTotalLike                  = [results stringForColumn:@"snsTotalLike"];
                    aNews.snsTotalComment               = [results stringForColumn:@"snsTotalComment"];
                    aNews.snsTotalShare                 = [results stringForColumn:@"snsTotalShare"];
                    aNews.indexcell                     = [results stringForColumn:@"indexcell"];
                    [arrFeeds addObject:aNews];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_PHOTOLIST_FEED,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_PHOTOLIST_FEED,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrFeeds;
}

+ (DBResult)deleteAllPhotoFeedsFromDB
{
    NSLog(@"%s", __func__);
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_PHOTOLIST_FEED;
    
    if (!database)
    {
        NSLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //NSLog(@"Delete all table name: %@", tableName);
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //NSLog(@"[delete statement] closed database");
            } else {
                //NSLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

//***************************************************************************************************
#pragma mark - News

+ (NSMutableArray *) getAllNews
{
    if (!database)
         database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrNews = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",DB_TABLE_NEWS];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_NEWS);
                arrNews = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    News *aNews                     =  [News new];
                    aNews.nodeId                    =  [results stringForColumn:@"nodeId"];
                    aNews.title                     =  [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"title"]];
                    aNews.thumbnailImagePath        =  [results stringForColumn:@"thumbnailImagePath"];
                    aNews.thumbnailImageType        =  [results stringForColumn:@"thumbnailImageType"];
                    aNews.shortBody                 =  [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"shortBody"]];
                    aNews.body                      =  [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"body"]];
                    aNews.order                     =  [results intForColumn:@"orderNews"];
                    aNews.trueTotalView             =  [results intForColumn:@"trueTotalView"];
                    aNews.settingTotalView          =  [results intForColumn:@"settingTotalView"];
                    aNews.isHot                     =  [results intForColumn:@"isHot"];
                    aNews.createdDate               =  [results stringForColumn:@"createdDate"];
                    aNews.lastUpdate                =  [results stringForColumn:@"lastUpdate"];
                    aNews.imageList                 =  [results stringForColumn:@"imageList"];
                    aNews.isLiked                   =  [results intForColumn:@"isLiked"];
                    aNews.numberOfLike              =  [results intForColumn:@"numberOfLike"];
                    aNews.url                       =  [results stringForColumn:@"url"];
                    aNews.categoryID                =  [results stringForColumn:@"categoryID"];
                    aNews.snsTotalComment           =  [results intForColumn:@"snsTotalComment"];
                    aNews.snsTotalLike              =  [results intForColumn:@"snsTotalLike"];
                    aNews.snsTotalDislike           =  [results intForColumn:@"snsTotalDislike"];
                    aNews.snsTotalShare             =  [results intForColumn:@"snsTotalShare"];
                    aNews.snsTotalView              =  [results intForColumn:@"snsTotalView"];
                    aNews.isLiked                   =  [results intForColumn:@"isLiked"];
                    aNews.arrComments               =  [NSMutableArray new];
                    
                    [arrNews addObject:aNews];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrNews;
}


+ (NSMutableArray *) getAllNewsWithCategoryID:(NSString *)categoryID
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrNews = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE categoryID = %@",DB_TABLE_NEWS, categoryID];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_NEWS);
                arrNews = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    News *aNews                     =  [News new];
                    aNews.nodeId                    =  [results stringForColumn:@"nodeId"];
                    aNews.title                     =  [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"title"]];
                    aNews.thumbnailImagePath        =  [results stringForColumn:@"thumbnailImagePath"];
                    aNews.thumbnailImageType        =  [results stringForColumn:@"thumbnailImageType"];
                    aNews.shortBody                 =  [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"shortBody"]];
                    NSString *tmpBody               =  [results stringForColumn:@"body"];
                    aNews.body                      =  [Utility convertAndReplaceDoLaToHtml:tmpBody];
                    aNews.order                     =  [results intForColumn:@"orderNews"];
                    aNews.trueTotalView             =  [results intForColumn:@"trueTotalView"];
                    aNews.settingTotalView          =  [results intForColumn:@"settingTotalView"];
                    aNews.isHot                     =  [results intForColumn:@"isHot"];
                    aNews.createdDate               =  [results stringForColumn:@"createdDate"];
                    aNews.lastUpdate                =  [results stringForColumn:@"lastUpdate"];
                    aNews.imageList                 =  [results stringForColumn:@"imageList"];
                    aNews.numberOfLike              =  [results intForColumn:@"numberOfLike"];
                    aNews.url                       =  [results stringForColumn:@"url"];
                    aNews.categoryID                =  [results stringForColumn:@"categoryID"];
                    aNews.snsTotalComment           =  [results intForColumn:@"snsTotalComment"];
                    aNews.snsTotalLike              =  [results intForColumn:@"snsTotalLike"];
                    aNews.snsTotalDislike           =  [results intForColumn:@"snsTotalDislike"];
                    aNews.snsTotalShare             =  [results intForColumn:@"snsTotalShare"];
                    aNews.snsTotalView              =  [results intForColumn:@"snsTotalView"];
                    aNews.isLiked                   =  [results intForColumn:@"isLiked"];
                    
                    aNews.arrComments               =  [NSMutableArray new];
                    
                    [arrNews addObject:aNews];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrNews;
}

+ (NSMutableArray *) getAllNewsWithCategoryIDPerPage:(NSString *)categoryID pageId:(NSInteger)pageId pageSize:(NSInteger)pageSize
{
    NSLog(@"%s cateId=%@ pageId=%d", __func__, categoryID, pageId);
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrNews = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            int offset = pageId * pageSize;
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE categoryID = %@ ORDER BY orderNews,lastUpdate DESC LIMIT %d OFFSET %d ",DB_TABLE_NEWS, categoryID, pageSize, offset];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_NEWS);
                arrNews = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    News *aNews                     =  [News new];
                    aNews.nodeId                    =  [results stringForColumn:@"nodeId"];
                    aNews.title                     =  [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"title"]];
                    aNews.thumbnailImagePath        =  [results stringForColumn:@"thumbnailImagePath"];
                    aNews.thumbnailImageType        =  [results stringForColumn:@"thumbnailImageType"];
                    aNews.shortBody                 =  [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"shortBody"]];
                    NSString *tmpBody               =  [results stringForColumn:@"body"];
                    aNews.body                      =  [Utility convertAndReplaceDoLaToHtml:tmpBody];
                    aNews.order                     =  [results intForColumn:@"orderNews"];
                    aNews.trueTotalView             =  [results intForColumn:@"trueTotalView"];
                    aNews.settingTotalView          =  [results intForColumn:@"settingTotalView"];
                    aNews.isHot                     =  [results intForColumn:@"isHot"];
                    aNews.createdDate               =  [results stringForColumn:@"createdDate"];
                    aNews.lastUpdate                =  [results stringForColumn:@"lastUpdate"];
                    aNews.imageList                 =  [results stringForColumn:@"imageList"];
                    aNews.numberOfLike              =  [results intForColumn:@"numberOfLike"];
                    aNews.url                       =  [results stringForColumn:@"url"];
                    aNews.categoryID                =  [results stringForColumn:@"categoryID"];
                    aNews.snsTotalComment           =  [results intForColumn:@"snsTotalComment"];
                    aNews.snsTotalLike              =  [results intForColumn:@"snsTotalLike"];
                    aNews.snsTotalDislike           =  [results intForColumn:@"snsTotalDislike"];
                    aNews.snsTotalShare             =  [results intForColumn:@"snsTotalShare"];
                    aNews.snsTotalView              =  [results intForColumn:@"snsTotalView"];
                    aNews.isLiked                   =  [results intForColumn:@"isLiked"];
                    
                    aNews.arrComments               =  [NSMutableArray new];
                    
                    [arrNews addObject:aNews];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrNews;
}

+ (News *) getANewsByCategoryId:(NSString *)nodeId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    News *aNews = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE nodeId = \'%@\'",DB_TABLE_NEWS,nodeId];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_NEWS);
                aNews = [[News alloc] init];
                
                while(results.next)
                {
                    aNews.nodeId                    =  [results stringForColumn:@"nodeId"];
                    aNews.title                     =  [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"title"]];
                    aNews.thumbnailImagePath        =  [results stringForColumn:@"thumbnailImagePath"];
                    aNews.thumbnailImageType        =  [results stringForColumn:@"thumbnailImageType"];
                    aNews.shortBody                 =  [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"shortBody"]];
                    NSString *tmpBody               =  [results stringForColumn:@"body"];
                    aNews.body                      =  [Utility convertAndReplaceDoLaToHtml:tmpBody];
                    aNews.order                     =  [results intForColumn:@"orderNews"];
                    aNews.trueTotalView             =  [results intForColumn:@"trueTotalView"];
                    aNews.settingTotalView          =  [results intForColumn:@"settingTotalView"];
                    aNews.isHot                     =  [results intForColumn:@"isHot"];
                    aNews.createdDate               =  [results stringForColumn:@"createdDate"];
                    aNews.lastUpdate                =  [results stringForColumn:@"lastUpdate"];
                    aNews.imageList                 =  [results stringForColumn:@"imageList"];
                    aNews.numberOfLike              =  [results intForColumn:@"numberOfLike"];
                    aNews.url                       =  [results stringForColumn:@"url"];
                    aNews.categoryID                =  [results stringForColumn:@"categoryID"];
                    aNews.snsTotalComment           =  [results intForColumn:@"snsTotalComment"];
                    aNews.snsTotalLike              =  [results intForColumn:@"snsTotalLike"];
                    aNews.snsTotalDislike           =  [results intForColumn:@"snsTotalDislike"];
                    aNews.snsTotalShare             =  [results intForColumn:@"snsTotalShare"];
                    aNews.snsTotalView              =  [results intForColumn:@"snsTotalView"];
                    aNews.isLiked                   =  [results intForColumn:@"isLiked"];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return aNews;
}


+(DBResult) insertWithNews:(News*)aNews
{
    if (!database)
         database = [VMDataBase getNewDBConnection];
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (nodeId, title, thumbnailImagePath, thumbnailImageType, shortBody, body, orderNews, trueTotalView, settingTotalView, isHot, createdDate, lastUpdate, imageList, isLiked, numberOfLike, url, categoryID, snsTotalComment, snsTotalLike, snsTotalDislike, snsTotalShare, snsTotalView, isLiked) VALUES (\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%d\', \'%d\', \'%d\', \'%d\', \'%@\', \'%@\', \'%@\', \'%d\', \'%d\', \'%@\', \'%@\', \'%d\', \'%d\', \'%d\', \'%d\', \'%d\',\'%d\')",
                             DB_TABLE_NEWS,
                             aNews.nodeId,
                             [Utility checkAndReplaceHtmlInsertToDB:aNews.title],
                             aNews.thumbnailImagePath,
                             aNews.thumbnailImageType,
                             [Utility checkAndReplaceHtmlInsertToDB:aNews.shortBody],
                             [Utility checkAndReplaceHtmlInsertToDB:aNews.body],
                             aNews.order,
                             aNews.trueTotalView,
                             aNews.settingTotalView,
                             aNews.isHot,
                             aNews.createdDate,
                             aNews.lastUpdate,
                             aNews.imageList,
                             aNews.isLiked,
                             aNews.numberOfLike,
                             aNews.url,
                             aNews.categoryID,
                             aNews.snsTotalComment,
                             aNews.snsTotalLike,
                             aNews.snsTotalDislike,
                             aNews.snsTotalShare,
                             aNews.snsTotalView,
                             aNews.isLiked];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", DB_TABLE_NEWS);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", DB_TABLE_NEWS, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement ] closed database");
            } else {
                //DLog(@"[insert statement ] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", DB_TABLE_NEWS, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+(DBResult)updateWithNews:(News*)aNews
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_NEWS;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET snsTotalComment = \'%d\', snsTotalLike = \'%d\', snsTotalDisLike = \'%d\', snsTotalShare = \'%d\', snsTotalView = \'%d\', isLiked = \'%d\', body=\'%@\', createdDate=\'%@\', imageList=\'%@\', isHot=\'%d\', lastUpdate=\'%@\', orderNews=\'%d\', settingTotalView=\'%d\', shortBody=\'%@\', thumbnailImagePath=\'%@\', thumbnailImageType=\'%@\', title=\'%@\', trueTotalView=\'%d\' WHERE nodeId = \'%@\'",
                             tableName,
                             aNews.snsTotalComment,
                             aNews.snsTotalLike,
                             aNews.snsTotalDislike,
                             aNews.snsTotalShare,
                             aNews.snsTotalView,
                             aNews.isLiked,
                             
                             [Utility checkAndReplaceHtmlInsertToDB:aNews.body],
                             aNews.createdDate,
                             aNews.imageList,
                             aNews.isHot,
                             aNews.lastUpdate,
                             aNews.order,
                             aNews.settingTotalView,
                             [Utility checkAndReplaceHtmlInsertToDB:aNews.shortBody],
                             aNews.thumbnailImagePath,
                             aNews.thumbnailImageType,
                             [Utility checkAndReplaceHtmlInsertToDB:aNews.title],
                             aNews.trueTotalView,
                             aNews.nodeId];
            
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"update statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: update statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[update statement into WorkDay] closed database");
            } else {
                //DLog(@"[update statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult)deleteAllNews
{
    if (!database)
         database = [VMDataBase getNewDBConnection];
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",DB_TABLE_NEWS];

            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", DB_TABLE_NEWS);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", DB_TABLE_NEWS, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", DB_TABLE_NEWS, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}



+(DBResult)deleteNewsWithID:(NSString*)newsID
{
    if (!database)
         database = [VMDataBase getNewDBConnection];
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //CORRECT?
            //BOOL susccessful = [database executeUpdate:@"DELETE FROM %@ WHERE nodeId = ?", DB_TABLE_NEWS,newsID];
            BOOL susccessful;
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE nodeId = %@", DB_TABLE_NEWS, newsID];
            susccessful = [database executeUpdate:sql];

            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", DB_TABLE_NEWS);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", DB_TABLE_NEWS, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", DB_TABLE_NEWS, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

+(DBResult)deleteNewsWithCategoryID:(NSString *)categoryID
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", DB_TABLE_NEWS,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE categoryID = \'%@\'", DB_TABLE_NEWS,categoryID];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"delete statement into %@ successful", DB_TABLE_NEWS);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", DB_TABLE_NEWS, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", DB_TABLE_NEWS, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

//***************************************************************************************************
#pragma mark - category by singer

+ (NSMutableArray *) getAllCategoryForContentType:(ContentTypeID)contentType
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrCategories = nil;
    NSString *tableName = DB_TABLE_CATEGORY_SINGER;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE contentTypeId = \'%d\'",tableName,contentType];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrCategories = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    CategoryBySinger *aCategory            =  [CategoryBySinger new];
                
                     aCategory.contentTypeId               = [results stringForColumn:@"contentTypeId"];
                     aCategory.categoryId                  = [results stringForColumn:@"categoryId"];
                     aCategory.bigIconImageFilePath        = [results stringForColumn:@"bigIconImageFilePath"];
                     aCategory.countryId                   = [results stringForColumn:@"countryId"];
                     aCategory.countryName                 = [results stringForColumn:@"countryName"];
                     aCategory.demographicDescription      = [results stringForColumn:@"demographicDescription"];
                     aCategory.demographicId               = [results stringForColumn:@"demographicId"];
                     aCategory.demographicName             = [results stringForColumn:@"demographicName"];
                     aCategory.description                 = [results stringForColumn:@"description"];
                     aCategory.forumLink                   = [results stringForColumn:@"forumLink"];
                     aCategory.iconImageFilePath           = [results stringForColumn:@"iconImageFilePath"];
                     aCategory.name                        = [results stringForColumn:@"name"];
                     aCategory.order                       = [results intForColumn:@"orderCategory"];
                     aCategory.parentId                    = [results stringForColumn:@"parentId"];
                     aCategory.thumbnailImagePath          = [results stringForColumn:@"thumbnailImagePath"];
                    
                    [arrCategories addObject:aCategory];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrCategories;
}




+ (DBResult) insertCategoryBySinger:(CategoryBySinger*)categoryBySinger
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_CATEGORY_SINGER;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            //delete first
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE categoryId=%@", tableName, categoryBySinger.categoryId];
            [database executeUpdateWithFormat:sql];
            //-- excuting db
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (contentTypeId, categoryId, bigIconImageFilePath, countryId, countryName, demographicDescription, demographicId, demographicName, description, forumLink, iconImageFilePath, name, orderCategory, parentId, thumbnailImagePath) VALUES (\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', %d, \'%@\', \'%@\')",
                                tableName,
                                categoryBySinger.contentTypeId,
                                categoryBySinger.categoryId,
                                categoryBySinger.bigIconImageFilePath,
                                categoryBySinger.countryId,
                                categoryBySinger.countryName,
                                categoryBySinger.demographicDescription,
                                categoryBySinger.demographicId,
                                categoryBySinger.demographicName,
                                categoryBySinger.description,
                                categoryBySinger.forumLink,
                                categoryBySinger.iconImageFilePath,
                                categoryBySinger.name,
                                categoryBySinger.order,
                                categoryBySinger.parentId,
                                categoryBySinger.thumbnailImagePath];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}



+ (DBResult)deleteAllCategoriesForContentTypeId:(ContentTypeID)contentType
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_CATEGORY_SINGER;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //CORRECT?
            //BOOL susccessful = [database executeUpdate:@"DELETE FROM ? WHERE contentTypeId = ?", tableName, [NSNumber numberWithInt:contentType]];
            BOOL susccessful;
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE contentTypeId = %@", tableName, [NSNumber numberWithInt:contentType]];
            susccessful = [database executeUpdate:sql];

            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}



#pragma mark - Music

//-- Music Album --//

+ (NSMutableArray *) getAllAlbumForContentType:(ContentTypeID)contentType
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrAlbum = nil;
    NSString *tableName = DB_TABLE_MUSIC_ALBUM;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrAlbum = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    MusicAlbum *aAlbum               =  [[MusicAlbum alloc] init];
                    
                    aAlbum.albumId                   = [results stringForColumn:@"albumId"];
                    aAlbum.name                      = [results stringForColumn:@"name"];
                    aAlbum.englishName               = [results stringForColumn:@"englishName"];
                    aAlbum.description               = [results stringForColumn:@"description"];
                    aAlbum.thumbImagePath            = [results stringForColumn:@"thumbImagePath"];
                    aAlbum.thumbImagePathThumb       = [results stringForColumn:@"thumbImagePathThumb"];
                    aAlbum.musicType                 = [results stringForColumn:@"musicType"];
                    aAlbum.totalTrack                = [results stringForColumn:@"totalTrack"];
                    aAlbum.totalMusic                = [results stringForColumn:@"totalMusic"];
                    aAlbum.trueTotalView             = [results stringForColumn:@"trueTotalView"];
                    aAlbum.settingTotalView          = [results stringForColumn:@"settingTotalView"];
                    aAlbum.trueTotalRating           = [results stringForColumn:@"trueTotalRating"];
                    aAlbum.settingTotalRating        = [results stringForColumn:@"settingTotalRating"];
                    aAlbum.contentProviderId         = [results stringForColumn:@"contentProviderId"];
                    aAlbum.authorMusicId             = [results stringForColumn:@"authorMusicId"];
                    aAlbum.musicPublisherId          = [results stringForColumn:@"musicPublisherId"];
                    aAlbum.isHot                     = [results stringForColumn:@"isHot"];
                    aAlbum.musicList                 = [results stringForColumn:@"musicList"];
                    
                    aAlbum.name = [Utility convertAndReplaceDoLaToHtml:aAlbum.name];
                    aAlbum.description = [Utility convertAndReplaceDoLaToHtml:aAlbum.description];
                    aAlbum.thumbImagePath = [Utility convertAndReplaceDoLaToHtml:aAlbum.thumbImagePath];
                    aAlbum.thumbImagePathThumb = [Utility convertAndReplaceDoLaToHtml:aAlbum.thumbImagePathThumb];

                    [arrAlbum addObject:aAlbum];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrAlbum;
}


+ (DBResult) insertAlbumBySinger:(MusicAlbum*)albumBySinger
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_MUSIC_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (albumId, name, englishName, description, thumbImagePath, thumbImagePathThumb, musicType, totalTrack, totalMusic, trueTotalView, settingTotalView, trueTotalRating, settingTotalRating, contentProviderId, authorMusicId, musicPublisherId, isHot, musicList) VALUES (\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\')",
                             tableName,
                             albumBySinger.albumId,
                             [Utility checkAndReplaceHtmlInsertToDB:albumBySinger.name],
                             albumBySinger.englishName,
                             [Utility checkAndReplaceHtmlInsertToDB:albumBySinger.description],
                             [Utility checkAndReplaceHtmlInsertToDB:albumBySinger.thumbImagePath],
                             [Utility checkAndReplaceHtmlInsertToDB:albumBySinger.thumbImagePathThumb],
                             albumBySinger.musicType,
                             albumBySinger.totalTrack,
                             albumBySinger.totalMusic,
                             albumBySinger.trueTotalView,
                             albumBySinger.settingTotalView,
                             albumBySinger.trueTotalRating,
                             albumBySinger.settingTotalRating,
                             albumBySinger.contentProviderId,
                             albumBySinger.authorMusicId,
                             albumBySinger.musicPublisherId,
                             albumBySinger.isHot,
                             albumBySinger.musicList];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult)deleteAllAlbumFromDB
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_MUSIC_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];

            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}



#pragma mark -/-
//-- Music Track --//


+ (NSMutableArray *) getAllTrackByAlbumId:(NSString *)albumId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrTrack = nil;
    NSString *tableName = DB_TABLE_MUSIC_TRACK;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql;
            if (albumId && [albumId length] > 0)
                sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE albumId = \'%@\'",tableName,albumId];
            else
                sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
            
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrTrack = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    MusicTrackNew *aTrack               =  [[MusicTrackNew alloc] init];
                    
                    aTrack.songRingbacktoneId        = [results stringForColumn:@"songRingbacktoneId"];
                    aTrack.albumAuthorMusicId        = [results stringForColumn:@"albumAuthorMusicId"];
                    aTrack.albumDescription          = [results stringForColumn:@"albumDescription"];
                    aTrack.albumEngName              = [results stringForColumn:@"albumEngName"];
                    aTrack.albumId                   = [results stringForColumn:@"albumId"];
                    aTrack.albumIsHot                = [results stringForColumn:@"albumIsHot"];
                    aTrack.albumMusicPublisherId     = [results stringForColumn:@"albumMusicPublisherId"];
                    aTrack.albumMusicType            = [results stringForColumn:@"albumMusicType"];
                    aTrack.albumName                 = [results stringForColumn:@"albumName"];
                    aTrack.albumPublishedYear        = [results stringForColumn:@"albumPublishedYear"];
                    aTrack.albumSetingTotalRating    = [results stringForColumn:@"albumSetingTotalRating"];
                    aTrack.albumSettingTotalView     = [results stringForColumn:@"albumSettingTotalView"];
                    aTrack.albumThumbImagePath       = [results stringForColumn:@"albumThumbImagePath"];
                    aTrack.albumTotalTrack           = [results stringForColumn:@"albumTotalTrack"];
                    aTrack.albumTrueTotalRating      = [results stringForColumn:@"albumTrueTotalRating"];
                    aTrack.albumTrueTotalView        = [results stringForColumn:@"albumTrueTotalView"];
                    aTrack.content                   = [results stringForColumn:@"content"];
                    aTrack.countryId                 = [results stringForColumn:@"countryId"];
                    aTrack.nodeId                    = [results stringForColumn:@"nodeId"];
                    aTrack.name                      = [results stringForColumn:@"name"];
                    aTrack.musicPath                 = [results stringForColumn:@"musicPath"];
                    aTrack.engName                   = [results stringForColumn:@"engName"];
                    aTrack.isHot                     = [results stringForColumn:@"isHot"];
                    aTrack.musicType                 = [results stringForColumn:@"musicType"];
                    aTrack.numberOfTrack             = [results stringForColumn:@"numberOfTrack"];
                    aTrack.musicContent              = [results stringForColumn:@"musicContent"];
                    aTrack.translateContent          = [results stringForColumn:@"translateContent"];
                    aTrack.thumbImagePath            = [results stringForColumn:@"thumbImagePath"];
                    aTrack.thumbImageType            = [results stringForColumn:@"thumbImageType"];
                    aTrack.trueTotalView             = [results stringForColumn:@"trueTotalView"];
                    aTrack.trueTotalRating           = [results stringForColumn:@"trueTotalRating"];
                    aTrack.settingTotalRating        = [results stringForColumn:@"settingTotalRating"];
                    aTrack.settingTotalView          = [results stringForColumn:@"settingTotalView"];
                    aTrack.snsTotalComment           = [results stringForColumn:@"snsTotalComment"];
                    aTrack.snsTotalDisLike           = [results stringForColumn:@"snsTotalDisLike"];
                    aTrack.snsTotalLike              = [results stringForColumn:@"snsTotalLike"];
                    aTrack.snsTotalShare             = [results stringForColumn:@"snsTotalShare"];
                    aTrack.snsTotalView              = [results stringForColumn:@"snsTotalView"];
                    aTrack.isLiked                   = [results stringForColumn:@"isLiked"];
                    
                    aTrack.content = [Utility convertAndReplaceDoLaToHtml:aTrack.content];
                    aTrack.name = [Utility convertAndReplaceDoLaToHtml:aTrack.name];
                    aTrack.musicPath = [Utility convertAndReplaceDoLaToHtml:aTrack.musicPath];
                    aTrack.musicContent = [Utility convertAndReplaceDoLaToHtml:aTrack.musicContent];
                    aTrack.thumbImagePath = [Utility convertAndReplaceDoLaToHtml:aTrack.thumbImagePath];
                    
                    aTrack.albumDescription = [Utility convertAndReplaceDoLaToHtml:aTrack.albumDescription];
                    aTrack.albumEngName = [Utility convertAndReplaceDoLaToHtml:aTrack.albumEngName];
                    aTrack.albumName = [Utility convertAndReplaceDoLaToHtml:aTrack.albumName];
                    aTrack.engName = [Utility convertAndReplaceDoLaToHtml:aTrack.engName];
                    aTrack.translateContent = [Utility convertAndReplaceDoLaToHtml:aTrack.translateContent];
                    
                    
                    [arrTrack addObject:aTrack];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrTrack;
}

+ (MusicTrackNew *) getATrackByNodeId:(NSString *)nodeId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    MusicTrackNew *aTrack = nil;
    NSString *tableName = DB_TABLE_MUSIC_TRACK;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE nodeId = \'%@\'",tableName,nodeId];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                aTrack = [[MusicTrackNew alloc] init];
                
                while(results.next)
                {
                    aTrack.songRingbacktoneId        = [results stringForColumn:@"songRingbacktoneId"];
                    aTrack.albumAuthorMusicId        = [results stringForColumn:@"albumAuthorMusicId"];
                    aTrack.albumDescription          = [results stringForColumn:@"albumDescription"];
                    aTrack.albumEngName              = [results stringForColumn:@"albumEngName"];
                    aTrack.albumId                   = [results stringForColumn:@"albumId"];
                    aTrack.albumIsHot                = [results stringForColumn:@"albumIsHot"];
                    aTrack.albumMusicPublisherId     = [results stringForColumn:@"albumMusicPublisherId"];
                    aTrack.albumMusicType            = [results stringForColumn:@"albumMusicType"];
                    aTrack.albumName                 = [results stringForColumn:@"albumName"];
                    aTrack.albumPublishedYear        = [results stringForColumn:@"albumPublishedYear"];
                    aTrack.albumSetingTotalRating    = [results stringForColumn:@"albumSetingTotalRating"];
                    aTrack.albumSettingTotalView     = [results stringForColumn:@"albumSettingTotalView"];
                    aTrack.albumThumbImagePath       = [results stringForColumn:@"albumThumbImagePath"];
                    aTrack.albumTotalTrack           = [results stringForColumn:@"albumTotalTrack"];
                    aTrack.albumTrueTotalRating      = [results stringForColumn:@"albumTrueTotalRating"];
                    aTrack.albumTrueTotalView        = [results stringForColumn:@"albumTrueTotalView"];
                    aTrack.content                   = [results stringForColumn:@"content"];
                    aTrack.countryId                 = [results stringForColumn:@"countryId"];
                    aTrack.nodeId                    = [results stringForColumn:@"nodeId"];
                    aTrack.name                      = [results stringForColumn:@"name"];
                    aTrack.musicPath                 = [results stringForColumn:@"musicPath"];
                    aTrack.engName                   = [results stringForColumn:@"engName"];
                    aTrack.isHot                     = [results stringForColumn:@"isHot"];
                    aTrack.musicType                 = [results stringForColumn:@"musicType"];
                    aTrack.numberOfTrack             = [results stringForColumn:@"numberOfTrack"];
                    aTrack.musicContent              = [results stringForColumn:@"musicContent"];
                    aTrack.translateContent          = [results stringForColumn:@"translateContent"];
                    aTrack.thumbImagePath            = [results stringForColumn:@"thumbImagePath"];
                    aTrack.thumbImageType            = [results stringForColumn:@"thumbImageType"];
                    aTrack.trueTotalView             = [results stringForColumn:@"trueTotalView"];
                    aTrack.trueTotalRating           = [results stringForColumn:@"trueTotalRating"];
                    aTrack.settingTotalRating        = [results stringForColumn:@"settingTotalRating"];
                    aTrack.settingTotalView          = [results stringForColumn:@"settingTotalView"];
                    aTrack.snsTotalComment           = [results stringForColumn:@"snsTotalComment"];
                    aTrack.snsTotalDisLike           = [results stringForColumn:@"snsTotalDisLike"];
                    aTrack.snsTotalLike              = [results stringForColumn:@"snsTotalLike"];
                    aTrack.snsTotalShare             = [results stringForColumn:@"snsTotalShare"];
                    aTrack.snsTotalView              = [results stringForColumn:@"snsTotalView"];
                    aTrack.isLiked                   = [results stringForColumn:@"isLiked"];
                    
                    aTrack.content = [Utility convertAndReplaceDoLaToHtml:aTrack.content];
                    aTrack.name = [Utility convertAndReplaceDoLaToHtml:aTrack.name];
                    aTrack.musicPath = [Utility convertAndReplaceDoLaToHtml:aTrack.musicPath];
                    aTrack.musicContent = [Utility convertAndReplaceDoLaToHtml:aTrack.musicContent];
                    aTrack.thumbImagePath = [Utility convertAndReplaceDoLaToHtml:aTrack.thumbImagePath];
                    
                    aTrack.albumDescription = [Utility convertAndReplaceDoLaToHtml:aTrack.albumDescription];
                    aTrack.albumEngName = [Utility convertAndReplaceDoLaToHtml:aTrack.albumEngName];
                    aTrack.albumName = [Utility convertAndReplaceDoLaToHtml:aTrack.albumName];
                    aTrack.engName = [Utility convertAndReplaceDoLaToHtml:aTrack.engName];
                    aTrack.translateContent = [Utility convertAndReplaceDoLaToHtml:aTrack.translateContent];

                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return aTrack;
}


+ (DBResult) insertTrackByAlbum:(MusicTrackNew*)trackInAlbum
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_MUSIC_TRACK;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (albumAuthorMusicId, albumDescription, albumEngName, albumId, albumIsHot, albumMusicPublisherId, albumMusicType, albumName, albumPublishedYear, albumSetingTotalRating, albumSettingTotalView, albumThumbImagePath, albumTotalTrack, albumTrueTotalRating, albumTrueTotalView, content, countryId, nodeId, name, musicPath, engName, isHot, musicType, numberOfTrack, musicContent, translateContent, thumbImagePath, thumbImageType, trueTotalView, trueTotalRating, settingTotalRating, settingTotalView, snsTotalComment, snsTotalDisLike, snsTotalLike, snsTotalShare, snsTotalView, isLiked, songRingbacktoneId) VALUES (\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\')",
                             tableName,
                             trackInAlbum.albumAuthorMusicId,
                             [Utility checkAndReplaceHtmlInsertToDB:trackInAlbum.albumDescription],
                             [Utility checkAndReplaceHtmlInsertToDB:trackInAlbum.albumEngName],
                             trackInAlbum.albumId,
                             trackInAlbum.albumIsHot,
                             trackInAlbum.albumMusicPublisherId,
                             trackInAlbum.albumMusicType,
                             [Utility checkAndReplaceHtmlInsertToDB:trackInAlbum.albumName],
                             trackInAlbum.albumPublishedYear,
                             trackInAlbum.albumSetingTotalRating,
                             trackInAlbum.albumSettingTotalView,
                             trackInAlbum.albumThumbImagePath,
                             trackInAlbum.albumTotalTrack,
                             trackInAlbum.albumTrueTotalRating,
                             trackInAlbum.albumTrueTotalView,
                             [Utility checkAndReplaceHtmlInsertToDB:trackInAlbum.content],
                             trackInAlbum.countryId,
                             trackInAlbum.nodeId,
                             [Utility checkAndReplaceHtmlInsertToDB:trackInAlbum.name],
                             [Utility checkAndReplaceHtmlInsertToDB:trackInAlbum.musicPath],
                             trackInAlbum.engName,
                             trackInAlbum.isHot,
                             trackInAlbum.musicType,
                             trackInAlbum.numberOfTrack,
                             [Utility checkAndReplaceHtmlInsertToDB:trackInAlbum.musicContent],
                             [Utility checkAndReplaceHtmlInsertToDB:trackInAlbum.translateContent],
                             [Utility checkAndReplaceHtmlInsertToDB:trackInAlbum.thumbImagePath],
                             trackInAlbum.thumbImageType,
                             trackInAlbum.trueTotalView,
                             trackInAlbum.trueTotalRating,
                             trackInAlbum.settingTotalRating,
                             trackInAlbum.settingTotalView,
                             trackInAlbum.snsTotalComment,
                             trackInAlbum.snsTotalDisLike,
                             trackInAlbum.snsTotalLike,
                             trackInAlbum.snsTotalShare,
                             trackInAlbum.snsTotalView,
                             trackInAlbum.isLiked,
                             trackInAlbum.songRingbacktoneId];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


//--update track
+ (DBResult)updateTrackByAlbum:(MusicTrackNew*)trackInAlbum
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_MUSIC_TRACK;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET songRingbacktoneId = \'%@\', snsTotalComment = \'%@\', snsTotalLike = \'%@\', snsTotalDisLike = \'%@\', snsTotalShare = \'%@\', snsTotalView = \'%@\', isLiked = \'%@\' WHERE nodeId = \'%@\'",
                             tableName,
                             trackInAlbum.songRingbacktoneId,
                             trackInAlbum.snsTotalComment,
                             trackInAlbum.snsTotalLike,
                             trackInAlbum.snsTotalDisLike,
                             trackInAlbum.snsTotalShare,
                             trackInAlbum.snsTotalView,
                             trackInAlbum.isLiked,
                             trackInAlbum.nodeId];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"update statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: update statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[update statement into WorkDay] closed database");
            } else {
                //DLog(@"[update statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult)deleteAllTrackByAlbumId:(NSString *)albumId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_MUSIC_TRACK;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            BOOL susccessful;
            NSString *sql;
            if ([albumId length] || albumId != nil) {
                sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE albumId = %@", tableName, albumId];
                //susccessful = [database executeUpdate:@"DELETE FROM ? WHERE albumId = ?", tableName, albumId];
            }else{
                sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
            }
            susccessful = [database executeUpdate:sql];
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult)deleteTrackByNodeId:(NSString *)nodeId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_MUSIC_TRACK;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //CORRECT?
            //BOOL susccessful = [database executeUpdate:@"DELETE FROM ? WHERE nodeId = ?", tableName, nodeId];
            BOOL susccessful;
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE nodeId = %@", tableName, nodeId];
            susccessful = [database executeUpdate:sql];

            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


//***************************************************************************************************
#pragma mark - Category By Video


+ (NSMutableArray *) getAllCategoryVideoForContentType:(ContentTypeID)contentType
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrCategories = nil;
    NSString *tableName = DB_TABLE_CATEGORY_VIDEO;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE contentTypeId = \'%d\'",tableName,contentType];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrCategories = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    CategoryBySinger *aCategory            =  [CategoryBySinger new];
                    
                    aCategory.contentTypeId               = [results stringForColumn:@"contentTypeId"];
                    aCategory.categoryId                  = [results stringForColumn:@"categoryId"];
                    aCategory.bigIconImageFilePath        = [results stringForColumn:@"bigIconImageFilePath"];
                    aCategory.countryId                   = [results stringForColumn:@"countryId"];
                    aCategory.countryName                 = [results stringForColumn:@"countryName"];
                    aCategory.demographicDescription      = [results stringForColumn:@"demographicDescription"];
                    aCategory.demographicId               = [results stringForColumn:@"demographicId"];
                    aCategory.demographicName             = [results stringForColumn:@"demographicName"];
                    aCategory.description                 = [results stringForColumn:@"description"];
                    aCategory.forumLink                   = [results stringForColumn:@"forumLink"];
                    aCategory.iconImageFilePath           = [results stringForColumn:@"iconImageFilePath"];
                    aCategory.name                        = [results stringForColumn:@"name"];
                    aCategory.order                       = [results intForColumn:@"orderCategory"];
                    aCategory.parentId                    = [results stringForColumn:@"parentId"];
                    aCategory.thumbnailImagePath          = [results stringForColumn:@"thumbnailImagePath"];
                    
                    [arrCategories addObject:aCategory];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrCategories;
}


+ (DBResult) insertCategoryByVideo:(CategoryBySinger*)categoryBySinger
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_CATEGORY_VIDEO;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (contentTypeId, categoryId, bigIconImageFilePath, countryId, countryName, demographicDescription, demographicId, demographicName, description, forumLink, iconImageFilePath, name, orderCategory, parentId, thumbnailImagePath) VALUES (\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', %d, \'%@\', \'%@\')",
                             tableName,
                             categoryBySinger.contentTypeId,
                             categoryBySinger.categoryId,
                             categoryBySinger.bigIconImageFilePath,
                             categoryBySinger.countryId,
                             categoryBySinger.countryName,
                             categoryBySinger.demographicDescription,
                             categoryBySinger.demographicId,
                             categoryBySinger.demographicName,
                             categoryBySinger.description,
                             categoryBySinger.forumLink,
                             categoryBySinger.iconImageFilePath,
                             categoryBySinger.name,
                             categoryBySinger.order,
                             categoryBySinger.parentId,
                             categoryBySinger.thumbnailImagePath];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult)deleteAllCategoriesByVideoForContentTypeId:(ContentTypeID)contentType
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_CATEGORY_VIDEO;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //CORRECT
            //BOOL susccessful = [database executeUpdate:@"DELETE FROM ? WHERE contentTypeId = ?", tableName, [NSNumber numberWithInt:contentType]];
            BOOL susccessful;
            NSString *sql;
            if (contentType==ContentTypeIDAllVideo)
                sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
            else
                sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE contentTypeId = %@", tableName, [NSNumber numberWithInt:contentType]];
            susccessful = [database executeUpdate:sql];

            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


//-- Video OffiCial and UnOffiCial Of Album --//

/**
 *  get multiple rows with contentType at Video OffiCial Of Album
 **/
+ (NSMutableArray *) getAllVideosOffiCialByCategoryId:(NSString *)categoryIdStr {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrAlbum = nil;
    NSString *tableName = DB_TABLE_VIDEO_OffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            NSString *sql = @"";
            if (categoryIdStr && [categoryIdStr length] > 0) {
                sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE categoryID = \'%@\'",tableName,categoryIdStr];
            }else{
                sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
            }
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrAlbum = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    VideoForAll *aVideo = [VideoForAll new];
                    
                    aVideo.albumAuthorMusicId = [results stringForColumn:@"albumAuthorMusicId"];
                    aVideo.albumDescription = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"albumDescription"]];
                    aVideo.albumEngName = [results stringForColumn:@"albumEngName"];
                    aVideo.albumId = [results stringForColumn:@"albumId"];
                    aVideo.albumIsHot = [results stringForColumn:@"albumIsHot"];
                    aVideo.albumMusicPublisherId = [results stringForColumn:@"albumMusicPublisherId"];
                    aVideo.albumMusicType = [results stringForColumn:@"albumMusicType"];
                    aVideo.albumName = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"albumName"]];
                    aVideo.albumPublishedYear = [results stringForColumn:@"albumPublishedYear"];
                    aVideo.albumSetingTotalRating = [results stringForColumn:@"albumSetingTotalRating"];
                    aVideo.albumSettingTotalView = [results stringForColumn:@"albumSettingTotalView"];
                    aVideo.albumThumbImagePath = [results stringForColumn:@"albumThumbImagePath"];
                    aVideo.albumTotalTrack = [results stringForColumn:@"albumTotalTrack"];
                    aVideo.albumTrueTotalRating = [results stringForColumn:@"albumTrueTotalRating"];
                    aVideo.albumTrueTotalView = [results stringForColumn:@"albumTrueTotalView"];
                    aVideo.categoryList = [results stringForColumn:@"categoryList"];
                    aVideo.content = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"content"]];
                    aVideo.countryId = [results stringForColumn:@"countryId"];
                    aVideo.engName = [results stringForColumn:@"engName"];
                    aVideo.isHot = [results stringForColumn:@"isHot"];
                    aVideo.musicPath = [results stringForColumn:@"musicPath"];
                    aVideo.musicType = [results stringForColumn:@"musicType"];
                    aVideo.name = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"name"]];
                    aVideo.nodeId = [results stringForColumn:@"nodeId"];
                    aVideo.numberOfTrack = [results stringForColumn:@"numberOfTrack"];
                    aVideo.settingTotalRating = [results stringForColumn:@"settingTotalRating"];
                    aVideo.settingTotalView = [results stringForColumn:@"settingTotalView"];
                    aVideo.thumbImagePath = [results stringForColumn:@"thumbImagePath"];
                    aVideo.thumbImageType = [results stringForColumn:@"thumbImageType"];
                    aVideo.translateContent = [results stringForColumn:@"translateContent"];
                    aVideo.trueTotalRating = [results stringForColumn:@"trueTotalRating"];
                    aVideo.trueTotalView = [results stringForColumn:@"trueTotalView"];
                    aVideo.youtubeUrl = [results stringForColumn:@"youtubeUrl"];
                    aVideo.snsTotalDisLike = [results stringForColumn:@"snsTotalDisLike"];
                    aVideo.snsTotalShare = [results stringForColumn:@"snsTotalShare"];
                    aVideo.snsTotalComment = [results stringForColumn:@"snsTotalComment"];
                    aVideo.snsTotalLike = [results stringForColumn:@"snsTotalLike"];
                    aVideo.snsTotalView = [results stringForColumn:@"snsTotalView"];
                    aVideo.isLiked = [results stringForColumn:@"isLiked"];
                    
                    [arrAlbum addObject:aVideo];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrAlbum;
}

+ (NSMutableArray *) getAllVideosOffiCial:(NSString *)categoryId {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrAlbum = nil;
    NSString *tableName = DB_TABLE_VIDEO_OffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            NSString *sql = @"";
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE categoryID=\'%@\'",tableName,categoryId];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrAlbum = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    VideoForAll *aVideo = [VideoForAll new];
                    
                    aVideo.albumAuthorMusicId = [results stringForColumn:@"albumAuthorMusicId"];
                    aVideo.albumDescription = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"albumDescription"]];
                    aVideo.albumEngName = [results stringForColumn:@"albumEngName"];
                    aVideo.albumId = [results stringForColumn:@"albumId"];
                    aVideo.albumIsHot = [results stringForColumn:@"albumIsHot"];
                    aVideo.albumMusicPublisherId = [results stringForColumn:@"albumMusicPublisherId"];
                    aVideo.albumMusicType = [results stringForColumn:@"albumMusicType"];
                    aVideo.albumName = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"albumName"]];
                    aVideo.albumPublishedYear = [results stringForColumn:@"albumPublishedYear"];
                    aVideo.albumSetingTotalRating = [results stringForColumn:@"albumSetingTotalRating"];
                    aVideo.albumSettingTotalView = [results stringForColumn:@"albumSettingTotalView"];
                    aVideo.albumThumbImagePath = [results stringForColumn:@"albumThumbImagePath"];
                    aVideo.albumTotalTrack = [results stringForColumn:@"albumTotalTrack"];
                    aVideo.albumTrueTotalRating = [results stringForColumn:@"albumTrueTotalRating"];
                    aVideo.albumTrueTotalView = [results stringForColumn:@"albumTrueTotalView"];
                    aVideo.categoryList = [results stringForColumn:@"categoryList"];
                    aVideo.content = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"content"]];
                    aVideo.countryId = [results stringForColumn:@"countryId"];
                    aVideo.engName = [results stringForColumn:@"engName"];
                    aVideo.isHot = [results stringForColumn:@"isHot"];
                    aVideo.musicPath = [results stringForColumn:@"musicPath"];
                    aVideo.musicType = [results stringForColumn:@"musicType"];
                    aVideo.name = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"name"]];
                    aVideo.nodeId = [results stringForColumn:@"nodeId"];
                    aVideo.numberOfTrack = [results stringForColumn:@"numberOfTrack"];
                    aVideo.settingTotalRating = [results stringForColumn:@"settingTotalRating"];
                    aVideo.settingTotalView = [results stringForColumn:@"settingTotalView"];
                    aVideo.thumbImagePath = [results stringForColumn:@"thumbImagePath"];
                    aVideo.thumbImageType = [results stringForColumn:@"thumbImageType"];
                    aVideo.translateContent = [results stringForColumn:@"translateContent"];
                    aVideo.trueTotalRating = [results stringForColumn:@"trueTotalRating"];
                    aVideo.trueTotalView = [results stringForColumn:@"trueTotalView"];
                    aVideo.youtubeUrl = [results stringForColumn:@"youtubeUrl"];
                    aVideo.snsTotalDisLike = [results stringForColumn:@"snsTotalDisLike"];
                    aVideo.snsTotalShare = [results stringForColumn:@"snsTotalShare"];
                    aVideo.snsTotalComment = [results stringForColumn:@"snsTotalComment"];
                    aVideo.snsTotalLike = [results stringForColumn:@"snsTotalLike"];
                    aVideo.snsTotalView = [results stringForColumn:@"snsTotalView"];
                    aVideo.isLiked = [results stringForColumn:@"isLiked"];
                    
                    [arrAlbum addObject:aVideo];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrAlbum;
}

/**
 *  get multiple rows with contentType at Video UnOffiCial Of Album
 **/
+ (NSMutableArray *) getAllVideosUnOffiCialByCategoryId:(NSString *)categoryIdStr {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrAlbum = nil;
    NSString *tableName = DB_TABLE_VIDEO_UnOffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = @"";
            if (categoryIdStr && [categoryIdStr length] > 0) {
                sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE categoryID = \'%@\'",tableName,categoryIdStr];
            }else{
                sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
            }
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrAlbum = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    VideoForCategory *aVideo = [VideoForCategory new];
                    
                    aVideo.categoryID = [results stringForColumn:@"categoryID"];
                    aVideo.body = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"body"]];
                    aVideo.countryID = [results stringForColumn:@"countryID"];
                    aVideo.isHot = [results stringForColumn:@"isHot"];
                    aVideo.nodeID = [results stringForColumn:@"nodeID"];
                    aVideo.orderVideo = [results stringForColumn:@"orderVideo"];
                    aVideo.settingTotalView = [results stringForColumn:@"settingTotalView"];
                    aVideo.shortBody = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"shortBody"]];
                    aVideo.thumbnailImagePath = [results stringForColumn:@"thumbnailImagePath"];
                    aVideo.title = [results stringForColumn:@"title"];
                    aVideo.trueTotalView = [results stringForColumn:@"trueTotalView"];
                    aVideo.videoFacebookPath = [results stringForColumn:@"videoFacebookPath"];
                    aVideo.videoFilePath = [results stringForColumn:@"videoFilePath"];
                    aVideo.videoYoutubePath = [results stringForColumn:@"videoYoutubePath"];
                    aVideo.youtubeUrl = [results stringForColumn:@"youtubeUrl"];
                    aVideo.snsTotalDisLike = [results stringForColumn:@"snsTotalDisLike"];
                    aVideo.snsTotalShare = [results stringForColumn:@"snsTotalShare"];
                    aVideo.snsTotalView = [results stringForColumn:@"snsTotalView"];
                    aVideo.snsTotalComment = [results stringForColumn:@"snsTotalComment"];
                    aVideo.snsTotalLike = [results stringForColumn:@"snsTotalLike"];
                    aVideo.isLiked = [results stringForColumn:@"isLiked"];
                    
                    [arrAlbum addObject:aVideo];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            //DLog(@"Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrAlbum;
}

//ko hieu sao voi UnOfficeial DB lai cho unique NodeId
+ (NSMutableArray *) getAllVideosUnOffiCial:(NSString *)categoryId {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrAlbum = nil;
    NSString *tableName = DB_TABLE_VIDEO_UnOffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = @"";
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE categoryID=\'%@\'",tableName, categoryId];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrAlbum = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    VideoForCategory *aVideo = [VideoForCategory new];
                    
                    aVideo.categoryID = [results stringForColumn:@"categoryID"];
                    aVideo.body = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"body"]];
                    aVideo.countryID = [results stringForColumn:@"countryID"];
                    aVideo.isHot = [results stringForColumn:@"isHot"];
                    aVideo.nodeID = [results stringForColumn:@"nodeID"];
                    aVideo.orderVideo = [results stringForColumn:@"orderVideo"];
                    aVideo.settingTotalView = [results stringForColumn:@"settingTotalView"];
                    aVideo.shortBody = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"shortBody"]];
                    aVideo.thumbnailImagePath = [results stringForColumn:@"thumbnailImagePath"];
                    aVideo.title = [results stringForColumn:@"title"];
                    aVideo.trueTotalView = [results stringForColumn:@"trueTotalView"];
                    aVideo.videoFacebookPath = [results stringForColumn:@"videoFacebookPath"];
                    aVideo.videoFilePath = [results stringForColumn:@"videoFilePath"];
                    aVideo.videoYoutubePath = [results stringForColumn:@"videoYoutubePath"];
                    aVideo.youtubeUrl = [results stringForColumn:@"youtubeUrl"];
                    aVideo.snsTotalDisLike = [results stringForColumn:@"snsTotalDisLike"];
                    aVideo.snsTotalShare = [results stringForColumn:@"snsTotalShare"];
                    aVideo.snsTotalView = [results stringForColumn:@"snsTotalView"];
                    aVideo.snsTotalComment = [results stringForColumn:@"snsTotalComment"];
                    aVideo.snsTotalLike = [results stringForColumn:@"snsTotalLike"];
                    aVideo.isLiked = [results stringForColumn:@"isLiked"];
                    
                    [arrAlbum addObject:aVideo];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            //DLog(@"Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrAlbum;
}

/**
 *  get a rows with contentType at Video OffiCial Of Album
 **/
+ (VideoForAll *) getAVideosOffiCialByNodeId:(NSString *)nodeId categoryId:(NSString *)categoryId {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    VideoForAll *aVideo = nil;
    NSString *tableName = DB_TABLE_VIDEO_OffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE nodeId = \'%@\' AND categoryID=\'%@\'",tableName,nodeId, categoryId];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                aVideo = [VideoForAll new];
                
                while(results.next)
                {
                    aVideo.albumAuthorMusicId = [results stringForColumn:@"albumAuthorMusicId"];
                    aVideo.albumDescription = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"albumDescription"]];
                    aVideo.albumEngName = [results stringForColumn:@"albumEngName"];
                    aVideo.albumId = [results stringForColumn:@"albumId"];
                    aVideo.albumIsHot = [results stringForColumn:@"albumIsHot"];
                    aVideo.albumMusicPublisherId = [results stringForColumn:@"albumMusicPublisherId"];
                    aVideo.albumMusicType = [results stringForColumn:@"albumMusicType"];
                    aVideo.albumName = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"albumName"]];
                    aVideo.albumPublishedYear = [results stringForColumn:@"albumPublishedYear"];
                    aVideo.albumSetingTotalRating = [results stringForColumn:@"albumSetingTotalRating"];
                    aVideo.albumSettingTotalView = [results stringForColumn:@"albumSettingTotalView"];
                    aVideo.albumThumbImagePath = [results stringForColumn:@"albumThumbImagePath"];
                    aVideo.albumTotalTrack = [results stringForColumn:@"albumTotalTrack"];
                    aVideo.albumTrueTotalRating = [results stringForColumn:@"albumTrueTotalRating"];
                    aVideo.albumTrueTotalView = [results stringForColumn:@"albumTrueTotalView"];
                    aVideo.categoryList = [results stringForColumn:@"categoryList"];
                    aVideo.content = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"content"]];
                    aVideo.countryId = [results stringForColumn:@"countryId"];
                    aVideo.engName = [results stringForColumn:@"engName"];
                    aVideo.isHot = [results stringForColumn:@"isHot"];
                    aVideo.musicPath = [results stringForColumn:@"musicPath"];
                    aVideo.musicType = [results stringForColumn:@"musicType"];
                    aVideo.name = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"name"]];
                    aVideo.nodeId = [results stringForColumn:@"nodeId"];
                    aVideo.numberOfTrack = [results stringForColumn:@"numberOfTrack"];
                    aVideo.settingTotalRating = [results stringForColumn:@"settingTotalRating"];
                    aVideo.settingTotalView = [results stringForColumn:@"settingTotalView"];
                    aVideo.thumbImagePath = [results stringForColumn:@"thumbImagePath"];
                    aVideo.thumbImageType = [results stringForColumn:@"thumbImageType"];
                    aVideo.translateContent = [results stringForColumn:@"translateContent"];
                    aVideo.trueTotalRating = [results stringForColumn:@"trueTotalRating"];
                    aVideo.trueTotalView = [results stringForColumn:@"trueTotalView"];
                    aVideo.youtubeUrl = [results stringForColumn:@"youtubeUrl"];
                    aVideo.snsTotalDisLike = [results stringForColumn:@"snsTotalDisLike"];
                    aVideo.snsTotalShare = [results stringForColumn:@"snsTotalShare"];
                    aVideo.snsTotalComment = [results stringForColumn:@"snsTotalComment"];
                    aVideo.snsTotalLike = [results stringForColumn:@"snsTotalLike"];
                    aVideo.snsTotalView = [results stringForColumn:@"snsTotalView"];
                    aVideo.isLiked = [results stringForColumn:@"isLiked"];
                    
                }
            }else {
                //DLog(@"select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            //DLog(@"Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return aVideo;
}


/**
 *  get multiple rows with contentType at Video UnOffiCial Of Album
 **/
+ (VideoForCategory *) getAVideosUnOffiCialBynodeID:(NSString *)nodeIdStr categoryId:(NSString *)categoryId {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    VideoForCategory *aVideo = nil;
    NSString *tableName = DB_TABLE_VIDEO_UnOffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE nodeID = \'%@\' AND categoryID=\'%@\'",tableName,nodeIdStr, categoryId];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                aVideo = [VideoForCategory new];
                
                while(results.next)
                {
                    aVideo.categoryID = [results stringForColumn:@"categoryID"];
                    aVideo.body = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"body"]];
                    aVideo.countryID = [results stringForColumn:@"countryID"];
                    aVideo.isHot = [results stringForColumn:@"isHot"];
                    aVideo.nodeID = [results stringForColumn:@"nodeID"];
                    aVideo.orderVideo = [results stringForColumn:@"orderVideo"];
                    aVideo.settingTotalView = [results stringForColumn:@"settingTotalView"];
                    aVideo.shortBody = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"shortBody"]];
                    aVideo.thumbnailImagePath = [results stringForColumn:@"thumbnailImagePath"];
                    aVideo.title = [results stringForColumn:@"title"];
                    aVideo.trueTotalView = [results stringForColumn:@"trueTotalView"];
                    aVideo.videoFacebookPath = [results stringForColumn:@"videoFacebookPath"];
                    aVideo.videoFilePath = [results stringForColumn:@"videoFilePath"];
                    aVideo.videoYoutubePath = [results stringForColumn:@"videoYoutubePath"];
                    aVideo.youtubeUrl = [results stringForColumn:@"youtubeUrl"];
                    aVideo.snsTotalDisLike = [results stringForColumn:@"snsTotalDisLike"];
                    aVideo.snsTotalShare = [results stringForColumn:@"snsTotalShare"];
                    aVideo.snsTotalView = [results stringForColumn:@"snsTotalView"];
                    aVideo.snsTotalComment = [results stringForColumn:@"snsTotalComment"];
                    aVideo.snsTotalLike = [results stringForColumn:@"snsTotalLike"];
                    aVideo.isLiked = [results stringForColumn:@"isLiked"];
                    
                }
            }else {
                //DLog(@"select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            //DLog(@"Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return aVideo;
}

/**
 * delete multiple rows with contentType at Video UnOffiCial Of Album
 **/
+ (DBResult)deleteAllVideosOffiCialByCategoryId:(NSString *)categoryIdStr {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_VIDEO_OffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            BOOL susccessful;
            NSString *sql;
            if ([categoryIdStr length] || categoryIdStr != nil) {
                sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE categoryID = %@", tableName, categoryIdStr];
                
                //susccessful = [database executeUpdate:@"DELETE FROM ? WHERE categoryID = ?", tableName, categoryIdStr];
            }else{
                sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
                
                //susccessful = [database executeUpdate:@"DELETE FROM %@", tableName];
            }
            susccessful = [database executeUpdate:sql];
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


/**
 * insert a row with Video OffiCial Of Album
 **/
+ (DBResult) insertVideosOffiCial:(VideoForAll *) videoOffiCial {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_VIDEO_OffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE nodeId = %@ AND categoryID = \'%@ \'", tableName, videoOffiCial.nodeId, videoOffiCial.categoryID];
            [database executeUpdateWithFormat:sql];
            
            
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (albumAuthorMusicId, albumDescription, albumEngName, albumId, albumIsHot, albumMusicPublisherId, albumMusicType, albumName, albumPublishedYear, albumSetingTotalRating, albumSettingTotalView, albumThumbImagePath, albumTotalTrack, albumTrueTotalRating, albumTrueTotalView, categoryList, content, countryId, engName, isHot, musicPath, musicType, name, nodeId, numberOfTrack, settingTotalRating, settingTotalView, thumbImagePath, thumbImageType, translateContent, trueTotalRating, trueTotalView, youtubeUrl, snsTotalDisLike, snsTotalShare, snsTotalView, snsTotalComment, snsTotalLike, isLiked, categoryID) VALUES (\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')",
                             tableName,
                             videoOffiCial.albumAuthorMusicId,
                             [Utility checkAndReplaceHtmlInsertToDB:videoOffiCial.albumDescription],
                             videoOffiCial.albumEngName,
                             videoOffiCial.albumId,
                             videoOffiCial.albumIsHot,
                             videoOffiCial.albumMusicPublisherId,
                             videoOffiCial.albumMusicType,
                             [Utility checkAndReplaceHtmlInsertToDB:videoOffiCial.albumName],
                             videoOffiCial.albumPublishedYear,
                             videoOffiCial.albumSetingTotalRating,
                             videoOffiCial.albumSettingTotalView,
                             videoOffiCial.albumThumbImagePath,
                             videoOffiCial.albumTotalTrack,
                             videoOffiCial.albumTrueTotalRating,
                             videoOffiCial.albumTrueTotalView,
                             videoOffiCial.categoryList,
                             [Utility checkAndReplaceHtmlInsertToDB:videoOffiCial.content],
                             videoOffiCial.countryId,
                             videoOffiCial.engName,
                             videoOffiCial.isHot,
                             videoOffiCial.musicPath,
                             videoOffiCial.musicType,
                             [Utility checkAndReplaceHtmlInsertToDB:videoOffiCial.name],
                             videoOffiCial.nodeId,
                             videoOffiCial.numberOfTrack,
                             videoOffiCial.settingTotalRating,
                             videoOffiCial.settingTotalView,
                             videoOffiCial.thumbImagePath,
                             videoOffiCial.thumbImageType,
                             videoOffiCial.translateContent,
                             videoOffiCial.trueTotalRating,
                             videoOffiCial.trueTotalView,
                             videoOffiCial.youtubeUrl,
                             videoOffiCial.snsTotalDisLike,
                             videoOffiCial.snsTotalShare,
                             videoOffiCial.snsTotalView,
                             videoOffiCial.snsTotalComment,
                             videoOffiCial.snsTotalLike,
                             videoOffiCial.isLiked,
                             videoOffiCial.categoryID];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                DLog(@"insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


/**
 * insert a row with Video UnOffiCial Of Album
 **/
+ (DBResult) insertVideosUnOffiCial:(VideoForCategory *) videoUnOffiCial {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_VIDEO_UnOffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE nodeID = \'%@\' AND categoryID = \'%@\'", tableName, videoUnOffiCial.nodeID, videoUnOffiCial.categoryID];
            if (![database executeUpdateWithFormat:sql])
                DLog(@"insert nodeID at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);

            //-- excuting db
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (categoryID, body, countryID, isHot, nodeID, orderVideo, settingTotalView, shortBody, thumbnailImagePath, title, trueTotalView, videoFacebookPath, videoFilePath, videoYoutubePath, youtubeUrl, snsTotalDisLike, snsTotalShare, snsTotalView, snsTotalComment, snsTotalLike, isLiked) VALUES (\'%@\',\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\')",
                             tableName,
                             videoUnOffiCial.categoryID,
                             [Utility checkAndReplaceHtmlInsertToDB:videoUnOffiCial.body],
                             videoUnOffiCial.countryID,
                             videoUnOffiCial.isHot,
                             videoUnOffiCial.nodeID,
                             videoUnOffiCial.orderVideo,
                             videoUnOffiCial.settingTotalView,
                             [Utility checkAndReplaceHtmlInsertToDB:videoUnOffiCial.shortBody],
                             videoUnOffiCial.thumbnailImagePath,
                             videoUnOffiCial.title,
                             videoUnOffiCial.trueTotalView,
                             videoUnOffiCial.videoFacebookPath,
                             videoUnOffiCial.videoFilePath,
                             videoUnOffiCial.videoYoutubePath,
                             videoUnOffiCial.youtubeUrl,
                             videoUnOffiCial.snsTotalDisLike,
                             videoUnOffiCial.snsTotalShare,
                             videoUnOffiCial.snsTotalView,
                             videoUnOffiCial.snsTotalComment,
                             videoUnOffiCial.snsTotalLike,
                             videoUnOffiCial.isLiked];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                DLog(@"insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


/**
 * update a row with Video OffiCial and UnOffiCial Of Album
 **/
+ (DBResult)updateVideosOffiCial:(VideoForAll *) videoOffiCial {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_VIDEO_OffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET snsTotalComment = \'%@\', snsTotalLike = \'%@\', snsTotalDisLike = \'%@\', snsTotalShare = \'%@\', snsTotalView = \'%@\', isLiked = \'%@\' WHERE nodeId = \'%@\' AND categoryID=\'%@\'",
                             tableName,
                             videoOffiCial.snsTotalComment,
                             videoOffiCial.snsTotalLike,
                             videoOffiCial.snsTotalDisLike,
                             videoOffiCial.snsTotalShare,
                             videoOffiCial.snsTotalView,
                             videoOffiCial.isLiked,
                             videoOffiCial.nodeId,
                             videoOffiCial.categoryID
                             ];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"update statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"update statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[update statement into WorkDay] closed database");
            } else {
                //DLog(@"[update statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

/**
 * update a row with Video OffiCial and UnOffiCial Of Album
 **/
+ (DBResult)updateVideosUnOffiCial:(VideoForCategory *) videoUnOffiCial {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_VIDEO_UnOffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET snsTotalComment = \'%@\', snsTotalLike = \'%@\', snsTotalDisLike = \'%@\', snsTotalShare = \'%@\', snsTotalView = \'%@\', isLiked = \'%@\' WHERE nodeID = \'%@\' AND categoryID=\'%@\'",
                             tableName,
                             videoUnOffiCial.snsTotalComment,
                             videoUnOffiCial.snsTotalLike,
                             videoUnOffiCial.snsTotalDisLike,
                             videoUnOffiCial.snsTotalShare,
                             videoUnOffiCial.snsTotalView,
                             videoUnOffiCial.isLiked,
                             videoUnOffiCial.nodeID,
                             videoUnOffiCial.categoryID];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"update statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"update statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[update statement into WorkDay] closed database");
            } else {
                //DLog(@"[update statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

/**
 * delete multiple rows with contentType at Video UnOffiCial Of Album
 **/
+ (DBResult)deleteAllVideosUnOffiCialByCategoryId:(NSString *)categoryIdStr {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_VIDEO_UnOffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            BOOL susccessful;
            NSString *sql;
            if ([categoryIdStr length] || categoryIdStr != nil) {
                sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE categoryID = %@", tableName, categoryIdStr];
                
                //susccessful = [database executeUpdate:@"DELETE FROM ? WHERE categoryID = ?", tableName, categoryIdStr];
            }else{
                sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];

                //susccessful = [database executeUpdate:@"DELETE FROM %@", tableName];
            }
            susccessful = [database executeUpdate:sql];
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


/**
 * delete a rows with contentType at Video OffiCial Of Album
 **/
+ (DBResult)deleteAVideosOffiCialByNodeId:(NSString *)nodeId categoryId:(NSString *)categoryId {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_VIDEO_OffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //CORRECT?
            //BOOL susccessful = [database executeUpdate:@"DELETE FROM ? WHERE nodeId = ?", tableName, nodeId];
            BOOL susccessful;
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE nodeId = %@ AND categoryID = \'%@\'", tableName, nodeId, categoryId];
            susccessful = [database executeUpdate:sql];

            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


/**
 * delete a rows with contentType at Video UnOffiCial Of Album
 **/
+ (DBResult)deleteAVideosUnOffiCialByBynodeID:(NSString *)nodeIdStr categoryId:(NSString *)categoryId{
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_VIDEO_UnOffiCial_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //CORRECT?
            //BOOL susccessful = [database executeUpdate:@"DELETE FROM ? WHERE nodeID = ?", tableName, nodeIdStr];
            BOOL susccessful;
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE nodeId = %@ AND categoryID = \'%@\'", tableName, nodeIdStr, categoryId];
            susccessful = [database executeUpdate:sql];

            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


/**
 *  get multiple rows with contentType at Video
 **/
+ (NSMutableArray *) getAllVideos {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrAlbum = nil;
    NSString *tableName = DB_TABLE_ALL_VIDEO;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrAlbum = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    VideoAllModel *aVideo = [VideoAllModel new];
                    
                    aVideo.body = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"body"]];
                    aVideo.cms_user_id = [results stringForColumn:@"cms_user_id"];
                    aVideo.content_type_id = [results stringForColumn:@"content_type_id"];
                    aVideo.created_date = [results stringForColumn:@"created_date"];
                    aVideo.last_update = [results stringForColumn:@"last_update"];
                    aVideo.description = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"description"]];
                    aVideo.name = [results stringForColumn:@"name"];
                    aVideo.node_id = [results stringForColumn:@"node_id"];
                    aVideo.isHot = [results stringForColumn:@"isHot"];
                    aVideo.snsTotalComment = [results stringForColumn:@"snsTotalComment"];
                    aVideo.snsTotalLike = [results stringForColumn:@"snsTotalLike"];
                    aVideo.snsTotalDisLike = [results stringForColumn:@"snsTotalDisLike"];
                    aVideo.snsTotalShare = [results stringForColumn:@"snsTotalShare"];
                    aVideo.snsTotalView = [results stringForColumn:@"snsTotalView"];
                    aVideo.isLiked = [results stringForColumn:@"isLiked"];
                    
                    aVideo.thumbnail_image_file_path = [results stringForColumn:@"thumbnail_image_file_path"];
                    aVideo.thumbnail_image_file_type = [results stringForColumn:@"thumbnail_image_file_type"];
                    aVideo.video_file_path = [results stringForColumn:@"video_file_path"];
                    aVideo.video_order = [results stringForColumn:@"video_order"];
                    aVideo.youtube_url = [results stringForColumn:@"youtube_url"];
                    
                    [arrAlbum addObject:aVideo];
                }
            }else {
                //DLog(@"select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            //DLog(@"Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrAlbum;
}


/**
 *  get multiple rows with contentType at Video
 **/
+ (VideoAllModel *) getAVideosBynodeID:(NSString *)nodeIdStr{
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    VideoAllModel *aVideo = nil;
    NSString *tableName = DB_TABLE_ALL_VIDEO;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE nodeID = \'%@\'",tableName,nodeIdStr];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                aVideo = [VideoAllModel new];
                
                while(results.next)
                {
                    aVideo.body = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"body"]];
                    aVideo.cms_user_id = [results stringForColumn:@"cms_user_id"];
                    aVideo.content_type_id = [results stringForColumn:@"content_type_id"];
                    aVideo.created_date = [results stringForColumn:@"created_date"];
                    aVideo.last_update = [results stringForColumn:@"last_update"];
                    aVideo.description = [Utility convertAndReplaceDoLaToHtml:[results stringForColumn:@"description"]];
                    aVideo.name = [results stringForColumn:@"name"];
                    aVideo.node_id = [results stringForColumn:@"node_id"];
                    aVideo.isHot = [results stringForColumn:@"isHot"];
                    aVideo.snsTotalComment = [results stringForColumn:@"snsTotalComment"];
                    aVideo.snsTotalLike = [results stringForColumn:@"snsTotalLike"];
                    aVideo.snsTotalDisLike = [results stringForColumn:@"snsTotalDisLike"];
                    aVideo.snsTotalShare = [results stringForColumn:@"snsTotalShare"];
                    aVideo.snsTotalView = [results stringForColumn:@"snsTotalView"];
                    aVideo.isLiked = [results stringForColumn:@"isLiked"];
                    
                    aVideo.thumbnail_image_file_path = [results stringForColumn:@"thumbnail_image_file_path"];
                    aVideo.thumbnail_image_file_type = [results stringForColumn:@"thumbnail_image_file_type"];
                    aVideo.video_file_path = [results stringForColumn:@"video_file_path"];
                    aVideo.video_order = [results stringForColumn:@"video_order"];
                    aVideo.youtube_url = [results stringForColumn:@"youtube_url"];
                    
                }
            }else {
                //DLog(@"select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            //DLog(@"Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return aVideo;
}

/**
 * insert a row with Video
 **/
+ (DBResult) insertVideosOfTBVideoAll:(VideoAllModel *) video {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_ALL_VIDEO;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (\"body\",\"cms_user_id\",\"content_type_id\",\"created_date\",\"description\",\"last_update\",\"name\",\"node_id\",\"isHot\",\"snsTotalComment\",\"snsTotalLike\",\"snsTotalDisLike\",\"snsTotalShare\",\"snsTotalView\",\"isLiked\",\"thumbnail_image_file_path\",\"thumbnail_image_file_type\",\"video_file_path\",\"video_order\",\"youtube_url\") VALUES (\'%@\',\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\')",
                             tableName,
                             [Utility checkAndReplaceHtmlInsertToDB:video.body],
                             video.cms_user_id,
                             video.content_type_id,
                             video.created_date,
                             [Utility checkAndReplaceHtmlInsertToDB:video.description],
                             video.last_update,
                             video.name,
                             video.node_id,
                             video.isHot,
                             video.snsTotalComment,
                             video.snsTotalLike,
                             video.snsTotalDisLike,
                             video.snsTotalShare,
                             video.snsTotalView,
                             video.isLiked,
                             video.thumbnail_image_file_path,
                             video.thumbnail_image_file_type,
                             video.video_file_path,
                             video.video_order,
                             video.youtube_url];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

/**
 * update a row with Video
 **/
+ (DBResult)updateVideosOfTBVideoAll:(VideoAllModel *) video {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_ALL_VIDEO;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET snsTotalComment = \'%@\', snsTotalLike = \'%@\', snsTotalDisLike = \'%@\', snsTotalShare = \'%@\', snsTotalView = \'%@\', isLiked = \'%@\' WHERE node_id = \'%@\'",
                             tableName,
                             video.snsTotalComment,
                             video.snsTotalLike,
                             video.snsTotalDisLike,
                             video.snsTotalShare,
                             video.snsTotalView,
                             video.isLiked,
                             video.node_id];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"update statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"update statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[update statement into WorkDay] closed database");
            } else {
                //DLog(@"[update statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

/**
 * delete multiple rows with contentType at Video
 **/
+ (DBResult)deleteAllVideosOfTBVideoAll {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_ALL_VIDEO;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

/**
 * delete a rows with contentType at Video UnOffiCial Of Album
 **/
+ (DBResult)deleteAVideosOfTBVideoAllBynodeID:(NSString *)nodeIdStr {
    
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_ALL_VIDEO;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //CORRECT?
            //BOOL susccessful = [database executeUpdate:@"DELETE FROM ? WHERE node_id = ?", tableName, nodeIdStr];
            BOOL susccessful;
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE node_id = %@", tableName, nodeIdStr];
            susccessful = [database executeUpdate:sql];

            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


#pragma mark - Photo

+ (NSMutableArray *) getAllAlbumPhotoForContentType:(ContentTypeID)contentType
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrAlbum = nil;
    NSString *tableName = DB_TABLE_PHOTO_ALBUM;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrAlbum = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    ListAlbumPhoto *aAlbum           =  [[ListAlbumPhoto alloc] init];
                    
                    aAlbum.albumId                   = [results stringForColumn:@"albumId"];
                    aAlbum.name                      = [results stringForColumn:@"name"];
                    aAlbum.thumbImagePath            = [results stringForColumn:@"thumbImagePath"];
                    aAlbum.description               = [results stringForColumn:@"description"];
                    aAlbum.order                     = [results stringForColumn:@"orderList"];
                    aAlbum.totalPhoto                = [results stringForColumn:@"totalPhoto"];
                    aAlbum.snsTotalComment           = [results stringForColumn:@"snsTotalComment"];
                    aAlbum.snsTotalLike              = [results stringForColumn:@"snsTotalLike"];
                    aAlbum.snsTotalDisLike           = [results stringForColumn:@"snsTotalDisLike"];
                    aAlbum.snsTotalShare             = [results stringForColumn:@"snsTotalShare"];
                    aAlbum.snsTotalView              = [results stringForColumn:@"snsTotalView"];
                    aAlbum.albumThumbnailImagePath = [NSString stringWithFormat:@"%@_thumbnail.%@", aAlbum.thumbImagePath.stringByDeletingPathExtension, aAlbum.thumbImagePath.pathExtension];

                    
                    [arrAlbum addObject:aAlbum];
                }
            }else {
                //DLog(@"select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            //DLog(@"Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrAlbum;
}

+ (DBResult) insertAlbumPhotoBySinger:(ListAlbumPhoto*)albumBySinger
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_PHOTO_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (albumId, name, thumbImagePath, description, orderList, totalPhoto, snsTotalComment, snsTotalLike, snsTotalDisLike, snsTotalShare, snsTotalView) VALUES (\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\')",
                             tableName,
                             albumBySinger.albumId,
                             albumBySinger.name,
                             albumBySinger.thumbImagePath,
                             albumBySinger.description,
                             albumBySinger.order,
                             albumBySinger.totalPhoto,
                             albumBySinger.snsTotalComment,
                             albumBySinger.snsTotalLike,
                             albumBySinger.snsTotalDisLike,
                             albumBySinger.snsTotalShare,
                             albumBySinger.snsTotalView];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

+ (DBResult) updateAlbumTotalPhotoBySinger:(NSString *)abId totalPhoto:(NSInteger)totalPhoto
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_PHOTO_ALBUM;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET totalPhoto=%d WHERE albumId=\'%@\'",
                             tableName,
                             totalPhoto,
                             abId];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                //DLog(@"insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            //DLog(@"Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

+ (DBResult)deleteAllAlbumPhotoFromDB
{
    NSLog(@"%s", __func__);
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_PHOTO_ALBUM;
    
    if (!database)
    {
        NSLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //NSLog(@"Delete all table name: %@", tableName);
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //NSLog(@"[delete statement] closed database");
            } else {
                //NSLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


#pragma mark -/-

+ (NSMutableArray *) getAllPhotoInAlbumByAlbumId:(NSString *)albumId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrAlbum = nil;
    NSString *tableName = DB_TABLE_PHOTO_DETAILS;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql;
            if (albumId) {
                sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE albumId = \'%@\'",tableName,albumId];
            }else{
                sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
            }
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrAlbum = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    ListPhotosInAlbum *aAlbum        =  [[ListPhotosInAlbum alloc] init];
                    
                    aAlbum.albumCreatedDate          = [results stringForColumn:@"albumCreatedDate"];
                    aAlbum.albumDescription          = [results stringForColumn:@"albumDescription"];
                    aAlbum.albumId                   = [results stringForColumn:@"albumId"];
                    aAlbum.albumImageFilePath        = [results stringForColumn:@"albumImageFilePath"];
                    aAlbum.albumLastUpdate           = [results stringForColumn:@"albumLastUpdate"];
                    aAlbum.albumName                 = [results stringForColumn:@"albumName"];
                    aAlbum.createDate                = [results stringForColumn:@"createDate"];
                    aAlbum.imagePath                 = [results stringForColumn:@"imagePath"];
                    aAlbum.name                      = [results stringForColumn:@"name"];
                    aAlbum.nodeId                    = [results stringForColumn:@"nodeId"];
                    aAlbum.snsTotalComment           = [results stringForColumn:@"snsTotalComment"];
                    aAlbum.snsTotalLike              = [results stringForColumn:@"snsTotalLike"];
                    aAlbum.snsTotalDisLike           = [results stringForColumn:@"snsTotalDisLike"];
                    aAlbum.snsTotalShare             = [results stringForColumn:@"snsTotalShare"];
                    aAlbum.snsTotalView              = [results stringForColumn:@"snsTotalView"];
                    aAlbum.isLiked                   = [results stringForColumn:@"isLiked"];
                    aAlbum.thumbnailImagePath = [NSString stringWithFormat:@"%@_thumbnail.%@", aAlbum.imagePath.stringByDeletingPathExtension, aAlbum.imagePath.pathExtension];
                
                    
                    [arrAlbum addObject:aAlbum];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrAlbum;
}


+ (ListPhotosInAlbum *) getAPhotoAlbumByNodeId:(NSString *)nodeId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    ListPhotosInAlbum *aAlbum = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE nodeId = \'%@\'",DB_TABLE_PHOTO_DETAILS,nodeId];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_PHOTO_DETAILS);
                
                while(results.next)
                {
                    aAlbum        =  [[ListPhotosInAlbum alloc] init];
                    
                    aAlbum.albumCreatedDate          = [results stringForColumn:@"albumCreatedDate"];
                    aAlbum.albumDescription          = [results stringForColumn:@"albumDescription"];
                    aAlbum.albumId                   = [results stringForColumn:@"albumId"];
                    aAlbum.albumImageFilePath        = [results stringForColumn:@"albumImageFilePath"];
                    aAlbum.albumLastUpdate           = [results stringForColumn:@"albumLastUpdate"];
                    aAlbum.albumName                 = [results stringForColumn:@"albumName"];
                    aAlbum.createDate                = [results stringForColumn:@"createDate"];
                    aAlbum.imagePath                 = [results stringForColumn:@"imagePath"];
                    aAlbum.thumbnailImagePath = [NSString stringWithFormat:@"%@_thumbnail.%@", aAlbum.imagePath.stringByDeletingPathExtension, aAlbum.imagePath.pathExtension];

                    aAlbum.name                      = [results stringForColumn:@"name"];
                    aAlbum.nodeId                    = [results stringForColumn:@"nodeId"];
                    aAlbum.snsTotalComment           = [results stringForColumn:@"snsTotalComment"];
                    aAlbum.snsTotalLike              = [results stringForColumn:@"snsTotalLike"];
                    aAlbum.snsTotalDisLike           = [results stringForColumn:@"snsTotalDisLike"];
                    aAlbum.snsTotalShare             = [results stringForColumn:@"snsTotalShare"];
                    aAlbum.snsTotalView              = [results stringForColumn:@"snsTotalView"];
                    aAlbum.isLiked                   = [results stringForColumn:@"isLiked"];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_PHOTO_DETAILS,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_PHOTO_DETAILS,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return aAlbum;
}


+ (DBResult) insertPhotoInAlbumoBySinger:(ListPhotosInAlbum*)albumBySinger
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_PHOTO_DETAILS;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //add by TuanNM@201408
            //xoa truoc
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE nodeId=%@", tableName, albumBySinger.nodeId];
            [database executeUpdateWithFormat:sql];
            //end modified
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (albumCreatedDate, albumDescription, albumId, albumImageFilePath, albumLastUpdate, albumName, createDate, imagePath, name, nodeId,snsTotalComment,snsTotalLike,snsTotalDisLike,snsTotalShare,snsTotalView,isLiked) VALUES (\'%@\', \'%@\', \'%@\', \'%@\',\'%@\', \'%@\', \'%@\', \'%@\',\'%@\', \'%@\', \'%@\', \'%@\', \'%@\',\'%@\', \'%@\', \'%@\')",
                             tableName,
                             albumBySinger.albumCreatedDate,
                             albumBySinger.albumDescription,
                             albumBySinger.albumId,
                             albumBySinger.albumImageFilePath,
                             albumBySinger.albumLastUpdate,
                             albumBySinger.albumName,
                             albumBySinger.createDate,
                             albumBySinger.imagePath,
                             albumBySinger.name,
                             albumBySinger.nodeId,
                             albumBySinger.snsTotalComment,
                             albumBySinger.snsTotalLike,
                             albumBySinger.snsTotalDisLike,
                             albumBySinger.snsTotalShare,
                             albumBySinger.snsTotalView,
                             albumBySinger.isLiked];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult)updatePhotoInAlbumBySinger:(ListPhotosInAlbum*)albumBySinger
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_PHOTO_DETAILS;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET snsTotalComment = \'%@\', snsTotalLike = \'%@\', snsTotalDisLike = \'%@\', snsTotalShare = \'%@\', snsTotalView = \'%@\', isLiked = \'%@\' WHERE nodeId = \'%@\'",
                             tableName,
                             albumBySinger.snsTotalComment,
                             albumBySinger.snsTotalLike,
                             albumBySinger.snsTotalDisLike,
                             albumBySinger.snsTotalShare,
                             albumBySinger.snsTotalView,
                             albumBySinger.isLiked,
                             albumBySinger.nodeId];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"update statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: update statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[update statement into WorkDay] closed database");
            } else {
                //DLog(@"[update statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}



+ (DBResult)deleteAllPhotoInAlbumByAlbumId:(NSString *)albumId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_PHOTO_DETAILS;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            BOOL susccessful;
            NSString *sql;
            if (albumId) {
                sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE albumId = %@", tableName, albumId];
                //susccessful = [database executeUpdate:@"DELETE FROM ? WHERE albumId = ?", tableName, albumId];
            }else{
                sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
                //susccessful = [database executeUpdate:@"DELETE FROM %@", tableName];
            }
            susccessful = [database executeUpdate:sql];
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}



#pragma mark - Schedule

+ (NSMutableArray *) getAllScheduleByCategoryid:(NSString *)categoryId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrAlbum = nil;
    NSString *tableName = DB_TABLE_SCHEDULE;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            NSString *sql;
            if (categoryId && [categoryId length] > 0)
                sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE categoryId = %@",tableName, categoryId];
            else
                sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrAlbum = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    Schedule *aSche                 =  [[Schedule alloc] init];
                    
                    aSche.categoryId                = [results stringForColumn:@"categoryId"];
                    aSche.nodeId                    = [results stringForColumn:@"nodeId"];
                    aSche.name                      = [results stringForColumn:@"name"];
                    aSche.imageFilePath             = [results stringForColumn:@"imageFilePath"];
                    aSche.videoFilePath             = [results stringForColumn:@"videoFilePath"];
                    aSche.startDate                 = [results stringForColumn:@"startDate"];
                    aSche.endDate                   = [results stringForColumn:@"endDate"];
                    aSche.desciption                = [results stringForColumn:@"desciption"];
                    aSche.orderSchedule             = [results stringForColumn:@"orderSchedule"];
                    aSche.organizationUnitName      = [results stringForColumn:@"organizationUnitName"];
                    aSche.countryId                 = [results stringForColumn:@"countryId"];
                    aSche.countryName               = [results stringForColumn:@"countryName"];
                    aSche.cityId                    = [results stringForColumn:@"cityId"];
                    aSche.cityName                  = [results stringForColumn:@"cityName"];
                    aSche.cityLogoFilePath          = [results stringForColumn:@"cityLogoFilePath"];
                    aSche.cityDescription           = [results stringForColumn:@"cityDescription"];
                    aSche.locationEventId           = [results stringForColumn:@"locationEventId"];
                    aSche.locationEventName         = [results stringForColumn:@"locationEventName"];
                    aSche.locationEventAddress      = [results stringForColumn:@"locationEventAddress"];
                    aSche.locationEventId           = [results stringForColumn:@"locationEventPhone"];
                    aSche.locationEventName         = [results stringForColumn:@"locationEventEmail"];
                    aSche.locationEventWebsite      = [results stringForColumn:@"locationEventWebsite"];
                    aSche.snsTotalComment           = [results stringForColumn:@"snsTotalComment"];
                    aSche.snsTotalLike              = [results stringForColumn:@"snsTotalLike"];
                    aSche.snsTotalDisLike           = [results stringForColumn:@"snsTotalDisLike"];
                    aSche.snsTotalShare             = [results stringForColumn:@"snsTotalShare"];
                    aSche.snsTotalView              = [results stringForColumn:@"snsTotalView"];
                    aSche.isLiked                   = [results stringForColumn:@"isLiked"];
                    aSche.price                     = [results stringForColumn:@"price"];
                    aSche.phone                     = [results stringForColumn:@"phone"];
                    aSche.listSinger                = [results stringForColumn:@"listSinger"];
                    
                    [arrAlbum addObject:aSche];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrAlbum;
}


+ (Schedule *) getAScheduleByNodeId:(NSString *)nodeId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    Schedule *aSche = nil;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE nodeId = \'%@\'",DB_TABLE_SCHEDULE,nodeId];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",DB_TABLE_SCHEDULE);
                
                while(results.next)
                {
                    aSche = [[Schedule alloc] init];
                    
                    aSche.categoryId                = [results stringForColumn:@"categoryId"];
                    aSche.nodeId                    = [results stringForColumn:@"nodeId"];
                    aSche.name                      = [results stringForColumn:@"name"];
                    aSche.imageFilePath             = [results stringForColumn:@"imageFilePath"];
                    aSche.videoFilePath             = [results stringForColumn:@"videoFilePath"];
                    aSche.startDate                 = [results stringForColumn:@"startDate"];
                    aSche.endDate                   = [results stringForColumn:@"endDate"];
                    aSche.desciption                = [results stringForColumn:@"desciption"];
                    aSche.orderSchedule             = [results stringForColumn:@"orderSchedule"];
                    aSche.organizationUnitName      = [results stringForColumn:@"organizationUnitName"];
                    aSche.countryId                 = [results stringForColumn:@"countryId"];
                    aSche.countryName               = [results stringForColumn:@"countryName"];
                    aSche.cityId                    = [results stringForColumn:@"cityId"];
                    aSche.cityName                  = [results stringForColumn:@"cityName"];
                    aSche.cityLogoFilePath          = [results stringForColumn:@"cityLogoFilePath"];
                    aSche.cityDescription           = [results stringForColumn:@"cityDescription"];
                    aSche.locationEventId           = [results stringForColumn:@"locationEventId"];
                    aSche.locationEventName         = [results stringForColumn:@"locationEventName"];
                    aSche.locationEventAddress      = [results stringForColumn:@"locationEventAddress"];
                    aSche.locationEventId           = [results stringForColumn:@"locationEventPhone"];
                    aSche.locationEventName         = [results stringForColumn:@"locationEventEmail"];
                    aSche.locationEventWebsite      = [results stringForColumn:@"locationEventWebsite"];
                    aSche.snsTotalComment           = [results stringForColumn:@"snsTotalComment"];
                    aSche.snsTotalLike              = [results stringForColumn:@"snsTotalLike"];
                    aSche.snsTotalDisLike           = [results stringForColumn:@"snsTotalDisLike"];
                    aSche.snsTotalShare             = [results stringForColumn:@"snsTotalShare"];
                    aSche.snsTotalView              = [results stringForColumn:@"snsTotalView"];
                    aSche.isLiked                   = [results stringForColumn:@"isLiked"];
                    aSche.price                     = [results stringForColumn:@"price"];
                    aSche.phone                     = [results stringForColumn:@"phone"];
                    aSche.listSinger                = [results stringForColumn:@"listSinger"];
                }
            }else {
               NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", DB_TABLE_SCHEDULE,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", DB_TABLE_SCHEDULE,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return aSche;
}


+ (DBResult) insertSchedule:(Schedule*)schedule
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_SCHEDULE;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (categoryId, nodeId, name, imageFilePath, videoFilePath, startDate, endDate, desciption, orderSchedule, organizationUnitName, countryId, countryName, cityId, cityName, cityLogoFilePath, cityDescription, locationEventId, locationEventName, locationEventAddress, locationEventPhone, locationEventEmail, locationEventWebsite, snsTotalComment, snsTotalLike, snsTotalDisLike, snsTotalShare, snsTotalView, isLiked, price, phone, listSinger) VALUES (\'%@\',\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\')",
                             tableName,
                             schedule.categoryId,
                             schedule.nodeId,
                             schedule.name,
                             schedule.imageFilePath,
                             schedule.videoFilePath,
                             schedule.startDate,
                             schedule.endDate,
                             schedule.desciption,
                             schedule.orderSchedule,
                             schedule.organizationUnitName,
                             schedule.countryId,
                             schedule.countryName,
                             schedule.cityId,
                             schedule.cityName,
                             schedule.cityLogoFilePath,
                             schedule.cityDescription,
                             schedule.locationEventId,
                             schedule.locationEventName,
                             schedule.locationEventAddress,
                             schedule.locationEventPhone,
                             schedule.locationEventEmail,
                             schedule.locationEventWebsite,
                             schedule.snsTotalComment,
                             schedule.snsTotalLike,
                             schedule.snsTotalDisLike,
                             schedule.snsTotalShare,
                             schedule.snsTotalView,
                             schedule.isLiked,
                             schedule.price,
                             schedule.phone,
                             schedule.listSinger];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult)updateSchedule:(Schedule*)schedule
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_SCHEDULE;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET snsTotalComment = \'%@\', snsTotalLike = \'%@\', snsTotalDisLike = \'%@\', snsTotalShare = \'%@\', snsTotalView = \'%@\', isLiked = \'%@\' WHERE nodeId = \'%@\'",
                             tableName,
                             schedule.snsTotalComment,
                             schedule.snsTotalLike,
                             schedule.snsTotalDisLike,
                             schedule.snsTotalShare,
                             schedule.snsTotalView,
                             schedule.isLiked,
                             schedule.nodeId];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult) deleteAllScheduleByCategory:(NSString *)categoryId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_SCHEDULE;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            //CORRECT?
            //BOOL susccessful = [database executeUpdate:@"DELETE FROM %@ WHERE categoryId = %@", tableName, categoryId];
            BOOL susccessful;
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE categoryId = %@", tableName, categoryId];
            susccessful = [database executeUpdate:sql];

            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}



#pragma mark - Top User

+ (NSMutableArray *) getAllTopUserByCategoryid:(NSString *)categoryId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrTop = nil;
    NSString *tableName = DB_TABLE_TOPUSER;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            NSString *sql;
            if (categoryId && [categoryId length] > 0)
                sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE categoryId = %@",tableName, categoryId];
            else
                sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
            
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrTop = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    TopUser *aTop                 =  [[TopUser alloc] init];
                    
                    aTop.categoryId               = [results stringForColumn:@"categoryId"];
                    aTop.userId                   = [results stringForColumn:@"userId"];
                    aTop.point                    = [results stringForColumn:@"point"];
                    aTop.profilePageId            = [results stringForColumn:@"profilePageId"];
                    aTop.serverId                 = [results stringForColumn:@"serverId"];
                    aTop.userGroupId              = [results stringForColumn:@"userGroupId"];
                    aTop.statusId                 = [results stringForColumn:@"statusId"];
                    aTop.viewId                   = [results stringForColumn:@"viewId"];
                    aTop.userName                 = [results stringForColumn:@"userName"];
                    aTop.userImage                = [results stringForColumn:@"userImage"];
                    aTop.fullName                 = [results stringForColumn:@"fullName"];
                    aTop.email                    = [results stringForColumn:@"email"];
                    aTop.gender                   = [results stringForColumn:@"gender"];
                    aTop.birthday                 = [results stringForColumn:@"birthday"];
                    aTop.birthdaySearch           = [results stringForColumn:@"birthdaySearch"];
                    aTop.countryIso               = [results stringForColumn:@"countryIso"];
                    aTop.languageId               = [results stringForColumn:@"languageId"];
                    aTop.styleId                  = [results stringForColumn:@"styleId"];
                    aTop.timeZone                 = [results stringForColumn:@"timeZone"];
                    aTop.dstCheck                 = [results stringForColumn:@"dstCheck"];
                    aTop.joined                   = [results stringForColumn:@"joined"];
                    aTop.lastLogin                = [results stringForColumn:@"lastLogin"];
                    aTop.lastActivity             = [results stringForColumn:@"lastActivity"];
                    aTop.userId                   = [results stringForColumn:@"userId"];
                    aTop.hideTip                  = [results stringForColumn:@"hideTip"];
                    aTop.status                   = [results stringForColumn:@"status"];
                    aTop.footerBar                = [results stringForColumn:@"footerBar"];
                    aTop.inviteUserId             = [results stringForColumn:@"inviteUserId"];
                    aTop.imBeep                   = [results stringForColumn:@"imBeep"];
                    aTop.imHide                   = [results stringForColumn:@"imHide"];
                    aTop.isInvisible              = [results stringForColumn:@"isInvisible"];
                    aTop.totalSpam                = [results stringForColumn:@"totalSpam"];
                    aTop.lastIpAddress            = [results stringForColumn:@"lastIpAddress"];
                    aTop.feedSort                 = [results stringForColumn:@"feedSort"];
                    
                    [arrTop addObject:aTop];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrTop;
}


+ (DBResult) insertTopUser:(TopUser *)topUser
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_TOPUSER;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (categoryId, userId, point, profilePageId, serverId, userGroupId, statusId, viewId, userName, fullName, email, gender, birthday, birthdaySearch, countryIso, languageId, styleId, timeZone, dstCheck, joined, lastLogin, lastActivity, userImage, hideTip, status, footerBar, inviteUserId, imBeep, imHide, isInvisible, totalSpam, lastIpAddress, feedSort) VALUES (\'%@\',\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\')",
                             tableName,
                             topUser.categoryId,
                             topUser.userId,
                             topUser.point,
                             topUser.profilePageId,
                             topUser.serverId,
                             topUser.userGroupId,
                             topUser.statusId,
                             topUser.viewId,
                             topUser.userName,
                             topUser.fullName,
                             topUser.email,
                             topUser.gender,
                             topUser.birthday,
                             topUser.birthdaySearch,
                             topUser.countryIso,
                             topUser.languageId,
                             topUser.styleId,
                             topUser.timeZone,
                             topUser.dstCheck,
                             topUser.joined,
                             topUser.lastLogin,
                             topUser.lastActivity,
                             topUser.userImage,
                             topUser.hideTip,
                             topUser.status,
                             topUser.footerBar,
                             topUser.inviteUserId,
                             topUser.imBeep,
                             topUser.imHide,
                             topUser.isInvisible,
                             topUser.totalSpam,
                             topUser.lastIpAddress,
                             topUser.feedSort];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult) deleteAllTopUserByCategory:(NSString *)categoryId
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_TOPUSER;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE categoryId = %@", tableName, categoryId];

            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


#pragma mark - store


+ (NSMutableArray *) getAllStore
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrStore = nil;
    NSString *tableName = DB_TABLE_STORE;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            //-- ORDER BY field_name ASC for an ascending sort, or ORDER BY field_name DESC
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
           
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrStore = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    Store *aStore                    =  [[Store alloc] init];
                   aStore.body                       = [results stringForColumn:@"body"];
                   aStore.cmsUserId                  = [results stringForColumn:@"cmsUserId"];
                   aStore.code                       = [results stringForColumn:@"code"];
                   aStore.contentProviderId          = [results stringForColumn:@"contentProviderId"];
                   aStore.createdDate                = [results stringForColumn:@"createdDate"];
                   aStore.idStore                    = [results stringForColumn:@"idStore"];
                   aStore.isHot                      = [results stringForColumn:@"lastUpdate"];
                   aStore.lastUpdate                 = [results stringForColumn:@"lastUpdate"];
                   aStore.name                       = [results stringForColumn:@"name"];
                   aStore.orderStore                 = [results stringForColumn:@"orderStore"];
                   aStore.phone                      = [results stringForColumn:@"phone"];
                   aStore.priceUnit                  = [results stringForColumn:@"priceUnit"];
                   aStore.settingTotalView           = [results stringForColumn:@"settingTotalView"];
                   aStore.shortBody                  = [results stringForColumn:@"shortBody"];
                   aStore.snsTotalComment            = [results stringForColumn:@"snsTotalComment"];
                   aStore.snsTotalDislike            = [results stringForColumn:@"snsTotalDislike"];
                   aStore.snsTotalLike               = [results stringForColumn:@"snsTotalLike"];
                   aStore.snsTotalShare              = [results stringForColumn:@"snsTotalShare"];
                   aStore.snsTotalView               = [results stringForColumn:@"snsTotalView"];
                   aStore.thumbnailImagePath         = [results stringForColumn:@"thumbnailImagePath"];
                   aStore.thumbnailImageType         = [results stringForColumn:@"thumbnailImageType"];
                   aStore.trueTotalView              = [results stringForColumn:@"trueTotalView"];
                   aStore.categoryID                 = [results stringForColumn:@"categoryID"];
                    
                   [arrStore addObject:aStore];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrStore;
}


+ (NSMutableArray *) getAllStoreWithCategoryID:(NSString *)categoryID
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSMutableArray *arrStore = nil;
    NSString *tableName = DB_TABLE_STORE;
    
    if (!database)
    {
        //DLog(@"Error %@ - %d", [database lastErrorMessage], [database lastErrorCode]);
        return nil;
    }else
    {
        if ([database open])
        {
            //-- open
            //DLog(@"Database opened! at server: %@", database.databasePath);
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE categoryID = \'%@\'",tableName, categoryID];
            FMResultSet *results=[database executeQuery:sql];
            
            //-- excute
            
            if (results)
            {
                //DLog(@"select statement into %@ table successful",tableName);
                arrStore = [[NSMutableArray alloc] init];
                
                while(results.next)
                {
                    Store *aStore                     =  [[Store alloc] init];
                    //-- fix special character
                    NSString *tmpBody                 = [results stringForColumn:@"body"];
                    aStore.body                       = [Utility convertAndReplaceDoLaToHtml:tmpBody];
                    aStore.cmsUserId                  = [results stringForColumn:@"cmsUserId"];
                    aStore.code                       = [results stringForColumn:@"code"];
                    aStore.contentProviderId          = [results stringForColumn:@"contentProviderId"];
                    aStore.createdDate                = [results stringForColumn:@"createdDate"];
                    aStore.idStore                    = [results stringForColumn:@"idStore"];
                    aStore.isHot                      = [results stringForColumn:@"lastUpdate"];
                    aStore.lastUpdate                 = [results stringForColumn:@"lastUpdate"];
                    aStore.name                       = [results stringForColumn:@"name"];
                    aStore.orderStore                 = [results stringForColumn:@"orderStore"];
                    aStore.phone                      = [results stringForColumn:@"phone"];
                    aStore.priceUnit                  = [results stringForColumn:@"priceUnit"];
                    aStore.settingTotalView           = [results stringForColumn:@"settingTotalView"];
                    aStore.shortBody                  = [results stringForColumn:@"shortBody"];
                    aStore.snsTotalComment            = [results stringForColumn:@"snsTotalComment"];
                    aStore.snsTotalDislike            = [results stringForColumn:@"snsTotalDislike"];
                    aStore.snsTotalLike               = [results stringForColumn:@"snsTotalLike"];
                    aStore.snsTotalShare              = [results stringForColumn:@"snsTotalShare"];
                    aStore.snsTotalView               = [results stringForColumn:@"snsTotalView"];
                    aStore.thumbnailImagePath         = [results stringForColumn:@"thumbnailImagePath"];
                    aStore.thumbnailImageType         = [results stringForColumn:@"thumbnailImageType"];
                    aStore.trueTotalView              = [results stringForColumn:@"trueTotalView"];
                    aStore.categoryID                 = [results stringForColumn:@"categoryID"];
                    
                    [arrStore addObject:aStore];
                }
            }else {
                NSLog(@"DBERR: select statement [%@] fails or table empty: %@ - %d", tableName,[database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  nil;
            }
            
            // close database
            if ([database close]) {
                //DLog(@"[select statement] database closed");
            } else {
                //DLog(@"[select statement] can not close database");
                return nil;
            }
            
        } else {
            NSLog(@"DBERR: Database can not open! [%@] Error: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
            return  nil;
        }
    }
    
    //return
    return arrStore;
}




+ (DBResult)insertWithStore:(Store*)aStore
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_STORE;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- remove character special that sql don't accept
            NSString *tmpBody = [Utility checkAndReplaceHtmlInsertToDB:aStore.body];
            
            //-- genarate id for store
            NSString *tmpId = [NSString stringWithFormat:@"%@#%@",aStore.categoryID, aStore.idStore];
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (body, cmsUserId, code, contentProviderId, createdDate, idStore, isHot, lastUpdate, name, orderStore, phone, priceUnit, settingTotalView, shortBody, snsTotalComment, snsTotalDislike, snsTotalLike, snsTotalShare, snsTotalView, thumbnailImagePath, thumbnailImageType, trueTotalView, categoryID) VALUES (\'%@\',\'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\', \'%@\',\'%@\', \'%@\', \'%@\')",
                             tableName,
                             tmpBody,
                             aStore.cmsUserId,
                             aStore.code,
                             aStore.contentProviderId,
                             aStore.createdDate,
                             tmpId,
                             aStore.isHot,
                             aStore.lastUpdate,
                             aStore.name,
                             aStore.orderStore,
                             aStore.phone,
                             aStore.priceUnit,
                             aStore.settingTotalView,
                             aStore.shortBody,
                             aStore.snsTotalComment,
                             aStore.snsTotalDislike,
                             aStore.snsTotalLike,
                             aStore.snsTotalShare,
                             aStore.snsTotalView,
                             aStore.thumbnailImagePath,
                             aStore.thumbnailImageType,
                             aStore.trueTotalView,
                             aStore.categoryID];
            
            if ([database executeUpdateWithFormat:sql])
            {
                //DLog(@"insert statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: insert statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[insert statement into WorkDay] closed database");
            } else {
                //DLog(@"[insert statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}


+ (DBResult)deleteAllStore
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_STORE;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

+ (DBResult)deleteStoreWithCategoryID:(NSString *)categoryID
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_STORE;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE categoryID = \'%@\'", tableName, categoryID];
            
            BOOL susccessful = [database executeUpdate:sql];
            
            if (susccessful)
            {
                //DLog(@"delete statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: delete statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[delete statement] closed database");
            } else {
                //DLog(@"[delete statement] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

+(DBResult)updateLikeCommentShare:(ListFeedData*)aNews
{
    if (!database)
        database = [VMDataBase getNewDBConnection];
    
    NSString *tableName = DB_TABLE_FEED;
    
    if (!database)
    {
        //DLog(@"Cannot create DB %@: %@ - %d ", tableName,[database lastErrorMessage], [database lastErrorCode]);
        return DBResultOpenFails;
    }
    else
    {
        if ([database open])
        {
            //-- open db
            //DLog(@"Database opened!");
            
            //-- excuting db
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET snsTotalComment = \'%@\', snsTotalLike = \'%@\', snsTotalShare = \'%@\', snsTotalView = \'%@\', isLiked = \'%@\' WHERE feedParentId = \'%@\' AND feedId = \'%@\'",
                             tableName,
                             aNews.snsTotalComment,
                             aNews.snsTotalLike,
                             aNews.snsTotalShare,
                             aNews.snsTotalView,
                             aNews.isLiked,
                             aNews.feedParentId,
                             aNews.feedId];
            
            if ([database executeUpdateWithFormat:sql])
            {
                DLog(@"update statement into %@ successful", tableName);
            }
            else
            {
                NSLog(@"DBERR: update statement at %@ fails: %@ - %d", tableName, [database lastErrorMessage], [database lastErrorCode]);
                [database close];
                return  DBResultStatementFails;
            }
            
            //-- close database
            if ([database close]) {
                //DLog(@"[update statement into WorkDay] closed database");
            } else {
                //DLog(@"[update statement into WorkDay] can not close database");
                return DBResultCloseFails;
            }
        }
        else
        {
            NSLog(@"DBERR: Database can not open! at %@ Error: %@ - %d ", tableName, [database lastErrorMessage], [database lastErrorCode]);
            return  DBResultOpenFails;
        }
        
    }
    
    //--return
    return DBResultStatementSuccessful;
}

@end
