//
//  StoreViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "StoreViewController.h"
#import "SearchViewController.h"

@interface StoreViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation StoreViewController

@synthesize pageViews = _pageViews;

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
	//-- Do any additional setup after loading the view.
    
    //-- set up view
    [self setViewWhenViewDidLoad];
    
    //-- set data
    [self setDataWhenViewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    
     self.screenName = @"Store Screen";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setViewWhenViewDidLoad
{
    [self customNavigationBar];
}

- (void)setDataWhenViewDidLoad
{
    //-- init data for tableview
    _arrCategories              = [NSMutableArray new];
    _datasource                 = [NSMutableArray new];
    _resultDataSource           = [NSMutableArray new];
    _indexSegmentSelected       = 0;
    _allowsReadCacheDataSource  = YES;
    _allowsLoadDataSource       = NO;
    
    //-- init arguments for api (page == 0)
    _currentPageOfLoadMore      = 0; //-- in a tableview, use for load more
    
    [self fetchingCategoriesForStore];
}

#pragma mark - UI

-(void) customNavigationBar
{
    [self setTitle:@"Store"];
    
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
    btnRight.frame= CGRectMake(15, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(searchForStore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barItemRight;
}



#pragma mark - Set up scrollview

//-- create page scroll
-(void) createPageScrollStore:(NSInteger)numberViews
{
    _scrollViewStore.contentSize = CGSizeMake(_scrollViewStore.frame.size.width * numberViews, _scrollViewStore.frame.size.height);
    _scrollViewStore.showsHorizontalScrollIndicator = NO;
    _scrollViewStore.showsVerticalScrollIndicator = NO;
    _scrollViewStore.alwaysBounceVertical = NO;
    _scrollViewStore.pagingEnabled = YES;
    _scrollViewStore.scrollsToTop = NO;
    
    //-- Set up the array to hold the views for each page
    _pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < numberViews; ++i)
    {
        [self.pageViews addObject:[NSNull null]];
    }
    
    //-- Set the scroll view's content size, autoscroll to the stating tableview
    [self setScrollViewContentSize:numberViews];
    [self setCurrentIndex:0];
    [self scrollToIndex:0];
}

-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = _scrollViewStore.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [_scrollViewStore scrollRectToVisible:frame animated:NO];
}


- (void)setScrollViewContentSize:(NSInteger)numberViews
{
    NSInteger pageCount = numberViews;
    if (pageCount == 0)
    {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(_scrollViewStore.frame.size.width * pageCount,
                             _scrollViewStore.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [_scrollViewStore setContentSize:size];
}

- (void)setCurrentIndex:(NSInteger)newIndex
{
    _indexSegmentSelected = newIndex;
    
    //-- change segmanet
    [_controlMenuTop setSelectedSegmentIndex:_indexSegmentSelected];
    
    _currentCategoryId = ((CategoryBySinger *)[_arrCategories objectAtIndex:_indexSegmentSelected]).categoryId;
    
    //-- reset datasource
    if ([_currentCategoryId isEqualToString:CATEGORY_ID_STORE_ALL])
        [self fetchingStoreWithoutCategory:_indexSegmentSelected];
    else
        //-- load data
        [self fetchingStoreWithCategory:_indexSegmentSelected];
    
}


//*******************************************************************************//
#pragma mark - Datasource

//-- get categories for store from DB
-(NSInteger) getAllCategoriesFromDB {
    
    NSInteger countData = 0;
    
    //-- read from cache
    _arrCategories = [VMDataBase getAllCategoryForContentType:ContentTypeIDStore];
    
    //-- set title for top menu
    if ([_arrCategories count] > 0)
    {
        countData = _arrCategories.count;
        
        if (!_controlMenuTop) {
            
            [self setTopMenuWithTitles:_arrCategories];
            [self createPageScrollStore:_arrCategories.count];
        }
        
    }else {
        
        _lblNoData.alpha = 1;
    }
    
    return countData;
}

//-- get categories for store
-(void)fetchingCategoriesForStore
{
    //-- get all categories from DB
   NSInteger countData = [self getAllCategoriesFromDB];
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) return;
    
    //-- check time
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesStoreCategoryRefreshTime;
    
    if (([Setting sharedSetting].milestonesStoreCategoryRefreshTime != 0) && (compeTime < [Setting sharedSetting].storeCategoryRefreshTime*60) && (countData > 0)) {
        return;
    }
    else
        [Setting sharedSetting].milestonesStoreCategoryRefreshTime = currentDate;
    
    
    if (![_activityIndicator isAnimating])
        [_activityIndicator startAnimating];
    
    [API getCategoryBySinger:SINGER_ID
               contentTypeId:ContentTypeIDStore
                       appID:PRODUCTION_ID
                  appVersion:PRODUCTION_VERSION
                   completed:^(NSDictionary *responseDictionary, NSError *error) {
                       
                       //-- stop indicator
                       if ([_activityIndicator isAnimating]){
                           [_activityIndicator stopAnimating];
                           _activityIndicator.hidden = YES;
                       }
                       
                       if (!error) {
                           [self createCategoriesFrom:responseDictionary];
                       }
                       
                   }];
}


-(void)createCategoriesFrom:(NSDictionary *)aDictionary
{
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
        //-- insert category: "tat ca"
        CategoryBySinger *aCategory         = [CategoryBySinger new];
        aCategory.contentTypeId             = [dictContentType objectForKey:@"content_type_id"];
        aCategory.categoryId                = CATEGORY_ID_STORE_ALL;
        aCategory.name                      = @"Tất cả";
        
        //-- insert into DB
        [VMDataBase insertCategoryBySinger:aCategory];
        
        
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
        }
        
        //-- get all categories from DB
        [self getAllCategoriesFromDB];
        
        //-- show line of segments
        _imgViewLineSegments.alpha = 1;
        
    }
}

