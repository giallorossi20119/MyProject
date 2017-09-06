//
//  SearchViewController.h
//  NooPhuocThinh
//
//  Created by longnh on 4/14/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+SVInfiniteScrolling.h"
#import "BaseTableMusicViewController.h"
#import "BaseTableVideoViewController.h"
#import "TableNewsViewController.h"
#import "TableScheduleViewController.h"
#import "TableStoreViewController.h"
#import "TableTopUserViewController.h"

// Categorize search types
typedef enum {
    
    searchMusicType,
    searchNewsType,
    searchVideoType,
    searchScheduleType,
    searchStoreType,
    searchTopUsersType
    
} SearchTypes;


@interface SearchViewController : BaseViewController
<BaseTableMusicViewControllerDelegate, BaseTableVideoViewControllerDelegate, TableNewsViewControllerDelegate, TableScheduleViewControllerDelegate,TableStoreViewControllerDelegate, TableTopUserViewControllerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>
{
    SearchTypes searchtype;
    NSInteger currentPageLoadMore;
    
    BOOL isLoadmore;
    
    //-- Search
    BOOL isSearchOn;
    BOOL canSelectRow;
    NSMutableArray *searchResult;
}

@property (nonatomic, assign) SearchTypes searchtype;
@property (nonatomic, retain) NSMutableArray *listDataSource;

@property (nonatomic, retain) BaseTableMusicViewController  *tableviewMusic;

@property (nonatomic, retain) BaseTableVideoViewController  *tableviewVideo;
@property (nonatomic, assign) NSInteger videoTypeId;

@property (nonatomic, retain) TableNewsViewController       *tableviewNews;
@property (nonatomic, retain) TableScheduleViewController   *tableviewSchedule;
@property (nonatomic, retain) TableStoreViewController      *tableviewStore;
@property (nonatomic, retain) TableTopUserViewController    *tableviewTopUser;

//-- Search
@property (nonatomic,retain) UITapGestureRecognizer *gestureTapRecognizer;
@property (nonatomic,retain) IBOutlet UIView *viewSearchBar;
@property (nonatomic,retain) IBOutlet UISearchBar *searchBar;

- (void) doneSearchingByisRefresh:(BOOL) isRefresh;


@end
