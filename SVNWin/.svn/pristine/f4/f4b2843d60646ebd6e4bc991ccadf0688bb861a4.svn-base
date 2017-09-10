//
//  PhotoViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellAlbumPhoto.h"
#import "API.h"
#import "UIImageView+WebCache.h"
#import "ListAlbumPhoto.h"
#import "PhotoAlbumViewController.h"
#import "CustomCellAlbumPhoto.h"
#import "ODRefreshControl.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "CBAutoScrollLabel.h"

enum
{
    cellTatca = 0
};

@interface PhotoViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray                      *_dataSourceAlbum;
    NSMutableArray                      *listAlbum;
    IBOutlet UIActivityIndicatorView    *_activityIndicator;
    
    BOOL                                _isCacheDataSourceAlbum;
    BOOL                                _isLoadDataSource;
    NSInteger                           _currentPage;
    NSInteger                           _totalAlbum;
}

@property (nonatomic, retain) IBOutlet UITableView          *tableViewAlbum;
@property (strong, nonatomic) IBOutlet UIImageView          *imgCover;

@end
