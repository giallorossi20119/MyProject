//
//  VideoListViewController.m
//  NooPhuocThinh
//
//  Created by HuntDo on 12/12/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoDetailViewController.h"
#import "SearchViewController.h"

@interface VideoListViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation VideoListViewController

@synthesize scrollViewListVideos;
@synthesize activityIndicator;
@synthesize tableviewVideo;
@synthesize imgLine;

@synthesize segmentsArrayCategories, indexOfCategories;
@synthesize videoTypeId,listCategoriesVideo;
@synthesize pageViews = _pageViews;

NSInteger numberOfViewsVideo = 0;

//****************************************************************************//
#pragma mark - Main

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //-- setup view
    [self setViewVideoWhenViewDidLoad];
    
    //-- load data
    [self setDataVideoWhenViewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Video Album Screen";
    
    //-- show navigationbar
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    [tableviewVideo.tableView reloadData];
}

//-- set View
-(void) setViewVideoWhenViewDidLoad {
    
    //-- Add BarButton to navigationBar
    [self customNavigationBarVideo];
}

//-- add BarButton to navigationBar
-(void) customNavigationBarVideo
{
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
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
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(searchVideoAlbum:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barItemRight;
}


//-- get Data
-(void) setDataVideoWhenViewDidLoad {
    NSLog(@"%s", __func__);
    
    //-- init char
    currentPageLoadMoreVideoOffiCialAll = 0;
    currentPageLoadMoreVideoUnOffiCialAll = 0;
    currentPageLoadMoreVideo = 0;
    
    
    currentIndexVideo = indexOfCategories;
    
    //-- create page scrolling
    [self createPageScrollAlbumVideo];
}


//-- create page scroll
-(void) createPageScrollAlbumVideo {
    NSLog(@"%s", __func__);
    numberOfViewsVideo = [segmentsArrayCategories count];
    scrollViewListVideos.contentSize = CGSizeMake(scrollViewListVideos.frame.size.width * numberOfViewsVideo, scrollViewListVideos.frame.size.height);
    scrollViewListVideos.showsHorizontalScrollIndicator = NO;
    scrollViewListVideos.showsVerticalScrollIndicator = NO;
    scrollViewListVideos.alwaysBounceVertical = NO;
    scrollViewListVideos.pagingEnabled = YES;
    scrollViewListVideos.scrollsToTop = NO;
    
    if ([segmentsArrayCategories count] > 0) {
        
        //-- show image line
        imgLine.hidden = NO;
        
        //-- Load Segment
        [self setUpSegmentControl];
    }else {
        
        //-- show image line
        imgLine.hidden = YES;
        
        numberOfViewsVideo = 1;
        
        CGRect frameScroll = [scrollViewListVideos frame];
        frameScroll.origin.y = 0;
        frameScroll.size.height += 35;
        
        [scrollViewListVideos setFrame:frameScroll];
    }
    
    
    //-- Set up the array to hold the views for each page
    _pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < numberOfViewsVideo; ++i) {
        
        [self.pageViews addObject:[NSNull null]];
    }
    
    
    //-- Set the scroll view's content size, autoscroll to the stating tableview,
    //-- and setup the other display elements.
    [self setScrollViewContentSize];
    [self setCurrentIndex:indexOfCategories];
    [self scrollToIndex:indexOfCategories];
}

-(void)scrollToIndex:(NSInteger)index
{
    NSLog(@"%s", __func__);
    CGRect frame = scrollViewListVideos.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [scrollViewListVideos scrollRectToVisible:frame animated:NO];
}

- (void)setScrollViewContentSize
{
    NSInteger pageCount = numberOfViewsVideo;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(scrollViewListVideos.frame.size.width * pageCount,
                             scrollViewListVideos.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [scrollViewListVideos setContentSize:size];
}

- (void)setCurrentIndex:(NSInteger)newIndex
{
    currentIndexVideo = newIndex;
    NSLog(@"%s", __func__);
    
    //-- change segmanet
    [segmentedControlVideo setSelectedSegmentIndex:currentIndexVideo];
    
    //-- load data
    [self loadDataVideo:currentIndexVideo];
    
}

-(void)loadDataVideo:(NSInteger)index
{
    NSLog(@"%s", __func__);
    if (index < 0 || index >= numberOfViewsVideo) {
        return;
    }
    
    id currentTableView = [self.pageViews objectAtIndex:index];
    
    if (NO == [currentTableView isKindOfClass:[BaseTableVideoViewController class]]) {
        
        //-- show loading
        if (![activityIndicator isAnimating]) {
            
            [activityIndicator setHidden:NO];
            [activityIndicator startAnimating];
        }
        
        if (index == 0) {
            
            //-- get all video
            [self fetchingVideoAllWithContentType:videoTypeId WithIndex:index];
            
        }else {
            
            CategoryBySinger *videoCategory = [listCategoriesVideo objectAtIndex:index];
            
            //-- get album video
            [self fetchingVideoWithCategory:videoCategory.categoryId WithIndex:index];
        }
    }else {
        
        [activityIndicator stopAnimating];
    }
}

- (void)unloadData:(NSInteger)index
{
    NSLog(@"%s", __func__);
    if (index < 0 || index >= numberOfViewsVideo) {
        return;
    }
    
    id currentTableView = [self.pageViews objectAtIndex:index];
    if ([currentTableView isKindOfClass:[BaseTableVideoViewController class]]) {
        [currentTableView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}


//****************************************************************************//
#pragma mark  UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
    if (page != currentIndexVideo) {
        [self setCurrentIndex:page];
    }
}


//****************************************************************************//
#pragma mark -- Segment

-(void) setUpSegmentControl
{
    //-- Segmented control with scrolling
    segmentedControlVideo = [[HMSegmentedControl alloc] initWithSectionTitles:segmentsArrayCategories];
    segmentedControlVideo.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 10);
    segmentedControlVideo.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControlVideo.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControlVideo.scrollEnabled = YES;
    segmentedControlVideo.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControlVideo setFrame:CGRectMake(0, 0, 320, 45)];
    [segmentedControlVideo addTarget:self action:@selector(segmentedControlChangedAlbumValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControlVideo setTextColor:[UIColor grayColor]];
    segmentedControlVideo.backgroundColor = COLOR_BG_MENU;
    [segmentedControlVideo setSelectedTextColor:[UIColor whiteColor]];
    [segmentedControlVideo setSelectedSegmentIndex:currentIndexVideo];
    segmentedControlVideo.font = [UIFont systemFontOfSize:16.0f];
    
    [self.view addSubview:segmentedControlVideo];
}

- (void)segmentedControlChangedAlbumValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"%s", __func__);
    
    if (segmentedControl.selectedSegmentIndex != currentIndexVideo) {
        [self setCurrentIndex:segmentedControl.selectedSegmentIndex];
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
    }
}


