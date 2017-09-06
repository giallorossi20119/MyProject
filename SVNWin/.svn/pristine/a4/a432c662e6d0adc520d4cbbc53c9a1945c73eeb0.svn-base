//
//  TableFanZoneViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 3/10/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellListComments.h"
#import "UIImageView+WebCache.h"

@protocol TableFanZoneViewControllerDelegate<NSObject>

@optional

-(void) goToDetailFanZoneViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow;

@end

@interface TableFanZoneViewController : UITableViewController
{
    id<TableFanZoneViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray            *listShoutbox;
@property (nonatomic, assign) NSInteger                 indexSegment;
@property (nonatomic, assign) id <TableFanZoneViewControllerDelegate> delegate;


@end
