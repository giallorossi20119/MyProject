//
//  TableStoreViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 3/18/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellCustomStore.h"
#import "Store.h"
#import "UIView+VMODEV.h"
#import "UIImageView+WebCache.h"

@protocol TableStoreViewControllerDelegate<NSObject>

@optional

-(void) goToDetailStoreViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow;

@end

@interface TableStoreViewController : UITableViewController
{
    id<TableStoreViewControllerDelegate> delegate;
}

@property (nonatomic, assign) NSInteger                 arrangeProduct;
@property (nonatomic, retain) NSMutableArray            *listStore;
@property (nonatomic, retain) id <TableStoreViewControllerDelegate> delegate;

@end