//****************************************************************************//
#pragma mark - Load Data API

//-- call api get all videos
-(void) fetchingVideoAllWithContentType:(ContentTypeID)contentType WithIndex:(int) byIndex
{
    //-- saved NSDefalut for AlbumId
    NSLog(@"%s", __func__);
    NSString *contentTypeStr = [NSString stringWithFormat:@"%d",videoTypeId];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:contentTypeStr]) {
        
        //-- request API get all videos
        [self callAPIGetAllVideosWithContentType:contentType WithIndex:byIndex];
        
    }else {
        
        //-- get videos from DB
        NSInteger countData = [self getVideoAllFromDBWithContentType:contentType WithIndex:byIndex];
        
        //-- check Network
        BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
        if (isErrorNetWork) {
            
            //-- check time
            NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
            NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesVideoRefreshTime;
            
            if (([Setting sharedSetting].milestonesVideoRefreshTime != 0) && (compeTime < [Setting sharedSetting].videoRefreshTime*60) && countData > 0) {
                
                return;
            }
            else
                [Setting sharedSetting].milestonesVideoRefreshTime = currentDate;
            
            //-- request API get all videos
            [self callAPIGetAllVideosWithContentType:contentType WithIndex:byIndex];
        }
    }
}

//-- get data from DB
-(NSInteger) getVideoAllFromDBWithContentType:(ContentTypeID)contentType WithIndex:(int) byIndex {
    NSLog(@"%s", __func__);
    
    NSInteger countData = 0;
    
    //-- remove lable nodata
    [self removeLableNoDataFrom:scrollViewListVideos withIndex:byIndex];
    
    //-- hidden loading
    [activityIndicator stopAnimating];
    
    //-- read in cache
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    NSString *contentTypeStr = [NSString stringWithFormat:@"%d",contentType];
    
    NSString *categoryId = @"-1";
    if (byIndex>0)
        categoryId = [listCategoriesVideo[byIndex] categoryId];
    if (contentType == ContentTypeIDAllVideo)
        listData = [VMDataBase getAllVideos];
    else if (contentType == ContentTypeIDVideo)
        listData = [VMDataBase getAllVideosOffiCialByCategoryId:categoryId];
    else
        listData = [VMDataBase getAllVideosUnOffiCialByCategoryId:categoryId];
    
    if (listData.count > 0) {
        
        countData = listData.count;
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        
        if (NO == [currentTableView isKindOfClass:[BaseTableVideoViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = scrollViewListVideos.bounds;
            frame.origin.x = frame.size.width * byIndex;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            tableviewVideo = [[BaseTableVideoViewController alloc] init];
            tableviewVideo.delegateVideo = self;
            tableviewVideo.videoTypeId = videoTypeId;
            
            tableviewVideo.view.backgroundColor = [UIColor clearColor];
            [tableviewVideo.view setFrame:frame];
            [tableviewVideo.view setTag:byIndex];
            
            //-- load data
            tableviewVideo.listData  = listData;
            
            [scrollViewListVideos addSubview:tableviewVideo.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:tableviewVideo];
            
        }else {
            
            tableviewVideo.listData  = listData;
            [tableviewVideo.tableView reloadData];
        }
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [scrollViewListVideos frame];
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable nodata
        [self addLableNoDataTo:scrollViewListVideos withIndex:byIndex withFrame:frame];
    }
    
    return countData;
}

//-- request API get all videos
-(void) callAPIGetAllVideosWithContentType:(ContentTypeID)contentType WithIndex:(int) byIndex {
    NSLog(@"%s", __func__);
    
    NSString *pageLoad = @"0";
    if (videoTypeId == ContentTypeIDVideo || videoTypeId == ContentTypeIDAllVideo)
        pageLoad = [NSString stringWithFormat:@"%d",currentPageLoadMoreVideoOffiCialAll];
    else
        pageLoad = [NSString stringWithFormat:@"%d",currentPageLoadMoreVideoUnOffiCialAll];
    
    //-- request news async
    [API getNodeForSingerID:SINGER_ID
              contentTypeId:contentType
                      limit:@"100"
                       page:pageLoad
                     period:@""
                  isHotNode:@"0"
                      start:@""
                      appID:PRODUCTION_ID
                 appVersion:PRODUCTION_VERSION
                  completed:^(NSDictionary *responseDictionary, NSError *error) {
                      
                      //-- fetching
                      if (videoTypeId == ContentTypeIDVideo || videoTypeId == ContentTypeIDAllVideo) {
                          
                          //-- fetching video OffiCial
                          [self createDataSourceVideoOffiCialAllFrom:responseDictionary WithIndex:byIndex];
                      }else {
                          
                          //-- fetching video UnOffiCial
                          [self createDataSourceVideoUnOffiCialAllFrom:responseDictionary WithIndex:byIndex];
                      }
                      
                      //-- hidden loading
                      [activityIndicator stopAnimating];
                  }];
}

//-- call api get all Behind the Scene videos, Fan Cam videos, TV videos
-(void) fetchingVideoWithCategory:(NSString *) categoryID WithIndex:(int) byIndex
{
    NSLog(@"%s", __func__);
    //-- saved NSDefalut for AlbumId
    if (![[NSUserDefaults standardUserDefaults] objectForKey:categoryID]) {
        
        //-- request API get videos by categoryID
        [self callAPIGetVideosByCategory:categoryID WithIndex:byIndex];
        
    }else {
        
        //-- get video from DB
       NSInteger countData = [self getAllVideoFromDBWithCategory:categoryID WithIndex:byIndex];
        
        //-- check Network
        BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
        
        if (isErrorNetWork) {
            
            NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
            NSInteger compeTime = currentDate - [[Setting sharedSetting] milestonesVideoRefreshTimeForAlbumId:categoryID];
            
            if (([[Setting sharedSetting] milestonesVideoRefreshTimeForAlbumId:categoryID] != 0) && (compeTime < [Setting sharedSetting].videoRefreshTime*60) && countData > 0) {
                return;
            }
            else
                [[Setting sharedSetting] setMilestonesVideoRefreshTime:currentDate albumId:categoryID];
            
            //-- request API get videos by categoryID
            [self callAPIGetVideosByCategory:categoryID WithIndex:byIndex];
        }
    }
}

//-- get video from DB
-(NSInteger) getAllVideoFromDBWithCategory:(NSString *) categoryID WithIndex:(int) byIndex {
    NSInteger countData = 0;
    NSLog(@"%s", __func__);
    
    //-- remove lable nodata
    [self removeLableNoDataFrom:scrollViewListVideos withIndex:byIndex];
    
    //-- read in cache
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    if (videoTypeId == ContentTypeIDVideo || videoTypeId == ContentTypeIDAllVideo)
        listData = [VMDataBase getAllVideosOffiCialByCategoryId:categoryID];
    else
        listData = [VMDataBase getAllVideosUnOffiCialByCategoryId:categoryID];
    
    if (listData.count > 0) {
        
        countData = listData.count;
        
        //-- hidden loading
        [activityIndicator stopAnimating];
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        
        if (NO == [currentTableView isKindOfClass:[BaseTableVideoViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = scrollViewListVideos.bounds;
            frame.origin.x = frame.size.width * byIndex;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            tableviewVideo = [[BaseTableVideoViewController alloc] init];
            tableviewVideo.delegateVideo = self;
            tableviewVideo.videoTypeId = videoTypeId;
            
            tableviewVideo.view.backgroundColor = [UIColor clearColor];
            [tableviewVideo.view setFrame:frame];
            [tableviewVideo.view setTag:byIndex];
            
            //-- load data
            tableviewVideo.listData  = listData;
            
            [scrollViewListVideos addSubview:tableviewVideo.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:tableviewVideo];
            
        }else {
            
            tableviewVideo.listData  = listData;
            [tableviewVideo.tableView reloadData];
        }
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [scrollViewListVideos frame];
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable nodata
        [self addLableNoDataTo:scrollViewListVideos withIndex:byIndex withFrame:frame];
    }
    
    return countData;
}

//-- request API get videos by categoryID
-(void) callAPIGetVideosByCategory:(NSString *) categoryID WithIndex:(int) byIndex {
    NSLog(@"%s", __func__);
    
    //-- request video async
    [API getNodeByCategoryForSingerWithContentTypeId:videoTypeId
                                               limit:@"100"
                                                page:[NSString stringWithFormat:@"%d",currentPageLoadMoreVideo]
                                           isHotNode:@"0"
                                       isGetNodeBody:@"1"
                                          categoryId:categoryID
                                              period:@""
                                               start:@""
                                               appID:PRODUCTION_ID
                                          appVersion:PRODUCTION_VERSION
                                              months:@""
                                           completed:^(NSDictionary *responseDictionary, NSError *error){
                                               
                                               //-- fetching
                                               if (videoTypeId == ContentTypeIDVideo || videoTypeId == ContentTypeIDAllVideo) {
                                                   
                                                   [self createDataSourceVideoWithCategoryID:categoryID from:responseDictionary WithIndex:byIndex];
                                               }else {
                                                   
                                                   [self createDataSourceVideoUnOffiCialWithCategoryID:categoryID from:responseDictionary WithIndex:byIndex];
                                               }
                                               
                                               //-- hidden loading
                                               [activityIndicator stopAnimating];
                                           }];
}

//****************************************************************************//
#pragma mark - Handler JSON Add Objects

-(void) createDataSourceVideoOffiCialAllFrom:(NSDictionary *)aDictionary WithIndex:(int) byIndex
{
    NSLog(@"%s", __func__);
   if (aDictionary)
    {
        NSDictionary *dictData = [aDictionary objectForKey:@"data"];
        NSMutableArray *arrCategory = [dictData objectForKey:@"singer_list"];
        if ([arrCategory count] > 0)
        {
            NSDictionary *dictSinger = [arrCategory objectAtIndex:0];
            NSString *categoryidStr = [NSString stringWithFormat:@"%d",videoTypeId];
            NSMutableArray *arrVideos = [dictSinger objectForKey:@"node_list"];
            
            //-- remove lable nodata
            [self removeLableNoDataFrom:scrollViewListVideos withIndex:byIndex];
            if ([arrVideos count] > 0)
            {
                //-- saved NSDefalut for video AlbumId
                if (![[NSUserDefaults standardUserDefaults] objectForKey:categoryidStr]) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:categoryidStr forKey:categoryidStr];
                }
                
                //-- check and add tableview music
                id currentTableView = [self.pageViews objectAtIndex:byIndex];
                
                if (NO == [currentTableView isKindOfClass:[BaseTableVideoViewController class]]) {
                    
                    //-- Load the photo view.
                    CGRect frame = scrollViewListVideos.bounds;
                    frame.origin.x = frame.size.width * byIndex;
                    frame.origin.y = 0.0f;
                    frame = CGRectInset(frame, 0.0f, 0.0f);
                    
                    tableviewVideo = [[BaseTableVideoViewController alloc] init];
                    tableviewVideo.delegateVideo = self;
                    tableviewVideo.videoTypeId = videoTypeId;
                    
                    tableviewVideo.view.backgroundColor = [UIColor clearColor];
                    [tableviewVideo.view setFrame:frame];
                    [tableviewVideo.view setTag:byIndex];
                    
                    //-- load data
                    tableviewVideo.listData  = [self addObjectToModelVideoOffiCialWithListData:arrVideos withCategoryId:@"-1"];
                    
                    //-- add Refresh to tableview
                    [self addRefreshAndLoadMoreForTableView:tableviewVideo.tableView WithIndex:byIndex];
                    
                    [scrollViewListVideos addSubview:tableviewVideo.view];
                    [self.pageViews replaceObjectAtIndex:byIndex withObject:tableviewVideo];
                    
                }else {
                    
                    tableviewVideo.listData = [self addObjectToModelVideoOffiCialWithListData:arrVideos withCategoryId:@"-1"];
                    
                    //-- reload data
                    [tableviewVideo.tableView reloadData];
                }
                
            }else {
                
                if (currentPageLoadMoreVideoOffiCialAll == 0) {
                    
                    //-- Load the photo view.
                    CGRect frame = [scrollViewListVideos frame];
                    frame.origin.x = frame.size.width * byIndex;
                    frame.origin.y = 0.0f;
                    frame = CGRectInset(frame, 0.0f, 0.0f);
                    
                    //-- add lable nodata
                    [self addLableNoDataTo:scrollViewListVideos withIndex:byIndex withFrame:frame];
                }
            }
        }
        
        //-- hidden loading
        [tableviewVideo.tableView.infiniteScrollingView stopAnimating];
    }
}

-(void) createDataSourceVideoUnOffiCialAllFrom:(NSDictionary *)aDictionary WithIndex:(int) byIndex
{
    NSLog(@"%s", __func__);
    if (aDictionary)
    {
        NSDictionary *dictData = [aDictionary objectForKey:@"data"];
        NSMutableArray *arrCategory = [dictData objectForKey:@"singer_list"];
        if ([arrCategory count] > 0)
        {
            NSDictionary *dictSinger = [arrCategory objectAtIndex:0];
            NSString *categoryidStr = [NSString stringWithFormat:@"%d",videoTypeId];
            NSMutableArray *arrVideos = [dictSinger objectForKey:@"node_list"];
            
            //-- remove lable nodata
            [self removeLableNoDataFrom:scrollViewListVideos withIndex:byIndex];
            
            if ([arrVideos count] > 0)
            {
                //-- saved NSDefalut for video AlbumId
                if (![[NSUserDefaults standardUserDefaults] objectForKey:categoryidStr]) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:categoryidStr forKey:categoryidStr];
                }
                
                //-- check and add tableview music
                id currentTableView = [self.pageViews objectAtIndex:byIndex];
                
                if (NO == [currentTableView isKindOfClass:[BaseTableVideoViewController class]]) {
                    
                    //-- Load the photo view.
                    CGRect frame = scrollViewListVideos.bounds;
                    frame.origin.x = frame.size.width * byIndex;
                    frame.origin.y = 0.0f;
                    frame = CGRectInset(frame, 0.0f, 0.0f);
                    
                    tableviewVideo = [[BaseTableVideoViewController alloc] init];
                    tableviewVideo.delegateVideo = self;
                    tableviewVideo.videoTypeId = ContentTypeIDUnofficialVideo;
                    
                    tableviewVideo.view.backgroundColor = [UIColor clearColor];
                    [tableviewVideo.view setFrame:frame];
                    [tableviewVideo.view setTag:byIndex];
                    
                    //-- load data
                    tableviewVideo.listData  = [self addObjectToModelVideoUnOffiCialWithListData:arrVideos withCategoryId:@"-1"];
                    
                    //-- add Refresh to tableview
                    [self addRefreshAndLoadMoreForTableView:tableviewVideo.tableView WithIndex:byIndex];
                    
                    [scrollViewListVideos addSubview:tableviewVideo.view];
                    [self.pageViews replaceObjectAtIndex:byIndex withObject:tableviewVideo];
                }else {
                    
                    tableviewVideo.listData = [self addObjectToModelVideoUnOffiCialWithListData:arrVideos withCategoryId:@"-1"];
                    
                    //-- reload data
                    [tableviewVideo.tableView reloadData];
                }
                
            }else {
                
                if (currentPageLoadMoreVideoUnOffiCialAll == 0) {
                    
                    //-- Load the photo view.
                    CGRect frame = [scrollViewListVideos frame];
                    frame.origin.x = frame.size.width * byIndex;
                    frame.origin.y = 0.0f;
                    frame = CGRectInset(frame, 0.0f, 0.0f);
                    
                    //-- add lable nodata
                    [self addLableNoDataTo:scrollViewListVideos withIndex:byIndex withFrame:frame];
                }
            }
        }
        
        //-- get tableview All Video in scrollview
        if (scrollViewListVideos.subviews.count > 0) {
            
            for (UITableView *viewTB in scrollViewListVideos.subviews) {
                
                if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                    
                    //-- hidden loading
                    [viewTB.infiniteScrollingView stopAnimating];
                    
                    break;
                }
            }
        }
    }
}

