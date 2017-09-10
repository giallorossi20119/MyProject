//
//  MainViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/3/13.
//  Copyright MAC_OSX 2013. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSMutableArray *pageViewsTab;
@property (nonatomic,assign) BOOL isLoading;

@end

@implementation MainViewController

@synthesize viewFunctionFirst, viewFunctionSecond, viewTab, viewFunction;
@synthesize scrollImage, scrollTotal,scrollPageTab;
@synthesize pageCtrImage, pageCtrFunction;
@synthesize pageViews = _pageViews;
@synthesize delegate = _delegate;
@synthesize pageViewsTab = _pageViewsTab;
@synthesize listSchedule,listNews,listStore;

#pragma mark - Main

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screenCode = HOME_SCREEN;
    
    isCallingAPI = false;
    bigScrollAnimating = false;
    scrollImage.alpha = 0;
    _rootSegmentY = viewTab.frame.origin.y;
    
    // Do any additional setup after loading the view, typically from a nib.
    [self performSelectorOnMainThread:@selector(getData) withObject:self waitUntilDone:YES];
    
    //-- setup view
    [self setViewWhenViewDidLoad];
    
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    //-- load photo album
    [self setDataWhenViewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Xin vui lòng đợi..."]; //to give the attributedTitle
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [scrollTotal addSubview:refreshControl];
}

-(void) getData
{
    //-- request Feeds
    [API getFeedofSingerID:PRODUCTION_ID
         productionVersion:PRODUCTION_VERSION
                  singerId:SINGER_ID completed:^(NSDictionary *responseDictionary, NSError *error)
     {
         //-- fetching
         [self getDatasourceFeedsWith:responseDictionary];
     }];
    
    //-- request Calendar
    [API getAllMusicAndVideoOfSinglerID:SINGER_ID
                          contentTypeId:ContentTypeIDSchedule
                                  limit:@"100"
                                   page:[NSString stringWithFormat:@"%d",0]
                              isHotNode:@"0"
                                 months:@"6"
                                  appID:PRODUCTION_ID
                             appVersion:PRODUCTION_VERSION
                              completed:^(NSDictionary *responseDictionary, NSError *error)
     {
         
         if (responseDictionary && !error)
         {
             [self createDataSourceAllScheduleFrom:responseDictionary byIndex:0];
         }
     }];
    
    //-- request Production
    [API getNodeForSingerID:SINGER_ID
              contentTypeId:ContentTypeIDStore
                      limit:@"10"
                       page:[NSString stringWithFormat:@"%d", 0]
                     period:@"1"
                  isHotNode:@"0"
                      start:@"-30"
                      appID:PRODUCTION_ID
                 appVersion:PRODUCTION_VERSION
                  completed:^(NSDictionary *responseDictionary, NSError *error) {
                      
                      [self createDataSourceWithoutCategory:responseDictionary];
                  }];
}

-(void)goToHome
{
    if (screenCode != HOME_SCREEN)
    {
        MainViewController *mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ID_MainViewController"];
        [self.navigationController pushViewController:mVC animated:NO];
        screenCode = HOME_SCREEN;
    }
}

-(void)goToChat
{
    if (screenCode != CHAT_SCREEN)
    {
        FanZoneViewController *fVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbIDFanZoneViewController"];
        [self.navigationController pushViewController:fVC animated:NO];
        screenCode = CHAT_SCREEN;
    }
}

-(void)goToMedia
{
//    if (screenCode != MEDIA_SCREEN)
//    {
//        VideoViewController *vVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbIDVideoViewController"];
//        [self.navigationController pushViewController:vVC animated:NO];
//        screenCode = MEDIA_SCREEN;
//    }
}

-(void)goToMusic
{
//    if (screenCode != MUSIC_SCREEN)
//    {
//        MusicHomeViewController *mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idMusicHomeViewControllerSb"];
//        [self.navigationController pushViewController:mVC animated:NO];
//        screenCode = MUSIC_SCREEN;
//    }
}

-(void)goToNews
{
    if (screenCode != NEWS_SCREEN)
    {
        NewsViewController *nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idNewsViewControllerSb"];
        [self.navigationController pushViewController:nVC animated:NO];
        screenCode = NEWS_SCREEN;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToHome) name:@"showHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToChat) name:@"showChat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToMedia) name:@"showMedia" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToMusic) name:@"showMusic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToNews) name:@"showNews" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeGetMoreData) name:@"getMoreCompleted" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    //bottom bar check
//    [self addBottomBarBaseViewController];
    
    _allowcreate = NO;
    self.screenName = @"Main Screen";
    [super viewWillAppear:animated];
    
    //--hidden navigation and tabbar
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setToolbarHidden:YES animated:NO];

    //-- fetching News
    [self fetchingNewsHost];
    
    //Them phan reset page o day
    NSString *keyCurrentPage;
    if ([_arrCategories count] > 0) {
        for (int i=0; i<[_arrCategories count]-1; i++) {
            NSString *cateId = [NSString stringWithFormat:@"%ld",(long)checkTabValue];
            keyCurrentPage = [NSString stringWithFormat:@"CurrentPage_%@",cateId];
            NSUserDefaults *defaultCurrentPageById = [NSUserDefaults standardUserDefaults];
            
            if ([defaultCurrentPageById valueForKey:keyCurrentPage]) {
                [defaultCurrentPageById setValue:@"0" forKey:keyCurrentPage];
                [defaultCurrentPageById synchronize];
            }
        }
        
        //-- set title for top menu
//        [self getHomeNewsDataFromDataBaseByIndex:(int)checkTabValue];
    }
    
    //-- set auto scroll image
    if (_dataSourceAlbum.count > 0)
    {
        [self.timerAuto invalidate];
        self.timerAuto = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(onTimer)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

//-- fetching Tab Function
-(void) setTabFunction
{
    NSLog(@"%s", __func__);

    _arrCategories = [NSMutableArray arrayWithObjects:@"Feed",@"Event",@"Market", nil];
    //-- Segmented control with scrolling
    _controlMenuTab = [[HMSegmentedControlOriginal alloc] initWithSectionTitles:_arrCategories];
    _controlMenuTab.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _controlMenuTab.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _controlMenuTab.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _controlMenuTab.scrollEnabled = YES;
    _controlMenuTab.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [_controlMenuTab setFrame:CGRectMake(0, 0 , 320, 40)];
    [_controlMenuTab addTarget:self action:@selector(segmentedTabChangedValue:) forControlEvents:UIControlEventValueChanged];
    [_controlMenuTab setFont:[UIFont boldSystemFontOfSize:18]];
    _controlMenuTab.backgroundColor = [UIColor whiteColor];
    _controlMenuTab.textColor = [UIColor grayColor];
    _controlMenuTab.selectedTextColor = [UIColor blackColor];
    _controlMenuTab.selectionIndicatorHeight = 2;
    _controlMenuTab.selectionIndicatorColor = [UIColor redColor];
    
    [self.viewTab addSubview:_controlMenuTab];
}

//-- segment category Selected
- (void)segmentedTabChangedValue:(HMSegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex != _currentIndex)
    {
        checkTabValue = segmentedControl.selectedSegmentIndex;
        [self setCurrentIndex:segmentedControl.selectedSegmentIndex];
        _currentIndex = segmentedControl.selectedSegmentIndex;
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
        _indexSegmentSelected = _currentIndex;
        CGFloat pageWidth = scrollPageTab.frame.size.width;
        CGFloat offsetX = pageWidth * _currentIndex;
        [scrollPageTab setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    }
}

-(void)scrollToIndex:(NSInteger)index
{
    _allowcreate = NO;
    CGRect frame = scrollPageTab.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [scrollPageTab scrollRectToVisible:frame animated:YES];
}

- (void)setCurrentIndex:(NSInteger)newIndex
{
    _currentIndex = newIndex;
    _currentCategoryId = [NSString stringWithFormat:@"%ld",(long)checkTabValue];
    
    //-- change seagment
    [_controlMenuTab setSelectedSegmentIndex:_currentIndex];
    
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
    [self fetchingFeedsWithCategory:_currentIndex];
}

//-- setup view
-(void) setViewWhenViewDidLoad
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"vao did scroll %f",scrollTotal.contentOffset.y);
    // Update the page when more than 50% of the previous/next page is visible for scrollImage
    CGFloat pageWidth = self.scrollImage.frame.size.width;
    int page = floor((self.scrollImage.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageCtrImage.currentPage = page;
    
    if (scrollView == scrollTotal)
    {
        NSLog(@"totalScrollview - scrollViewDidScroll: %f - %f", scrollView.contentOffset.y, viewTab.frame.origin.y);
        
        if (scrollView.contentOffset.y < 210)
        {
            CGRect fr = viewTab.frame;
            fr.origin.y = _rootSegmentY - scrollView.contentOffset.y;
            viewTab.frame = fr;
            NSLog(@"toa do viewsegment x= %f y= %f",viewTab.frame.origin.x,viewTab.frame.origin.y);
        }
        else
        {
            CGRect fr = viewTab.frame;
            fr.origin.y = scrollTotal.frame.origin.y;
            viewTab.frame = fr;
            NSLog(@"toa do viewsegment x= %f y= %f",viewTab.frame.origin.x,viewTab.frame.origin.y);
        }
    }
    
//    if (scrollView == scrollImage)
//    {
//        [self.timerAuto invalidate];
//    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"did end scrolling animation");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"did end dragging");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"begin dragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"did end decel");
    
    if (scrollView == scrollImage)
    {
        [self.timerAuto invalidate];
        self.timerAuto = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(onTimer)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    
    if (scrollView == scrollPageTab)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = floor(fractionalPage);
        if (page != _currentIndex)
        {
            [self removeView:400];
            checkTabValue = page;
            [self setCurrentIndex:page];
        }
    }
    
//    if ([scrollView viewWithTag:5000] && scrollView == scrollTotal)
//    {
//        UIView *view = (UIView*)[scrollView viewWithTag:5000];
//        [view removeFromSuperview], view = nil;
//    }
    
    if (scrollView == scrollTotal)
    {
//        [scrollView addSubview:viewloader];
//        viewloader.hidden = NO;
    }
}

-(void)callForMoreData
{
    alertGetMore = [[UIAlertView alloc] initWithTitle: @"Loading..." message: nil delegate:self cancelButtonTitle: nil otherButtonTitles: nil];
    UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(125, 50, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [alertGetMore addSubview: progress];
    [progress startAnimating];
    [alertGetMore show];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"getMoreCompleted" object:nil];
}

-(void)closeGetMoreData
{
    [alertGetMore dismissWithClickedButtonIndex:0 animated:YES];
    
    if (_currentIndex == 0)
    {
        [self removeView:5000];
        
        viewNoData = [[UIView alloc] initWithFrame:CGRectMake(0, viewloader1.frame.origin.y, 320, 50)];
        UILabel *lblloader = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 50.0)];
        lblloader.backgroundColor = [UIColor clearColor];
        lblloader.textColor = [UIColor lightGrayColor];
        lblloader.textAlignment = NSTextAlignmentCenter;
        lblloader.text = @"Không còn dữ liệu !";
        [viewNoData addSubview:lblloader];
        viewNoData.tag = 400;
        [scrollPageTab addSubview:viewNoData];
        viewloader1 = nil;
    }
    else if (_currentIndex == 1)
    {
        [self removeView:5001];
        
        viewNoData = [[UIView alloc] initWithFrame:CGRectMake(320, viewloader2.frame.origin.y, 320, 50)];
        UILabel *lblloader = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 50.0)];
        lblloader.backgroundColor = [UIColor clearColor];
        lblloader.textColor = [UIColor lightGrayColor];
        lblloader.textAlignment = NSTextAlignmentCenter;
        lblloader.text = @"Không còn dữ liệu !";
        [viewNoData addSubview:lblloader];
        viewNoData.tag = 400;
        [scrollPageTab addSubview:viewNoData];
        viewloader2 = nil;
    }
    else
    {
        [self removeView:5002];
        
        viewNoData = [[UIView alloc] initWithFrame:CGRectMake(640, viewloader3.frame.origin.y, 320, 50)];
        UILabel *lblloader = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 50.0)];
        lblloader.backgroundColor = [UIColor clearColor];
        lblloader.textColor = [UIColor lightGrayColor];
        lblloader.textAlignment = NSTextAlignmentCenter;
        lblloader.text = @"Không còn dữ liệu !";
        [viewNoData addSubview:lblloader];
        viewNoData.tag = 400;
        [scrollPageTab addSubview:viewNoData];
        viewloader3 = nil;
    }
}

