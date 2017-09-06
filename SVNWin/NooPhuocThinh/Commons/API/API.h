//
//  API.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/16/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "VMConstant.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#define NDEBUG 1

#ifdef NDEBUG
#define DDBG DBG(@"")
#define DBG(xx) NSLog(@"%p %s (%d): %@", self, __PRETTY_FUNCTION__, __LINE__, xx)
#define DBGRECT(xx) DBG(NSStringFromCGRect(xx))
#define DBGPOINT(xx) DBG(NSStringFromCGPoint(xx))
#define LOG(xx, ...) NSLog(@"%p %s (%d): %@", self, __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:xx, ##__VA_ARGS__])
#else
#define DDBG
#define DBG(xx)
#define DBGRECT(xx)
#define DBGPOINT(xx)
#define LOG(xx, ...)
#endif

//---------------------------- Server Test----------------------------//

/*
 * Host get content: news, schedule, store, video, music, category, singer, setting ...
 */
//#define HOST_FOR_CONTENT (@"http://test1.bome.vn/gom_services")

/*
 * host for apis: add_user, get_user_info, get_user_point, get_shoutbox_data, add_shoutbox, check user, like, comment.
 */

// #define HOST_FOR_USER (@"http://sns374.ori.soci.vn/ati/service_v1.0")
//#define HOST_FOR_USER (@"https://myidol.bome.vn/ati/service_v1.0")


//---------------------------- Server Telco ----------------------------//

/*
 * Host get content: news, schedule, store, video, music, category, singer, setting ...
 */
//#define HOST_FOR_CONTENT (@"http://service.soci.vn/?q=gom_services") //longnh
#define HOST_FOR_CONTENT ([[[NSUserDefaults standardUserDefaults] objectForKey:API_DEF] objectForKey:@"start_url_for_content"])


/*
 * host for apis: add_user, get_user_info, get_user_point, get_shoutbox_data, add_shoutbox, check user
 * like, comment.
 */
//#define HOST_FOR_USER (@"https://myidol.soci.vn/ati/service_v1.0") //longnh
#define HOST_FOR_USER ([[[NSUserDefaults standardUserDefaults] objectForKey:API_DEF] objectForKey:@"start_url_for_user"])
#define HOST_FOR_CHARGING ([[[NSUserDefaults standardUserDefaults] objectForKey:API_DEF] objectForKey:@"start_url_for_charging"])


//----------------------------------------------------------------------------------------------------------------//


#define ERROR_DOMAIN (@"test1.bome.error.vn")

#define ERROR_CODE_NETWORK          0x100
#define ERROR_CODE_DATA             0x101
#define ERROR_CODE_UNKNOW           0x102
#define ERROR_CODE_FROM_SERVER      0x103


@interface API : NSObject

#pragma mark -

+(NSString *) getUserIdifExist;

//------------------------------ Hunt Do ----------------------------------------------//
/**
 * by Long Nguyen 16/12/2013
 * @abstract get node of user
 * @param singerID: 643 for Tran Thanh
 * @param contentTypeId: enum
 * @param limit: number of items on 1 page, if limit = -1 then unlimit (get all). Value default is 10.
 * @param page (int): start is 0, specific page = 0, 1,2,3...
 * @param period: number of months: 3, 6... only use for content type:schedule, event
 * @param isHotNode (0 or 1): if isHotNode== 1 then only get item marked is hot.
 * @param start: (int): number of day, against date current. accept negative value. example: -1 equal yesterday.
 * @param appID:
 * @param appVersion:
 
 * @result NSDictionary in JSON format
 
 **/

+ (void)getNodeForSingerID:(NSString*)singerID
             contentTypeId:(ContentTypeID)contentTypeId
                     limit:(NSString*)limit
                      page:(NSString *)page
                    period:(NSString*)period
                 isHotNode:(NSString*)isHotNode
                     start:(NSString*)start
                     appID:(NSString*)appID
                appVersion:(NSString*)appVersion
                 completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 9/1/2014
 * @abstract get setting from server when start run app
 * @param production_id: 48 for Tran Thanh
 * @param distributorId: 6 for Tran Thanh
 * @param distributorChannelId: 9 for Tran Thanh
 * @param platformId (int): 2 for android, 4 for ios
 * @param contentProviderId: default is 1.
 * @result NSDictionary in JSON format
 
 **/

