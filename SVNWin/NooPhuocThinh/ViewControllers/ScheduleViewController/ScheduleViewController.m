//
//  ScheduleViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/27/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "ScheduleViewController.h"
#import "SearchViewController.h"

@interface ScheduleViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation ScheduleViewController

@synthesize activityIndicator, indexOfChedule, segmentsArray, tableviewSchedule, nodeIdStr;
@synthesize pageViews = _pageViews;

NSInteger numberViews = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - Main

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self customNavigationBar];
    
    //-- set data
    [self setDataWhenViewDidLoad];
    
    //-- set up view
    [self setViewWhenViewDidLoad];
    
    //-- create page scrolling
    [self createPageScrollSchedule];
}


- (void)viewWillAppear:(BOOL)animated
{
    //-- show navigationbar
    self.screenName = @"Schedule Screen";
    [self setTitle:@"Lịch diễn"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-- set data
-(void) setDataWhenViewDidLoad
{
    NSArray *arrSeg = [NSArray arrayWithObjects:@"Trong tháng", @"Trong 3 tháng", @"Trong 6 tháng", nil];
    segmentsArray  = [[NSMutableArray alloc] initWithArray:arrSeg];
    
    //-- alloc array
    dataSourceSchedule = [[NSMutableArray alloc] init];
    
    _isCacheSchedule = YES;
        
    //-- init char
    currentPageLoadMore = 0;
    currentIndex = 0;
}


//-- create page scroll
-(void) createPageScrollSchedule
{
    numberViews = [segmentsArray count];
    
    scrollContainer.contentSize = CGSizeMake(scrollContainer.frame.size.width * numberViews, scrollContainer.frame.size.height);
    scrollContainer.showsHorizontalScrollIndicator = NO;
    scrollContainer.showsVerticalScrollIndicator = NO;
    scrollContainer.alwaysBounceVertical = NO;
    scrollContainer.pagingEnabled = YES;
    scrollContainer.scrollsToTop = NO;
    
    //-- left and right swipe scrollview
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [scrollContainer addGestureRecognizer:swipeGesture];
    
    //-- Set up the array to hold the views for each page
    _pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < numberViews; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    //-- Set the scroll view's content size, autoscroll to the stating tableview,
    //-- and setup the other display elements.
    [self setScrollViewContentSize];
    [self setCurrentIndex:0];
    [self scrollToIndex:0];
    
    //hiepph, to add bottom line
//    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 3)];/// change size as you need.
//    separatorLineView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f
//                                                        green:240.0f/255.0f
//                                                         blue:240.0f/255.0f
//                                                        alpha:1.0f];// you can also put image here
//    [scrollContainer addSubview:separatorLineView];
}


-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = scrollContainer.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [scrollContainer scrollRectToVisible:frame animated:NO];
}


- (void)setScrollViewContentSize
{
    NSInteger pageCount = numberViews;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(scrollContainer.frame.size.width * pageCount,
                             scrollContainer.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    
    [scrollContainer setContentSize:size];
}


- (void)setCurrentIndex:(NSInteger)newIndex
{
    currentIndex = newIndex;
    
    //-- change segmanet
    [segmentedControlSchedule setSelectedSegmentIndex:currentIndex];
    
    //-- load data
    [self loadDataAlbum:currentIndex];
    
}


-(void)loadDataAlbum:(NSInteger)index
{
    if (index < 0 || index >= numberViews) {
        return;
    }
    
    if (index == 0) {
        indexMonths = @"1";
    }else if (index == 1){
        indexMonths = @"3";
    }else if (index == 2){
        indexMonths = @"6";
    }
    
    //-- get data
    [self fetchingAllScheduleByPeriod:indexMonths withIndex:index];
}


- (void)unloadData:(NSInteger)index
{
    if (index < 0 || index >= numberViews) {
        return;
    }
    
    id currentTableView = [self.pageViews objectAtIndex:index];
    if ([currentTableView isKindOfClass:[TableScheduleViewController class]]) {
        [currentTableView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}



#pragma mark  - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
    if (page != currentIndex) {
        
        [self setCurrentIndex:page];
    }
}


//*******************************************************************************//
#pragma mark - Set up UI

-(void) customNavigationBar
{
    [self setTitle:@"Lịch diễn"];
//    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
//    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- search button
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(15, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(searchSchedule:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = barItemRight;
    
}


//-- setup view
-(void) setViewWhenViewDidLoad
{
    //-- custom add barbutton to navigationbar
    //[self addBarbutton];
//    [self customNavigationBar];
    
    //-- add segment
    [self setUpSegmentControl];
}


//-- add bar button
-(void) addBarbutton
{
    //-- back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- search button
//    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
//    btnRight.frame= CGRectMake(15, 0, 30, 30);
//    [btnRight setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
//    [btnRight addTarget:self action:@selector(searchAlbum:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
//    self.navigationItem.rightBarButtonItem=barItemRight;
}



#pragma mark - Segment

-(void) setUpSegmentControl
{
    //-- Segmented control with scrolling
    segmentedControlSchedule = [[HMSegmentedControlOriginal alloc] initWithSectionTitles:segmentsArray];
//    segmentedControlSchedule.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControlSchedule.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 10);
    segmentedControlSchedule.selectionStyle = HMSegmentedControlOriginalSelectionStyleTextWidthStripe;
    segmentedControlSchedule.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    segmentedControlSchedule.scrollEnabled = YES;
    segmentedControlSchedule.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControlSchedule setFrame:CGRectMake(0, 0, 320, 40)];
    [segmentedControlSchedule addTarget:self action:@selector(segmentedControlChangedScheduleValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControlSchedule setTextColor:[UIColor grayColor]];
    [segmentedControlSchedule setSelectedTextColor:[UIColor blackColor]];
    [segmentedControlSchedule setSelectedSegmentIndex:currentIndex];
    segmentedControlSchedule.font = [UIFont systemFontOfSize:15.0f];
    
    [segmentedControlSchedule setSelectionIndicatorColor:[UIColor colorWithRed:255.0f/255.0f
                                                                          green:102.0f/255.0f
                                                                           blue:153.0f/255.0f
                                                                          alpha:1.0f]];
    
    segmentedControlSchedule.selectionIndicatorHeight = 3;
    segmentedControlSchedule.backgroundColor = [UIColor clearColor];
    
    [viewSegment addSubview:segmentedControlSchedule];
}


- (void)segmentedControlChangedScheduleValue:(HMSegmentedControlOriginal *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex != currentIndex) {
        [self setCurrentIndex:segmentedControl.selectedSegmentIndex];
        currentIndex = segmentedControl.selectedSegmentIndex;
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
    }
}



#pragma mark - Action

//---handle swipe gesture --
-(IBAction) handleSwipeGesture:(UIGestureRecognizer *)sender
{
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft: {
            
            currentIndex --;
            
            //-- change segmanet
            [segmentedControlSchedule setSelectedSegmentIndex:currentIndex];
            
            //-- load data
            [self loadDataAlbum:currentIndex];
        }
            break;
        case UISwipeGestureRecognizerDirectionRight: {
            
            currentIndex ++;
            
            //-- change segmanet
            [segmentedControlSchedule setSelectedSegmentIndex:currentIndex];
            
            //-- load data
            [self loadDataAlbum:currentIndex];
        }
            break;
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"UISwipeGestureRecognizerDirectionDown");
            break;
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"UISwipeGestureRecognizerDirectionUp");
            break;
        default:
            break;
    }
}



//*******************************************************************************//
#pragma mark - Datasource

- (void)fetchingAllScheduleByPeriod:(NSString*)months withIndex:(NSInteger)index
{
    NSInteger countData = [self getScheduleDataFromDBByIndex:index];
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (isErrorNetWork) {
        
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
        NSInteger compeTime = currentDate - [[Setting sharedSetting] milestonesEventRefreshTimeForCategoryId:months];
       
        if (([[Setting sharedSetting] milestonesEventRefreshTimeForCategoryId:months] != 0) && (compeTime < [Setting sharedSetting].eventRefreshTime*60) && (countData>0)) {
            
            return;
        }
        else
            [[Setting sharedSetting] setMilestonesEventRefreshTime:currentDate categoryId:months];
    
        //-- call api
        [self callAPIToGetSchedule:months withIndex:index];
    }
}


-(NSInteger) getScheduleDataFromDBByIndex:(NSInteger) byIndex
{
    NSInteger countData = 0;
    
    //-- remove lable nodata
    [self removeLableNoDataFrom:scrollContainer withIndex:byIndex];
    
    //-- read in cache
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    listData = [VMDataBase getAllScheduleByCategoryid:indexMonths];
    
    if (listData.count > 0) {
        
        countData = listData.count;
        
        //-- hidden loading
        [activityIndicator stopAnimating];
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        
        if (NO == [currentTableView isKindOfClass:[TableScheduleViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = scrollContainer.bounds;
            frame.origin.x = frame.size.width * byIndex;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            tableviewSchedule = [[TableScheduleViewController alloc] init];
            tableviewSchedule.delegate = self;
            tableviewSchedule.view.backgroundColor = [UIColor clearColor];
            [tableviewSchedule.view setFrame:frame];
            [tableviewSchedule.view setTag:byIndex];
            [tableviewSchedule.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [tableviewSchedule.tableView setSeparatorColor:COLOR_SEPARATOR_CELL];
            tableviewSchedule.listSchedule  = listData;
            
            [scrollContainer addSubview:tableviewSchedule.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:tableviewSchedule];
            
        }else {
            
            tableviewSchedule.listSchedule  = listData;
            [tableviewSchedule.tableView reloadData];
        }
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [scrollContainer frame];
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        [tableviewSchedule.tableView reloadData];
        
        //-- add lable nodata
        [self addLableNoDataTo:scrollContainer withIndex:byIndex withFrame:frame];
    }
    
    return countData;
}

- (void)callAPIToGetSchedule:(NSString*)months withIndex:(NSInteger)index
{
    [activityIndicator startAnimating];
    //-- request musics async
    [API getAllMusicAndVideoOfSinglerID:SINGER_ID
                          contentTypeId:ContentTypeIDSchedule
                                  limit:@"100"
                                   page:[NSString stringWithFormat:@"%d",currentPageLoadMore]
                              isHotNode:@"0"
                                 months:months
                                  appID:PRODUCTION_ID
                             appVersion:PRODUCTION_VERSION
                              completed:^(NSDictionary *responseDictionary, NSError *error) {
                                  
                                  if (responseDictionary && !error) {
                                      [self createDataSourceAllScheduleFrom:responseDictionary byIndex:index];
                                  }
                                  
                                  [activityIndicator stopAnimating];
                              }];
}


-(void)createDataSourceAllScheduleFrom:(NSDictionary *)aDictionary byIndex:(int)index
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"singer_list"];
    
    if ([arrSinger count] > 0)
    {
        NSMutableArray *nodeList = [[arrSinger objectAtIndex:0] objectForKey:@"node_list"];
        
        if ([nodeList count] > 0) {
            
            //-- saved NSDefalut for AlbumId
            if (![[NSUserDefaults standardUserDefaults] objectForKey:indexMonths]) {
                
                [[NSUserDefaults standardUserDefaults] setValue:indexMonths forKey:indexMonths];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            //-- add objects
            [self addObjectToListAndSaveDatabaseBy:nodeList byIndex:index];
        }
    }
}


//-- add object
-(void) addObjectToListAndSaveDatabaseBy:(NSMutableArray *)nodeList byIndex:(NSInteger)index
{
    for (NSInteger i = 0; i < [nodeList count]; i++)
    {
        Schedule *schedule = [[Schedule alloc] init];
        
        schedule.categoryId = indexMonths;
        schedule.nodeId = [[nodeList objectAtIndex:i] objectForKey:@"node_id"];
        schedule.name = [[nodeList objectAtIndex:i] objectForKey:@"name"];
        schedule.imageFilePath = [[nodeList objectAtIndex:i] objectForKey:@"image_file_path"];
        schedule.videoFilePath = [[nodeList objectAtIndex:i] objectForKey:@"video_file_path"];
        schedule.startDate = [[nodeList objectAtIndex:i] objectForKey:@"start_date"];
        schedule.endDate = [[nodeList objectAtIndex:i] objectForKey:@"end_date"];
        schedule.desciption = [[nodeList objectAtIndex:i] objectForKey:@"description"];
        schedule.price = [[nodeList objectAtIndex:i] objectForKey:@"price"];
        schedule.phone = [[nodeList objectAtIndex:i] objectForKey:@"phone"];
        schedule.orderSchedule = [[nodeList objectAtIndex:i] objectForKey:@"order"];
        schedule.organizationUnitName = [[nodeList objectAtIndex:i] objectForKey:@"organization_unit_name"];
        schedule.countryId = [[nodeList objectAtIndex:i] objectForKey:@"country_id"];
        schedule.countryName= [[nodeList objectAtIndex:i] objectForKey:@"country_name"];
        schedule.cityId = [[nodeList objectAtIndex:i] objectForKey:@"city_id"];
        schedule.cityName = [[nodeList objectAtIndex:i] objectForKey:@"city_name"];
        schedule.cityLogoFilePath = [[nodeList objectAtIndex:i] objectForKey:@"city_logo_file_path"];
        schedule.cityDescription = [[nodeList objectAtIndex:i] objectForKey:@"city_description"];
        schedule.locationEventId = [[nodeList objectAtIndex:i] objectForKey:@"location_event_id"];
        schedule.locationEventName = [[nodeList objectAtIndex:i] objectForKey:@"location_event_name"];
        schedule.locationEventAddress = [[nodeList objectAtIndex:i] objectForKey:@"location_event_address"];
        schedule.locationEventPhone = [[nodeList objectAtIndex:i] objectForKey:@"location_event_phone"];
        schedule.locationEventEmail = [[nodeList objectAtIndex:i] objectForKey:@"location_event_name_email"];
        schedule.locationEventWebsite = [[nodeList objectAtIndex:i] objectForKey:@"location_event_website"];
        schedule.listSinger = [[nodeList objectAtIndex:i] objectForKey:@"list_singer"];
        schedule.snsTotalDisLike = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_dislike"];
        schedule.snsTotalShare = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_share"];
        schedule.snsTotalView = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_view"];
        
        NSString *numberComment = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"sns_total_comment"]];
        NSString *numberLike = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"sns_total_like"]];
        NSString *isLiked = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"is_liked"]];
        schedule.snsTotalComment = numberComment;
        schedule.snsTotalLike = numberLike;
        schedule.isLiked = isLiked;
        
        //-- get list singer nick_name
        NSMutableArray *listSinger = [[NSMutableArray alloc] init];
        NSMutableArray *listData = [[nodeList objectAtIndex:i] objectForKey:@"list_singer"];
        
        for (NSInteger j=0; j<[listData count]; j++) {
            NSString *nameSinger = [[listData objectAtIndex:j] objectForKey:@"nick_name"];
            
            [listSinger addObject:nameSinger];
        }
        
        NSArray *arrSinger = [listSinger mutableCopy];
        schedule.listSinger = [arrSinger componentsJoinedByString:@", "];
        
        Schedule *aSchel = [VMDataBase getAScheduleByNodeId:schedule.nodeId];
        
        if (aSchel.nodeId) {
            
            //-- neu mTrackFromDB.snsTotalComment > mTrack.snsTotalComment thi update vao Db
            if ([aSchel.snsTotalComment integerValue] > [schedule.snsTotalComment integerValue]) {
                
                schedule.snsTotalComment = aSchel.snsTotalComment;
            }
            
            //-- neu mTrackFromDB.snsTotalLike > mTrack.snsTotalLike thi update vao Db
            if ([aSchel.snsTotalLike integerValue] > [schedule.snsTotalLike integerValue]) {
                
                schedule.snsTotalLike = aSchel.snsTotalLike;
            }
            
            //-- update a Schedule
            [VMDataBase updateSchedule:schedule];
            
        }else {
            //-- insert into DB
            [VMDataBase insertSchedule:schedule];
        }
    }
    
    //-- get Schedule from DB
    [self getScheduleDataFromDBByIndex:index];
}



