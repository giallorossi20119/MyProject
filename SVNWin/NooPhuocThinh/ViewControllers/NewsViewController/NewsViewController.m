//
//  NewsViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "NewsViewController.h"
#import "SearchViewController.h"
#import "DNewsViewController.h"

@interface NewsViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation NewsViewController

@synthesize _activityIndicator;
@synthesize pageViews = _pageViews;

#pragma mark - memory management

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
    NSLog(@"%s", __func__);
    isCallingAPI = false;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //-- set up view
    [self setViewWhenViewDidLoad];
    
    //-- set data
    [self setDataWhenViewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    self.screenName = @"News Screen";
    
    //-- read from cache
    _arrCategories = [VMDataBase getAllCategoryForContentType:ContentTypeIDNews];
    //Them phan reset page o day
    NSString *keyCurrentPage;
    if ([_arrCategories count] > 0) {
        for (int i=0; i<[_arrCategories count]-1; i++) {
            NSString *cateId = ((CategoryBySinger *)[_arrCategories objectAtIndex:i]).categoryId;
            keyCurrentPage = [NSString stringWithFormat:@"CurrentPage_%@",cateId];
            NSUserDefaults *defaultCurrentPageById = [NSUserDefaults standardUserDefaults];
        
            if ([defaultCurrentPageById valueForKey:keyCurrentPage]) {
                [defaultCurrentPageById setValue:@"0" forKey:keyCurrentPage];
                [defaultCurrentPageById synchronize];
            }
        }

        //-- set title for top menu
        [self getNewsDataFromDataBaseByIndex:_currentIndex];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    [super viewDidAppear:animated];
     self.navigationController.navigationItem.hidesBackButton=YES;
    
    //-- disable search display
    if ([self.searchDisplayController isActive])
        [self.searchDisplayController setActive:NO animated:YES];
}


- (void)setViewWhenViewDidLoad
{
    NSLog(@"%s", __func__);
    //--set navigation bar: back button, search button, background...
    [self customNavigationBar];
    
    //-- set background for view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [UIView view:_scrollViewNews setY:47];
}


- (void)setDataWhenViewDidLoad
{
    NSLog(@"%s", __func__);
    //-- init data for tableview
    _arrCategories              = [NSMutableArray new];
    _dataSource                 = [NSMutableArray new];
    _resultDataSource           = [NSMutableArray new];
    _isSearching                = NO;
    _indexSegmentSelected       = 0;
    
    _allowsReadCacheCategory    = YES;
    _allowsReadCacheDataSource  = YES;
    _allowsLoadDataSource       = NO;
    
    _currentPage                = 0;
    
    [self fetchingCategoriesForNews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UI

-(void) customNavigationBar
{
    NSLog(@"%s", __func__);
    [self setTitle:@"Tin tức"];
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    //-- back button
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
    [btnRight addTarget:self action:@selector(searchForNews:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barItemRight;
}



#pragma mark - Set up scrollview

//-- create page scroll
-(void) createPageScrollNews:(NSInteger)numberViews
{
    _scrollViewNews.contentSize = CGSizeMake(_scrollViewNews.frame.size.width * numberViews, _scrollViewNews.frame.size.height);
    _scrollViewNews.showsHorizontalScrollIndicator = NO;
    _scrollViewNews.showsVerticalScrollIndicator = NO;
    _scrollViewNews.alwaysBounceVertical = NO;
    _scrollViewNews.pagingEnabled = YES;
    _scrollViewNews.scrollsToTop = NO;
    
    //-- Set up the array to hold the views for each page
    _pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < numberViews; ++i) {
        
        [self.pageViews addObject:[NSNull null]];
    }
    
    //-- Set the scroll view's content size, autoscroll to the stating tableview
    [self setScrollViewContentSize:numberViews];
    
    [self setCurrentIndex:0];
    
    [self scrollToIndex:0];
}


-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = _scrollViewNews.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [_scrollViewNews scrollRectToVisible:frame animated:NO];
}


- (void)setScrollViewContentSize:(NSInteger)numberViews
{
    NSInteger pageCount = numberViews;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(_scrollViewNews.frame.size.width * pageCount,
                             _scrollViewNews.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [_scrollViewNews setContentSize:size];
}

//index cua category
- (void)setCurrentIndex:(NSInteger)newIndex
{
    _currentIndex = newIndex;
    _currentCategoryId = ((CategoryBySinger *)[_arrCategories objectAtIndex:newIndex]).categoryId;

    //-- change seagment
    [_controlMenuTop setSelectedSegmentIndex:_currentIndex];
    
    //-- set currentpage default
    NSString *keyCurrentPage = [NSString stringWithFormat:@"CurrentPage_%@",_currentCategoryId];
    NSUserDefaults *defaultCurrentPageById = [NSUserDefaults standardUserDefaults];
    
    if ([defaultCurrentPageById valueForKey:keyCurrentPage]) {
        [defaultCurrentPageById setValue:@"0" forKey:keyCurrentPage];
        [defaultCurrentPageById synchronize];
    }
    _currentPage = 0;
    _isLoadedFullNode = NO;
    
    //Tinh lai pagesize
    _pageSize = NODE_IN_PAGE_OFFLINE_LIMIT;
    if (![_currentCategoryId isEqualToString:@""]) {
        BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
        if (isErrorNetWork) {
            //ktra xem co phai lay o server
            if ([self isCacheForCategoryPerPageTimeout:_currentCategoryId pageIndex:@"0" updateCacheNow:false])
                _pageSize = NODE_IN_PAGE_ONLINE_LIMIT;
        }
    }

    //-- load data
    [self fetchingNewsWithCategory:_currentIndex];
    
}



#pragma mark - call api

-(void)fetchingCategoriesForNews
{
    NSLog(@"%s", __func__);
    if ([_arrCategories count] == 0 && _allowsReadCacheCategory)
    {
        //-- read from cache
        _arrCategories = [VMDataBase getAllCategoryForContentType:ContentTypeIDNews];
        
        //-- set title for top menu
        if ([_arrCategories count] > 0)
        {
            [self setTopMenuWithTitles:_arrCategories];
            
            [self createPageScrollNews:_arrCategories.count];
            
            //-- turn off read from cache
            _allowsReadCacheCategory = NO;
        }
    }
    
    if (([_arrCategories count]==0 || !_allowsReadCacheCategory))
    {
        //-- check Network
        BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
        if (!isErrorNetWork) return;
        
        if (!_allowsReadCacheCategory) //-- check_time
        {
            NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
            NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesNewsCategoryRefreshTime;
            if (([Setting sharedSetting].milestonesNewsCategoryRefreshTime !=0) && (compeTime < ([Setting sharedSetting].newsCategoryRefreshTime*60)))
                return;
            else
                [Setting sharedSetting].milestonesNewsCategoryRefreshTime = currentDate;
        }
        _activityIndicator.hidden = NO;
        [_activityIndicator startAnimating];
        isCallingAPI = true;
        [API getCategoryBySinger:SINGER_ID
                   contentTypeId:ContentTypeIDNews
                           appID:PRODUCTION_ID
                      appVersion:PRODUCTION_VERSION
                       completed:^(NSDictionary *responseDictionary, NSError *error) {
                           isCallingAPI = false;
                           [self createCategoriesFrom:responseDictionary];
                           
                       }];
    }
}

/*
 Kiem tra cache xem 1 page trong 1 category co thoi gian timeout het chua
*/
- (bool) isCacheForCategoryPerPageTimeout: (NSString *)categoryId pageIndex:(NSString *)pageIndex updateCacheNow:(BOOL)updateCacheNow
{
    //-- check time
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger prvTime = [[Setting sharedSetting] milestonesNewRefreshTimeForCategoryIdPerPage:categoryId pageIndex:pageIndex];
    NSInteger compeTime = currentDate - prvTime;
    NSLog(@"%s crrpage=%@ categoryId=%@ timeout=%f crr=%d, prv=%d", __func__, pageIndex, categoryId, [Setting sharedSetting].newListRefreshTime*60, currentDate, prvTime);

    if (([[Setting sharedSetting] milestonesNewRefreshTimeForCategoryIdPerPage:categoryId pageIndex:pageIndex] != 0) && (compeTime < [Setting sharedSetting].newListRefreshTime*60)) {
        return false;
    }
    if (updateCacheNow)
        [[Setting sharedSetting] setMilestonesNewRefreshTimeForCagegoryPerPage:currentDate categoryId: categoryId pageIndex:pageIndex];

    return true;
}

//-- get news with category id
-(void) fetchingNewsWithCategory:(NSInteger)index
{
    NSLog(@"%s", __func__);
    //-- check Network
    //load from cache
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (isErrorNetWork) {
        
        //ktra xem co phai lay o server
        BOOL allowLoadData = [self isCacheForCategoryPerPageTimeout:_currentCategoryId pageIndex:@"0" updateCacheNow:false];

        if (allowLoadData)
        {
            _activityIndicator.hidden = NO;
            if (![_activityIndicator isAnimating])
                [_activityIndicator startAnimating];
            isCallingAPI = true;
            dispatch_async(dispatch_get_main_queue(), ^(void){
            //-- request news async
            [API  getNodeByCategoryForSingerWithContentTypeId:ContentTypeIDNews
                                                        limit:[NSString stringWithFormat:@"%d",NODE_IN_PAGE_ONLINE_LIMIT]
                                                         page:@"0"
                                                    isHotNode:@"0"
                                                isGetNodeBody:@"0"
                                                   categoryId:_currentCategoryId
                                                       period:@""
                                                        start:@"-30"
                                                        appID:PRODUCTION_ID
                                                   appVersion:PRODUCTION_VERSION
                                                       months:@""
                                                    completed:^(NSDictionary *responseDictionary, NSError *error){
                                                        isCallingAPI = false;
                                                        if (error!=nil) {
                                                            [self checkAndShowErrorNoticeNetwork];
                                                            NSLog(@"Load from cache due API failed");
                                                            [self getNewsDataFromDataBaseByIndex:index];
                                                            if (![_activityIndicator isAnimating]) {
                                                                _activityIndicator.hidden = YES;
                                                                [_activityIndicator stopAnimating];
                                                            }
                                                        }
                                                        else {
                                                            NSLog(@"tintuc data %d entry=%lu", index, (unsigned long)[responseDictionary count]);
                                                            //NSLog(@"tintuc %@ ", responseDictionary);
                                                            //-- parse json
                                                            [self createDataSourceFrom:responseDictionary atIndex:index];
                                                        }
                                                    }];
            } );
            return;
        }
    }
    NSLog(@"Load from cache");
    [self getNewsDataFromDataBaseByIndex:index];
    
}


//-- get music album from DB
-(NSInteger)getNewsDataFromDataBaseByIndex:(int)byIndex {
    NSLog(@"%s", __func__);
    
    NSInteger countData = 0;
    
    //-- hidden loading
    if (!isCallingAPI)
        [_activityIndicator stopAnimating];
    
    //-- remove lable nodata
    [self removeLableNoDataFrom:_scrollViewNews withIndex:byIndex];
    
    //-- category id
    _currentCategoryId = ((CategoryBySinger *)[_arrCategories objectAtIndex:byIndex]).categoryId;
    
    //-- set currentpage default
    NSString *keyCurrentPage = [NSString stringWithFormat:@"CurrentPage_%@",_currentCategoryId];
    NSUserDefaults *defaultCurrentPageById = [NSUserDefaults standardUserDefaults];
    
    if (![defaultCurrentPageById valueForKey:keyCurrentPage]) {
        [defaultCurrentPageById setValue:@"0" forKey:keyCurrentPage];
        [defaultCurrentPageById synchronize];
    }
    NSInteger currentPageValue = [[defaultCurrentPageById valueForKey:keyCurrentPage] integerValue];
    
    
    //-- read in cache
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    //listData = [VMDataBase getAllNewsWithCategoryID:_currentCategoryId];
    int totalNeed = _pageSize*(currentPageValue+1);
    listData = [VMDataBase getAllNewsWithCategoryIDPerPage:_currentCategoryId pageId:0 pageSize:totalNeed];
    if (listData.count > 0)
    {
        
        countData = listData.count;
        if (countData < totalNeed)
            _isLoadedFullNode = YES;
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        
        if (NO == [currentTableView isKindOfClass:[TableNewsViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = _scrollViewNews.bounds;
            frame.origin.x = frame.size.width * byIndex;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            self.tableviewNews = [[TableNewsViewController alloc] init];
            self.tableviewNews.delegate = self;
            self.tableviewNews.isShowLableNodata = YES;
            self.tableviewNews.view.backgroundColor = [UIColor clearColor];
            [self.tableviewNews.view setFrame:frame];
            [self.tableviewNews.view setTag:byIndex];
            
            self.tableviewNews.listNews  = listData;
            
            //-- add Refresh to tableview
            [self addRefreshAndLoadMoreForTableView:self.tableviewNews.tableView WithIndex:byIndex];
            
            [_scrollViewNews addSubview:self.tableviewNews.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:self.tableviewNews];
            
        }else {
            self.tableviewNews = (TableNewsViewController *) currentTableView;
            self.tableviewNews.listNews = listData;
            [self.tableviewNews.tableView reloadData];
        }
        
    }
    else {
        
        //-- Load the photo view.
        CGRect frame = [_scrollViewNews frame];
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable no data
        [self addLableNoDataTo:_scrollViewNews withIndex:byIndex withFrame:frame];
    }
    
    //-- get tableview All News in scrollview
    if (_scrollViewNews.subviews.count > 0) {
        
        for (UITableView *viewTB in _scrollViewNews.subviews) {
            
            if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                
                //-- hidden loading
                [viewTB.infiniteScrollingView stopAnimating];
                
                break;
            }
        }
    }
    
    return countData;
}


-(void)createDataSourceFrom:(NSDictionary *)aDictionary atIndex:(NSInteger)currentIndex
{
    NSLog(@"%s", __func__);
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrCategory = [dictData objectForKey:@"category_list"];
    if ([arrCategory count] > 0)
    {
        NSLog(@"[arrCategory count]:%d",[arrCategory count]);
        NSDictionary *dictSinger = [arrCategory objectAtIndex:0];
        
        NSMutableArray *arrNews = [dictSinger objectForKey:@"node_list"];
        NSLog(@"[arrNews count]:%d",[arrNews count]);
        
        _isLoadedFullNode = NO;
        NSString *categoryId = [dictSinger objectForKey:@"category_id"];

        //xoa news nam trong category hien tai trong DB
        [VMDataBase deleteNewsWithCategoryID:categoryId];
        if ([arrNews count] > 0)
        {
            for (NSInteger i = 0; i < [arrNews count]; i++)
            {
                News *aNews                = [[News alloc] init];
                aNews.body                 = [[arrNews objectAtIndex:i] objectForKey:@"body"];
                aNews.createdDate          = [[arrNews objectAtIndex:i] objectForKey:@"created_date"];
                aNews.imageList            = [[arrNews objectAtIndex:i] objectForKey:@"image_list"];
                aNews.isHot                = [[[arrNews objectAtIndex:i] objectForKey:@"is_hot"] integerValue];
                aNews.lastUpdate           = [[arrNews objectAtIndex:i] objectForKey:@"last_update"];
                aNews.nodeId               = [[arrNews objectAtIndex:i] objectForKey:@"node_id"];
                aNews.order                = [[[arrNews objectAtIndex:i] objectForKey:@"order"] integerValue];
                aNews.settingTotalView     = [[[arrNews objectAtIndex:i] objectForKey:@"setting_total_view"] integerValue];
                aNews.shortBody            = [[arrNews objectAtIndex:i] objectForKey:@"short_body"];
                aNews.thumbnailImagePath   = [[arrNews objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
                aNews.thumbnailImageType   = [[arrNews objectAtIndex:i] objectForKey:@"thumbnail_image_type"];
                aNews.title                = [[arrNews objectAtIndex:i] objectForKey:@"title"];
                aNews.trueTotalView        = [[[arrNews objectAtIndex:i] objectForKey:@"true_total_view"] integerValue];
                aNews.snsTotalComment      = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_comment"] integerValue];
                aNews.snsTotalDislike      = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_dislike"] integerValue];
                aNews.snsTotalLike         = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_like"] integerValue];
                aNews.snsTotalShare        = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_share"] integerValue];
                aNews.snsTotalView         = [[[arrNews objectAtIndex:i] objectForKey:@"sns_total_view"] integerValue];
                aNews.isLiked              = [[[arrNews objectAtIndex:i] objectForKey:@"is_liked"] integerValue];
                
                //-- properties additional
                aNews.arrComments = [NSMutableArray new];
                aNews.url = @"";
                aNews.categoryID = categoryId;
                
               
                //-- insert news into db
                [VMDataBase insertWithNews:aNews];
            }
            
            //-- get data
            //lay dc ok thi update flag cache timeout
            [self isCacheForCategoryPerPageTimeout:categoryId pageIndex:@"0" updateCacheNow:true];
            
            //load lai new la current index
            //if (currentIndex==_currentIndex)
                [self getNewsDataFromDataBaseByIndex:_currentIndex];
        }
    }
    
    //-- stop indicator
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
}


-(void)createCategoriesFrom:(NSDictionary *)aDictionary
{
    NSLog(@"%s", __func__);
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"singer_list"];
    NSMutableArray *arrCategory;
    NSDictionary *dictContentType;
    
    if (arrSinger.count > 0)
    {
        NSDictionary *dictSinger = [arrSinger objectAtIndex:0];
        NSMutableArray *arrContentType = [dictSinger objectForKey:@"content_type_list"];
        dictContentType = [arrContentType objectAtIndex:0];
        arrCategory = [dictContentType objectForKey:@"category_list"];
    }
    
    if ([arrCategory count] > 0)
    {
        for (NSDictionary *tmpDict in arrCategory)
        {
            CategoryBySinger *aCategory         = [CategoryBySinger new];
            aCategory.contentTypeId             = [dictContentType objectForKey:@"content_type_id"];
            aCategory.categoryId                = [tmpDict objectForKey:@"category_id"];
            aCategory.bigIconImageFilePath      = [tmpDict objectForKey:@"big_icon_image_file_path"];
            aCategory.countryId                 = [tmpDict objectForKey:@"country_id"];
            aCategory.countryName               = [tmpDict objectForKey:@"country_name"];
            aCategory.demographicDescription    = [tmpDict objectForKey:@"demographic_description"];
            aCategory.demographicId             = [tmpDict objectForKey:@"demographic_id"];
            aCategory.demographicName           = [tmpDict objectForKey:@"demographic_name"];
            aCategory.description               = [tmpDict objectForKey:@"description"];
            aCategory.forumLink                 = [tmpDict objectForKey:@"forum_link"];
            aCategory.iconImageFilePath         = [tmpDict objectForKey:@"icon_image_file_path"];
            aCategory.name                      = [tmpDict objectForKey:@"name"];
            aCategory.order                     = [[tmpDict objectForKey:@"order"] integerValue];
            aCategory.parentId                  = [tmpDict objectForKey:@"parent_id"];
            aCategory.thumbnailImagePath        = [tmpDict objectForKey:@"thumbnail_image_path"];
            
            //-- insert into DB
            [VMDataBase insertCategoryBySinger:aCategory];
            
            //-- add into arr
            if (_allowsReadCacheCategory)
                [_arrCategories addObject:aCategory];
        }
        
        //-- set title for top menu
        if (_allowsReadCacheCategory && [_arrCategories count] > 0)
        {
            [self createPageScrollNews:_arrCategories.count];
            
            [self setTopMenuWithTitles:_arrCategories];
        }
        
        //-- show line of segments
        _imgViewLineSegments.alpha = 1;
    }
    
    //-- stop indicator
    if ([_activityIndicator isAnimating] && !isCallingAPI){
         [_activityIndicator stopAnimating];
        _activityIndicator.hidden = YES;
    }
}


-(void)loadMoreNewsAtIndex:(NSInteger)index
{
    NSLog(@"%s", __func__);

    //-- change state to loading api.
    _allowsLoadDataSource = YES;
    
//    if (_totalNews == 0) {
//        
//        [self fetchingNewsWithCategory:index];
//    } else if (_totalNews > 0 && [_dataSource count] < _totalNews) {
    if (!_isLoadedFullNode) {
        _currentPage++;
        
        //-- set currentpage default
        NSString *keyCurrentPage = [NSString stringWithFormat:@"CurrentPage_%@",_currentCategoryId];
        NSUserDefaults *defaultCurrentPageById = [NSUserDefaults standardUserDefaults];
        
        if ([defaultCurrentPageById valueForKey:keyCurrentPage]) {
            
            NSInteger currentPageInt = [[defaultCurrentPageById valueForKey:keyCurrentPage] integerValue];
            currentPageInt ++;
            
            NSString *currentPageCategory = [NSString stringWithFormat:@"%d",currentPageInt];
            
            [defaultCurrentPageById setValue:currentPageCategory forKey:keyCurrentPage];
            [defaultCurrentPageById synchronize];
        }
        
        [self fetchingNewsWithCategory:index];
        
    } else {
        //-- get tableview All Video in scrollview
        if (_scrollViewNews.subviews.count > 0) {
            
            for (UITableView *viewTB in _scrollViewNews.subviews) {
                
                if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == index) {
                    
                    //-- hidden loading
                    [viewTB.infiniteScrollingView stopAnimating];
                    
                    break;
                }
            }
        }
    }
}



#pragma mark - segments for top menu

- (void) addRefreshAndLoadMoreForTableView:(UITableView *)aTableview WithIndex:(int) byIndex
{
    NSLog(@"%s", __func__);
    //-- refresh data
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:aTableview];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    
    //-- load more from bottom
    __weak NewsViewController *myself = self;
    
    //  -- setup infinite scrolling
    [aTableview addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreNewsAtIndex:byIndex];
    }];
}


-(void) setTopMenuWithTitles:(NSMutableArray *)categories
{
    NSLog(@"%s", __func__);
    NSMutableArray *listNameCategories = [categories valueForKey:@"name"];
    
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
    
    [self.view addSubview:_controlMenuTop];
    [UIView view:_scrollViewNews setY:47];
}


//-- segment category Selected
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex != _currentIndex) {
        [self setCurrentIndex:segmentedControl.selectedSegmentIndex];
        _currentIndex = segmentedControl.selectedSegmentIndex;
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
    }
}



