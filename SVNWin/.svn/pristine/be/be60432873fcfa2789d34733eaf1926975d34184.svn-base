//
//  TableScheduleViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/29/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "ScheduleListSinger.h"

@protocol TableScheduleViewControllerDelegate<NSObject>

@optional

-(void) goToDetailScheduleViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow;

@end

@interface TableScheduleViewController : UITableViewController
{
    id<TableScheduleViewControllerDelegate> delegate;
    
    NSString            *scheduleMonth;
    NSString            *scheduleDay;
    NSString            *timeConvert;
}

@property (nonatomic, retain) NSMutableArray            *listSchedule;
@property (nonatomic, assign) id <TableScheduleViewControllerDelegate> delegate;

@end