+ (void)getSettingWithProductionId:(NSString*)productionId
                     distributorId:(NSString*)distributorId
              distributorChannelId:(NSString*)distributorChannelId
                        platformId:(PlatformOS) platformId
                 contentProviderId:(NSString*)contentProviderId
                         completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * @abstract get feeds from server
 * @param production_id:
 * @param production_version:
 * @param singer_id:
 * @result NSDictionary in JSON format
 
 **/
+ (void)getFeedofSingerID:(NSString*)productionId
                     productionVersion:(NSString*)productionVersion
                    singerId:(NSString*)singerId
                         completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


#pragma mark - Category

/**
 * by Long Nguyen 17/12/2013
 * @abstract get Category By Singer for every content type
 * @param singleID: 936 for Tran Thanh
 * @param contentTypeId: enum
 * @param appID:
 * @param appVersion:
 * @result NSDictionary in JSON format
 **/

+ (void)getCategoryBySinger:(NSString*)singleID
              contentTypeId:(ContentTypeID)contentTypeId
                      appID:(NSString*)appID
                 appVersion:(NSString*)appVersion
                  completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 17/12/2013
 * @abstract get Node By Category For Singer. called after getCategoryBySinger api
 * @param contentTypeId: enum
 * @param limit: number of items on 1 page, if limit = -1 then unlimit (get all). Value default is 10.
 * @param page (int): start is 0, specific page = 0, 1,2,3...
 * @param period: number of months: 3, 6... only use for content type:schedule, event
 * @param isHotNode (0 or 1): if isHotNode== 1 then only get item marked is hot.
 * @param start: (int): number of day, against date current. accept negative value. example: -1 equal yesterday.
 * @param appID:
 * @param appVersion:
 * @param isGetNodeBody: (0 or 1), if == 1 then details news.
 * @result NSDictionary in JSON format
 **/
+ (void)getNodeByCategoryForSingerWithContentTypeId:(ContentTypeID)contentTypeId
                                              limit:(NSString *) limit
                                               page:(NSString *) page
                                          isHotNode:(NSString *) isHotNode
                                      isGetNodeBody:(NSString *) isGetNodeBody
                                         categoryId:(NSString *) categoryID
                                             period:(NSString *) period
                                              start:(NSString *) start
                                              appID:(NSString *) appID
                                         appVersion:(NSString *) appVersion
                                             months:(NSString *)months
                                          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 6/1/2014
 * @abstract send to server status of user
 * @param status: what'on user's mind.
 * @param user_id: id of user.
 * @param app_id:
 * @param app_version
 * @result NSDictionary in JSON format
 **/
+ (void)writeStatus:(NSString *) status
            user_id:(NSString *) userId
             app_id:(NSString *) appId
        app_version:(NSString *) appVersion
          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


//---------------------------------------------------------------------------------------------//


#pragma mark - SMS Register

//-- check exist user by FB
+ (void)getUserExistByFBTypeRequest:(NSString*)typeRequest
                             mobile:(NSString*)mobile
                         fb_user_id:(NSString *)fb_user_id
                          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


//-- get Phone number 3G
+ (void)getPhoneNumberAPICompleted:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


//-- check exist Phone number
+ (void)getUserExistByPhoneNumberTypeRequest:(NSString*)typeRequest
                                      mobile:(NSString*)mobile
                                   completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


//-- api API GSoapTest
+ (void)callAPIGSoapTestPhoneNumber:(NSString *)mobileNumber
                               code:(NSString *)code
                             singer:(NSString*)singer sign:(NSString*)sign
                          completed:(void (^)(NSString *responseString, NSError *error))completed;


//-- api cash Phone number by link
+ (void)callCashPhoneNumberReqId:(NSString*)reqId
                    mobileNumber:(NSString *)mobileNumber
                      smsContent:(NSString *)smsContent
                            sign:(NSString*)sign
                       completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


//-- call api verify
+ (void)apiVerifyLoginWithPhoneNumberReqId:(NSString*)reqId mobileNumber:(NSString *)mobileNumber singerCode:(NSString *)singerCode password:(NSString *)password sign:(NSString*)sign completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

//-- get link api
+(NSString *) getLinkAPI_DKCT;