-(void)removeView:(NSInteger)tagNo
{
    UIView *view = (UIView*)[scrollPageTab viewWithTag:tagNo];
    [view removeFromSuperview], view = nil;
}

//-- load photo album
-(void) setDataWhenViewDidLoad
{
    //-- init data for tableview
    isSelectedFanZone = NO;
    isCallingAPI = NO;

    _currentPage = 0;
    _isCacheDataSourceAlbum = YES;
    
    _allowsReadCacheCategory    = YES;
    _allowsReadCacheDataSource  = YES;
    _allowsLoadDataSource       = NO;
    
    //--alloc data
    arrAlbums = [[NSMutableArray alloc] init];
    _dataSourceAlbum = [[NSMutableArray alloc] init];
    _arrCategories              = [NSMutableArray new];
    _dataSourceFeeds            = [NSMutableArray new];
    _indexSegmentSelected       = 0;
    
    //-- fetching Photo album
    [self fetchingPhotoAlbum];
    
    //-- fetching Tab Function
    [self setTabFunction];
    [self createHomeTabPageScrollNews:_arrCategories.count];
    
    [self fetchingCategoriesForHome];
    
    scrollTotal.scrollEnabled = YES;
}

//-- go to Fanzone
-(void) goingtoFanZoneScreen:(NSNotification *) notification {
    
    BOOL isExistFanzoneVC = NO;
    
    for (int i = 0; i< self.navigationController.viewControllers.count; i++) {
        
        UIViewController *fanZoneVC = [self.navigationController.viewControllers objectAtIndex:i];
        
        if ([fanZoneVC isKindOfClass:[FanZoneViewController class]]) {
            
            //-- exist
            isExistFanzoneVC = YES;
            
            break;
        }
    }
    
    if (isExistFanzoneVC == NO) {
        
        //-- set invalidate timerAuto
        [self.timerAuto invalidate];
        
        FanZoneViewController *fzVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbIDFanZoneViewController"];
        fzVC._currentIndex = [notification.object integerValue];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
            [self.navigationController pushViewController:fzVC animated:YES];
        else
            [self.navigationController pushViewController:fzVC animated:NO];
    }
}

//-- go to Music Home when selected button Play
-(void) goingtoMusicHomeScreen {
    
    BOOL isExistMusicHomeVC = NO;
    
    for (int i = 0; i< self.navigationController.viewControllers.count; i++) {
        
        UIViewController *musicHomeVC = [self.navigationController.viewControllers objectAtIndex:i];
        
        if ([musicHomeVC isKindOfClass:[MusicHomeViewController class]]) {
            
            //-- exist
            isExistMusicHomeVC = YES;
            
            break;
        }
    }
    
    if (isExistMusicHomeVC == NO) {
        
        //-- set invalidate timerAuto
        [self.timerAuto invalidate];
        
        MusicHomeViewController *mhVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idMusicHomeViewControllerSb"];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
            [self.navigationController pushViewController:mhVC animated:YES];
        else
            [self.navigationController pushViewController:mhVC animated:NO];
    }
}

- (void)loadScrollImage
{
    [scrollImage scrollRectToVisible:CGRectMake(0,0, scrollImage.frame.size.width, scrollImage.frame.size.height) animated:NO];
    scrollImage.showsHorizontalScrollIndicator = NO;
    scrollImage.showsVerticalScrollIndicator = NO;
    scrollImage.alwaysBounceVertical = NO;
    scrollImage.pagingEnabled = YES;
    
    if (_dataSourceAlbum.count >= 5)
    {
        for (NSInteger i = 0; i < 5; i ++)
        {
            NSString *imagePath = ((MusicAlbum *)[_dataSourceAlbum objectAtIndex:i]).thumbImagePath;
            [self addImageWithName:imagePath atPosition:(int)i];
        }
        
        //-- set number of pages
        pageCtrImage.numberOfPages = 5;
        scrollImage.contentSize = CGSizeMake(5 * scrollImage.frame.size.width, scrollImage.frame.size.height);
        
        //-- set auto scroll image
        if (!self.timerAuto)
        {
            self.timerAuto = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                              target:self
                                                            selector:@selector(onTimer)
                                                            userInfo:nil
                                                             repeats:YES];
        }
        
    }else{
        
        if (_dataSourceAlbum.count > 0)
        {
            for (NSInteger i = 0; i < _dataSourceAlbum.count; i ++)
            {
                NSString *imagePath = ((MusicAlbum *)[_dataSourceAlbum objectAtIndex:i]).thumbImagePath;
                [self addImageWithName:imagePath atPosition:(int)i];
            }
            
            //-- set number of pages
            pageCtrImage.numberOfPages = _dataSourceAlbum.count;
            scrollImage.contentSize = CGSizeMake(_dataSourceAlbum.count * scrollImage.frame.size.width, scrollImage.frame.size.height);
            
            //-- set auto scroll image
            if (!self.timerAuto)
            {
                self.timerAuto = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                                  target:self
                                                                selector:@selector(onTimer)
                                                                userInfo:nil
                                                                 repeats:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Call Feed API

-(void) getDatasourceFeedsWith:(NSDictionary *)aDictionary
{
    NSMutableArray *arrNewsFeed = [aDictionary objectForKey:@"data"];
    
    if ([arrNewsFeed count] > 0)
    {
        //-- delete cache
        if (_currentPage == 0)
        {
            [VMDataBase deleteAllFeedsFromDB];
            [VMDataBase deleteAllPhotoFeedsFromDB];
            [_dataSourceFeeds removeAllObjects];
        }
                
        for (NSInteger i = 0; i < [arrNewsFeed count]; i++)
        {
            ListFeedData *aFeeds = [ListFeedData new];
            
            aFeeds.feedType = [[arrNewsFeed objectAtIndex:i] objectForKey:@"type_id"];
            aFeeds.feedUserName = [[arrNewsFeed objectAtIndex:i] objectForKey:@"full_name"];
            aFeeds.feedUserImage = [[arrNewsFeed objectAtIndex:i] objectForKey:@"user_image"];
            aFeeds.feedTitle = [[arrNewsFeed objectAtIndex:i] objectForKey:@"title"];
            aFeeds.feedParentId = [[arrNewsFeed objectAtIndex:i] objectForKey:@"parent_user_id"];
            aFeeds.feedTimeStamp = [[arrNewsFeed objectAtIndex:i] objectForKey:@"time_stamp"];
            aFeeds.feedTimeUpdate = [[arrNewsFeed objectAtIndex:i] objectForKey:@"time_update"];
            
            NSDictionary *arrFeedData = [[arrNewsFeed objectAtIndex:i] objectForKey:@"feed_data"];
            //--Type of feed data content
            
            //page comment
            if ([aFeeds.feedType  isEqual: @"pages_comment"])
            {
                aFeeds.feedId = [arrFeedData objectForKey:@"feed_comment_id"];
                aFeeds.snsTotalComment = [arrFeedData objectForKey:@"total_comment"];
                aFeeds.snsTotalLike = [arrFeedData objectForKey:@"total_like"];
                aFeeds.snsTotalShare = [arrFeedData objectForKey:@"total_share"];
                aFeeds.snsTotalView = [arrFeedData objectForKey:@"total_view"];
            }
            
            //link
            if ([aFeeds.feedType  isEqual: @"link"])
            {
                aFeeds.feedId = [arrFeedData objectForKey:@"link_id"];
                aFeeds.feedLink = [arrFeedData objectForKey:@"link"];
                aFeeds.feedImage = [arrFeedData objectForKey:@"image"];
                aFeeds.feedDescription = [arrFeedData objectForKey:@"description"];
                aFeeds.snsTotalComment = [arrFeedData objectForKey:@"total_comment"];
                aFeeds.snsTotalLike = [arrFeedData objectForKey:@"total_like"];
                aFeeds.snsTotalShare = [arrFeedData objectForKey:@"total_share"];
                aFeeds.snsTotalView = [arrFeedData objectForKey:@"total_view"];
            }
            
            //video
            if ([aFeeds.feedType  isEqual: @"video"])
            {
                aFeeds.feedId = [arrFeedData objectForKey:@"video_id"];
                aFeeds.feedLink = [arrFeedData objectForKey:@"link"];
                aFeeds.feedImage = [arrFeedData objectForKey:@"thumbnail"];
                aFeeds.videoURL = [arrFeedData objectForKey:@"youtube_url"];
                aFeeds.snsTotalComment = [arrFeedData objectForKey:@"total_comment"];
                aFeeds.snsTotalLike = [arrFeedData objectForKey:@"total_like"];
                aFeeds.snsTotalShare = [arrFeedData objectForKey:@"total_share"];
                aFeeds.snsTotalView = [arrFeedData objectForKey:@"total_view"];
            }
            
            //photo
            if ([aFeeds.feedType isEqual: @"photo"])
            {
                aFeeds.feedId = [arrFeedData objectForKey:@"album_id"];
                aFeeds.photoList = [arrFeedData objectForKey:@"photo_list"];
                aFeeds.NoPhoto = [aFeeds.photoList count];
                aFeeds.albumId = [arrFeedData objectForKey:@"album_id"];
                
                for (NSInteger j=0; j<[aFeeds.photoList count]; j++)
                {
                    PhotoListFeedData *pListData = [[PhotoListFeedData alloc]init];
                    pListData.albumId = aFeeds.albumId;
                    pListData.photoId = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"photo_id"];
                    pListData.photoTitle = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"title"];
                    pListData.imagePath = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"destination"];
                    pListData.photoDescription = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"description"];
                    pListData.snsTotalLike = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_like"];
                    pListData.snsTotalComment = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_comment"];
                    pListData.snsTotalShare = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_share"];
                    pListData.snsTotalView = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_view"];
                    pListData.indexcell = [NSString stringWithFormat:@"%ld",(long)i];
                    
                    if ([aFeeds.albumId isEqual:@"0"])
                    {
                        aFeeds.snsTotalComment = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_comment"];
                        aFeeds.snsTotalLike = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_like"];
                        aFeeds.snsTotalShare = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_share"];
                        aFeeds.snsTotalView = [[aFeeds.photoList objectAtIndex:j]objectForKey:@"total_view"];
                    }
                    else
                    {
                        aFeeds.snsTotalComment = [arrFeedData objectForKey:@"total_comment"];
                        aFeeds.snsTotalLike = [arrFeedData objectForKey:@"total_like"];
                        aFeeds.snsTotalShare = [arrFeedData objectForKey:@"total_share"];
                        aFeeds.snsTotalView = [arrFeedData objectForKey:@"total_view"];
                    }
                    
                    //-- insert into DB
                    [VMDataBase insertPhotoListFeedBySinger:pListData];
                }                
            }
            
            //is like
            aFeeds.isLiked = [arrFeedData objectForKey:@"is_liked"];
            [_dataSourceFeeds addObject:aFeeds];
            
            //-- insert into DB
            [VMDataBase insertFeedBySinger:aFeeds];
        }
    }
}