- (void) addRefreshAndLoadMoreForTableView:(UITableView *)aTableview WithIndex:(int) byIndex
{
    NSLog(@"%s", __func__);
    //-- refresh data
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:aTableview];
    [refreshControl addTarget:self action:@selector(refreshDataVideo:) forControlEvents:UIControlEventValueChanged];
    
    //-- load more from bottom
    __weak VideoListViewController *myself = self;
    
    //  -- setup infinite scrolling
    [aTableview addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreVideoWithIndex:byIndex];
    }];
}

//-- refresh tableview
-(void) refreshDataVideo:(ODRefreshControl *) refresh
{
    [refresh beginRefreshing];
    
    if (scrollViewListVideos.subviews.count > 0) {
        
        UITableView *viewTableviewVideo = [scrollViewListVideos.subviews objectAtIndex:currentIndexVideo];
        
        [viewTableviewVideo reloadData];
    }
    
    [refresh endRefreshing];
}

//-- load more video
-(void)loadMoreVideoWithIndex:(int) byIndex
{
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesVideoRefreshTime;
    NSLog(@"%s", __func__);
    
    if (([Setting sharedSetting].milestonesVideoRefreshTime != 0) && (compeTime < [Setting sharedSetting].videoRefreshTime*60)) {
        
        //-- hidden loading
        [activityIndicator stopAnimating];
        
        for (UITableView *viewTB in scrollViewListVideos.subviews) {
            
            if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                
                //-- hidden loading
                [viewTB.infiniteScrollingView stopAnimating];
                
                break;
            }
        }
        return;
    }
    else
        [Setting sharedSetting].milestonesVideoRefreshTime = currentDate;
    
    if (scrollViewListVideos.subviews.count > 0) {
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        tableviewVideo = (BaseTableVideoViewController *) currentTableView;
        
        if (tableviewVideo.listData.count %10 == 0) {
            
            if (videoTypeId == ContentTypeIDVideo || videoTypeId == ContentTypeIDAllVideo)
                currentPageLoadMoreVideoOffiCialAll ++;
            else
                currentPageLoadMoreVideoUnOffiCialAll ++;
            
            //-- get all video
            [self fetchingVideoAllWithContentType:videoTypeId WithIndex:byIndex];
            
        }else {
            
            //-- hidden loading
            [activityIndicator stopAnimating];
            
            for (UITableView *viewTB in scrollViewListVideos.subviews) {
                
                if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                    
                    //-- hidden loading
                    [viewTB.infiniteScrollingView stopAnimating];
                    
                    break;
                }
            }
        }
    }
}