/*
 * get store with category id
 */

-(void) fetchingStoreWithCategory:(NSInteger)index
{
    //-- reset datasource
    _currentCategoryId = ((CategoryBySinger *)[_arrCategories objectAtIndex:_indexSegmentSelected]).categoryId;
    
    if ([_datasource count] == 0 && _allowsReadCacheDataSource) //-- read cache
    {
        id tableview = [_arrTableviews objectAtIndex:_indexSegmentSelected];
        
        //-- remove lable no data
        [self removeLableNoDataFromTableView:tableview withIndex:_indexSegmentSelected];
        
        _datasource = [VMDataBase getAllStoreWithCategoryID:_currentCategoryId];
        
        if ([_datasource count] >0) {
            
            //-- remove lable nodata
            [self removeLableNoDataFrom:_scrollViewStore withIndex:index];
            
            //-- check and add tableview music
            id currentTableView = [self.pageViews objectAtIndex:index];
            
            if (NO == [currentTableView isKindOfClass:[TableStoreViewController class]]) {
                
                //-- Load the photo view.
                CGRect frame = _scrollViewStore.bounds;
                frame.origin.x = frame.size.width * index;
                frame.origin.y = 0.0f;
                frame = CGRectInset(frame, 0.0f, 0.0f);

                self.tableviewStore = [[TableStoreViewController alloc] init];
                self.tableviewStore.delegate = self;
                self.tableviewStore.view.backgroundColor = [UIColor clearColor];
                [self.tableviewStore.view setFrame:frame];
                [self.tableviewStore.view setTag:index];
                [self.tableviewStore.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                [self.tableviewStore.tableView setSeparatorColor:COLOR_SEPARATOR_CELL];
    
                self.tableviewStore.listStore  = _datasource;
                
                [_scrollViewStore addSubview:self.tableviewStore.view];
                [self.pageViews replaceObjectAtIndex:index withObject:self.tableviewStore];
                
            }
            else
            {
                self.tableviewStore = (TableStoreViewController *) currentTableView;
                self.tableviewStore.listStore = _datasource;
                [self.tableviewStore.tableView reloadData];
            }
        }
    }
    
    //-- get tableview All News in scrollview
    if (_scrollViewStore.subviews.count > 0)
    {
        self.tableviewStore.arrangeProduct = 0;
        for (UITableView *viewTB in _scrollViewStore.subviews)
        {
            
            if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == index)
            {
                //-- hidden loading
                [viewTB.infiniteScrollingView stopAnimating];
                
                break;
            }
        }
    }
    
    //-- load from api
    if (([_datasource count] == 0 || _allowsLoadDataSource))
    {
        //-- check Network
        BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
        if (!isErrorNetWork) return;
        
        if (![_activityIndicator isAnimating] && _currentPageOfLoadMore > 0)
            [_activityIndicator startAnimating];
        
        //-- request news async
        [API getNodeByCategoryForSingerWithContentTypeId:ContentTypeIDStore
                                                   limit:@"10"
                                                    page:[NSString stringWithFormat:@"%d",_currentPageOfLoadMore]
                                               isHotNode:@"0"
                                           isGetNodeBody:@"1"
                                              categoryId:_currentCategoryId
                                                  period:@""
                                                   start:@"-30"
                                                   appID:PRODUCTION_ID
                                              appVersion:PRODUCTION_VERSION
                                                  months:@""
                                               completed:^(NSDictionary *responseDictionary, NSError *error){
                                                   //-- parse json
                                                   [self createDataSourceWithCategoryIDFrom:responseDictionary atIndex:index];
                                                   
                                                    //-- stop indicator
                                                    [_activityIndicator stopAnimating];
                                                    _activityIndicator.hidden = YES;
                                               }];
    }
    
}