#pragma mark - Call API

-(void) fetchingNewsHost {
    NSLog(@"%s", __func__);

   //-- request new news async
    [API getNodeForSingerID:SINGER_ID
              contentTypeId:16
                      limit:@"5"
                       page:@"0"
                     period:@""
                  isHotNode:@"0"
                      start:@""
                      appID:PRODUCTION_ID
                 appVersion:PRODUCTION_VERSION
                  completed:^(NSDictionary *responseDictionary, NSError *error) {
                      
                      //-- fetching
                      [self getDatasourceNewsHostWith:responseDictionary];
                  }];
}

-(void) getDatasourceNewsHostWith:(NSDictionary *)aDictionary {
    
    if (aDictionary)
    {
        NSString *singerNoticeDefault = [[NSUserDefaults standardUserDefaults] objectForKey:Key_Singer_Notice_Default];
        
        if ([singerNoticeDefault length] == 0)
            singerNoticeDefault = TITLE_Singer_Notice_Default;
        
        NSDictionary *dictData = [aDictionary objectForKey:@"data"];
        NSMutableArray *arrCategory = [dictData objectForKey:@"singer_list"];
        if ([arrCategory count] > 0)
        {
            NSDictionary *dictSinger = [arrCategory objectAtIndex:0];
            NSMutableArray *arrNews = [dictSinger objectForKey:@"node_list"];
            
            if ([arrNews count] > 0)
            {
                //-- create JSON
                NSString *lableString = @"";
                
                for (NSInteger i = 0; i< arrNews.count; i++) {
                    
                    NSDictionary *newsInfo = [arrNews objectAtIndex:i];
                    
                    NSString *titleNews = [newsInfo valueForKey:@"title"];
                    
                    if ([titleNews length] >= 100)
                        titleNews = [NSString stringWithFormat:@"%@...",[titleNews substringToIndex:100]];
                    
                    //-- remove \n
                    titleNews = [titleNews stringByReplacingOccurrencesOfString:@" \n" withString:@""];
                    titleNews = [titleNews stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    
                    
                    if (i == 0)
                        lableString = [lableString stringByAppendingString:[NSString stringWithFormat:@"%@",titleNews]];
                    else
                        lableString = [lableString stringByAppendingString:[NSString stringWithFormat:@"               %@",titleNews]];
                }
            }
        }
    }
}


- (void)fetchingPhotoAlbum
{
    //-- remove all object
    [arrAlbums removeAllObjects];
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) {
        
        //-- read cache
        _dataSourceAlbum = [VMDataBase getAllAlbumPhotoForContentType:ContentTypeIDPhoto];
        
        if (_dataSourceAlbum.count > 0){
            scrollImage.alpha = 1;
            
            //-- reload tableview
            [self loadScrollImage];
        }else{
            scrollImage.alpha = 0;
        }
    }else {
        
        //-- request news async
        [API getAlbumOfSinglerID:SINGER_ID
                   contentTypeId:ContentTypeIDPhoto
                           limit:@"200"
                            page:[NSString stringWithFormat:@"%ld",_currentPage]
                       isGetBody:@"1"
                        isGetHot:@"0"
                           appID:PRODUCTION_ID
                      appVersion:PRODUCTION_VERSION
                       completed:^(NSDictionary *responseDictionary, NSError *error) {
                           
                           if (!error && responseDictionary) {
                               
                               //-- fetching
                               [self createDataSourcePhotoInAlbum:responseDictionary];
                               
                           }else{
                               scrollImage.alpha = 0;
                           }
                           
                       }];
    }
}


-(void)createDataSourcePhotoInAlbum:(NSDictionary *)aDictionary
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"singer_list"];
    
    if ([arrSinger count] > 0)
    {
        arrAlbums = [[arrSinger objectAtIndex:0] objectForKey:@"album_list"];
        
        if ([arrAlbums count] > 0)
        {
            scrollImage.alpha = 1;
            
            //-- delete cache
            if (_currentPage == 0)
            {
                [VMDataBase deleteAllAlbumPhotoFromDB];
                [_dataSourceAlbum removeAllObjects];
            }
            
            for (NSInteger i = 0; i < [arrAlbums count]; i++)
            {
                ListAlbumPhoto *aAlbums = [[ListAlbumPhoto alloc] init];
                
                aAlbums.albumId = [[arrAlbums objectAtIndex:i] objectForKey:@"album_id"];
                aAlbums.name = [[arrAlbums objectAtIndex:i] objectForKey:@"name"];
                aAlbums.thumbImagePath = [[arrAlbums objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
                aAlbums.description = [[arrAlbums objectAtIndex:i] objectForKey:@"description"];
                aAlbums.order = [[arrAlbums objectAtIndex:i] objectForKey:@"order"];
                aAlbums.totalPhoto = [[arrAlbums objectAtIndex:i] objectForKey:@"total_photo"];
                aAlbums.photoList = [[arrAlbums objectAtIndex:i] objectForKey:@"photo_list"];
                NSString *numberComment = [NSString stringWithFormat:@"%d",[[[arrAlbums objectAtIndex:i] objectForKey:@"sns_total_comment"] intValue]];
                NSString *numberLike = [NSString stringWithFormat:@"%d",[[[arrAlbums objectAtIndex:i] objectForKey:@"sns_total_like"] intValue]];
                aAlbums.snsTotalComment = numberComment;
                aAlbums.snsTotalLike = numberLike;
                aAlbums.snsTotalDisLike = [[arrAlbums objectAtIndex:i] objectForKey:@"sns_total_dislike"];
                aAlbums.snsTotalShare = [[arrAlbums objectAtIndex:i] objectForKey:@"sns_total_share"];
                aAlbums.snsTotalView = [[arrAlbums objectAtIndex:i] objectForKey:@"sns_total_view"];
                
                [_dataSourceAlbum addObject:aAlbums];
                
                //-- insert into DB
                [VMDataBase insertAlbumPhotoBySinger:aAlbums];
            }
            
            [self loadScrollImage];
            
        }else{
            scrollImage.alpha = 0;
        }
    }
}

#pragma mark - ACTION

- (void) onTimer
{
    // Updates the variable w, adding 320
    CGFloat w = scrollImage.contentOffset.x;
    
    //This makes the scrollView scroll to the desired position
    if (_dataSourceAlbum.count <= 5)
    {
        if (w == scrollImage.frame.size.width*(_dataSourceAlbum.count-1))
        {
            w = 0;
            scrollImage.contentOffset = CGPointMake(w, 0);
        } else
        {
            w += 320;
            [UIView animateWithDuration:0.5 animations:^{
                scrollImage.contentOffset = CGPointMake(w, 0);
            }];
        }
    }
    else
    {
        if (w == scrollImage.frame.size.width*4)
        {
            w = 0;
            scrollImage.contentOffset = CGPointMake(w, 0);
        }
        else
        {
            w += 320;
            [UIView animateWithDuration:0.5 animations:^{
                scrollImage.contentOffset = CGPointMake(w, 0);
            }];
        }
    }
}

- (IBAction)clickToBtnNews:(id)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    NewsViewController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"idNewsViewControllerSb"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:nvc animated:YES];
    else
        [self.navigationController pushViewController:nvc animated:NO];
}

