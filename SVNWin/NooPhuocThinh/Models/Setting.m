//
//  Setting.m
//  NooPhuocThinh
//
//  Created by HuntDo on 7/29/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "Setting.h"

static Setting *setting = nil;

@implementation Setting

@synthesize newRefreshTime              = _newRefreshTime;
@synthesize newListRefreshTime          = _newListRefreshTime;
@synthesize newsCategoryRefreshTime     = _newsCategoryRefreshTime;
@synthesize musicRefreshTime            = _musicRefreshTime;
@synthesize musicAlbumRefreshTime       = _musicAlbumRefreshTime;
@synthesize videoRefreshTime            = _videoRefreshTime;
@synthesize videoCategoryRefreshTime    = _videoCategoryRefreshTime;
@synthesize storeRefreshTime            = _storeRefreshTime;
@synthesize storeCategoryRefreshTime    = _storeCategoryRefreshTime;
@synthesize eventRefreshTime            = _eventRefreshTime;
@synthesize eventCategoryRefreshTime    = _eventCategoryRefreshTime;
@synthesize imageRefreshTime            = _imageRefreshTime;
@synthesize imageAlbumRefreshTime       = _imageAlbumRefreshTime;
@synthesize topUserRefreshTime          = _topUserRefreshTime;
@synthesize singerInfoRefreshTime       = _singerInfoRefreshTime;

@synthesize milestonesNewRefreshTime            = _milestonesNewRefreshTime;
@synthesize milestonesNewsCategoryRefreshTime   = _milestonesNewsCategoryRefreshTime;
@synthesize milestonesMusicRefreshTime          = _milestonesMusicRefreshTime;
@synthesize milestonesMusicAlbumRefreshTime     = _milestonesMusicAlbumRefreshTime;
@synthesize milestonesVideoRefreshTime          = _milestonesVideoRefreshTime;
@synthesize milestonesVideoCategoryRefreshTime  = _milestonesVideoCategoryRefreshTime;
@synthesize milestonesStoreRefreshTime          = _milestonesStoreRefreshTime;
@synthesize milestonesStoreCategoryRefreshTime  = _milestonesStoreCategoryRefreshTime;
@synthesize milestonesEventRefreshTime          = _milestonesEventRefreshTime;
@synthesize milestonesEventCategoryRefreshTime  = _milestonesEventCategoryRefreshTime;
@synthesize milestonesImageRefreshTime          = _milestonesImageRefreshTime;
@synthesize milestonesImageAlbumRefreshTime     = _milestonesImageAlbumRefreshTime;
@synthesize milestonesTopUserRefreshTime        = _milestonesTopUserRefreshTime;
@synthesize milestonesSingerInfoRefreshTime     = _milestonesSingerInfoRefreshTime;

+(Setting *)sharedSetting
{
    if (!setting)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            setting = [Setting new];
        });
    }
    return setting;
}

#pragma mark - period time refresh

- (float)milestonesNewsCategoryRefreshTime
{
    _milestonesNewsCategoryRefreshTime = [userDefault floatForKey:Count_time_news_category_refresh_time];
    return _milestonesNewsCategoryRefreshTime;
}

