//
//  MusicHomeViewController.h
//  NooPhuocThinh
//
//  Created by HuntDo on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicCustomCellHome.h"
#import "MusicAlbumViewController.h"
#import "AppDelegate.h"
#import "MusicHome.h"
#import "MusicTrackNew.h"
#import "API.h"
#import "UIImageView+WebCache.h"
#import "VMDataBase.h"
#import "CBAutoScrollLabel.h"


@interface MusicHomeViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray                      *_dataSourceAlbum;
    
    BOOL                                _isCacheDataSourceAlbum;
    
    NSInteger                           _currentPage;
    
    IBOutlet UIActivityIndicatorView  *_activityIndicator;
}

@property (nonatomic, retain) IBOutlet UITableView            *tableViewMusicHome;
@property (nonatomic, retain) MusicHome                       *musicHome;
@property (nonatomic, assign) NSInteger                       indexOfAlbums;
@property (nonatomic, retain) NSMutableArray                  *artists;


@end
