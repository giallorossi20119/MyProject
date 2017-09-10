//
//  TableTopUserViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 1/5/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellTopUser.h"
#import "UIImageView+WebCache.h"
#import "TopUser.h"

@protocol TableTopUserViewControllerDelegate<NSObject>

@optional

-(void) goToDetailProfileViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow;

@end

@interface TableTopUserViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    id<TableTopUserViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray            *listTopUser;
@property (nonatomic, assign) id <TableTopUserViewControllerDelegate> delegate;

@end
