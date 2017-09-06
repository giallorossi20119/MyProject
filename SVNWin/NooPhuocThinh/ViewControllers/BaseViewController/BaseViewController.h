//
//  BaseViewController.h
//  NooPhuocThinh
//
//  Created by Thuy Dao on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserInfo.h"
#import "UserPoint.h"
#import "UserField.h"
#import "FacebookUtils.h"
#import "SHKActivityIndicator.h"
#import "API.h"
#import "ShoutBoxData.h"
#import "Profile.h"
#import "JSON.h"
#import "WBNoticeView.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "PostComments.h"
#import "webviewPurview.h"
#import "WifiLoginView.h"
#import "Comment.h"
#import "VMConstant.h"
#import "Profile.h"
#import "ShareInviteFriendView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

typedef enum {
    DownloadTypeMusic = 0,
    DownloadTypeVideo = 1,
    DownloadTypePhoto = 2,
}DownloadType;

@class UITextView;
@class UIView;
@class BaseViewController;

@protocol BaseViewControllerDelegate <NSObject>

@optional
- (void)baseViewController:(BaseViewController*)baseViewController didCreateAccountSuscessful:(Profile*)Profile;
- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;

//-- pass data comments Delegate
- (void)passCommentsDelegate:(NSMutableArray*)listDataComments;

//-- sync data success Delegate
- (void)syncDataSuccessDelegate:(NSDictionary*)response;

@end

@class FanZoneViewController;

@protocol FanZoneViewControllerDelegate <NSObject>

- (void)fanZoneViewController:(FanZoneViewController*)fanZoneViewController sendLatestMessages:(NSMutableArray *)latestMessages;

@end


@interface BaseViewController : GAITrackedViewController
<UITextViewDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate>
{
    @public
    NSInteger                   checkTabValue;
    NSInteger                   screenCode;
    
    @private
    PostComments                *_viewComments;
    webviewPurview              *viewPurview;
    WifiLoginView               *viewWifiLogin;
  
    @protected
    NSString                    *strTitle;
    IBOutlet UIImageView        *imvBackgorund;
    IBOutlet UITextView         *_txtComment;
    UIView                      *_viewDialogComment;
    
    WBErrorNoticeView *notice;
    WBSuccessNoticeView *noticeSuccess;
    
    float totalTimeRequest;
    bool isProcessAPI;
    //-- share invite
    ShareInviteFriendView  *shareInviteFriend;
    
    //-- count timerRequestErrorNetwork
    float totalTimerRequestErrorNetwork;
}

@property (nonatomic, retain) NSTimer               *timerRequest;
@property (nonatomic, retain) NSTimer               *timerRequestErrorNetwork;

@property (nonatomic, retain) NSMutableArray        *arrCommentData;
@property (nonatomic, retain) WBErrorNoticeView     *notice;
@property (nonatomic, retain) WBSuccessNoticeView   *noticeSuccess;

@property (nonatomic, retain) Profile               *myAccount;
@property (nonatomic, assign) id<BaseViewControllerDelegate> delegateBaseController;

#pragma mark - UI

- (void)setupBackButton;
- (void)setTitle:(NSString *)title;
- (void)addViewCSLWithFrame:(CGRect)frame;

/*
 * Method SlideBar Bottom
 */

-(void) addBottomBarBaseViewController;
-(void) removeBottomBarBaseViewController;
-(BOOL) checkBottomBarExistBaseViewController;

/*
 * Method SlideBar Bottom
 */

-(void) addSlideBarBaseViewController;
-(void) removeSlideBarBaseViewController;


#pragma mark - Share Facebok

- (void) shareFacebookWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)urlLink imagePath:(NSString *)imagePath contentId:(NSString*)contentId contentTypeId:(NSString*)contentTypeId;

#pragma mark - API data view

- (void) apiDataView:(NSString *)contentId contentTypeId:(NSString *)contentTypeId;


#pragma mark - post comments
/*
 * by HuntDo
 */
-(void)showDialogComments:(CGPoint)point title:(NSString *)title;
-(void)cancelComment;
-(void)postComment;
-(NSString *)getContentOfComment;
-(void)setDelagateForTextComment:(id)delegate;

#pragma mark - Facebook
/*
 * by HuntDo 3/1/2013
 */
-(void) createAccount;


#pragma mark - Error Notice Network

-(void) showConnectionError;

//-- show alert Check Network
-(BOOL) checkAndShowErrorNoticeNetwork;

//-- show notification Failed
-(void) showNotificationFailed;

//-- play song again when error network
-(void) callRequestErrorNetwork;

//-- show lable no data
-(void) addLableNoDataTo:(UIScrollView *)scrollview withIndex:(NSInteger) index withFrame:(CGRect) frameLable;

//-- show lable no data
-(void) addLableNoShoutboxTo:(UIScrollView *)scrollview withIndex:(NSInteger) index withFrame:(CGRect) frameLable;

//-- remove lable no data
-(void) removeLableNoDataFrom:(UIScrollView *)scrollview withIndex:(NSInteger) index;

//-- show lable no data tableview
-(void) addLableNoDataToTableView:(UITableView *)tableview withIndex:(NSInteger) index withFrame:(CGRect) frameLable byTitle:(NSString *) titleData;

//-- remove lable no data tableview
-(void) removeLableNoDataFromTableView:(UITableView *)tableview withIndex:(NSInteger) index;


//-- call api sync data
- (bool)callAPISyncData:(NSInteger)typeSync text:(NSString*)text contentId:(NSString *)contentId contentTypeId:(NSString *)contentTypeId commentId:(NSString*)commentId;

//-- call api get list comment
- (void)callApiGetDataComment:(NSString*)singerId contentId:(NSString*)contentId contentTypeId:(NSString*)contentTypeId commentId:(NSString*)commentId getCommentOfComment:(NSString*)getCommentOfComment;

//-- call api get list comment of feed
- (void)callApiGetFeedDataComment:(NSString*)singerId contentId:(NSString*)contentId contentTypeId:(NSString*)contentTypeId commentId:(NSString*)commentId getCommentOfComment:(NSString*)getCommentOfComment;

//-- Thông báo nâng cấp user
-(void) showMessageUpdateLevelOfUser;

-(void) showMessageWithType:(VMTypeMessage) typeMessage withMessage:(NSString *) messageStr withFriendName:(NSString *)friendName needDelegate:(BOOL) needDelegate withTag:(NSInteger) tag;
-(bool) simulateGenerateTelcoGlobalCodeByPhonenumber:(NSString *)phonenumber;


//*******************************************************************************************//
#pragma mark - Share and Invite Friend

//-- add view share and invite
-(void) addViewShareInviteWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)urlLink imagePath:(NSString *)imagePath contentId:(NSString*)contentId contentTypeId:(NSString*)contentTypeId;


//*******************************************************************************************//
#pragma mark - Private Download

-(BOOL) checkUserDownloadWithDateByType:(DownloadType) downloadType;


@end
