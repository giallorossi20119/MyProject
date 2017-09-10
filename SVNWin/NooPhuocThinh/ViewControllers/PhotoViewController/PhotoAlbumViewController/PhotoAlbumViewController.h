//
//  PhotoAlbumViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/26/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellPhotoAlbum.h"
#import "API.h"
#import "VMDataBase.h"
#import "ListPhotosInAlbum.h"
#import "ListAlbumPhoto.h"
#import "UIImageView+WebCache.h"
#import "DetailsAlbumPhotoViewController.h"

@interface PhotoAlbumViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray                      *_listPhoto;
    NSMutableArray                      *_dataSourcePhotos;
    IBOutlet UIActivityIndicatorView    *_activityIndicator;
    
    BOOL                                _isCacheDataSourceAlbum;
    NSInteger                           _currentPage;
    NSString                            *_nodeTotal;
}

@property (nonatomic, retain) NSMutableArray            *listPhoto;
@property (nonatomic, retain) NSMutableArray            *arrPhotos;
@property (nonatomic, retain) NSMutableArray            *arrTitle;
@property (nonatomic, retain) IBOutlet UITableView      *tableViewPhotoInAlbum;
@property (nonatomic, retain) ListPhotosInAlbum         *photoInAlbum;
@property (nonatomic, assign) NSInteger                 indexOfAlbum;
@property (nonatomic, retain) NSString                  *albumId;

@property (nonatomic, weak)  IBOutlet CBAutoScrollLabel *autoFullName;

@end
