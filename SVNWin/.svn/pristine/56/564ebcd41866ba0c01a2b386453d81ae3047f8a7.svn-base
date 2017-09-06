//
//  VideoListViewController.h
//  NooPhuocThinh
//
//  Created by HuntDo on 12/12/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHKActivityIndicator.h"
#import "API.h"
#import "VideoAllModel.h"
#import "VideoForAll.h"
#import "VideoForCategory.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ODRefreshControl.h"
#import "CellCustomVideoList.h"
#import "HMSegmentedControl.h"
#import "BaseTableVideoViewController.h"
#import "CategoryBySinger.h"

@interface VideoListViewController : BaseViewController
<UIScrollViewDelegate,BaseTableVideoViewControllerDelegate>
{
    NSInteger currentPageLoadMoreVideoOffiCialAll;
    NSInteger currentPageLoadMoreVideoUnOffiCialAll;
    NSInteger currentPageLoadMoreVideo;
    
    
    //-- segment
    HMSegmentedControl      *segmentedControlVideo;
    NSInteger currentIndexVideo;
}

@property (nonatomic, strong) IBOutlet UIImageView      *imgLine;
@property (nonatomic, strong) IBOutlet UIScrollView     *scrollViewListVideos;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView      *activityIndicator;
@property (nonatomic, retain) BaseTableVideoViewController  *tableviewVideo;

//-- Data From Home Video
@property (nonatomic, retain) NSMutableArray    *segmentsArrayCategories;
@property (nonatomic, assign) NSInteger         videoTypeId;
@property (nonatomic, retain) NSMutableArray    *listCategoriesVideo;
@property (nonatomic, assign) NSInteger         indexOfCategories;


@end