#pragma mark - scrollview delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollViewNews)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = floor(fractionalPage);
        if (page != _currentIndex) {
            [self setCurrentIndex:page];
        }
    }
}



#pragma mark - table view delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        if (!_resultDataSource)
            return 0;
        else
            return [_resultDataSource count];
    }
    else //-- no search
    {
        if (!_dataSource)
            return 0;
        else
            return [_dataSource count];
    }
    
    return 0;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //-- set height for table
    return 114;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"NewsCellCustom";
    
    UITableView *currentTableview = (UITableView*)[_arrTableviews objectAtIndex:_indexSegmentSelected];
    
    NewsCellCustom *cell = [currentTableview dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [NewsCellCustom cellWithCustomType:NewsCellCustomTypeForListNews];
    }
    
    News *news = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView && _resultDataSource && [_resultDataSource count] >0)
        news = (News *)[_resultDataSource objectAtIndex:indexPath.row];
    else
        if (_dataSource && [_dataSource count] >0)
            news = (News *)[_dataSource objectAtIndex:indexPath.row];
    
    [cell.imgViewAvatar setImageWithURL:[NSURL URLWithString:news.thumbnailImagePath]
                       placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
    
    [cell.imgViewAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [cell.imgViewAvatar setClipsToBounds:YES];
    [Utility scaleImage:cell.imgViewAvatar.image toSize:CGSizeMake(80, 80)];
    
    if ((indexPath.row%2) == 0)
        cell.imgViewBackground.image = [UIImage imageNamed:@"bg_tintuc2.png"];
    else
        cell.imgViewBackground.image = [UIImage imageNamed:@"bg_tintuc1.png"];

    if(news)
    {
        cell.lblTitle.text = news.title;
        cell.lblShortContent.text = news.shortBody;
        cell.lblCommentCount.text = [NSString stringWithFormat:@"%d",news.snsTotalComment];
        cell.lblDate.text = [Utility relativeTimeFromDate:[Utility dateFromString:news.lastUpdate]];
    }

    [cell.btnComment addTarget:self action:@selector(showComments:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier:@"segueDetailNews" sender:self];
    }
}

//*******************************************************************************//
#pragma mark - TableNewsViewController delegate

-(void)goToDetailNewsViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    NSLog(@"%s", __func__);
    //NSLog(@"listData:%@",listData);
    DNewsViewController *detailNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbDNewsViewControllerId"];
    
    News *newsInfo = (News *)[listData objectAtIndex:indexRow];
    
    detailNewsVC.news = newsInfo;
    detailNewsVC.arrNews = listData;
    detailNewsVC.numberOfNews = listData.count;
    detailNewsVC.indexOfNews = [listData indexOfObject:newsInfo];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:detailNewsVC animated:YES];
    else
        [self.navigationController pushViewController:detailNewsVC animated:NO];
    
    //longnh add
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"read_news"  // Event action (required)
                                                           label:newsInfo.title
                                                           value:nil] build]];
    
    /*
     DetailNewsViewController *detailNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailNewsViewControllerId"];
     
     News *newsInfo = (News *)[listData objectAtIndex:indexRow];
     
     detailNewsVC.news = newsInfo;
     detailNewsVC.arrNews = listData;
     detailNewsVC.numberOfNews = listData.count;
     detailNewsVC.indexOfNews = [listData indexOfObject:newsInfo];
     
     if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
     [self.navigationController pushViewController:detailNewsVC animated:YES];
     else
     [self.navigationController pushViewController:detailNewsVC animated:NO];
     
     //longnh add
     id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
     [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
     action:@"read_news"  // Event action (required)
     label:newsInfo.title
     value:nil] build]];
     */
}


