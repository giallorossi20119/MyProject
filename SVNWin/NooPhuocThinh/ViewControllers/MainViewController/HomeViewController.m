//
//  HomeViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 11/17/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize scrollPageTab,viewtop;
@synthesize pageViews = _pageViews;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchingDataTab];
}

-(void)fetchingDataTab
{
    //data feeds
    listFeedData = [[NSMutableArray alloc] init];
    listFeedData = [VMDataBase getAllFeeds:@"94"];
    
    //data calendar
    listCalendarData = [[NSMutableArray alloc] init];
    listCalendarData = [VMDataBase getAllScheduleByCategoryid:@"1"];
    
    //data production
    listProductionData = [[NSMutableArray alloc] init];
    listProductionData = [VMDataBase getAllStoreWithCategoryID:CATEGORY_ID_STORE_ALL];
    
    [self createHomeTabPageScrollNews:3];
    
    [self setTopMenuWithTitles];
}

-(void) setTopMenuWithTitles
{
    NSLog(@"%s", __func__);
    NSMutableArray *listNameCategories = [NSMutableArray arrayWithObjects:@"Feed",@"Event",@"Market", nil];
    
    //-- Segmented control with scrolling
    _controlMenuTop = [[HMSegmentedControlOriginal alloc] initWithSectionTitles:listNameCategories];
    _controlMenuTop.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _controlMenuTop.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _controlMenuTop.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _controlMenuTop.scrollEnabled = YES;
    _controlMenuTop.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [_controlMenuTop setFrame:CGRectMake(0, 0 , 320, 45)];
    [_controlMenuTop addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [_controlMenuTop setFont:[UIFont systemFontOfSize:16]];
    _controlMenuTop.backgroundColor = COLOR_BG_MENU;
    _controlMenuTop.textColor = [UIColor grayColor];
    _controlMenuTop.selectedTextColor = [UIColor whiteColor];
    _controlMenuTop.selectionIndicatorHeight = 5;
    
    [scrollPageTab addSubview:_controlMenuTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createHomeTabPageScrollNews:(NSInteger)numberViews
{
    //create pagetab content size
    [scrollPageTab setFrame:CGRectMake(0, scrollPageTab.frame.origin.y, scrollPageTab.frame.size.width, scrollPageTab.frame.size.height)];
    scrollPageTab.contentSize = CGSizeMake(scrollPageTab.frame.size.width * numberViews, scrollPageTab.frame.size.height);
    scrollPageTab.showsHorizontalScrollIndicator = NO;
    scrollPageTab.showsVerticalScrollIndicator = NO;
    scrollPageTab.alwaysBounceVertical = NO;
    scrollPageTab.pagingEnabled = YES;
    scrollPageTab.scrollsToTop = NO;
    
    //-- Set up the array to hold the views for each page
    _pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < numberViews; ++i) {
        
        [self.pageViews addObject:[NSNull null]];
    }
    
    //-- Set the scroll view's content size, autoscroll to the stating tableview
    [self setHomeScrollViewContentSize:numberViews];
    
    [self getHomeNewsDataFromDataBaseByIndex:0];
}

-(NSInteger)getHomeNewsDataFromDataBaseByIndex:(int)byIndex
{
    NSLog(@"%s", __func__);

    NSInteger countData = 0;
    
    //-- read in cache
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    listData = listFeedData;
    [self.view setFrame:CGRectMake(0, 1800, 320, 1800)];
    [self.tableView setContentSize:CGSizeMake(320, 1800)];
    [scrollPageTab setContentSize:CGSizeMake(960, 1800)];
    if (listData.count > 0)
    {
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        
        if (NO == [currentTableView isKindOfClass:[HomeTableViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = scrollPageTab.bounds;
            frame.origin.x = frame.size.width * byIndex;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            self.homeTableViewController = [[HomeTableViewController alloc] init];
            self.homeTableViewController.delegate = self;
            self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
            [self.homeTableViewController.view setFrame:frame];
            [self.homeTableViewController.view setTag:byIndex];
            self.homeTableViewController.listNews  = listData;
            
            [scrollPageTab addSubview:self.homeTableViewController.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:self.homeTableViewController];
        }
        else
        {
            self.homeTableViewController = (HomeTableViewController *) currentTableView;
            self.homeTableViewController.listNews = listData;
            [self.homeTableViewController.tableView reloadData];
        }
    }
    else {
        //-- Load the photo view.
        CGRect frame = [scrollPageTab frame];
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
    }
    return countData;
}

- (void)setHomeScrollViewContentSize:(NSInteger)numberViews
{
    NSInteger pageCount = numberViews;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(scrollPageTab.frame.size.width * pageCount,
                             scrollPageTab.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [scrollPageTab setContentSize:size];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItemId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    return cell;
}

@end