//-- call api login Free app
+ (void)apiVerifyLoginFreeAppWithPhoneNumber:(NSString *)mobileNumber password:(NSString *)password completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


#pragma mark - Thoa
//------------------------------ Long Nguyen ----------------------------------------------//
/**
 * by Long Nguyen 16/12/2013
 * @abstract getAllMusicAndVideoOfSinglerID
 * @param singleID: 936 for Tran Thanh
 * @param contentTypeId: enum
 * @param limit: number of items on 1 page, if limit = -1 then unlimit (get all). Value default is 10.
 * @param page (int): start is 0, specific page = 0, 1,2,3...
 * @param period: number of months: 3, 6... only use for content type:schedule, event
 * @param isHotNode (0 or 1): if isHotNode== 1 then only get item marked is hot.
 * @param appID:
 * @param appVersion:
 
 * @result NSDictionary in JSON format
 
 **/
+ (void)getAllMusicAndVideoOfSinglerID:(NSString*)singleID
                         contentTypeId:(ContentTypeID)contentTypeId
                                 limit:(NSString*)limit
                                  page:(NSString *)page
                             isHotNode:(NSString*)isHotNode
                                months:(NSString*)months
                                 appID:(NSString*)appID
                            appVersion:(NSString*)appVersion
                             completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 16/12/2013
 * @abstract get all albums of singer
 * @param singleID: 936 for Tran Thanh
 * @param contentTypeId: enum
 * @param limit: number of items on 1 page, if limit = -1 then unlimit (get all). Value default is 10.
 * @param page (int): start is 0, specific page = 0, 1,2,3...
 * @param period: number of months: 3, 6... only use for content type:schedule, event
 * @param isHotNode (0 or 1): if isHotNode== 1 then only get item marked is hot.
 * @param isGetBody: có lấy nội dung không; 0- mặc đinh , không lấy; 1- có lấy. Với album music là lấy danh sách music trong album, với photo album là lấy danh sách photo trong album
 * @param appID:
 * @param appVersion:
 * @result NSDictionary in JSON format
 **/
+ (void)getAlbumOfSinglerID:(NSString*)singleID
              contentTypeId:(ContentTypeID)contentTypeId
                      limit:(NSString*)limit
                       page:(NSString *)page
                  isGetBody:(NSString*)isGetBody
                   isGetHot:(NSString*)isGetHot
                      appID:(NSString*)appID
                 appVersion:(NSString*)appVersion
                  completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

/**
 * by Long Nguyen 16/12/2013
 * @abstract get all music in album
 * @param album_id:x,xx,xxx,... id (Integer) của album, cách nhau bởi dấu "," , -1 nếu lấy tất cả
 * @param contentTypeId: enum
 * @param limit: number of items on 1 page, if limit = -1 then unlimit (get all). Value default is 10.
 * @param page (int): start is 0, specific page = 0, 1,2,3...
 * @param isHotNode (0 or 1): if isHotNode== 1 then only get item marked is hot.
 * @param appID:
 * @param appVersion:
 * @result NSDictionary in JSON format
 **/
+ (void)getNodeByAlbum:(NSString*)albumId
         contentTypeId:(ContentTypeID)contentTypeId
                 limit:(NSString*)limit
                  page:(NSString *)page
             isHotNode:(NSString*)isHotNode
                 appID:(NSString*)appID
            appVersion:(NSString*)appVersion
             completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 18/12/2013
 * @abstract create user fanzone using facebook account
 * @param fb_user_id
 * @param uuid
 * @param user_name
 * @param fullname
 * @param password
 * @param email
 * @param gender(1:Male, 2:Female)
 * @param country_iso(default: VN)
 * @param user_image
 * @param appID:
 * @param appVersion:
 * @result NSDictionary in JSON format
 **/
+ (void)createAccount:(NSString*)userName
             fullName:(NSString *)fullName
            passwordd:(NSString*)password
                email:(NSString *)email
               gender:(NSString*)gender
             birthday:(NSString*)birthday
           countryIso:(NSString *)countryIso
             fbUserId:(NSString*)fbUserId
          accessToken:(NSString*)acessToken
               mobile:(NSString*)mobile
            userImage:(NSString*)userImage
                appID:(NSString*)appID
           appVersion:(NSString*)appVersion
           coverPhoto:(NSString*)coverPhoto
            completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;