- (IBAction)clickToBtnMusic:(id)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    MusicHomeViewController *mhVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idMusicHomeViewControllerSb"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:mhVC animated:YES];
    else
        [self.navigationController pushViewController:mhVC animated:NO];
}


- (IBAction)clickToBtnVideo:(id)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    VideoViewController *vvc = [self.storyboard instantiateViewControllerWithIdentifier:@"sbIDVideoViewController"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:vvc animated:YES];
    else
        [self.navigationController pushViewController:vvc animated:NO];
}


- (IBAction)clickToBtnPhoto:(id)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    PhotoViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"sbPhotoVIewControllerId"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:pvc animated:YES];
    else
        [self.navigationController pushViewController:pvc animated:NO];
}


- (IBAction)clickToBtnProfile:(id)sender
{
    //-- set delegate
    [self setDelegateBaseController:self];
    isSelectedFanZone = NO;
   
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        
        //-- set invalidate timerAuto
        [self.timerAuto invalidate];
        
        ProfileViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idProfileViewControllerSb"];
        pVC.userId = userId;
        pVC.profileType = ProfileTypeMyAccount;
        pVC.isSelectedProfile = YES;
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
            [self.navigationController pushViewController:pVC animated:YES];
        else
            [self.navigationController pushViewController:pVC animated:NO];
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
   
}


- (IBAction)clickToBtnFanZone:(id)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    //-- set delegate
    [self setDelegateBaseController:self];
    isSelectedFanZone = YES;
    
    FanZoneViewController *fzVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbIDFanZoneViewController"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:fzVC animated:YES];
    else
        [self.navigationController pushViewController:fzVC animated:NO];
}

- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
//    _isProcessLikeAPI = false;
}

//-- pass base view controller delegete
- (void) baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if(!isSelectedFanZone && userId) { //-- swith to profile
        
        ProfileViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idProfileViewControllerSb"];
        pVC.userId = userId;
        pVC.profileType = ProfileTypeMyAccount;
        pVC.isSelectedProfile = YES;
            
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
            [self.navigationController pushViewController:pVC animated:YES];
        else
            [self.navigationController pushViewController:pVC animated:NO];
        
    }else if(isSelectedFanZone && userId) { //-- swith to fanzone
        
        FanZoneViewController *fzVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbIDFanZoneViewController"];
        
        if (![self.navigationController.viewControllers containsObject:fzVC]) {
            
            if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
                [self.navigationController pushViewController:fzVC animated:YES];
            else
                [self.navigationController pushViewController:fzVC animated:NO];
        }
    }
}


- (IBAction)clickToBtnTopUser:(id)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    TopUserViewController *tuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idTopUserViewControllerSb"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:tuVC animated:YES];
    else
        [self.navigationController pushViewController:tuVC animated:NO];
}


- (IBAction)clickToBtnAbout:(id)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    AboutViewController *tuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbAboutViewControllerId"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:tuVC animated:YES];
    else
        [self.navigationController pushViewController:tuVC animated:NO];
}


- (IBAction)clickToBtnStore:(id)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    StoreViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idStoreViewControllerSb"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:pVC animated:YES];
    else
        [self.navigationController pushViewController:pVC animated:NO];
}


- (IBAction)clickToBtnSchedule:(id)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    ScheduleViewController *tuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbScheduleViewControllerId"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:tuVC animated:YES];
    else
        [self.navigationController pushViewController:tuVC animated:NO];
}

//--change pageControl
- (IBAction)changepage:(id)sender
{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollImage.frame.size.width * self.pageCtrImage.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollImage.frame.size;
    [self.scrollImage scrollRectToVisible:frame animated:YES];
    
    [self.pageCtrImage setCurrentPageIndicatorTintColor:[UIColor blueColor]];
    [self.pageCtrImage setPageIndicatorTintColor:[UIColor grayColor]];
    
    if ([pageCtrImage respondsToSelector:@selector(pageIndicatorTintColor)])
    {
        pageCtrImage.pageIndicatorTintColor = [UIColor grayColor];
        pageCtrImage.currentPageIndicatorTintColor = [UIColor blueColor];
    }
}


-(IBAction)singleTapping:(UIGestureRecognizer *)sender
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    NSInteger indexAlbum = [sender view].tag;

    PhotoAlbumViewController *maVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbPhotoAlbumViewControllerId"];
    
    NSMutableArray *albumTitleArr = [[NSMutableArray alloc] init];
    ListAlbumPhoto *abP;
    NSInteger indexOfAlbum;
    
    if ([_dataSourceAlbum count]>0) {
        
        for (NSInteger i=0; i<[_dataSourceAlbum count]; i++) {
            ListAlbumPhoto *tmp2 = (ListAlbumPhoto *)[_dataSourceAlbum objectAtIndex:i];
            NSString *title = tmp2.name;
            
            [albumTitleArr addObject:title];
        }
        [albumTitleArr insertObject:@"Tất cả" atIndex:0];
    }
    
    if ([_dataSourceAlbum count]>0) {
        abP = (ListAlbumPhoto *)[_dataSourceAlbum objectAtIndex:indexAlbum];
        indexOfAlbum = [_dataSourceAlbum indexOfObject:abP] + 1;
    }
    
    if (abP) {
        maVC.indexOfAlbum = indexOfAlbum;
        maVC.arrPhotos = _dataSourceAlbum;
        maVC.arrTitle = albumTitleArr;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:maVC animated:YES];
    else
        [self.navigationController pushViewController:maVC animated:NO];
}

#pragma mark - ScrollViewDelegate

-(void)addImageWithName:(NSString *)imageString atPosition:(int)position
{
    // Load the photo view.
    CGRect frame = self.scrollImage.bounds;
    
    frame.origin.x = frame.size.width * position;
    frame.size.height = 139;//longnh fix
    
    NSLog(@"frame w:%f h:%f",frame.size.width,frame.size.height);
    frame.origin.y = 0.0f;
    frame = CGRectInset(frame, 5.0f, 0.0f);
    
    newPageView = [[UIImageView alloc] init];
    newPageView.frame = frame;
    
    [self callGetImageUrlForCellWithIndex:position withImageView:newPageView withUrl:imageString];
    
    [self.scrollImage addSubview:newPageView];
}

//-- get image url
-(void) callGetImageUrlForCellWithIndex:(int) position withImageView:(UIImageView *)newImage withUrl:(NSString *)urlString
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(newImage) weakPage = newImage;
    
    //-- fix size
    [weakPage setContentMode:UIViewContentModeScaleAspectFill];
    [weakPage setClipsToBounds:NO];
    
    //-- download image
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        newImage.image = image;
        
        NSLog(@"%f %f",weakSelf.scrollImage.frame.size.width, weakSelf.scrollImage.frame.size.height);
        
        [weakPage setContentMode:UIViewContentModeCenter];
        //-- add action for photo
        [weakPage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [weakPage addGestureRecognizer:singleTap];
        weakPage.tag = position;
        
        [weakSelf.scrollImage addSubview:weakPage];
        
    }];
}

//test fetching store
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
}

-(void) goToLike:(int)indexPath withSender:(id)sender
{
    if (checkTabValue == 0)
    {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
        
        if (userId)
        {
            UIButton *aButton = (UIButton *)sender;
            if (aButton.selected)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Bạn đã like thông tin !"
                                                               delegate:self
                                                      cancelButtonTitle:@"Thoát"
                                                      otherButtonTitles:@"Đồng ý", nil];
                [alert show];
            }
            else
            {
                aButton.selected = YES;
                
                ListFeedData *tempData = (ListFeedData *)[listFeedData objectAtIndex:indexPath];
                NSInteger number = [tempData.snsTotalLike integerValue] + 1;
                tempData.snsTotalLike = [NSString stringWithFormat:@"%ld",(long)number];
                tempData.isLiked = @"1";
                [VMDataBase updateLikeCommentShare:tempData];
                
                id currentTableView = [self.pageViews objectAtIndex:checkTabValue];
                
                self.homeTableViewController = (HomeTableViewController *) currentTableView;
                self.homeTableViewController.listNews = listFeedData;
                [self.homeTableViewController.tableView reloadData];
                
                //-- create JSON
                NSString *jSonData = @"";
                
                NSMutableArray *paraKeyItem = [self getListParaKeyOfItem:kTypeFeed];
                NSMutableArray *paraArrItem = [self getListParaArray:kTypeFeed text:userId contentId:TYPE_ID_FEED contentTypeId:TYPE_ID_FEED commentId:@""];
                
                NSDictionary *paraDict = [NSDictionary dictionaryWithObjects:paraArrItem forKeys:paraKeyItem];
                
                jSonData = [jSonData stringByAppendingString:[NSString stringWithFormat:@"[%@]",[paraDict JSONFragment]]];
                
                [API syncFeedData:userId singerId:@"639" dataFeed:jSonData productionId:PRODUCTION_ID productionVersion:PRODUCTION_VERSION completed:^(NSDictionary *responseDictionary, NSError *error)
                 {
                     if (responseDictionary && !error)
                     {
                         NSDictionary *dictData = [responseDictionary objectForKey:@"error"];
                         NSMutableArray *msg = [dictData objectForKey:@"error_message"];
                         
                         for (NSInteger i=0; i<[msg count]; i++)
                         {
                             if ([[msg objectAtIndex:i]  isEqual: @"HAD_LIKED_BEFORE_OR_TOO_QUICK"])
                             {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                 message:@"Bạn đã like thông tin !"
                                                                                delegate:self
                                                                       cancelButtonTitle:@"Thoát"
                                                                       otherButtonTitles:@"Đồng ý", nil];
                                 [alert show];
                             }
                         }
                     }
                     else
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:@"Có lỗi xảy ra xin vui lòng kiểm tra lại kết nối mạng!"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Thoát"
                                                               otherButtonTitles:@"Đồng ý", nil];
                         [alert show];
                     }
                 }];
            }
        }
        else
        {
            //-- thong bao nang cap user
            [self showMessageUpdateLevelOfUser];
        }

    }
}

-(void) goToComment:(int)indexPath withSender:(id)sender
{
    [self.timerAuto invalidate];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId)
    {
        HomeCommentViewController *hcVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeCommentViewControllerId"];
        hcVC.indexP = [NSString stringWithFormat:@"%d",indexPath];
        hcVC.tempLinkData = listFeedData;
        
        [self.navigationController pushViewController:hcVC animated:NO];
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}

