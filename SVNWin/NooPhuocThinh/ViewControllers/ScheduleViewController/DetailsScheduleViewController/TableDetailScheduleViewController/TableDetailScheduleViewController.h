//
//  TableDetailScheduleViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/30/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellDetailSchedule.h"
#import "Schedule.h"
//#import "ScheduleDetail.h"

#define COLOR_SCHEDULE_CELL_BOLD [UIColor colorWithRed:31/255.0f green:50/255.0f blue:61/255.0f alpha:0.9]
#define COLOR_SCHEDULE_CELL_REGULAR [UIColor colorWithRed:37/255.0f green:72/255.0f blue:82/255.0f alpha:0.9];

@protocol TableDetailScheduleViewControllerDelegate<NSObject>

@optional

@end

@interface TableDetailScheduleViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    id <TableDetailScheduleViewControllerDelegate> delegate;
    NSString            *stringSinger;
}


@property (nonatomic, retain) NSMutableArray            *listCellImage;
@property (nonatomic, retain) NSMutableArray            *listSchedule;
@property (nonatomic, retain) Schedule                  *schedule;
@property (nonatomic, assign) id <TableDetailScheduleViewControllerDelegate> delegate;



@end