/**
 * by Long Nguyen 19/12/2013
 * @abstract get user info
 * @param user_id
 * @result NSDictionary in JSON format
 **/
+ (void)getUserInfo:(NSString*)userId withFaceBookID:(NSString*)fbUserId
       productionId:(NSString*)productionId
  productionVersion:(NSString*)productionVersion
         avatarSize:(NSString*)avatarSize
          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

/**
 * by Long Nguyen 19/12/2013
 * @abstract get user info by fbUserId
 * @param fb_user_id
 * @result NSDictionary in JSON format
 **/
+ (void)getUserInfoByFaceBookID:(NSString*)fbUserId withUserId:(NSString*)userId
                   productionId:(NSString*)productionId
              productionVersion:(NSString*)productionVersion
                     avatarSize:(NSString*)avatarSize
                      completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

+ (void)updateUserInfo:(NSString*)userId fbUserId:(NSString*)fbUserId mobile:(NSString*)mobile
           accessToken:(NSString*)accessToken completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 19/12/2013
 * @abstract get user points
 * @param user_id
 * @result NSDictionary in JSON format
 **/
+ (void)getUserPoints:(NSString*)userId
                appId:(NSString*)appId
           appVersion:(NSString*)appVersion
            completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 19/12/2013
 * @abstract get data shoutbox
 * @param itermId(page_id)
 * @result NSDictionary in JSON format
 **/
+ (void)getDataShoutBox:(NSString*)pageId
                  limit:(NSString*)limit
              startTime:(NSString*)startTime
                endTime:(NSString*)endTime
                  appId:(NSString*)appId
             appVersion:(NSString*)appVersion
              completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 19/12/2013
 * @abstract insert data shoutbox
 * @param item_id
 * @param user_id
 * @param text
 * @result NSDictionary in JSON format
 **/
+ (void)addShoutBox:(NSString*)pageId
             userId:(NSString *)userId
               text:(NSString *)text
              appId:(NSString*)appId
         appVersion:(NSString*)appVersion
          startTime:(NSString*)startTime
   isGetNewShoutBox:(NSString*)isGetNewShoutBox
          completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 3/1/2014
 * @abstract get singer info
 * @param node_id
 * @param content_type_id
 * @param app_id
 * @param app_version
 * @result NSDictionary in JSON format
 **/
+ (void)getNodeDetail:(NSString*)nodeId
        contentTypeId:(ContentTypeID)contentTypeId
                appId:(NSString*)appId
           appVersion:(NSString*)appVersion
            completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


/**
 * by Long Nguyen 6/1/2014
 * @abstract get top user point
 * @param rank_type
 * @param time
 * @param time_end
 * @param is_get_all_day
 * @param limit
 * @param production_version
 * @param production_id
 * @result NSDictionary in JSON format
 **/
+ (void)getTopUserPoint:(NSString*)rankType
               singerId:(NSString*)singerId
                   time:(NSString*)time
                timeEnd:(NSString*)timeEnd
            isGetAllDay:(NSString*)isGetAllDay
                  limit:(NSString*)limit
           productionId:(NSString*)productionId
      productionVersion:(NSString*)productionVersion
              completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

//---------------------------------------------------------------------------------------------//


/**
 * by Long Nguyen 15/1/2014
 * @abstract sync data comment
 * @param user_id
 * @param page_id
 * @param data_comment
 * @param content_id
 * @param content_type_id
 * @param text
 * @param time_stamp
 * @param data_like
 * @param data_view
 * @param production_version
 * @param production_id
 * @result NSDictionary in JSON format
 **/
+ (void)syncData:(NSString*)userID
          pageId:(NSString*)pageId
        dataSync:(NSString*)dataSync
        dataType:(NSString*)dataType
    productionId:(NSString*)productionId
productionVersion:(NSString*)productionVersion
       completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

//---------------------------------------------------------------------------------------------//


/**
 * by Long Nguyen 17/1/2014
 * @abstract get list comment
 * @param singer_id
 * @param content_id
 * @param content_type_id
 * @param comment_id
 * @param get_comment_of_comment
 * @param production_version
 * @param production_id
 * @result NSDictionary in JSON format
 **/
