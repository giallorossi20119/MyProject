//
//  StoreViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMDataBase.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ODRefreshControl.h"
#import "CellCustomStore.h"
#import "UIImageView+WebCache.h"
#import "StoreDetailViewController.h"
#import "UIView+VMODEV.h"
#import "Utility.h"
#import "UIView+VMODEV.h"
#import "HMSegmentedControlOriginal.h"
#import "NSString+HTML.h"
#import "TableStoreViewController.h"

#define CATEGORY_ID_STORE_ALL @"category_id_store_all"

@interface StoreViewController : BaseViewController <UISearchBarDelegate, UISearchDisplayDelegate, TableStoreViewControllerDelegate>
{
    NSMutableArray                          *_datasource;
    NSArray                                 *_resultDataSource; //-- for search
    NSMutableArray                          *_arrTableviews;
    IBOutlet UIScrollView                   *_scrollViewStore;
    IBOutlet UILabel                        *_lblNoData;
    
    NSMutableArray                          *_arrCategories;
    NSInteger                                _indexSegmentSelected;
    NSString                                *_currentCategoryId;
    HMSegmentedControlOriginal              *_controlMenuTop;  //-- top menu
    IBOutlet UIImageView                    *_imgViewLineSegments;
    
    IBOutlet UIActivityIndicatorView        *_activityIndicator;
    
    NSInteger                                _totalNews;
    NSInteger                                _currentPageOfLoadMore; //-- page of news
    
    BOOL                                     _allowsReadCacheDataSource;
    BOOL                                     _allowsLoadDataSource;
}

//-- for segment
@property (nonatomic, retain) TableStoreViewController           *tableviewStore;

@end