//-- Video OffiCial
-(void) createDataSourceVideoWithCategoryID:(NSString *)categoryID
                                                 from: (NSDictionary *)aDictionary WithIndex:(int) byIndex
{
    NSLog(@"%s", __func__);
    if (aDictionary)
    {
        NSDictionary *dictData = [aDictionary objectForKey:@"data"];
        NSMutableArray *arrCategory = [dictData objectForKey:@"category_list"];
        if ([arrCategory count] > 0)
        {
            NSDictionary *dictSinger = [arrCategory objectAtIndex:0];
            NSString *categoryidStr = [dictSinger objectForKey:@"category_id"];
            NSMutableArray *arrVideos = [dictSinger objectForKey:@"node_list"];
            
            //-- remove lable nodata
            [self removeLableNoDataFrom:scrollViewListVideos withIndex:byIndex];
            
            if ([arrVideos count] > 0)
            {
                //-- saved NSDefalut for video AlbumId
                if (![[NSUserDefaults standardUserDefaults] objectForKey:categoryID]) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:categoryID forKey:categoryID];
                }
                
                //-- check and add tableview music
                id currentTableView = [self.pageViews objectAtIndex:byIndex];
                
                if (NO == [currentTableView isKindOfClass:[BaseTableVideoViewController class]]) {
                    
                    //-- Load the photo view.
                    CGRect frame = scrollViewListVideos.bounds;
                    frame.origin.x = frame.size.width * byIndex;
                    frame.origin.y = 0.0f;
                    frame = CGRectInset(frame, 0.0f, 0.0f);
                    
                    tableviewVideo = [[BaseTableVideoViewController alloc] init];
                    tableviewVideo.delegateVideo = self;
                    tableviewVideo.videoTypeId = ContentTypeIDVideo;
                    
                    tableviewVideo.view.backgroundColor = [UIColor clearColor];
                    [tableviewVideo.view setFrame:frame];
                    [tableviewVideo.view setTag:byIndex];
                    
                    //-- load data
                    tableviewVideo.listData  = [self addObjectToModelVideoOffiCialWithListData:arrVideos withCategoryId:categoryidStr];
                    
                    [scrollViewListVideos addSubview:tableviewVideo.view];
                    [self.pageViews replaceObjectAtIndex:byIndex withObject:tableviewVideo];
                }
                
            }else {
                
                //-- Load the photo view.
                CGRect frame = [scrollViewListVideos frame];
                frame.origin.x = frame.size.width * byIndex;
                frame.origin.y = 0.0f;
                frame = CGRectInset(frame, 0.0f, 0.0f);
                
                //-- add lable nodata
                [self addLableNoDataTo:scrollViewListVideos withIndex:byIndex withFrame:frame];
            }
        }
        
    }
}