-(void)createDataSourceWithCategoryIDFrom:(NSDictionary *)aDictionary atIndex:(NSInteger)index
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrCategory = [dictData objectForKey:@"category_list"];
    
    if ([arrCategory count] > 0)
    {
        NSDictionary *dictSinger = [arrCategory objectAtIndex:0];
        
        //-- total news for categoryID
        _totalNews = [[dictSinger objectForKey:@"node_total"] integerValue];
        
        NSMutableArray *arrStore = [dictSinger objectForKey:@"node_list"];
        
        if ([arrStore count] > 0)
        {
            //-- delete cache
            if (_currentPageOfLoadMore == 0)
            {
                [VMDataBase deleteStoreWithCategoryID:_currentCategoryId];
                [_datasource removeAllObjects];
            }
            
            for (NSInteger i = 0; i < [arrStore count]; i++)
            {
                Store *aStore = [Store new];
                
                aStore.body                 = [[arrStore objectAtIndex:i] objectForKey:@"body"];
                aStore.cmsUserId            = [[arrStore objectAtIndex:i] objectForKey:@"cms_user_id"];
                aStore.code                 = [[arrStore objectAtIndex:i] objectForKey:@"code"];
                aStore.contentProviderId    = [[arrStore objectAtIndex:i] objectForKey:@"content_provider_id"];
                aStore.createdDate          = [[arrStore objectAtIndex:i] objectForKey:@"created_date"];
                aStore.idStore              = [[arrStore objectAtIndex:i] objectForKey:@"id"];
                aStore.isHot                = [[arrStore objectAtIndex:i] objectForKey:@"is_hot"];
                aStore.lastUpdate           = [[arrStore objectAtIndex:i] objectForKey:@"last_update"];
                aStore.name                 = [[arrStore objectAtIndex:i] objectForKey:@"name"];
                aStore.orderStore           = [[arrStore objectAtIndex:i] objectForKey:@"order"];
                aStore.phone                = [[arrStore objectAtIndex:i] objectForKey:@"phone"];
                aStore.priceUnit            = [[arrStore objectAtIndex:i] objectForKey:@"price_unit"];
                aStore.settingTotalView     = [[arrStore objectAtIndex:i] objectForKey:@"setting_total_view"];
                aStore.shortBody            = [[arrStore objectAtIndex:i] objectForKey:@"short_body"];
                aStore.snsTotalComment      = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_comment"];
                aStore.snsTotalDislike      = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_dislike"];
                aStore.snsTotalLike         = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_like"];
                aStore.snsTotalShare        = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_share"];
                aStore.snsTotalView         = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_view"];
                aStore.thumbnailImagePath   = [[arrStore objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
                aStore.thumbnailImageType   = [[arrStore objectAtIndex:i] objectForKey:@"thumbnail_image_type"];
                aStore.trueTotalView        = [[arrStore objectAtIndex:i] objectForKey:@"true_total_view"];
                aStore.categoryID           = _currentCategoryId;
                
                //-- insert into db
                [VMDataBase insertWithStore:aStore];
                
                //-- add to datasouce
                [_datasource addObject:aStore];
            }
            
        }
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:index];
        
        if (NO == [currentTableView isKindOfClass:[TableStoreViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = _scrollViewStore.bounds;
            frame.origin.x = frame.size.width * index;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            self.tableviewStore = [[TableStoreViewController alloc] init];
            self.tableviewStore.delegate = self;
            self.tableviewStore.view.backgroundColor = [UIColor clearColor];
            [self.tableviewStore.view setFrame:frame];
            [self.tableviewStore.view setTag:index];
            
            //-- add Refresh to tableview
            [self addRefreshAndLoadMoreForTableView:self.tableviewStore.tableView WithIndex:index];
            
            self.tableviewStore.listStore  = _datasource;
            
            [_scrollViewStore addSubview:self.tableviewStore.view];
            [self.pageViews replaceObjectAtIndex:index withObject:self.tableviewStore];
            
        }else{
            
            self.tableviewStore = (TableStoreViewController *)currentTableView;
            self.tableviewStore.listStore = _datasource;
            [self.tableviewStore.tableView reloadData];
        }
        
    }
    
    //-- change state loading
    _allowsLoadDataSource = NO;
    
    //-- get tableview All Video in scrollview
    if (_scrollViewStore.subviews.count > 0)
    {
        self.tableviewStore.arrangeProduct = 0;
        for (UITableView *viewTB in _scrollViewStore.subviews)
        {
            
            if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == index)
            {
                //-- hidden loading
                [viewTB.infiniteScrollingView stopAnimating];
                
                break;
            }
        }
    }
    
}


/*
 * get store without category
 */

-(void) fetchingStoreWithoutCategory:(NSInteger)index
{
    NSLog(@"%s", __func__);
    if ([_datasource count]==0 && _allowsReadCacheDataSource) //-- read cache
    {
        UITableView *currentTableview = [_arrTableviews objectAtIndex:_indexSegmentSelected];
        
        //-- remove lable no data
        [self removeLableNoDataFromTableView:currentTableview withIndex:_indexSegmentSelected];
        
        _datasource = [VMDataBase getAllStoreWithCategoryID:CATEGORY_ID_STORE_ALL];
        
        if ([_datasource count] > 0)
        {
            
            //-- remove lable nodata
            [self removeLableNoDataFrom:_scrollViewStore withIndex:index];
            
            //-- check and add tableview music
            id currentTableView = [self.pageViews objectAtIndex:index];
            
            if (NO == [currentTableView isKindOfClass:[TableStoreViewController class]])
            {
//                [_scrollViewStore setContentSize:CGSizeMake(_scrollViewStore.frame.size.width * 3, 500)];
//                [_scrollViewStore setFrame:CGRectMake(0, 46, 320, 1000)];
                
                //-- Load the photo view.
                CGRect frame = _scrollViewStore.bounds;
                frame.origin.x = frame.size.width * index;
                frame.origin.y = 0.0f;
                frame = CGRectInset(frame, 0.0f, 0.0f);

                self.tableviewStore = [[TableStoreViewController alloc] init];
                self.tableviewStore.delegate = self;
                self.tableviewStore.view.backgroundColor = [UIColor clearColor];
                [self.tableviewStore.view setFrame:frame];
                
                [self.tableviewStore.view setTag:index];
                
                self.tableviewStore.listStore  = _datasource;
                [_scrollViewStore addSubview:self.tableviewStore.view];
                [self.pageViews replaceObjectAtIndex:index withObject:self.tableviewStore];
                
            }
            else
            {
                self.tableviewStore = (TableStoreViewController *) currentTableView;
                self.tableviewStore.listStore = _datasource;
                [self.tableviewStore.tableView reloadData];
            }
        }
    }
    
    //-- get tableview All News in scrollview
    if (_scrollViewStore.subviews.count > 0)
    {
        self.tableviewStore.arrangeProduct = 0;
        for (UITableView *viewTB in _scrollViewStore.subviews)
        {
            
            if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == index)
            {
                //-- hidden loading
                [viewTB.infiniteScrollingView stopAnimating];
                break;
            }
        }
    }
    
    //-- load from api
    if (([_datasource count] == 0 || _allowsLoadDataSource))
    {
        //-- check Network
        BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
        if (!isErrorNetWork) return;
        
        if (![_activityIndicator isAnimating] && _currentPageOfLoadMore == 0)
            [_activityIndicator startAnimating];
        
        //-- request news async
        [API getNodeForSingerID:SINGER_ID
                  contentTypeId:ContentTypeIDStore
                          limit:@"10"
                           page:[NSString stringWithFormat:@"%d", _currentPageOfLoadMore]
                         period:@"1"
                      isHotNode:@"0"
                          start:@"-30"
                          appID:PRODUCTION_ID
                     appVersion:PRODUCTION_VERSION
                      completed:^(NSDictionary *responseDictionary, NSError *error) {
                          
                          [self createDataSourceWithoutCategory:responseDictionary];
                          
                          //-- stop indicator
                          if ([_activityIndicator isAnimating]){
                              _activityIndicator.hidden = YES;
                              [_activityIndicator stopAnimating];
                          }

                      }];
    }
    
}