-(void)commentSuccessDelegate
{
    ListFeedData *tempData = (ListFeedData *)[listFeedData objectAtIndex:_currTempIndex];
    NSInteger number = [tempData.snsTotalComment integerValue] + 1;
    tempData.snsTotalComment = [NSString stringWithFormat:@"%ld",(long)number];
    [VMDataBase updateLikeCommentShare:tempData];
    
    id currentTableView = [self.pageViews objectAtIndex:checkTabValue];
    
    self.homeTableViewController = (HomeTableViewController *) currentTableView;
    self.homeTableViewController.listNews = listFeedData;
    [self.homeTableViewController.tableView reloadData];
}

-(void) goToShare:(int)indexPath withSender:(id)sender
{
    NSLog(@"Click Shares");
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId)
    {
        if (checkTabValue == 0)
        {
            NSString *title = @"Title";
            NSString *headline = @"Headline";
            //        NSString *headline = [schedule.name stringByReplacingOccurrencesOfString:@" " withString:@" "];
            NSString *description = [NSString stringWithFormat:@"Tôi muốn chia sẻ %@ trong ứng dụng %@ tại %@",headline, KEY_FB_SINGER_DISPLAY_NAME, URL_APP_STORE];
            
            [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:@"NewDefault.png" contentId:@"" contentTypeId:TYPE_ID_EVENT];
            
            ListFeedData *tempData = (ListFeedData *)[listFeedData objectAtIndex:indexPath];
            NSInteger number = [tempData.snsTotalShare integerValue] + 1;
            tempData.snsTotalShare = [NSString stringWithFormat:@"%ld",(long)number];
            [VMDataBase updateLikeCommentShare:tempData];
            
            id currentTableView = [self.pageViews objectAtIndex:checkTabValue];
            
            self.homeTableViewController = (HomeTableViewController *) currentTableView;
            self.homeTableViewController.listNews = listFeedData;
            [self.homeTableViewController.tableView reloadData];
        }
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}

-(void)goToDetailStoreViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    StoreDetailViewController *detailStoreVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbStoreDetailViewControllerId"];
    
    Store *aStore = (Store *)[listData objectAtIndex:indexRow];
    NSInteger currentIndex = [listData indexOfObject:aStore];
    
    detailStoreVC.store             = aStore;
    detailStoreVC.currentIndex      = currentIndex;
    detailStoreVC.arrStore          = listData;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [self.navigationController pushViewController:detailStoreVC animated:YES];
    }
    else
    {
        [UIView  beginAnimations: @"Animation2"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController:detailStoreVC animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
}

-(void) goToDetailScheduleViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    DetailsScheduleViewController *dsVC = (DetailsScheduleViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailsScheduleViewControllerId"];
    
    NSInteger indexOfSchedule;
    NSMutableArray *urlSongArr = [[NSMutableArray alloc] init];
    
    Schedule *schedule = [listData objectAtIndex:indexRow];
    indexOfSchedule = [listData indexOfObject:schedule];
    
    if ([listData count]>0)
    {
        for (NSInteger i=0; i<[listData count]; i++)
        {
            Schedule *mTr = [listData objectAtIndex:i];
            NSString *urlStr = mTr.imageFilePath;
            
            [urlSongArr addObject:urlStr];
        }
    }
    
    dsVC.schedule = schedule;
    dsVC.dataSourceSchedule = listData;
    dsVC.indexOfSchedule = indexOfSchedule;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [self.navigationController pushViewController:dsVC animated:YES];
    }
    else
    {
        [UIView  beginAnimations: @"Animation3"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController:dsVC animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
}

-(void)createDataSourceAllScheduleFrom:(NSDictionary *)aDictionary byIndex:(int)index
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"singer_list"];
    
    [VMDataBase deleteAllScheduleByCategory:@"1"];
    
    _isLoadedFullNode = NO;
    
    if ([arrSinger count] > 0)
    {
        NSMutableArray *nodeList = [[arrSinger objectAtIndex:0] objectForKey:@"node_list"];
        
        if ([nodeList count] > 0)
        {
            //-- add objects
            [self addObjectToListAndSaveDatabaseBy:nodeList byIndex:index];
        }
    }
    
    NSString *tempCar = [NSString stringWithFormat:@"%ld",(long)checkTabValue];
    //-- get data
    //lay dc ok thi update flag cache timeout
    
//    [self isCacheForCategoryPerPageTimeout:tempCar pageIndex:@"0" updateCacheNow:true];
//    
//    //load lai new la current index
//    [self getHomeNewsDataFromDataBaseByIndex:(int)_currentIndex];
}

//-- add object
-(void) addObjectToListAndSaveDatabaseBy:(NSMutableArray *)nodeList byIndex:(NSInteger)index
{
    for (NSInteger i = 0; i < [nodeList count]; i++)
    {
        Schedule *schedule = [[Schedule alloc] init];
        
        schedule.categoryId = @"1";
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
        NSMutableArray *listSingerCalendar = [[NSMutableArray alloc] init];
        NSMutableArray *listDataCalendar = [[nodeList objectAtIndex:i] objectForKey:@"list_singer"];
        
        for (NSInteger j=0; j<[listDataCalendar count]; j++) {
            NSString *nameSinger = [[listDataCalendar objectAtIndex:j] objectForKey:@"nick_name"];
            
            [listSingerCalendar addObject:nameSinger];
        }
        
        NSArray *arrSinger = [listSingerCalendar mutableCopy];
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
            
        }
        else
        {
            //-- insert into DB
            [VMDataBase insertSchedule:schedule];
        }
    }
}

-(void)createDataSourceWithoutCategory:(NSDictionary *)aDictionary
{
    if (!_dataSourceFeeds) {
        _dataSourceFeeds = [NSMutableArray new];
    }
    
    [VMDataBase deleteAllStore];
    
    _isLoadedFullNode = NO;
    
    UITableView *currentTableview = [_arrTableviews objectAtIndex:_indexSegmentSelected];
    
    //-- remove lable no data
    [self removeLableNoDataFromTableView:currentTableview withIndex:_indexSegmentSelected];
    
    NSDictionary *dictData      = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger   = [dictData objectForKey:@"singer_list"];
    
    if ([arrSinger count] > 0)
    {
        NSDictionary *dictSinger = [arrSinger objectAtIndex:0];
        NSMutableArray *arrStore = [dictSinger objectForKey:@"node_list"];
        
        if ([arrStore count] > 0)
        {
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
                [_dataSourceFeeds addObject:aStore];
            }
        }
    }
    
    NSString *tempCar = [NSString stringWithFormat:@"%ld",(long)checkTabValue];
    //-- get data
    //lay dc ok thi update flag cache timeout
    
//    [self isCacheForCategoryPerPageTimeout:tempCar pageIndex:@"0" updateCacheNow:true];
//    
//    //load lai new la current index
//    [self getHomeNewsDataFromDataBaseByIndex:(int)_currentIndex];
}

- (NSMutableArray *)getListParaKeyOfItem:(NSInteger)typeSync
{
    NSLog(@"%s", __func__);
    NSMutableArray *paraKey = [[NSMutableArray alloc] init];
    
    if (typeSync == kTypeFeed)
    {
        [paraKey addObject:@"feed_time_stamp"];
        [paraKey addObject:@"content_type_id"];;
        [paraKey addObject:@"item_id"];
    }
    else
    {
        [paraKey addObject:@"content_id"];
        [paraKey addObject:@"content_type_id"];;
        [paraKey addObject:@"time_stamp"];
    }
    
    return paraKey;
}

- (NSMutableArray *)getListParaArray:(NSInteger)typeSync text:(NSString *)text contentId:(NSString*)contentId contentTypeId:(NSString *)contentTypeId commentId:(NSString *)commentId
{
    NSLog(@"%s", __func__);
    NSMutableArray *paraArr = [[NSMutableArray alloc] init];
    
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%ld",(long)timeStamp];
    
    if (typeSync == kTypeFeed)
    {
        [paraArr addObject:timeString];
        [paraArr addObject:@"pages_comment"];
        [paraArr addObject:@"17"];
    }
    else
    {
        [paraArr addObject:contentId];
        [paraArr addObject:contentTypeId];
        [paraArr addObject:timeString];
    }
    
    return paraArr;
}