//-- Video UnOffiCial
-(void) createDataSourceVideoUnOffiCialWithCategoryID:(NSString *)categoryID from: (NSDictionary *)aDictionary WithIndex:(int) byIndex
{
    NSLog(@"%s", __func__);
    if (aDictionary)
    {
        NSDictionary *dictData = [aDictionary objectForKey:@"data"];
        NSMutableArray *arrCategory = [dictData objectForKey:@"category_list"];
        if ([arrCategory count] > 0)
        {
            NSDictionary *dictSinger = [arrCategory objectAtIndex:0];
            NSString *categoryidStr = [dictSinger objectForKey:@"category_id"];
            NSMutableArray *arrVideos = [dictSinger objectForKey:@"node_list"];
            
            //-- remove lable nodata
            [self removeLableNoDataFrom:scrollViewListVideos withIndex:byIndex];
            
            if ([arrVideos count] > 0)
            {
                //-- saved NSDefalut for video AlbumId
                if (![[NSUserDefaults standardUserDefaults] objectForKey:categoryID]) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:categoryID forKey:categoryID];
                }
                
                //-- check and add tableview music
                id currentTableView = [self.pageViews objectAtIndex:byIndex];
                
                if (NO == [currentTableView isKindOfClass:[BaseTableVideoViewController class]]) {
                    
                    //-- Load the photo view.
                    CGRect frame = scrollViewListVideos.bounds;
                    frame.origin.x = frame.size.width * byIndex;
                    frame.origin.y = 0.0f;
                    frame = CGRectInset(frame, 0.0f, 0.0f);
                    
                    tableviewVideo = [[BaseTableVideoViewController alloc] init];
                    tableviewVideo.delegateVideo = self;
                    tableviewVideo.videoTypeId = ContentTypeIDUnofficialVideo;
                    
                    tableviewVideo.view.backgroundColor = [UIColor clearColor];
                    [tableviewVideo.view setFrame:frame];
                    [tableviewVideo.view setTag:byIndex];
                    
                    //-- load data
                    tableviewVideo.listData  = [self addObjectToModelVideoUnOffiCialWithListData:arrVideos withCategoryId:categoryidStr];
                    
                    [scrollViewListVideos addSubview:tableviewVideo.view];
                    [self.pageViews replaceObjectAtIndex:byIndex withObject:tableviewVideo];
                }
                
            }else {
                
                //-- Load the photo view.
                CGRect frame = [scrollViewListVideos frame];
                frame.origin.x = frame.size.width * byIndex;
                frame.origin.y = 0.0f;
                frame = CGRectInset(frame, 0.0f, 0.0f);
                
                //-- add lable nodata
                [self addLableNoDataTo:scrollViewListVideos withIndex:byIndex withFrame:frame];
            }
        }
    }
}


