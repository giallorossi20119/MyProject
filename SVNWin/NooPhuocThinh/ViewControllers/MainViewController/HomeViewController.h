//
//  HomeViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 11/17/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMDataBase.h"
#import "HomeTableViewController.h"

#define CATEGORY_ID_STORE_ALL @"category_id_store_all"

@interface HomeViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,HomeTableViewControllerDelegate>
{
    NSMutableArray *listFeedData;
    NSMutableArray *listCalendarData;
    NSMutableArray *listProductionData;
    HMSegmentedControlOriginal  *_controlMenuTop;
}

@property (nonatomic, retain) HomeTableViewController           *homeTableViewController;
@property (nonatomic, strong) NSMutableArray                    *pageViews;
@property (nonatomic, retain) IBOutlet UIScrollView             *scrollPageTab;
@property (nonatomic, retain) IBOutlet UIView                   *viewtop;

@end
