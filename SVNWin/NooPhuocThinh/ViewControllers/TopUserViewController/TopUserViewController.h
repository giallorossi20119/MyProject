//
//  TopUserViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellTopUser.h"
#import "HMSegmentedControl.h"
#import "ProfileViewController.h"
#import "TableTopUserViewController.h"
#import "TopUser.h"
#import "VMDataBase.h"
#import "API.h"
#import "CustomCellContest.h"
#import "ListWinners.h"
#import "UIImageView+WebCache.h"


#define type_all    @"all"
#define type_month  @"month"
#define type_week   @"week"
#define type_day    @"day"
#define get_all     @"1"
#define get_normal  @"0"

@interface TopUserViewController : BaseViewController<TableTopUserViewControllerDelegate, UIScrollViewDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
{
    IBOutlet UIButton                   *btnTopUser;
    IBOutlet UIButton                   *btnTrungthuong;
    BOOL                                isTopUser;
    BOOL                                isTrungthuong;
    
    //-- indicator
    IBOutlet UIActivityIndicatorView    *_activityIndicator;
    IBOutlet UIScrollView               *scrollContainer;
    IBOutlet UITextView                 *txvDanhsach;
    IBOutlet UIImageView                *imgLineBold;
    BOOL                                _isCacheTopUser;
    
    //-- view contest
    IBOutlet UIScrollView               *_scrollViewContest;
    IBOutlet UITableView                *_tableViewContest;
    IBOutlet UITextView                 *_txvSubject;
    IBOutlet UIWebView                  *_wvContest;
    NSMutableArray                      *_listData;
    NSMutableArray                      *_listWinners;
    NSString                            *_winnerId;
    NSString                            *_winnerName;
    NSString                            *_winnerLetterSubject;
    NSString                            *_winnerLetterBody;
    
    //-- segment
    HMSegmentedControl                  *_segmentedControlTopUser;
    
    //-- init char
    NSMutableArray                      *_dataSourceTopUser;
    NSInteger                           _numberViews;
    NSInteger                           _currentIndex;
    NSInteger                           _currentPageLoadMore;
    NSString                            *_typeRank;
    NSString                            *_typeTime;
    NSString                            *_typeTimeEnd;
    NSString                            *_typeGet;
    
    //--timer
    NSDateFormatter                     *dateFormat;
    NSString                            *weekStart;
    NSString                            *weekEnd;
    NSString                            *currentDay;
    NSString                            *yesterday;
    NSString                            *currentMonth;
}

@property (nonatomic, retain) IBOutlet UIImageView        *imgTop;
@property (nonatomic, retain) IBOutlet UIView             *viewTopUser;
@property (nonatomic, retain) IBOutlet UIView             *viewTrungthuong;

//-- for segment
@property (nonatomic, retain) TableTopUserViewController  *tableviewTopUser;

@property (nonatomic, retain) NSMutableArray              *segmentsArray;
@property (nonatomic, retain) NSMutableArray              *arrTopUser;
@property (nonatomic, assign) NSInteger                   indexOfTopUser;

//-- Action
- (IBAction)clickToBtnTopUser:(id)sender;
- (IBAction)clickToBtnTrungthuong:(id)sender;


@end