//-- Model Video OffiCial
-(NSMutableArray *) addObjectToModelVideoOffiCialWithListData:(NSMutableArray *) arrVideos withCategoryId:(NSString *) categoryidStr {
    NSLog(@"%s", __func__);
    NSMutableArray *listDataSourceVideo = [[NSMutableArray alloc] init];
    
    if (videoTypeId == ContentTypeIDAllVideo) {
        [VMDataBase deleteAllVideosOfTBVideoAll];
        for (NSInteger i = 0; i < [arrVideos count]; i++)
        {
            VideoAllModel *aVideo = [VideoAllModel new];
            
            aVideo.body = [[arrVideos objectAtIndex:i] objectForKey:@"body"];
            aVideo.cms_user_id = [[arrVideos objectAtIndex:i] objectForKey:@"cms_user_id"];
            aVideo.content_type_id = [[arrVideos objectAtIndex:i] objectForKey:@"content_type_id"];
            aVideo.created_date = [[arrVideos objectAtIndex:i] objectForKey:@"created_date"];
            aVideo.description = [[arrVideos objectAtIndex:i] objectForKey:@"description"];
            aVideo.last_update = [[arrVideos objectAtIndex:i] objectForKey:@"last_update"];
            aVideo.name = [[arrVideos objectAtIndex:i] objectForKey:@"name"];
            aVideo.node_id = [[arrVideos objectAtIndex:i] objectForKey:@"node_id"];
            aVideo.isHot = [[arrVideos objectAtIndex:i] objectForKey:@"isHot"];
            
            NSString *numberComment = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_comment"]];
            NSString *numberLike = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_like"]];
            NSString *numberView = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_view"]];
            NSString *isLiked = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"is_liked"]];
            aVideo.snsTotalDisLike = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_dislike"];
            aVideo.snsTotalShare = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_share"];
            aVideo.snsTotalComment = numberComment;
            aVideo.snsTotalLike = numberLike;
            aVideo.snsTotalView = numberView;
            aVideo.isLiked = isLiked;
            
            aVideo.thumbnail_image_file_path = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_file_path"];
            aVideo.thumbnail_image_file_type = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_file_type"];
            aVideo.video_file_path = [[arrVideos objectAtIndex:i] objectForKey:@"video_file_path"];
            aVideo.video_order = [[arrVideos objectAtIndex:i] objectForKey:@"video_order"];
            aVideo.youtube_url = [[arrVideos objectAtIndex:i] objectForKey:@"youtube_url"];
            
            //-- properties additional
            aVideo.numberOfLike = 0;
            aVideo.arrComments = [NSMutableArray new];
            aVideo.url = @"";
            
            //-- insert video Official to DB
            [VMDataBase insertVideosOfTBVideoAll:aVideo];
        }
        
        listDataSourceVideo = [VMDataBase getAllVideos];
        
    }else {
        [VMDataBase deleteAllVideosOffiCialByCategoryId:categoryidStr];
        for (NSInteger i = 0; i < [arrVideos count]; i++)
        {
            VideoForAll *aVideo = [VideoForAll new];
            
            aVideo.categoryID = categoryidStr;
            aVideo.albumAuthorMusicId = [[arrVideos objectAtIndex:i] objectForKey:@"album_author_music_id"];
            aVideo.albumDescription = [[arrVideos objectAtIndex:i] objectForKey:@"album_description"];
            aVideo.albumEngName = [[arrVideos objectAtIndex:i] objectForKey:@"album_english_name"];
            aVideo.albumId = [[arrVideos objectAtIndex:i] objectForKey:@"album_id"];
            aVideo.albumIsHot = [[arrVideos objectAtIndex:i] objectForKey:@"album_is_hot"];
            aVideo.albumMusicPublisherId = [[arrVideos objectAtIndex:i] objectForKey:@"album_music_publisher_id"];
            aVideo.albumMusicType = [[arrVideos objectAtIndex:i] objectForKey:@"album_music_type"];
            aVideo.albumName = [[arrVideos objectAtIndex:i] objectForKey:@"album_name"];
            aVideo.albumPublishedYear = [[arrVideos objectAtIndex:i] objectForKey:@"album_published_year"];
            aVideo.albumSetingTotalRating = [[arrVideos objectAtIndex:i] objectForKey:@"album_setting_total_rating"];
            aVideo.albumSettingTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"album_setting_total_view"];
            aVideo.albumThumbImagePath = [[arrVideos objectAtIndex:i] objectForKey:@"album_thumbnail_image_file_path"];
            aVideo.albumTotalTrack = [[arrVideos objectAtIndex:i] objectForKey:@"album_total_track"];
            aVideo.albumTrueTotalRating = [[arrVideos objectAtIndex:i] objectForKey:@"album_true_total_rating"];
            aVideo.albumTrueTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"album_true_total_view"];
            aVideo.categoryList = [[arrVideos objectAtIndex:i] objectForKey:@"category_list"];
            aVideo.content = [[arrVideos objectAtIndex:i] objectForKey:@"content"];
            aVideo.countryId = [[arrVideos objectAtIndex:i] objectForKey:@"country_id"];
            aVideo.engName = [[arrVideos objectAtIndex:i] objectForKey:@"english_name"];
            aVideo.isHot = [[arrVideos objectAtIndex:i] objectForKey:@"is_hot"];
            aVideo.musicPath = [[arrVideos objectAtIndex:i] objectForKey:@"music_path"];
            aVideo.musicType = [[arrVideos objectAtIndex:i] objectForKey:@"music_type"];
            aVideo.name = [[arrVideos objectAtIndex:i] objectForKey:@"name"];
            aVideo.nodeId = [[arrVideos objectAtIndex:i] objectForKey:@"node_id"];
            aVideo.numberOfTrack = [[arrVideos objectAtIndex:i] objectForKey:@"number_of_track"];
            aVideo.settingTotalRating = [[arrVideos objectAtIndex:i] objectForKey:@"setting_total_rating"];
            aVideo.settingTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"setting_total_view"];
            aVideo.thumbImagePath = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
            aVideo.thumbImageType = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_type"];
            aVideo.translateContent = [[arrVideos objectAtIndex:i] objectForKey:@"translated_content"];
            aVideo.trueTotalRating = [[arrVideos objectAtIndex:i] objectForKey:@"true_total_rating"];
            aVideo.trueTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"true_total_view"];
            aVideo.youtubeUrl = [[arrVideos objectAtIndex:i] objectForKey:@"youtube_url"];
            
            NSString *numberComment = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_comment"]];
            NSString *numberLike = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_like"]];
            NSString *numberView = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_view"]];
            NSString *isLiked = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"is_liked"]];
            aVideo.snsTotalDisLike = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_dislike"];
            aVideo.snsTotalShare = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_share"];
            aVideo.snsTotalComment = numberComment;
            aVideo.snsTotalLike = numberLike;
            aVideo.snsTotalView = numberView;
            aVideo.isLiked = isLiked;
            
            //-- properties additional
            aVideo.numberOfLike = 0;
            aVideo.arrComments = [NSMutableArray new];
            aVideo.url = @"";
            
            
            //-- insert video Official to DB
            [VMDataBase insertVideosOffiCial:aVideo];
        }
        
        //NSString *contentTypeStr = [NSString stringWithFormat:@"%d",ContentTypeIDVideo];
        //if ([categoryidStr isEqualToString:contentTypeStr])
        //    listDataSourceVideo = [VMDataBase getAllVideosOffiCial];
        //else
            listDataSourceVideo = [VMDataBase getAllVideosOffiCialByCategoryId:categoryidStr];
        
    }
    
    return listDataSourceVideo;
}

