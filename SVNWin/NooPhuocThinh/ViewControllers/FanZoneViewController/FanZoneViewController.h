//
//  FanZoneViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellListComments.h"
#import "DetailsCommentViewController.h"
#import "BaseViewController.h"
#import "FacebookUtils.h"
#import "API.h"
#import "Comment.h"
#import "Utility.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIImageView+WebCache.h"
#import "ODRefreshControl.h"
#import "VMDataBase.h"
#import "CustomCellListComments.h"
#import "TableFanZoneViewController.h"
#import "HMSegmentedControl.h"

@class TableFanZoneViewController;

@interface FanZoneViewController : BaseViewController
<BaseViewControllerDelegate, TableFanZoneViewControllerDelegate>
{
    IBOutlet UITableView                    *_tableViewHomeFanZone;
    IBOutlet UIScrollView                   *_scrollViewHomeFanZone;
    IBOutlet UIScrollView                   *_scrollViewContainer;
    
    NSTimer                                 *_timer;
    NSInteger                               _lastIndexMessage;
    NSInteger                               _countMessageLocal;
    BOOL                                    _isReadCacheMessage; //-- allows read from cache
    BOOL                                    _isAutoScroll;
    BOOL                                    _isCallApi;
    BOOL                                    _isClickComment;
    
    NSMutableArray                          *_dataMessagesHistory; // for tabs != home
    NSMutableArray                          *_arrTableviews;
    NSMutableArray                          *_arrCategories;
    NSInteger                                _indexSegmentSelected;
    HMSegmentedControlOriginal              *_controlMenuTop;  //-- top menu
    IBOutlet UIImageView                    *_imgViewLineSegments;
    IBOutlet UIActivityIndicatorView        *_activityIndicator;
    
    NSInteger                               _currentIndex;
    
@public
    MulticastDelegate<FanZoneViewControllerDelegate> *delegates;
}

@property (nonatomic, assign) NSInteger _currentIndex;

//-- for segment
@property (nonatomic, retain) TableFanZoneViewController           *tableviewFanzone;

@property (nonatomic, retain) NSMutableArray                        *shoutboxDataArray; //-- for home tab
@property (nonatomic, assign) id<FanZoneViewControllerDelegate>     delegateFanZone;

@end