+ (void)getCommentData:(NSString*)singerId
             contentId:(NSString*)contentId
         contentTypeId:(NSString*)contentTypeId
             commentId:(NSString*)commentId
   getCommentOfComment:(NSString*)getCommentOfComment
          productionId:(NSString*)productionId
     productionVersion:(NSString*)productionVersion
             completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

//---------------------------------------------------------------------------------------------//


/**
 * by Long Nguyen 22/1/2014
 * @abstract get list winners
 * @param singer_id
 * @param contest_id
 * @param round_id
 * @param production_version
 * @param production_id
 * @result NSDictionary in JSON format
 **/
+ (void)getListWinners:(NSString*)singerId
             contestId:(NSString*)contest_id
               roundId:(NSString*)roundId
          productionId:(NSString*)productionId
     productionVersion:(NSString*)productionVersion
             completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

//---------------------------------------------------------------------------------------------//


/**
 * by Long Nguyen 25/1/2014
 * @abstract get shoutbox data comment
 * @param fanzone_id
 * @param start_time
 * @param end_time
 * @param limit
 * @param production_version
 * @param production_id
 * @result NSDictionary in JSON format
 **/
+ (void)getShoutBoxDataComment:(NSString*)fanzoneId
                     startTime:(NSString*)startTime
                       endTime:(NSString*)endTime
                         limit:(NSString*)limit
                  productionId:(NSString*)productionId
             productionVersion:(NSString*)productionVersion
                     completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

//---------------------------------------------------------------------------------------------//


/**
 * by Long Nguyen 25/1/2014
 * @abstract get shoutbox data comment
 * @param page_id
 * @param fanzone_id
 * @param user_id
 * @param text
 * @param is_get_new_shoutbox
 * @param start_time
 * @param end_time
 * @param limit
 * @param production_version
 * @param production_id
 * @result NSDictionary in JSON format
 **/
+ (void)postCommentFanzone:(NSString*)pageId
                 fanzoneId:(NSString*)fanzoneId
                    userId:(NSString*)userId
                      text:(NSString*)text
          isGetNewShoutBox:(NSString*)isGetNewShoutBox
                 startTime:(NSString*)startTime
                   endTime:(NSString*)endTime
                     limit:(NSString*)limit
              productionId:(NSString*)productionId
         productionVersion:(NSString*)productionVersion
                 completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

//---------------------------------------------------------------------------------------------//

//-- Search API
+ (void)searchAPIOfSinglerID:(NSString*)singleID
               contentTypeId:(ContentTypeID)contentTypeId
                     keyword:(NSString*)keyword
                       limit:(NSString*)limit
                        page:(NSString *)page
                   isGetBody:(NSString*)isGetBody
                    isGetHot:(NSString*)isGetHot
                       appID:(NSString*)appID
                  appVersion:(NSString*)appVersion
                   completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

+ (void)searchUserOfSinglerID:(NSString*)singleID
                      keyword:(NSString*)keyword
                        limit:(NSString*)limit
                         page:(NSString *)page
                        appID:(NSString*)appID
                   appVersion:(NSString*)appVersion
                    completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

//-- request get SONG_RINGBACKTONE_ID
+ (void)apiGetSongRingBackToneIDByMusicID:(NSString*)musicId
                     distributorChannelId:(NSString*)distributorChannelId
                                telcoCode:(NSString*)telcoCode
                                    appID:(NSString*)appID
                               appVersion:(NSString*)appVersion
                                completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

+ (void)sendLocalLog:(NSString*)sendLog
           completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;


//test
+ (void)syncFeedData:(NSString*)userID
            singerId:(NSString*)singerId
            dataFeed:(NSString*)dataFeed
        productionId:(NSString*)productionId
   productionVersion:(NSString*)productionVersion
           completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

//-- get comment data feed
+ (void)getCommentDataFeed:(NSString*)singerID
              productionId:(NSString*) productionId
         productionVersion:(NSString*)productionVersion
             contentTypeId:(NSString *)contentTypeId
                 contentId:(NSString*)contentId
                 commentId:(NSString*)commentId
              isGetComment:(NSString*)isGetComment
                    isFeed:(NSString*)isFeed
                 completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed;

@end