-(void)createDataSourceWithoutCategory:(NSDictionary *)aDictionary
{
    if (!_datasource) {
        _datasource = [NSMutableArray new];
    }
    
    UITableView *currentTableview = [_arrTableviews objectAtIndex:_indexSegmentSelected];
    
    //-- remove lable no data
    [self removeLableNoDataFromTableView:currentTableview withIndex:_indexSegmentSelected];
    
    NSDictionary *dictData      = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger   = [dictData objectForKey:@"singer_list"];
    
    if ([arrSinger count] > 0)
    {
        NSDictionary *dictSinger = [arrSinger objectAtIndex:0];
        
        //-- total news for categoryID
        _totalNews = [[dictSinger objectForKey:@"node_total"] integerValue];
        
        NSMutableArray *arrStore = [dictSinger objectForKey:@"node_list"];
        
        if ([arrStore count] > 0)
        {
            //-- delete cache
            if (_currentPageOfLoadMore == 0)
            {
                [VMDataBase deleteStoreWithCategoryID:CATEGORY_ID_STORE_ALL];
                [_datasource removeAllObjects];
            }
            
            for (NSInteger i = 0; i < [arrStore count]; i++)
            {
                
                Store *aStore = [Store new];
                
                aStore.body                 = [[arrStore objectAtIndex:i] objectForKey:@"body"];
                aStore.cmsUserId            = [[arrStore objectAtIndex:i] objectForKey:@"cms_user_id"];
                aStore.code                 = [[arrStore objectAtIndex:i] objectForKey:@"code"];
                aStore.contentProviderId    = [[arrStore objectAtIndex:i] objectForKey:@"content_provider_id"];
                aStore.createdDate          = [[arrStore objectAtIndex:i] objectForKey:@"created_date"];
                aStore.idStore              = [[arrStore objectAtIndex:i] objectForKey:@"id"];
                aStore.isHot                = [[arrStore objectAtIndex:i] objectForKey:@"is_hot"];
                aStore.lastUpdate           = [[arrStore objectAtIndex:i] objectForKey:@"last_update"];
                aStore.name                 = [[arrStore objectAtIndex:i] objectForKey:@"name"];
                aStore.orderStore           = [[arrStore objectAtIndex:i] objectForKey:@"order"];
                aStore.phone                = [[arrStore objectAtIndex:i] objectForKey:@"phone"];
                aStore.priceUnit            = [[arrStore objectAtIndex:i] objectForKey:@"price_unit"];
                aStore.settingTotalView     = [[arrStore objectAtIndex:i] objectForKey:@"setting_total_view"];
                aStore.shortBody            = [[arrStore objectAtIndex:i] objectForKey:@"short_body"];
                aStore.snsTotalComment      = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_comment"];
                aStore.snsTotalDislike      = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_dislike"];
                aStore.snsTotalLike         = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_like"];
                aStore.snsTotalShare        = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_share"];
                aStore.snsTotalView         = [[arrStore objectAtIndex:i] objectForKey:@"sns_total_view"];
                aStore.thumbnailImagePath   = [[arrStore objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
                aStore.thumbnailImageType   = [[arrStore objectAtIndex:i] objectForKey:@"thumbnail_image_type"];
                aStore.trueTotalView        = [[arrStore objectAtIndex:i] objectForKey:@"true_total_view"];
                aStore.categoryID           = CATEGORY_ID_STORE_ALL;
                
                //-- insert into db
                [VMDataBase insertWithStore:aStore];
                
                //-- add to datasouce
                [_datasource addObject:aStore];
            }
            
            //-- check and add tableview music
            id currentTableView = [self.pageViews objectAtIndex:_indexSegmentSelected];
            
            if (NO == [currentTableView isKindOfClass:[TableStoreViewController class]]) {
                
                //-- Load the photo view.
                CGRect frame = _scrollViewStore.bounds;
                frame.origin.x = frame.size.width * _indexSegmentSelected;
                frame.origin.y = 0.0f;
                frame = CGRectInset(frame, 0.0f, 0.0f);
                
                self.tableviewStore = [[TableStoreViewController alloc] init];
                self.tableviewStore.delegate = self;
                self.tableviewStore.view.backgroundColor = [UIColor clearColor];
                [self.tableviewStore.view setFrame:frame];
                [self.tableviewStore.view setTag:_indexSegmentSelected];
                
                self.tableviewStore.listStore  = _datasource;
                
                //-- add Refresh to tableview
                [self addRefreshAndLoadMoreForTableView:self.tableviewStore.tableView WithIndex:_indexSegmentSelected];
                
                [_scrollViewStore addSubview:self.tableviewStore.view];
                [self.pageViews replaceObjectAtIndex:_indexSegmentSelected withObject:self.tableviewStore];
                
            }
            else
            {
                self.tableviewStore = (TableStoreViewController *) currentTableView;
                self.tableviewStore.listStore = _datasource;
                [self.tableviewStore.tableView reloadData];
            }
            
        }else {
            
            //-- Load the photo view.
            CGRect frame = [_scrollViewStore frame];
            frame.origin.x = 0.0f;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            //-- add lable no data
            [self addLableNoDataToTableView:currentTableview withIndex:_indexSegmentSelected withFrame:frame byTitle:TITLE_NoData_Default];
        }
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [_scrollViewStore frame];
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable no data
        [self addLableNoDataToTableView:currentTableview withIndex:_indexSegmentSelected withFrame:frame byTitle:TITLE_NoData_Default];
    }
    
    //-- change state loading
    _allowsLoadDataSource = NO;
    
    //-- get tableview All News in scrollview
    if (_scrollViewStore.subviews.count > 0)
    {
        self.tableviewStore.arrangeProduct = 0;
        for (UITableView *viewTB in _scrollViewStore.subviews)
        {
            
            if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == _indexSegmentSelected)
            {
                
                //-- hidden loading
                [viewTB.infiniteScrollingView stopAnimating];
                
                [viewTB reloadData];
                
                break;
            }
        }
    }
    
}


-(void)loadMoreStoreAtIndex:(NSInteger)index
{
    //-- check time
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger compeTime = currentDate - [[Setting sharedSetting] milestonesStoreRefreshTimeForCategoryId:_currentCategoryId];
    
    if (([[Setting sharedSetting] milestonesStoreRefreshTimeForCategoryId:_currentCategoryId] != 0) && (compeTime < [Setting sharedSetting].storeRefreshTime*60)) {
        
        if (_scrollViewStore.subviews.count > 0)
        {
            self.tableviewStore.arrangeProduct = 0;
            for (UITableView *viewTB in _scrollViewStore.subviews) {
                
                if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == _indexSegmentSelected) {
                    
                    //-- hidden loading
                    [viewTB.infiniteScrollingView stopAnimating];
                    
                    break;
                }
            }
        }
        return;
    }
    else
        [[Setting sharedSetting] setMilestonesStoreRefreshTime:currentDate categoryId:_currentCategoryId];
        
    //-- change state to loading api.
    _allowsLoadDataSource = YES;
    
    if (_totalNews == 0) {
        
        if ([_currentCategoryId isEqualToString:CATEGORY_ID_STORE_ALL])
            [self fetchingStoreWithoutCategory:index];
        else
            [self fetchingStoreWithCategory:index];
    }
    else if (_totalNews > 0 && [_datasource count] < _totalNews)
    {
        _currentPageOfLoadMore++;
        if ([_currentCategoryId isEqualToString:CATEGORY_ID_STORE_ALL])
            [self fetchingStoreWithoutCategory:index];
        else
            [self fetchingStoreWithCategory:index];
    }
    else{
        //-- get tableview All News in scrollview
        if (_scrollViewStore.subviews.count > 0)
        {
            self.tableviewStore.arrangeProduct = 0;
            for (UITableView *viewTB in _scrollViewStore.subviews) {
                
                if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == _indexSegmentSelected)
                {
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
    //-- refresh data
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:aTableview];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    
    //-- load more from bottom
    __weak StoreViewController *myself = self;
    
    //  -- setup infinite scrolling
    [aTableview addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreStoreAtIndex:byIndex];
    }];
}