- (void)setMilestonesNewsCategoryRefreshTime:(float)milestonesNewsCategoryRefreshTime
{
    _milestonesNewsCategoryRefreshTime = milestonesNewsCategoryRefreshTime;
    [userDefault setFloat:milestonesNewsCategoryRefreshTime forKey:Count_time_news_category_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesMusicRefreshTime
{
    _milestonesMusicRefreshTime = [userDefault floatForKey:Count_time_music_refresh_time];
    return _milestonesMusicRefreshTime;
}

- (void)setMilestonesMusicRefreshTime:(float)milestonesMusicRefreshTime
{
    _milestonesMusicRefreshTime = milestonesMusicRefreshTime;
    [userDefault setFloat:milestonesMusicRefreshTime forKey:Count_time_music_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesMusicAlbumRefreshTime
{
    _milestonesMusicAlbumRefreshTime = [userDefault floatForKey:Count_time_music_album_refresh_time];
    return _milestonesMusicAlbumRefreshTime;
}

- (void)setMilestonesMusicAlbumRefreshTime:(float)milestonesMusicAlbumRefreshTime
{
    _milestonesMusicAlbumRefreshTime = milestonesMusicAlbumRefreshTime;
    [userDefault setFloat:_milestonesMusicAlbumRefreshTime forKey:Count_time_music_album_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesVideoRefreshTime
{
    _milestonesVideoRefreshTime = [userDefault floatForKey:Count_time_video_refresh_time];
    return _milestonesVideoRefreshTime;
}

- (void)setMilestonesVideoRefreshTime:(float)milestonesVideoRefreshTime
{
    _milestonesVideoRefreshTime = milestonesVideoRefreshTime;
    [userDefault setFloat:milestonesVideoRefreshTime forKey:Count_time_video_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesVideoCategoryRefreshTime
{
    _milestonesVideoCategoryRefreshTime = [userDefault floatForKey:Count_time_video_category_refresh_time];
    return _milestonesVideoCategoryRefreshTime;
}

- (void)setMilestonesVideoCategoryRefreshTime:(float)milestonesVideoCategoryRefreshTime
{
    _milestonesVideoCategoryRefreshTime = milestonesVideoCategoryRefreshTime;
    [userDefault setFloat:milestonesVideoCategoryRefreshTime forKey:Count_time_video_category_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesStoreRefreshTime
{
    _milestonesStoreRefreshTime = [userDefault floatForKey:Count_time_store_refresh_time];
    return _milestonesStoreRefreshTime;
}

- (void)setMilestonesStoreRefreshTime:(float)milestonesStoreRefreshTime
{
    _milestonesStoreRefreshTime = milestonesStoreRefreshTime;
    [userDefault setFloat:milestonesStoreRefreshTime forKey:Count_time_store_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesStoreCategoryRefreshTime
{
    _milestonesStoreCategoryRefreshTime = [userDefault floatForKey:Count_time_store_category_refresh_time];
    return _milestonesStoreCategoryRefreshTime;
}

- (void)setMilestonesStoreCategoryRefreshTime:(float)milestonesStoreCategoryRefreshTime
{
    _milestonesStoreCategoryRefreshTime = milestonesStoreCategoryRefreshTime;
    [userDefault setFloat:milestonesStoreCategoryRefreshTime forKey:Count_time_store_category_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesEventRefreshTime
{
    _milestonesEventRefreshTime = [userDefault floatForKey:Count_time_event_refresh_time];
    return _milestonesEventRefreshTime;
}

- (void)setMilestonesEventRefreshTime:(float)milestonesEventRefreshTime
{
    _milestonesEventRefreshTime = milestonesEventRefreshTime;
    [userDefault setFloat:milestonesEventRefreshTime forKey:Count_time_event_refresh_time];
    [userDefault synchronize];
    
}

- (float)milestonesEventCategoryRefreshTime
{
    _milestonesEventCategoryRefreshTime = [userDefault floatForKey:Count_time_event_category_refresh_time];
    return _milestonesEventCategoryRefreshTime;
}

- (void)setMilestonesEventCategoryRefreshTime:(float)milestonesEventCategoryRefreshTime
{
    _milestonesEventCategoryRefreshTime = milestonesEventCategoryRefreshTime;
    [userDefault setFloat:milestonesEventCategoryRefreshTime forKey:Count_time_event_category_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesImageRefreshTime
{
    _milestonesImageRefreshTime = [userDefault floatForKey:Count_time_image_refresh_time];
    return _milestonesImageRefreshTime;

}

- (void)setMilestonesImageRefreshTime:(float)milestonesImageRefreshTime
{
    _milestonesImageRefreshTime = milestonesImageRefreshTime;
    [userDefault setFloat:milestonesImageRefreshTime forKey:Count_time_image_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesImageAlbumRefreshTime
{
    _milestonesImageAlbumRefreshTime = [userDefault floatForKey:Count_time_image_album_refresh_time];
    return _milestonesImageAlbumRefreshTime;
}

- (void)setMilestonesImageAlbumRefreshTime:(float)milestonesImageAlbumRefreshTime
{
    _milestonesImageAlbumRefreshTime = milestonesImageAlbumRefreshTime;
    [userDefault setFloat:milestonesImageAlbumRefreshTime forKey:Count_time_image_album_refresh_time];
    [userDefault synchronize];
}

- (float)milestonesTopUserRefreshTime
{
    _milestonesTopUserRefreshTime = [userDefault floatForKey:Count_time_top_user_refresh_time];
    return _milestonesTopUserRefreshTime;
}

- (void)setMilestonesTopUserRefreshTime:(float)milestonesTopUserRefreshTime
{
    _milestonesTopUserRefreshTime = milestonesTopUserRefreshTime;
    [userDefault setFloat:milestonesTopUserRefreshTime forKey:Count_time_top_user_refresh_time];
    [userDefault synchronize];
}

#pragma mark - milestone for every category id

//Add by TuanNM@20140901
- (NSInteger)milestonesNewRefreshTimeForCategoryIdPerPage:(NSString *)categoryId pageIndex:(NSString *)pageIndex
{
    NSString *key = [NSString stringWithFormat:@"%@_%@_%@",Count_time_news_list_refresh_time,categoryId, pageIndex];
    return [userDefault integerForKey:key]; //longnh fix code cho nay de disable khong kiem tra time update nua
}
- (void)setMilestonesNewRefreshTimeForCagegoryPerPage:(NSInteger)milestonesNewRefreshTimeForCategoryPerPage categoryId:(NSString *)categoryId pageIndex:(NSString *)pageIndex
{
    NSString *key = [NSString stringWithFormat:@"%@_%@_%@",Count_time_news_list_refresh_time,categoryId,pageIndex];
    [userDefault setInteger:milestonesNewRefreshTimeForCategoryPerPage forKey:key];
    [userDefault synchronize];
}
//End adding
- (NSInteger)milestonesMusicRefreshTimeForAlbumId:(NSString *)albumId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_music_refresh_time,albumId];
    return [userDefault integerForKey:key];
}
- (void)setMilestonesMusicRefreshTime:(NSInteger)milestonesMusicRefreshTime albumId:(NSString *)albumId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_music_refresh_time,albumId];
    [userDefault setInteger:milestonesMusicRefreshTime forKey:key];
    [userDefault synchronize];
}

- (NSInteger)milestonesVideoRefreshTimeForAlbumId:(NSString *)albumId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_video_refresh_time,albumId];
    return [userDefault integerForKey:key];
}
- (void)setMilestonesVideoRefreshTime:(NSInteger)milestonesVideoRefreshTime albumId:(NSString *)albumId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_video_refresh_time,albumId];
    [userDefault setInteger:milestonesVideoRefreshTime forKey:key];
    [userDefault synchronize];
}

- (NSInteger)milestonesStoreRefreshTimeForCategoryId:(NSString *)categoryId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_store_refresh_time, categoryId];
    return [userDefault integerForKey:key];
}

- (void)setMilestonesStoreRefreshTime:(NSInteger)milestonesStoreRefreshTime categoryId:(NSString *)categoryId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_store_refresh_time,categoryId];
    [userDefault setInteger:milestonesStoreRefreshTime forKey:key];
    [userDefault synchronize];
}

- (NSInteger)milestonesEventRefreshTimeForCategoryId:(NSString *)categoryId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_event_refresh_time, categoryId];
    return [userDefault integerForKey:key];
}

- (void)setMilestonesEventRefreshTime:(NSInteger)milestonesEventRefreshTime categoryId:(NSString *)categoryId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_event_refresh_time,categoryId];
    [userDefault setInteger:milestonesEventRefreshTime forKey:key];
    [userDefault synchronize];
}

- (NSInteger)milestonesImageRefreshTimeForAlbumId:(NSString *)albumId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_image_refresh_time, albumId];
    return [userDefault integerForKey:key];
}