-(void)replaceSubview:(UIView *)oldView withSubview:(UIView *)newView transition:(NSString *)transition direction:(NSString *)direction duration:(NSTimeInterval)duration
{
    // Set up the animation
    CATransition *animation = [CATransition animation];
    // Set the type and if appropriate direction of the transition,
    if (transition == kCATransitionFade)
    {
        [animation setType:kCATransitionFade];
    }
    else
    {
        [animation setType:transition];
        [animation setSubtype:direction];
    }
    // Set the duration and timing function of the transtion -- duration is passed in as a parameter, use ease in/ease out as the timing function
    [animation setDuration:duration];
    [animation setTimingFunction:[CAMediaTimingFunction   functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[oldView layer] addAnimation:animation forKey:@"transitionViewAnimation"];
}

//-- create page scroll
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
    
    [self setCurrentIndex:checkTabValue];
    
    [self scrollToIndex:checkTabValue];
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

- (void)createHomeTabPage
{
    //check table view
    UITableView *currentTableView = [_arrHomeFeedTableViews objectAtIndex:checkTabValue];
    
    NSInteger countData = 0;
    
    if (listFeedData.count > 0)
    {
        countData = listFeedData.count;
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:checkTabValue];
        
        if (NO == [currentTableView isKindOfClass:[HomeTableViewController class]])
        {
           
            //-- Load the photo view.
            CGRect frame = scrollPageTab.bounds;
            frame.origin.x = frame.size.width * checkTabValue;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            self.homeTableViewController = [[HomeTableViewController alloc] init];
            self.homeTableViewController.delegate = self;
            
            if (checkTabValue == 0)
            {
                self.homeTableViewController.listNews  = listFeedData;
            }
            else if (checkTabValue == 1)
            {
                self.homeTableViewController.listNews  = listCalendarData;
            }
            else if (checkTabValue == 2)
            {
                self.homeTableViewController.listNews  = listProductionData;
            }
            
            self.homeTableViewController.currentPage = checkTabValue;
            NSLog(@"count data %@",self.homeTableViewController.listNews);
            self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
            [self.homeTableViewController.view setFrame:frame];
            [self.homeTableViewController.view setTag:checkTabValue];
            
            //-- add Refresh to tableview
            [self addRefreshAndLoadMoreForTableView:self.homeTableViewController.tableView WithIndex:(int)checkTabValue];
            
            [scrollPageTab addSubview:self.homeTableViewController.view];
            [self.pageViews replaceObjectAtIndex:checkTabValue withObject:self.homeTableViewController];
        }
        else
        {
            self.homeTableViewController = (HomeTableViewController *) currentTableView;
            self.homeTableViewController.listNews = listFeedData;
            [self.homeTableViewController.tableView reloadData];
            [self.homeTableViewController.tableView setContentSize:CGSizeMake(self.homeTableViewController.tableView.contentSize.width, self.homeTableViewController.tableView.contentSize.height+30)];
        }
        
        //-- get tableview All Video in scrollview
        NSLog(@"scrollpagetab subview %lu",(unsigned long)scrollPageTab.subviews.count);
        if (scrollPageTab.subviews.count > 0)
        {
            for (UITableView *viewTB in scrollPageTab.subviews)
            {
                if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == (long)index)
                {
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
    //-- refresh data
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:aTableview];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    
    //-- load more from bottom
    __weak HomeTableViewController *myself = self.homeTableViewController;
    
    //  -- setup infinite scrolling
    [aTableview addInfiniteScrollingWithActionHandler:^{
        
        [self loadMoreFeedAtIndex:byIndex];
    }];
}

-(void)refresh:(UIRefreshControl *)refreshControl
{
    NSLog(@"%s", __func__);
    
    [refreshControl beginRefreshing];
    
    //-- request Feeds
    [API getFeedofSingerID:PRODUCTION_ID
         productionVersion:PRODUCTION_VERSION
                  singerId:SINGER_ID completed:^(NSDictionary *responseDictionary, NSError *error)
     {
         //-- fetching
         [self getDatasourceFeedsWith:responseDictionary];
     }];
    
    //-- request Calendar
    [API getAllMusicAndVideoOfSinglerID:SINGER_ID
                          contentTypeId:ContentTypeIDSchedule
                                  limit:@"100"
                                   page:[NSString stringWithFormat:@"%d",0]
                              isHotNode:@"0"
                                 months:@"6"
                                  appID:PRODUCTION_ID
                             appVersion:PRODUCTION_VERSION
                              completed:^(NSDictionary *responseDictionary, NSError *error)
     {
         
         if (responseDictionary && !error)
         {
             [self createDataSourceAllScheduleFrom:responseDictionary byIndex:0];
         }
     }];
    
    //-- request Production
    [API getNodeForSingerID:SINGER_ID
              contentTypeId:ContentTypeIDStore
                      limit:@"10"
                       page:[NSString stringWithFormat:@"%d", 0]
                     period:@"1"
                  isHotNode:@"0"
                      start:@"-30"
                      appID:PRODUCTION_ID
                 appVersion:PRODUCTION_VERSION
                  completed:^(NSDictionary *responseDictionary, NSError *error) {
                      
                      [self createDataSourceWithoutCategory:responseDictionary];
                  }];
    
    [refreshControl endRefreshing];
}

-(void)refreshData:(ODRefreshControl *)refreshControl
{
    NSLog(@"%s", __func__);
    
    [refreshControl beginRefreshing];

    //-- request Feeds
    [API getFeedofSingerID:PRODUCTION_ID
         productionVersion:PRODUCTION_VERSION
                  singerId:SINGER_ID completed:^(NSDictionary *responseDictionary, NSError *error)
     {
         //-- fetching
         [self getDatasourceFeedsWith:responseDictionary];
     }];
    
    //-- request Calendar
    [API getAllMusicAndVideoOfSinglerID:SINGER_ID
                          contentTypeId:ContentTypeIDSchedule
                                  limit:@"100"
                                   page:[NSString stringWithFormat:@"%d",0]
                              isHotNode:@"0"
                                 months:@"6"
                                  appID:PRODUCTION_ID
                             appVersion:PRODUCTION_VERSION
                              completed:^(NSDictionary *responseDictionary, NSError *error)
     {
         
         if (responseDictionary && !error)
         {
             [self createDataSourceAllScheduleFrom:responseDictionary byIndex:0];
         }
     }];
    
    //-- request Production
    [API getNodeForSingerID:SINGER_ID
              contentTypeId:ContentTypeIDStore
                      limit:@"10"
                       page:[NSString stringWithFormat:@"%d", 0]
                     period:@"1"
                  isHotNode:@"0"
                      start:@"-30"
                      appID:PRODUCTION_ID
                 appVersion:PRODUCTION_VERSION
                  completed:^(NSDictionary *responseDictionary, NSError *error) {
                      
                      [self createDataSourceWithoutCategory:responseDictionary];
                  }];
    
    [refreshControl endRefreshing];
}

-(void)loadMoreFeedAtIndex:(NSInteger)index
{
    if (_allowcreate == NO)
    {
        [self.homeTableViewController.tableView setContentSize:CGSizeMake(self.homeTableViewController.tableView.contentSize.width, self.homeTableViewController.tableView.contentSize.height+30)];
        _allowcreate = YES;
    }
    else
    {}
    
    //-- check time
    NSString *currentCategoryId = [NSString stringWithFormat:@"%ld",(long)checkTabValue];
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSLog(@"load more nhe");
    NSInteger compeTime = currentDate - [[Setting sharedSetting] milestonesStoreRefreshTimeForCategoryId:currentCategoryId];
    
    if (([[Setting sharedSetting] milestonesStoreRefreshTimeForCategoryId:currentCategoryId] != 0) && (compeTime < [Setting sharedSetting].storeRefreshTime*60)) {
        
        if (scrollPageTab.subviews.count > 0)
        {
            for (UITableView *viewTB in scrollPageTab.subviews) {
                
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
        [[Setting sharedSetting] setMilestonesStoreRefreshTime:currentDate categoryId:currentCategoryId];
}

//*******************************************************************************//
#pragma mark - TableHomeViewController delegate

-(void)goToDetailHomeLinkFeed: (NSMutableArray*)linkData withIndex:(NSString *)linkIndex
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    HomeFeedLinkViewController *tuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeFeedLinkViewControllerId"];
    tuVC.indexP = linkIndex;
    tuVC.tempLinkData = linkData;

    [UIView  beginAnimations: @"Animation1"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:tuVC animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

-(void)goToDetailHomePhotoFeed: (NSString*)indexCell withIdPhoto:(long)idPhoto
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    DetailsAlbumPhotoViewController *maVC = (DetailsAlbumPhotoViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailsAlbumPhotoViewControllerId"];
    
    int value = [indexCell intValue];
    
    tempPhotoFeedData = [[NSMutableArray alloc]init];
    tempPhotoFeedData = [VMDataBase getAllPhotoFeeds:((ListFeedData*)[listFeedData objectAtIndex:value]).albumId];
    if ([((ListFeedData*)[listFeedData objectAtIndex:value]).albumId isEqual:@"0"])
    {
        for (NSInteger i = 0; i < tempPhotoFeedData.count; i++)
        {
            if ([((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).indexcell isEqual:indexCell])
            {
                PhotoListFeedData *arrTemp = [PhotoListFeedData new];
                arrTemp.albumId = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).albumId;
                arrTemp.photoId = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).photoId;
                arrTemp.photoTitle = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).photoTitle;
                arrTemp.imagePath = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).imagePath;
                arrTemp.photoDescription = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).photoDescription;
                arrTemp.snsTotalLike = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).snsTotalLike;
                arrTemp.snsTotalComment = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).snsTotalComment;
                arrTemp.snsTotalShare = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).snsTotalShare;
                arrTemp.snsTotalView = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).snsTotalView;
                arrTemp.indexcell = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).indexcell;
                
                NSMutableArray *check = [[NSMutableArray alloc]init];
                [check insertObject:arrTemp atIndex:0];
                
                ListPhotosInAlbum *abP = (ListPhotosInAlbum *)[tempPhotoFeedData objectAtIndex:i];
                
                if (abP)
                {
                    maVC.indexOfPhoto = 0;
                    maVC.arrayPhoto = check;
                    maVC.number_of_images = 1;
                    maVC.albumTitle = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).photoTitle;
                }
            }
        }
    }
    else
    {
        ListPhotosInAlbum *abP = (ListPhotosInAlbum *)[tempPhotoFeedData objectAtIndex:idPhoto];
        
        if (abP)
        {
            maVC.indexOfPhoto = idPhoto;
            maVC.arrayPhoto = tempPhotoFeedData;
            maVC.number_of_images = tempPhotoFeedData.count;
            maVC.albumTitle = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:idPhoto]).photoTitle;
        }
    }

    [UIView  beginAnimations: @"Animation4"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:maVC animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

-(void) goToDetailHomeStoreFeed:(NSMutableArray *)storeData withIdProduct:(long)idProduct
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    [self goToDetailStoreViewControllerWithListData:storeData withIndexRow:(int)idProduct];
}

-(void) goToDetailHomeEventFeed:(NSMutableArray *)eventData withIdEvent:(long)idEvent
{
    //-- set invalidate timerAuto
    [self.timerAuto invalidate];
    
    [self goToDetailScheduleViewControllerWithListData:eventData withIndexRow:(int)idEvent];
}

- (void)reachTop:(BOOL)done
{
    NSLog(@"vao reachtop scroll tableview");
    self.homeTableViewController.tableView.scrollEnabled = NO;
}

- (void)reachBottom:(BOOL)done
{
    NSLog(@"vao reachbottom scroll tableview");
}