-(void) setTopMenuWithTitles:(NSMutableArray *)categories
{
    //-- hidden label nodata
    _lblNoData.alpha = 0;
    
    NSMutableArray *listNameCategories = [categories valueForKey:@"name"];
    //-- Segmented control with scrolling
    _controlMenuTop = [[HMSegmentedControlOriginal alloc] initWithSectionTitles:listNameCategories];
    _controlMenuTop.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _controlMenuTop.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _controlMenuTop.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _controlMenuTop.scrollEnabled = YES;
    _controlMenuTop.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [_controlMenuTop setFrame:CGRectMake(0, 0 , 320, 45)];
    [_controlMenuTop addTarget:self action:@selector(segmentedControlChangedStoreValue:) forControlEvents:UIControlEventValueChanged];
    [_controlMenuTop setFont:[UIFont systemFontOfSize:16]];
    _controlMenuTop.backgroundColor = [UIColor whiteColor];
    _controlMenuTop.textColor = [UIColor grayColor];
    _controlMenuTop.selectedTextColor = [UIColor blackColor];
    _controlMenuTop.selectionIndicatorHeight = 5;
    
    [self.view addSubview:_controlMenuTop];
    [UIView view:_scrollViewStore setY:46];
    [UIView view:_scrollViewStore setHeight:_scrollViewStore.frame.size.height - 46];//longnh fix bug
}