//-- Model Video UnOffiCial
-(NSMutableArray *) addObjectToModelVideoUnOffiCialWithListData:(NSMutableArray *) arrVideos withCategoryId:(NSString *) categoryidStr {
    NSLog(@"%s", __func__);
    
    NSMutableArray *listDataSourceVideo = [[NSMutableArray alloc] init];
    [VMDataBase deleteAllVideosUnOffiCialByCategoryId:categoryidStr];
    for (NSInteger i = 0; i < [arrVideos count]; i++)
    {
        VideoForCategory *aVideo = [VideoForCategory new];
        
        aVideo.categoryID = categoryidStr;
        aVideo.body = [[arrVideos objectAtIndex:i] objectForKey:@"body"];
        aVideo.countryID = [[arrVideos objectAtIndex:i] objectForKey:@"country_id"];
        aVideo.isHot = [[arrVideos objectAtIndex:i] objectForKey:@"is_hot"];
        aVideo.nodeID = [[arrVideos objectAtIndex:i] objectForKey:@"node_id"];
        aVideo.orderVideo = [[arrVideos objectAtIndex:i] objectForKey:@"order"];
        aVideo.settingTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"setting_total_view"];
        aVideo.shortBody = [[arrVideos objectAtIndex:i] objectForKey:@"short_body"];
        aVideo.thumbnailImagePath = [[arrVideos objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
        aVideo.title = [[arrVideos objectAtIndex:i] objectForKey:@"title"];
        aVideo.trueTotalView = [[arrVideos objectAtIndex:i] objectForKey:@"true_total_view"];
        aVideo.videoFacebookPath = [[arrVideos objectAtIndex:i] objectForKey:@"video_facebook_path"];
        aVideo.videoFilePath = [[arrVideos objectAtIndex:i] objectForKey:@"video_file_path"];
        aVideo.videoYoutubePath = [[arrVideos objectAtIndex:i] objectForKey:@"video_youtube_path"];        
        aVideo.youtubeUrl = [[arrVideos objectAtIndex:i] objectForKey:@"youtube_url"];
        
        NSString *numberComment = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_comment"]];
        NSString *numberLike = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_like"]];
        NSString *numberView = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"sns_total_view"]];
        NSString *isLiked = [NSString stringWithFormat:@"%@",[[arrVideos objectAtIndex:i] objectForKey:@"is_liked"]];
        aVideo.snsTotalDisLike = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_dislike"];
        aVideo.snsTotalShare = [[arrVideos objectAtIndex:i] objectForKey:@"sns_total_share"];
        aVideo.snsTotalView = numberView;
        aVideo.snsTotalComment = numberComment;
        aVideo.snsTotalLike = numberLike;
        aVideo.isLiked = isLiked;
        
        //-- properties additional
        aVideo.numberOfLike = 0;
        aVideo.arrComments = [NSMutableArray new];
        aVideo.url = @"";
        

        //-- insert video Official to DB
        [VMDataBase insertVideosUnOffiCial:aVideo];

    }
    
    //NSString *contentTypeStr = [NSString stringWithFormat:@"%d",ContentTypeIDUnofficialVideo];
    //if       ([categoryidStr isEqualToString:contentTypeStr])
    //           listDataSourceVideo = [VMDataBase getAllVideosUnOffiCial];
    //else
               listDataSourceVideo = [VMDataBase getAllVideosUnOffiCialByCategoryId:categoryidStr];
    
    return listDataSourceVideo;
}