-(NSInteger)getHomeNewsDataFromDataBaseByIndex:(int)byIndex
{
    NSLog(@"%s", __func__);
    
    NSInteger countData = 0;
    
    //-- remove lable nodata
    [self removeLableNoDataFrom:scrollPageTab withIndex:byIndex];
    
    //-- category id
    _currentCategoryId = [NSString stringWithFormat:@"%ld",(long)checkTabValue];
    
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
    int totalNeed = _pageSize*(currentPageValue+1);
    
    if (checkTabValue == 0)
    {
        listFeedData = [VMDataBase getAllFeeds:@"94"];
        listData = listFeedData;
    }
    else if (checkTabValue == 1)
    {
        listCalendarData = [VMDataBase getAllScheduleByCategoryid:@"1"];
        listData = listCalendarData;
    }
    else if (checkTabValue == 2)
    {
        listProductionData = [VMDataBase getAllStoreWithCategoryID:CATEGORY_ID_STORE_ALL];
        listData = listProductionData;
    }
    
    if (listData.count > 0)
    {
        countData = listData.count;
        if (countData < totalNeed)
            _isLoadedFullNode = YES;
        //-- check and add tableview music
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
            self.homeTableViewController.currentPage = checkTabValue;
//            [self.homeTableViewController.tableView setDragDelegate:self refreshDatePermanentKey:@"refrehscainao"];
//            self.homeTableViewController.tableView.showLoadMoreView = YES;
            self.homeTableViewController.listNews  = listData;
            
            if (loadingIndicator1 == nil && loadingIndicator2 == nil)
            {
                loadingIndicator1 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                loadingIndicator1.hidden = NO;
                [loadingIndicator1 startAnimating];
                [loadingIndicator1 setFrame:CGRectMake(480, 160, loadingIndicator1.frame.size.width, loadingIndicator1.frame.size.height)];
                [scrollPageTab addSubview:loadingIndicator1];
                
                loadingIndicator2 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                loadingIndicator2.hidden = NO;
                [loadingIndicator2 startAnimating];
                [loadingIndicator2 setFrame:CGRectMake(800, 160, loadingIndicator2.frame.size.width, loadingIndicator2.frame.size.height)];
                [scrollPageTab addSubview:loadingIndicator2];
            }
            
            //-- add Refresh to tableview
            [self addRefreshAndLoadMoreForTableView:self.homeTableViewController.tableView WithIndex:byIndex];
            
            [scrollPageTab addSubview:self.homeTableViewController.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:self.homeTableViewController];
                
            [self redesignScrollSize:listData.count];
        }
        else
        {
            self.homeTableViewController = (HomeTableViewController *) currentTableView;
            self.homeTableViewController.listNews = listData;
            [self redesignScrollSize:listData.count];
        }
        
    }
    else
    {
        //-- Load the photo view.
        CGRect frame = [scrollPageTab frame];
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
    }
    
    //-- get tableview All News in scrollview
    if (scrollPageTab.subviews.count > 0) {
        
        for (UITableView *viewTB in scrollPageTab.subviews) {
            
            if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                
                //-- hidden loading
                [viewTB.infiniteScrollingView stopAnimating];
                
                break;
            }
        }
    }
    
    return countData;
}

-(void) addLabelNoMoreData:(UIScrollView *)scrollview withIndex:(NSInteger)index withFrame:(CGRect) frameLabel
{
    UILabel *lblNodata = [[UILabel alloc] initWithFrame:frameLabel];
    lblNodata.tag = index;
    lblNodata.backgroundColor = [UIColor clearColor];
    lblNodata.textColor = [UIColor lightGrayColor];
    lblNodata.textAlignment = NSTextAlignmentCenter;
    lblNodata.lineBreakMode = NSLineBreakByWordWrapping;
    lblNodata.numberOfLines = 0;
    lblNodata.text = @"No More Data";
    
    [scrollview addSubview:lblNodata];
}

-(void) removeLabelNoMoreData:(UIScrollView *)scrollview withIndex:(NSInteger) index
{
    for (UIView *lblNadata in scrollview.subviews) {
        
        if ([lblNadata isKindOfClass:[UILabel class]] && lblNadata.tag == index)
        {
            [lblNadata removeFromSuperview];
            break;
        }
    }
}

-(void)redesignScrollSize:(NSInteger)size
{
    float heightSize = 0;
    float additionalSize = scrollImage.frame.size.height + viewTab.frame.size.height + viewFunction.frame.size.height + 15;
    if (_currentIndex == 0)
    {
        heightSize = 400 * size + 50;
        [scrollPageTab setFrame:CGRectMake(scrollPageTab.frame.origin.x, scrollPageTab.frame.origin.y, 320, heightSize +additionalSize + 50)];
        [scrollTotal setContentSize:CGSizeMake(scrollTotal.frame.size.width, heightSize+additionalSize)];
        [self.homeTableViewController.tableView reloadData];
        
        if (viewloader1 == nil)
        {
            viewloader1 = [[UIView alloc] initWithFrame:CGRectMake(0, heightSize - 50, 320, 50)];
            viewloader1.tag = 5000;
            
            btnLoad = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnLoad setFrame:CGRectMake(145, 10, 30, 30)];
            btnLoad.backgroundColor = [UIColor clearColor];
            btnImage = [UIImage imageNamed:@"refreshIcon.png"];
            [btnLoad setImage:btnImage forState:UIControlStateNormal];
            [btnLoad addTarget:self action:@selector(callForMoreData) forControlEvents:UIControlEventTouchUpInside];
            [viewloader1 addSubview:btnLoad];
            
            [scrollPageTab addSubview:viewloader1];
        }
    }
    else if (_currentIndex == 1)
    {
        heightSize = 140 * size + 50;
        [scrollPageTab setFrame:CGRectMake(scrollPageTab.frame.origin.x, scrollPageTab.frame.origin.y, 320, heightSize + additionalSize + 50)];
        [scrollTotal setContentSize:CGSizeMake(scrollTotal.frame.size.width, heightSize+additionalSize)];
        [self.homeTableViewController.tableView reloadData];
        
        if (viewloader2 == nil)
        {
            viewloader2 = [[UIView alloc] initWithFrame:CGRectMake(320, heightSize - 50, 320, 50)];
            viewloader2.tag = 5001;
            
            btnLoad = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnLoad setFrame:CGRectMake(145, 10, 30, 30)];
            btnLoad.backgroundColor = [UIColor clearColor];
            btnImage = [UIImage imageNamed:@"refreshIcon.png"];
            [btnLoad setImage:btnImage forState:UIControlStateNormal];
            [btnLoad addTarget:self action:@selector(callForMoreData) forControlEvents:UIControlEventTouchUpInside];
            [viewloader2 addSubview:btnLoad];
            
            [scrollPageTab addSubview:viewloader2];
        }
        
    }
    else if (_currentIndex == 2)
    {
        heightSize = 200 * (size/2) + 50;
        [scrollPageTab setFrame:CGRectMake(scrollPageTab.frame.origin.x, scrollPageTab.frame.origin.y, 320, heightSize + additionalSize + 50)];
        [scrollTotal setContentSize:CGSizeMake(scrollTotal.frame.size.width, heightSize+additionalSize)];
        [self.homeTableViewController.tableView reloadData];
        
        if (viewloader3 == nil)
        {
            viewloader3 = [[UIView alloc] initWithFrame:CGRectMake(640, heightSize - 50, 320, 50)];
            viewloader3.tag = 5002;
            
            btnLoad = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnLoad setFrame:CGRectMake(145, 10, 30, 30)];
            btnLoad.backgroundColor = [UIColor clearColor];
            btnImage = [UIImage imageNamed:@"refreshIcon.png"];
            [btnLoad setImage:btnImage forState:UIControlStateNormal];
            [btnLoad addTarget:self action:@selector(callForMoreData) forControlEvents:UIControlEventTouchUpInside];
            [viewloader3 addSubview:btnLoad];
            
            [scrollPageTab addSubview:viewloader3];
        }
        
    }
}