//-- segment category Selected
- (void)segmentedControlChangedStoreValue:(HMSegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex != _indexSegmentSelected) {
        
        _indexSegmentSelected = segmentedControl.selectedSegmentIndex;
        _currentCategoryId = ((CategoryBySinger *)[_arrCategories objectAtIndex:_indexSegmentSelected]).categoryId;
        _allowsReadCacheDataSource = YES;
        _currentPageOfLoadMore = 0;
        [_datasource removeAllObjects];
        
        [self setCurrentIndex:segmentedControl.selectedSegmentIndex];
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
    }
}


- (void) changeCategoryWithPage:(NSInteger)page
{
    _controlMenuTop.selectedSegmentIndex = page;
    _indexSegmentSelected = page;
    
    _currentCategoryId = ((CategoryBySinger *)[_arrCategories objectAtIndex:_indexSegmentSelected]).categoryId;
    _allowsReadCacheDataSource = YES;
    _currentPageOfLoadMore = 0;
    [_datasource removeAllObjects];
    
    //-- reset datasource
    if ([_currentCategoryId isEqualToString:CATEGORY_ID_STORE_ALL])
        [self fetchingStoreWithoutCategory:page];
    else
        [self fetchingStoreWithCategory:page];
}



#pragma mark - scrollview delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
    
    if (_indexSegmentSelected != page) {
        
        [self changeCategoryWithPage:page];
    }
}


