//
//  NewsViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsCellCustom.h"
#import "UIImageView+WebCache.h"
//#import "DetailNewsViewController.h"
#import "BaseViewController.h"
#import "ODRefreshControl.h"
#import "SHKActivityIndicator.h"
#import "API.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "Utility.h"
#import "HMSegmentedControl.h"
#import "VMDataBase.h"
#import "UIView+VMODEV.h"
#import "HMSegmentedControlOriginal.h"
#import "TableNewsViewController.h"

#define NODE_IN_PAGE_ONLINE_LIMIT 300 //longnh
#define NODE_IN_PAGE_OFFLINE_LIMIT 50 //longnh

typedef enum {
    
    NewsTypeTotal = 0,
    NewsTypeSinger = 1 // for singer
    
} NewsType;


@interface NewsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIScrollViewDelegate, TableNewsViewControllerDelegate>
{
    @private
    NSMutableArray                                  *_arrCategories;
    NSMutableArray                                  *_dataSource;
    NSMutableArray                                  *_dataComment;
    NSArray                                         *_resultDataSource;
    
    NSInteger                                       _currentPage; //-- page of news
    NSInteger                                       _currentIndex;
    NSInteger                                       _totalNews;
  
    BOOL                                            _isSearching;
    IBOutlet UIView                                 *_viewSearch;
    
    //-- top menu
    HMSegmentedControlOriginal                      *_controlMenuTop;
    NSInteger                                       _indexSegmentSelected;
    NSString                                        *_currentCategoryId;
    IBOutlet UIImageView                            *_imgViewLineSegments;
    
    BOOL                                            _allowsReadCacheCategory;
    BOOL                                            _allowsReadCacheDataSource;
    BOOL                                            _allowsLoadDataSource;
    BOOL                                            _isLoadedFullNode;//longnh

    IBOutlet UIScrollView                           *_scrollViewNews;
    NSMutableArray                                  *_arrTableviews;
    //thay doi size cua page
    int                                             _pageSize;
    BOOL                                            isCallingAPI;
   
}

//-- for segment
@property (nonatomic, retain) TableNewsViewController           *tableviewNews;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *_activityIndicator;
//Add by TuanNM@20140901
- (bool) isCacheForCategoryPerPageTimeout: (NSString *)categoryId pageIndex:(NSString *)pageIndex updateCacheNow:(BOOL)updateCacheNow;
//End add
@end
