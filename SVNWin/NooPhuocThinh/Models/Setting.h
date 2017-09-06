//
//  Setting.h
//  NooPhuocThinh
//
//  Created by HuntDo on 7/29/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VMConstant.h"

@interface Setting : NSObject

#pragma mark - refresh time

//-- refresh time (minutes)
@property (nonatomic, assign) float newRefreshTime;
@property (nonatomic, assign) float newListRefreshTime;
@property (nonatomic, assign) float newsCategoryRefreshTime;
@property (nonatomic, assign) float musicRefreshTime;
@property (nonatomic, assign) float musicAlbumRefreshTime;
@property (nonatomic, assign) float videoRefreshTime;
@property (nonatomic, assign) float videoCategoryRefreshTime;
@property (nonatomic, assign) float storeRefreshTime;
@property (nonatomic, assign) float storeCategoryRefreshTime;
@property (nonatomic, assign) float eventRefreshTime;
@property (nonatomic, assign) float eventCategoryRefreshTime;
@property (nonatomic, assign) float imageRefreshTime;
@property (nonatomic, assign) float imageAlbumRefreshTime;
@property (nonatomic, assign) float topUserRefreshTime;
@property (nonatomic, assign) float singerInfoRefreshTime;

//--milestones (seconds)

@property (nonatomic, assign) float milestonesNewRefreshTime;
@property (nonatomic, assign) float milestonesNewsCategoryRefreshTime;
@property (nonatomic, assign) float milestonesMusicRefreshTime;
@property (nonatomic, assign) float milestonesMusicAlbumRefreshTime;
@property (nonatomic, assign) float milestonesVideoRefreshTime;
@property (nonatomic, assign) float milestonesVideoCategoryRefreshTime;
@property (nonatomic, assign) float milestonesStoreRefreshTime;
@property (nonatomic, assign) float milestonesStoreCategoryRefreshTime;
@property (nonatomic, assign) float milestonesEventRefreshTime;
@property (nonatomic, assign) float milestonesEventCategoryRefreshTime;
@property (nonatomic, assign) float milestonesImageRefreshTime;
@property (nonatomic, assign) float milestonesImageAlbumRefreshTime;
@property (nonatomic, assign) float milestonesTopUserRefreshTime;
@property (nonatomic, assign) float milestonesSingerInfoRefreshTime;

+(Setting *)sharedSetting;

/*
 * milestones (seconds) for every category
 */

//-- news
- (NSInteger)milestonesNodeRefreshTime:(NSString *)type nodeId:(NSString *)nodeId;
- (NSInteger)milestonesNewRefreshTimeForCategoryIdPerPage:(NSString *)categoryId pageIndex:(NSString *)pageIndex;
- (void)setMilestonesNewRefreshTimeForCagegoryPerPage:(NSInteger)milestonesNewRefreshTimeForCategoryPerPage categoryId:(NSString *)categoryId pageIndex:(NSString *)pageIndex;
- (bool) isCacheForNodeTimeout: (NSString *)type nodeId:(NSString *)nodeId updateCacheNow:(BOOL)updateCacheNow  timeout:(NSInteger)timeout;
//-- music
- (NSInteger)milestonesMusicRefreshTimeForAlbumId:(NSString *)albumId;
- (void)setMilestonesMusicRefreshTime:(NSInteger)milestonesMusicRefreshTime albumId:(NSString *)albumId;

//-- video
- (NSInteger)milestonesVideoRefreshTimeForAlbumId:(NSString *)albumId;
- (void)setMilestonesVideoRefreshTime:(NSInteger)milestonesVideoRefreshTime albumId:(NSString *)albumId;

//-- store
- (NSInteger)milestonesStoreRefreshTimeForCategoryId:(NSString *)categoryId;
- (void)setMilestonesStoreRefreshTime:(NSInteger)milestonesStoreRefreshTime categoryId:(NSString *)categoryId;

//-- event
- (NSInteger)milestonesEventRefreshTimeForCategoryId:(NSString *)categoryId;
- (void)setMilestonesEventRefreshTime:(NSInteger)milestonesEventRefreshTime categoryId:(NSString *)categoryId;

//-- images
- (NSInteger)milestonesImageRefreshTimeForAlbumId:(NSString *)albumId;
- (void)setMilestonesImageRefreshTime:(NSInteger)milestonesImageRefreshTime albumId:(NSString *)albumId;


@end