-(void) refreshData:(ODRefreshControl *) refreshControl
{
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger compeTime = currentDate - [[Setting sharedSetting] milestonesStoreRefreshTimeForCategoryId:_currentCategoryId];
    if (([[Setting sharedSetting] milestonesStoreRefreshTimeForCategoryId:_currentCategoryId] != 0) && (compeTime < [Setting sharedSetting].storeRefreshTime *60)) {
        
        [refreshControl endRefreshing];
        return;
    }
    else
        [[Setting sharedSetting] setMilestonesStoreRefreshTime:currentDate categoryId:_currentCategoryId];
    
    //-- change state to loading api
    _allowsLoadDataSource = YES;
    _currentPageOfLoadMore = 0;
    
    [refreshControl beginRefreshing];
    
    if ([_currentCategoryId isEqualToString:CATEGORY_ID_STORE_ALL])
        [self fetchingStoreWithoutCategory:_indexSegmentSelected];
    else
        [self fetchingStoreWithCategory:_indexSegmentSelected];
    
    [refreshControl endRefreshing];
}


//*******************************************************************************//
#pragma mark - TableStoreViewControllerDelegate

-(void)goToDetailStoreViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    StoreDetailViewController *detailStoreVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbStoreDetailViewControllerId"];
    
    Store *aStore = (Store *)[listData objectAtIndex:indexRow];
    NSInteger currentIndex = [listData indexOfObject:aStore];
    
    detailStoreVC.store             = aStore;
    detailStoreVC.currentIndex      = currentIndex;
    detailStoreVC.arrStore          = listData;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:detailStoreVC animated:YES];
    else
        [self.navigationController pushViewController:detailStoreVC animated:NO];
}



