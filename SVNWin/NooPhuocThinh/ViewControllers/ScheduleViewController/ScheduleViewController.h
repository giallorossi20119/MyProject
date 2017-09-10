//
//  ScheduleViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/27/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "HMSegmentedControlOriginal.h"
#import "VMDataBase.h"
#import "TableScheduleViewController.h"
#import "CustomCellScheduleHome.h"
#import "DetailsScheduleViewController.h"


@interface ScheduleViewController : BaseViewController<TableScheduleViewControllerDelegate, UIScrollViewDelegate>
{
    IBOutlet UIScrollView               *scrollContainer;
    IBOutlet UIView                     *viewBottom;
    
    //-- init char
    NSMutableArray                      *dataSourceSchedule;
    NSInteger                           currentPageLoadMore;
    NSInteger                           currentIndex;
    NSString                            *indexMonths;
    
    //-- segment
    HMSegmentedControlOriginal         *segmentedControlSchedule;
    
    BOOL                                _isCacheSchedule;
    IBOutlet UIView                     *viewSegment;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView      *activityIndicator;
@property (nonatomic, retain) TableScheduleViewController           *tableviewSchedule;

@property (nonatomic, retain) NSMutableArray                        *segmentsArray;
@property (nonatomic, retain) NSMutableArray                        *arrSchedule;
@property (nonatomic, assign) NSInteger                             indexOfChedule;

@property (nonatomic, retain) NSString                              *nodeIdStr;


@end