-(void)refreshData:(ODRefreshControl *)refreshControl
{
    NSLog(@"%s", __func__);
    
    //-- change state to loading api
    _allowsLoadDataSource =  YES;
    _currentPage = 0;
    _isLoadedFullNode = NO;
    //-- set currentpage default
    NSString *keyCurrentPage = [NSString stringWithFormat:@"CurrentPage_%@",_currentCategoryId];
    NSUserDefaults *defaultCurrentPageById = [NSUserDefaults standardUserDefaults];
    [defaultCurrentPageById setValue:@"0" forKey:keyCurrentPage];
    [defaultCurrentPageById synchronize];
    
    [refreshControl beginRefreshing];
    
    if (![_activityIndicator isAnimating])
        [_activityIndicator startAnimating];
    
    [self fetchingNewsWithCategory:_currentIndex];
    
    [refreshControl endRefreshing];
}



#pragma mark - search

-(void)searchNews:(id)sender
{
    _isSearching = !_isSearching;
    if (_isSearching)
        [self showSearchBar];
    else
    {
        [self searchBarCancelButtonClicked:self.searchDisplayController.searchBar];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.title contains[cd] %@",
                                    searchText];
    
    _resultDataSource = [_dataSource filteredArrayUsingPredicate:resultPredicate];
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self filterContentForSearchText:searchBar.text];
    [self.searchDisplayController.searchContentsController.navigationController setNavigationBarHidden:NO];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
     [self hiddenSearchBar];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self removeMenu];
   
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:NO animated:YES];
    [self.view addSubview:_controlMenuTop];
    [self hiddenSearchBar];
    return YES;
}