#pragma mark - search

-(void)searchNews:(id)sender
{
    // NSLog(@"searchNews");
}


- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.name contains[cd] %@",
                                    searchText];
    
    _resultDataSource = [_datasource filteredArrayUsingPredicate:resultPredicate];
    
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
   
    return YES;
}


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:NO animated:YES];
    [self hiddenSearchBar];
    return YES;
}


- (void) hiddenSearchBar
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchDisplayController.searchContentsController.navigationController setNavigationBarHidden:NO];
        self.searchDisplayController.searchBar.alpha = 0;
        
        [UIView view:self.searchDisplayController.searchBar setY:0];
        
        
    }];
    
    id currentTableView = (UITableView *)[_arrTableviews objectAtIndex:_indexSegmentSelected];
    [currentTableView reloadData];;
}

-(void) showSearchBar
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchDisplayController.searchContentsController.navigationController setNavigationBarHidden:NO];
        self.searchDisplayController.searchBar.alpha = 1;
       
        [UIView view:self.searchDisplayController.searchBar setY:47];
    }];
}



#pragma mark - actions

-(void) showComments:(id)sender
{
    NSLog(@"show all comment for New");
}


-(void)back:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


//********************************************************************************//
#pragma mark - Search Store

- (void)searchForStore:(id)sender
{
    SearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idSearchViewControllerSb"];
    searchVC.searchtype = searchStoreType;
    
    [UIView animateWithDuration:0.55
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:searchVC animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}


@end