- (void)fetchingCategoriesForHome
{
    NSLog(@"%s", __func__);
    if ([_arrCategories count] == 0 && _allowsReadCacheCategory)
    {
        //-- set title for top menu
        if ([_arrCategories count] > 0)
        {
//            [self setTopMenuWithTitles:_arrCategories];
            
            [self createHomeTabPageScrollNews:_arrCategories.count];
            
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
    
        isCallingAPI = true;
        
        if (checkTabValue == 0)
        {
            [API getFeedofSingerID:PRODUCTION_ID
                 productionVersion:PRODUCTION_VERSION
                          singerId:SINGER_ID completed:^(NSDictionary *responseDictionary, NSError *error)
             {
                 //-- fetching
                 [self getDatasourceFeedsWith:responseDictionary];
             }];
        }
        else if (checkTabValue == 1)
        {
            [API getAllMusicAndVideoOfSinglerID:SINGER_ID
                                  contentTypeId:ContentTypeIDSchedule
                                          limit:@"100"
                                           page:[NSString stringWithFormat:@"%d",0]
                                      isHotNode:@"0"
                                         months:@"6"
                                          appID:PRODUCTION_ID
                                     appVersion:PRODUCTION_VERSION
                                      completed:^(NSDictionary *responseDictionary, NSError *error)
             {
                 
                 if (responseDictionary && !error)
                 {
                     [self createDataSourceAllScheduleFrom:responseDictionary byIndex:0];
                 }
             }];
        }
        else if (checkTabValue == 2)
        {
            [API getNodeForSingerID:SINGER_ID
                      contentTypeId:ContentTypeIDStore
                              limit:@"10"
                               page:[NSString stringWithFormat:@"%d", 0]
                             period:@"1"
                          isHotNode:@"0"
                              start:@"-30"
                              appID:PRODUCTION_ID
                         appVersion:PRODUCTION_VERSION
                          completed:^(NSDictionary *responseDictionary, NSError *error) {
                              
                              [self createDataSourceWithoutCategory:responseDictionary];
                          }];
        }
    }
}

/*
 Kiem tra cache xem 1 page trong 1 category co thoi gian timeout het chua
 */
- (BOOL) isCacheForCategoryPerPageTimeout: (NSString *)categoryId pageIndex:(NSString *)pageIndex updateCacheNow:(BOOL)updateCacheNow
{
    //-- check time
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger prvTime = [[Setting sharedSetting] milestonesNewRefreshTimeForCategoryIdPerPage:categoryId pageIndex:pageIndex];
    NSInteger compeTime = currentDate - prvTime;
    NSLog(@"%s crrpage=%@ categoryId=%@ timeout=%f crr=%ld, prv=%ld", __func__, pageIndex, categoryId, [Setting sharedSetting].newListRefreshTime*60, (long)currentDate, (long)prvTime);
    
    if (([[Setting sharedSetting] milestonesNewRefreshTimeForCategoryIdPerPage:categoryId pageIndex:pageIndex] != 0) && (compeTime < [Setting sharedSetting].newListRefreshTime*60)) {
        return false;
    }
    if (updateCacheNow)
        [[Setting sharedSetting] setMilestonesNewRefreshTimeForCagegoryPerPage:currentDate categoryId: categoryId pageIndex:pageIndex];
    
    return true;
}

//-- get news with category id
-(void) fetchingFeedsWithCategory:(NSInteger)index
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
            isCallingAPI = true;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //-- request news async
                if (checkTabValue == 0)
                {
                    [API getFeedofSingerID:PRODUCTION_ID
                         productionVersion:PRODUCTION_VERSION
                                  singerId:SINGER_ID completed:^(NSDictionary *responseDictionary, NSError *error)
                     {
                         //-- fetching
                         isCallingAPI = false;
                         if (error!=nil) {
                             [self checkAndShowErrorNoticeNetwork];
                             NSLog(@"Load from cache due API failed");
                             [self getHomeNewsDataFromDataBaseByIndex:(int)index];
                         }
                         else {
                             NSLog(@"tintuc data %ld entry=%lu", (long)index, (unsigned long)[responseDictionary count]);
                             //NSLog(@"tintuc %@ ", responseDictionary);
                             //-- parse json
                             [self getDatasourceFeedsWith:responseDictionary];
                         }
                     }];
                }
                else if (checkTabValue == 1)
                {
                    [API getAllMusicAndVideoOfSinglerID:SINGER_ID
                                          contentTypeId:ContentTypeIDSchedule
                                                  limit:@"100"
                                                   page:[NSString stringWithFormat:@"%d",0]
                                              isHotNode:@"0"
                                                 months:@"6"
                                                  appID:PRODUCTION_ID
                                             appVersion:PRODUCTION_VERSION
                                              completed:^(NSDictionary *responseDictionary, NSError *error)
                     {
                         
                         if (responseDictionary && !error)
                         {
                             isCallingAPI = false;
                             if (error!=nil) {
                                 [self checkAndShowErrorNoticeNetwork];
                                 NSLog(@"Load from cache due API failed");
                                 [self getHomeNewsDataFromDataBaseByIndex:(int)index];
                             }
                             else {
                                 NSLog(@"tintuc data %ld entry=%lu", (long)index, (unsigned long)[responseDictionary count]);
                                 //NSLog(@"tintuc %@ ", responseDictionary);
                                 //-- parse json
                                  [self createDataSourceAllScheduleFrom:responseDictionary byIndex:0];
                             }
                             
                            
                         }
                     }];
                }
                else if (checkTabValue == 2)
                {
                    [API getNodeForSingerID:SINGER_ID
                              contentTypeId:ContentTypeIDStore
                                      limit:@"10"
                                       page:[NSString stringWithFormat:@"%d", 0]
                                     period:@"1"
                                  isHotNode:@"0"
                                      start:@"-30"
                                      appID:PRODUCTION_ID
                                 appVersion:PRODUCTION_VERSION
                                  completed:^(NSDictionary *responseDictionary, NSError *error) {
                                      
                                      isCallingAPI = false;
                                      if (error!=nil) {
                                          [self checkAndShowErrorNoticeNetwork];
                                          NSLog(@"Load from cache due API failed");
                                          [self getHomeNewsDataFromDataBaseByIndex:(int)index];
                                      }
                                      else {
                                          NSLog(@"tintuc data %ld entry=%lu", (long)index, (unsigned long)[responseDictionary count]);
                                          //NSLog(@"tintuc %@ ", responseDictionary);
                                          //-- parse json
                                          [self createDataSourceWithoutCategory:responseDictionary];
                                      }
                                      
                                      
                                  }];
                }
            } );
//            return;
        }
    }
    NSLog(@"Load from cache");
    [self getHomeNewsDataFromDataBaseByIndex:(int)index];
    
}

- (void) scrolldownBigScroll
{
    NSLog(@"---scrolldownBigScroll: %f", scrollTotal.contentOffset.y);
    
    if (!bigScrollAnimating) [scrollTotal setContentOffset:CGPointMake(0, 387) animated:YES];
}

- (IBAction)selectedNews:(id)sender
{
    NewsViewController *nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idNewsViewControllerSb"];
    [self.navigationController pushViewController:nVC animated:YES];
}

- (IBAction)selectedMusic:(id)sender
{
//    MusicHomeViewController *mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idMusicHomeViewControllerSb"];
//    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)selectedVideo:(id)sender
{
//    VideoViewController *vVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbIDVideoViewController"];
//    [self.navigationController pushViewController:vVC animated:YES];
}

- (IBAction)selectedPhoto:(id)sender
{
//    PhotoViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbPhotoVIewControllerId"];
//    [self.navigationController pushViewController:pVC animated:YES];
}

- (IBAction)selectedMore:(id)sender
{
    viewFunctionExpand = [[UIView alloc]init];
    viewFunctionExpand.backgroundColor = [UIColor whiteColor];
    viewFunctionExpand.frame = CGRectMake(0.0, 0.0, 300.0, 200.0);
    viewFunctionExpand.layer.cornerRadius = 5;
    viewFunctionExpand.layer.masksToBounds = YES;
    
    scrollFunction = [[UIScrollView alloc] init];
    scrollFunction.backgroundColor = [UIColor whiteColor];
    scrollFunction.frame = CGRectMake(0.0, 0.0, 300.0, 200.0);
    scrollFunction.layer.cornerRadius = 5;
    scrollFunction.layer.masksToBounds = YES;
    [self loadScrollFunction];
    [viewFunctionExpand addSubview:scrollFunction];
    
    KLCPopup* popup = [KLCPopup popupWithContentView:viewFunctionExpand showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    // Init Page Control
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(viewFunctionExpand.frame.size.width/2 - 10,viewFunctionExpand.frame.size.height - 30,20,20);
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    [viewFunctionExpand addSubview:pageControl];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    [popup show];
}

- (void)loadScrollFunction
{
    scrollFunction.contentSize = CGSizeMake(scrollFunction.frame.size.width*2, scrollFunction.frame.size.height);
    scrollFunction.showsHorizontalScrollIndicator = NO;
    scrollFunction.showsVerticalScrollIndicator = NO;
    scrollFunction.alwaysBounceVertical = NO;
    scrollFunction.pagingEnabled = YES;
    scrollFunction.delegate = self;
    
    NSInteger numberOfViews = 2;
    for (int i = 0; i< numberOfViews; i++)
    {
        CGFloat xOrigin = i * scrollFunction.frame.size.width;
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 0, scrollFunction.frame.size.width, scrollFunction.frame.size.height)];
        switch (i)
        {
            case 0: {
                [myView addSubview:viewFunctionFirst];
                break;
            }
            case 1: {
                [myView addSubview:viewFunctionSecond];
                break;
            }
                
            default: {
                break;
            }
        }
        
        [scrollFunction addSubview:myView];
    }
    
    scrollFunction.contentSize = CGSizeMake(scrollFunction.frame.size.width * numberOfViews, scrollFunction.frame.size.height);
    
    [_btnAbout addTarget:self action:@selector(selectedAbout:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAppStore addTarget:self action:@selector(selectedAppStore:) forControlEvents:UIControlEventTouchUpInside];
    [_btnComedy addTarget:self action:@selector(selectedComedy:) forControlEvents:UIControlEventTouchUpInside];
    [_btnEarning addTarget:self action:@selector(selectedEarning:) forControlEvents:UIControlEventTouchUpInside];
    [_btnEducation addTarget:self action:@selector(selectedEducation:) forControlEvents:UIControlEventTouchUpInside];
    [_btnEvent addTarget:self action:@selector(selectedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_btnFanzone addTarget:self action:@selector(selectedFanZone:) forControlEvents:UIControlEventTouchUpInside];
    [_btnFunny addTarget:self action:@selector(selectedFunny:) forControlEvents:UIControlEventTouchUpInside];
    [_btnGameshow addTarget:self action:@selector(selectedGameshow:) forControlEvents:UIControlEventTouchUpInside];
    [_btnMarket addTarget:self action:@selector(selectedMarket:) forControlEvents:UIControlEventTouchUpInside];
    [_btnProfile addTarget:self action:@selector(selectedProfile:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSport addTarget:self action:@selector(selectedSport:) forControlEvents:UIControlEventTouchUpInside];
    [_btnTopUser addTarget:self action:@selector(selectedTopUser:) forControlEvents:UIControlEventTouchUpInside];
}

//-- direct from btn function
-(void)selectedAbout:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    AboutViewController *aVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbAboutViewControllerId"];
    [self.navigationController pushViewController:aVC animated:YES];
}

-(void)selectedAppStore:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    [self callUnderConstructionPopup];
}

-(void)selectedComedy:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    [self callUnderConstructionPopup];
}

-(void)selectedEarning:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    [self callUnderConstructionPopup];
}

-(void)selectedEducation:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    [self callUnderConstructionPopup];
}

-(void)selectedEvent:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    ScheduleViewController *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbScheduleViewControllerId"];
    [self.navigationController pushViewController:sVC animated:YES];
}

-(void)selectedFanZone:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    FanZoneViewController *fVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbIDFanZoneViewController"];
    [self.navigationController pushViewController:fVC animated:YES];
}

-(void)selectedFunny:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    [self callUnderConstructionPopup];
}

-(void)selectedGameshow:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    [self callUnderConstructionPopup];
}

-(void)selectedMarket:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    StoreViewController *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idStoreViewControllerSb"];
    [self.navigationController pushViewController:sVC animated:YES];
}

-(void)selectedProfile:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId)
    {
        ProfileViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idProfileViewControllerSb"];
        pVC.userId = userId;
        pVC.profileType = ProfileTypeMyAccount;
        pVC.isSelectedProfile = YES;
        [self.navigationController pushViewController:pVC animated:YES];
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}

-(void)selectedSport:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    [self callUnderConstructionPopup];
}

-(void)selectedTopUser:(id)sender
{
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    
    TopUserViewController *tVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idTopUserViewControllerSb"];
    [self.navigationController pushViewController:tVC animated:YES];
}

-(void)callUnderConstructionPopup
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"This function has not been published yet !"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Confirm", nil];
    [alert show];
}

@end