- (void) removeMenu
{
    for (UIView *view in self.view.subviews)
        if ([view isKindOfClass:[HMSegmentedControl class]])
        {
            [view removeFromSuperview];
            break;
        }
}

- (void) hiddenSearchBar
{
    [UIView animateWithDuration:0.3 animations:^{
        _isSearching = NO;
        [self.searchDisplayController.searchContentsController.navigationController setNavigationBarHidden:NO];
        self.searchDisplayController.searchBar.alpha = 0;
       
        [UIView view:self.searchDisplayController.searchBar setY:0];
        
    }];
}


-(void) showSearchBar
{
    [UIView animateWithDuration:0.3 animations:^{
         _isSearching = YES;
        [self.searchDisplayController.searchContentsController.navigationController setNavigationBarHidden:NO];
        self.searchDisplayController.searchBar.alpha = 1;
       
        [UIView view:self.searchDisplayController.searchBar setY:47];
    }];
}



#pragma mark - actions

-(void) showComments:(id)sender
{
    //NSLog(@"show all comment for New");
}


-(void)back:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


//********************************************************************************//
#pragma mark - Search News

- (void)searchForNews:(id)sender
{
    SearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idSearchViewControllerSb"];
    searchVC.searchtype = searchNewsType;
    
    [UIView animateWithDuration:0.55
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:searchVC animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}


@end
