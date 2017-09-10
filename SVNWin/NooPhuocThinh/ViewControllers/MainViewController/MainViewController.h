//
//  MainViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/3/13.
//  Copyright MAC_OSX 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AboutViewController.h"
#import "FanZoneViewController.h"
#import "MusicHomeViewController.h"
#import "NewsViewController.h"
#import "PhotoViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "StoreViewController.h"
#import "TopUserViewController.h"
#import "VideoViewController.h"
#import "CBAutoScrollLabel.h"
#import "VMDataBase.h"
#import "JPRadialProgressView.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MusicAlbumViewController.h"
#import "ScheduleViewController.h"
#import "Utility.h"
#import  "ProfileViewController.h"
#import "BasketViewController.h"
#import "TutorialViewController.h"
#import "GameViewController.h"
#import "ListFeedData.h"
#import "PhotoListFeedData.h"
#import "HomeFeedLinkCell.h"
#import "HomeCalendarCell.h"
#import "HomeProductCell.h"
#import "HomeFeedVideoCell.h"
#import "HomeFeedPageCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HomeVideoWebView.h"
#import "DNewsViewController.h"
#import "UIView+DropShadow.h"
#import "HomeFeedLinkViewController.h"
#import "HomeTableViewController.h"
#import "HomeViewController.h"
#import "KLCPopup.h"
#import "HomeCommentViewController.h"
#import "UITableView+DragLoad.h"
#import "UIScrollView+UzysAnimatedGifLoadMore.h"

@interface MainViewController : BaseViewController
<UIScrollViewDelegate,BaseViewControllerDelegate,UIGestureRecognizerDelegate,MPPlayableContentDelegate,MPPlayableContentDataSource,HomeTableViewControllerDelegate,CommentsNewsViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDragLoadDelegate>
{
    UICollectionView *_collectionView;
    //test
    float                   touchDistance;
    NSInteger               _currTempIndex;
    BOOL                    _allowsReadCacheCategory;
    BOOL                    _allowsReadCacheDataSource;
    BOOL                    _allowsLoadDataSource;
    BOOL                    _isLoadedFullNode;
    BOOL                    isCallingAPI;
    NSMutableArray          *_arrCategories;
    NSString                *_currentCategoryId;
    int                     _pageSize;
    BOOL                    _allowcreate;
    
    BOOL pageControlUsed;
    
    NSMutableArray              *_dataSourceAlbum;
    BOOL                        _isCacheDataSourceAlbum;
    NSMutableArray              *arrAlbums;
    NSInteger                   _currentPage;
    NSMutableArray              *arrImageCover;
    UIImageView                 *newPageView;
    HMSegmentedControlOriginal  *_controlMenuTop;  //-- top menu

    BOOL isSelectedFanZone;
    
    //pageView Tab
    NSMutableArray              *_arrTabCategories;
    HMSegmentedControlOriginal  *_controlMenuTab;
    NSMutableArray              *_dataSourceFeeds;
    NSMutableArray              *_arrTableviews;
    NSInteger                   _indexSegmentSelected;
    NSInteger                   _currentIndex;
    NSMutableArray              *_arrHomeFeedTableViews;
    
    //home feed,calendar,production
    NSMutableArray *listFeedData;
    NSMutableArray *listPhotoFeedData;
    NSMutableArray *listCalendarData;
    NSMutableArray *listProductionData;
    NSMutableArray *tempPhotoFeedData;
    NSInteger arrangeProduct;
    NSInteger noProduct;
    MPMoviePlayerController *player;
    BOOL direction;
    NSString *txtNoView;
    NSString *txtNoLike;
    NSString *txtNoComment;
    NSString *txtNoShare;
    NSInteger NoTouches;
    BOOL checkthoi;
    BOOL keolen;
    BOOL bigScrollAnimating;
    
    UIView *viewloader1;
    UIView *viewloader2;
    UIView *viewloader3;
    UIButton *btnLoad;
    UIImage *btnImage;
    UIAlertView *alertGetMore;
    UIView *viewNoData;
    UIPageControl           *pageControl;
    
    double                              timeEnd;
    UIActivityIndicatorView             *loadingIndicator1;
    UIActivityIndicatorView             *loadingIndicator2;
    UIScrollView                        *scrollFunction;
    float                               heightScrollSize;
    NSInteger                           *screenCodeMain;
    UIView                              *viewFunctionExpand;
@private
    float                               _rootSegmentY;
}

@property (nonatomic, retain) IBOutlet UIScrollView           *scrollTotal;
@property (nonatomic, retain) IBOutlet UIScrollView           *scrollImage;
@property (nonatomic, retain) IBOutlet UIScrollView           *scrollPageTab;
@property (nonatomic, retain) IBOutlet UIView                 *viewFunction;
@property (nonatomic, retain) IBOutlet UIView                 *viewFunctionFirst;
@property (nonatomic, retain) IBOutlet UIView                 *viewFunctionSecond;
@property (nonatomic, retain) IBOutlet UIView                 *viewTab;
@property (nonatomic, retain) IBOutlet UIPageControl          *pageCtrImage;
@property (nonatomic, retain) IBOutlet UIPageControl          *pageCtrFunction;
@property (nonatomic, retain) NSTimer                         *timerAuto;
@property (nonatomic, assign) id <TableScheduleViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray                  *listSchedule;
@property (nonatomic, retain) NSMutableArray                  *listStore;
@property (nonatomic, retain) NSMutableArray                  *listNews;
@property (nonatomic, retain) HomeTableViewController         *homeTableViewController;
@property (nonatomic, retain) NSTimer                         *timerScroll;

//--ACTION
- (IBAction)selectedNews:(id)sender;
- (IBAction)selectedMusic:(id)sender;
- (IBAction)selectedVideo:(id)sender;
- (IBAction)selectedPhoto:(id)sender;
- (IBAction)selectedMore:(id)sender;

//-- button function
@property (strong, nonatomic) IBOutlet UIButton *btnSport;
@property (strong, nonatomic) IBOutlet UIButton *btnEducation;
@property (strong, nonatomic) IBOutlet UIButton *btnAppStore;
@property (strong, nonatomic) IBOutlet UIButton *btnEarning;
@property (strong, nonatomic) IBOutlet UIButton *btnProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnFanzone;
@property (strong, nonatomic) IBOutlet UIButton *btnTopUser;
@property (strong, nonatomic) IBOutlet UIButton *btnAbout;
@property (strong, nonatomic) IBOutlet UIButton *btnEvent;
@property (strong, nonatomic) IBOutlet UIButton *btnMarket;
@property (strong, nonatomic) IBOutlet UIButton *btnGameshow;
@property (strong, nonatomic) IBOutlet UIButton *btnFunny;
@property (strong, nonatomic) IBOutlet UIButton *btnComedy;

//--change pageControl
- (IBAction)changepage:(id)sender;

-(void)showProgressHUD:(NSString*)msg;
-(void)hideProgressHUD;

@end
