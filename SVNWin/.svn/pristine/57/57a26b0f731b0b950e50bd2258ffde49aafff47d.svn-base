//
//  TableNewsViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 3/6/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsCellCustom.h"
#import "UIImageView+WebCache.h"

@protocol TableNewsViewControllerDelegate<NSObject>

@optional

-(void) goToDetailNewsViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow;

@end

@interface TableNewsViewController : UITableViewController
{
    id<TableNewsViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray            *listNews;
@property (nonatomic, assign) id <TableNewsViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isShowLableNodata;

@end