- (void)setMilestonesImageRefreshTime:(NSInteger)milestonesImageRefreshTime albumId:(NSString *)albumId
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",Count_time_image_refresh_time,albumId];
    [userDefault setInteger:milestonesImageRefreshTime forKey:key];
    [userDefault synchronize];
}

//Add by TuanNM@20140902
- (NSInteger)milestonesNodeRefreshTime:(NSString *)type nodeId:(NSString *)nodeId
{
    NSString *key = [NSString stringWithFormat:@"node%@_%@", type, nodeId];
    return [userDefault integerForKey:key];
}

- (void)setMilestonesNodeRefreshTime:(NSInteger)milestonesNodeRefreshTime type:(NSString *)type nodeId:(NSString *)nodeId
{
    NSString *key = [NSString stringWithFormat:@"node%@_%@", type, nodeId];
    [userDefault setInteger:milestonesNodeRefreshTime forKey:key];
    [userDefault synchronize];
}

- (NSInteger)milestonesSingerInfoRefreshTime
{
    return [userDefault integerForKey:Count_time_singer_info_refresh_time];
}

- (void)setMilestonesSingerInfoRefreshTime:(NSInteger)milestonesSingerInfoRefreshTime
{
    [userDefault setInteger:milestonesSingerInfoRefreshTime forKey:Count_time_singer_info_refresh_time];
    [userDefault synchronize];
}
/*
 Kiem tra node co thoi gian timeout trong cache het chua
 */
- (bool) isCacheForNodeTimeout: (NSString *)type nodeId:(NSString *)nodeId updateCacheNow:(BOOL)updateCacheNow  timeout:(NSInteger)timeout
{
    //-- check time
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger prvTime = [[Setting sharedSetting] milestonesNodeRefreshTime:type nodeId:nodeId];
    NSInteger compeTime = currentDate - prvTime;
    NSLog(@"%s type=%@ nodeId=%@ timeout=%d crr=%d, prv=%d", __func__, type, nodeId, timeout, currentDate, prvTime);
    
    if (compeTime < timeout) {
        return false;
    }
    if (updateCacheNow)
        [[Setting sharedSetting] setMilestonesNodeRefreshTime:currentDate type:type nodeId:nodeId];
    return true;
}
//End add
@end