//*******************************************************************************//
#pragma mark - BaseTableviewMusic delegate

-(void) goToVideoPlayViewControllerWithListData:(NSMutableArray *)listData withVideoTypeId:(NSInteger)valueVideoTypeId withIndexRow:(int)indexRow
{
    NSLog(@"%s", __func__);
    VideoDetailViewController *videoDetailVC = (VideoDetailViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetailViewControllerIdentifier"];
    
    //-- pass Data
    videoDetailVC.contentVideoTypeId = valueVideoTypeId;
    
    if (valueVideoTypeId == ContentTypeIDVideo || valueVideoTypeId == ContentTypeIDAllVideo) {
        
        if (valueVideoTypeId == ContentTypeIDAllVideo) {
            
            //-- Official Video info
            VideoAllModel *aVideo = [listData objectAtIndex:indexRow];
            videoDetailVC.videoAllModelInfo = aVideo;
            
        }else {
            
            //-- Official Video info
            VideoForAll *aVideo = [listData objectAtIndex:indexRow];
            videoDetailVC.videoForAllInfo = aVideo;
        }
        
    }else {
        
        //-- Unofficial Video info
        VideoForCategory *aVideo = [listData objectAtIndex:indexRow];
        videoDetailVC.videoForCategoryInfo = aVideo;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:videoDetailVC animated:YES];
    else
        [self.navigationController pushViewController:videoDetailVC animated:NO];
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


//********************************************************************************//
#pragma mark - Search Video Album

- (void)searchVideoAlbum:(id)sender
{
    SearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idSearchViewControllerSb"];
    searchVC.searchtype = searchVideoType;
    searchVC.videoTypeId = self.videoTypeId;
    
    [UIView animateWithDuration:0.55
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:searchVC animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}


@end