//*******************************************************************************//
#pragma mark - TableScheduleViewController delegate

-(void) goToDetailScheduleViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    DetailsScheduleViewController *dsVC = (DetailsScheduleViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailsScheduleViewControllerId"];
    
    NSInteger indexOfSchedule;
    NSMutableArray *urlSongArr = [[NSMutableArray alloc] init];
    
    Schedule *schedule = [listData objectAtIndex:indexRow];
    indexOfSchedule = [listData indexOfObject:schedule];
    
    if ([listData count]>0) {
        for (NSInteger i=0; i<[listData count]; i++) {
            Schedule *mTr = [listData objectAtIndex:i];
            NSString *urlStr = mTr.imageFilePath;
            
            [urlSongArr addObject:urlStr];
        }
    }
    
    dsVC.schedule = schedule;
    dsVC.dataSourceSchedule = listData;
    dsVC.indexOfSchedule = indexOfSchedule;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:dsVC animated:YES];
    else
        [self.navigationController pushViewController:dsVC animated:NO];
}



//*******************************************************************************//
#pragma mark - Action

- (void)back:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


- (void)searchSchedule:(id)sender
{
    SearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idSearchViewControllerSb"];
    searchVC.searchtype = searchScheduleType;
    
    [UIView animateWithDuration:0.55
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:searchVC animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}


@end
