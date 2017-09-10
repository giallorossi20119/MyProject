//
//  VideoViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/12/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "VideoListViewController.h"
#import "BaseViewController.h"
#import "Utility.h"
#import "VideosCustomCell.h"
#import  "VideoListViewController.h"
#import  "VMDataBase.h"
#import "ContentTypeList.h"

typedef enum {
    VideoHomeCellALl = 0,
    VideoHomeCellFormal = 1,
    VideoHomeCellInformal = 2,
    VideoHomeCellBehindScene = 3,
    VideoHomeCellFanCam = 4,
    VideoHomeCellTV = 5
}VideoHomeCell;

@interface VideoViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataSourceVideo;
    NSMutableArray *listSectionCategories;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableViewVideos;
@property (nonatomic, retain) NSMutableArray *dataSourceVideo;
@property (nonatomic, retain) NSMutableArray *listSectionCategories;

@end
