//
//  FacebookUtils.h
//  AGKGlobal
//
//  Created by Thuy Dao on 6/21/13.
//  Copyright (c) 2013 Thuy Dao. All rights reserved.
//

/*
 // link
 
 https://developers.facebook.com/docs/reference/api/privacy-parameter/
 
 
 */

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Utility.h"
#import "NetworkActivity.h"

@class FacebookUtils;

@protocol FacebookUtilsDelegate <NSObject>

@optional

- (void)facebook:(FacebookUtils*)fbU didLoginFinish:(NSString*)response;
- (void)facebook:(FacebookUtils*)fbU didLoginFail:(NSError*)error;
- (void)facebook:(FacebookUtils*)fbU didLogout:(BOOL)success;

- (void)facebook:(FacebookUtils*)fbU didRefeshNewFeedFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didRefeshNewFeedFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didLikeFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didLikeFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetUserInfoFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetUserInfoFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetMeFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetMeFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didCommentFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didCommentFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetReFeshFriendFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetReFeshFriendFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetCommentForPostFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetCommentForPostFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetCommentForIDFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetCommentForIDFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetPostFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetPostFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetProfileListFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetProfileListFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetNewsFeedSeeMoreFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetNewsFeedSeeMoreFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetNewsFeedStoriesFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetNewsFeedStoriesFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetCommentSeeMoreFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetCommentSeeMoreFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetPlaceFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetPlaceFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetNearbyPlacesFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetNearbyPlacesFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetDetailPhotoFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetDetailPhotoFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didShareFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didShareFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didGetAllFriendListFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didGetAllFriendListFail:(NSError*)error;

- (void)facebook:(FacebookUtils*)fbU didDeletePostFinish:(NSDictionary*)result;
- (void)facebook:(FacebookUtils*)fbU didDeletePostFail:(NSError*)error;

@end

@interface FacebookUtils : NSObject
{
    @private
        FBSession *__fbSession;
}

+ (FBSession*)facebookSession;
+ (void)initWithDelegate:(id<FacebookUtilsDelegate>) delegate;
+ (BOOL)isAuthorized;
+ (BOOL)isOpen;
+ (void)logInFacebook;
+ (void)logOutFacebook;
+ (void)resetFacebookSession;
+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication;

+ (void)refreshNewsFeed:(NSString*)query;

+ (void)like:(NSString*)postID HTTPMethod:(NSString*)method;

+ (void)requestProfileWithID:(NSString*)userID;

+ (void)getMe;

+ (void)refreshFriends;

+ (void)comment:(NSString*)postID withText:(NSString*)text;

+ (void)getCommentForPost:(NSString*)PostID;

+ (void)getCommentForID:(NSString *)CommentID;

+ (void)getPost:(NSString*)PostID;

+ (void)getALLFriendsList;

+ (void)getProfilesList:(NSString*)listId;

+ (void)getPagesList:(NSString*)listId;

+ (void)getNewsFeedSeeMore:(NSInteger)limitNumber;

+ (void)getComment:(NSString *)PostID seeMore:(NSInteger)offset;

+ (void)addDelegate:(id)delegate;

+ (void)removeDelegate:(id)delegate;

+ (void)getPlace:(NSString*)checkinID;

+ (void)getNearbyPlaces:(CLLocation*)location;

+ (void)hidenPost:(NSString*)postID;

+ (void)getDetailPhoto:(NSString*)pid;

+ (void)sharePost:(NSString*)url text:(NSString*)text audience:(NSMutableDictionary*)audienceDict;

+ (void)multiQuery:(NSString*)querry;

+ (void)getNewFeedsMultiQuery;

+ (void)getNewsFeedStories;

+ (void)getSeeMoreNewFeedsMultiQuery:(NSString*)limit;

+ (void)deletePost:(NSString*)postID;


#pragma mark - util

+ (NSString*)ConverCount:(NSString*)count;
+ (NSString*)getAudienceValue:(NSDictionary*)audienceDict;
@end
