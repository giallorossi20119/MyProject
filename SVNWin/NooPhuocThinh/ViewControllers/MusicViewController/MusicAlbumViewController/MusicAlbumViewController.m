//
//  MusicAlbumViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "MusicAlbumViewController.h"
#import "UIImageView+UIImageView_FaceAwareFill.h"

@interface MusicAlbumViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation MusicAlbumViewController

@synthesize segmentsArray, indexOfAlbum, arrTracks;
@synthesize albumIdStr;
@synthesize activityIndicator;
@synthesize tableviewMusic;
@synthesize pageViews = _pageViews;
@synthesize imgCover = _imgCover;
@synthesize tempImageView = _tempImageView;

NSInteger numberOfViews = 0;

//*******************************************************************************//
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
	// Do any additional setup after loading the view.
    
    [self setTitle:@"Music"];
    
    //-- set up view
    [self setViewWhenViewDidLoad];
    
    //-- set data
    [self setDataWhenViewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Music Album Screen";
    
    //-- show navigationbar
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    
    //-- check user and going to Fanzone screen
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataTableView) name:@"Reload_MusicAlbumVC" object:nil];
    
    //-- reload data
    [tableviewMusic.tableView reloadData];
}

-(void) reloadDataTableView {
    
    //-- reload data
    id currentTableView = [self.pageViews objectAtIndex:currentIndex];
    tableviewMusic = (BaseTableMusicViewController *) currentTableView;
    if ([tableviewMusic respondsToSelector:@selector(tableView)])
        [tableviewMusic.tableView reloadData];
    
    NSUserDefaults *defaultSelectedSong = [NSUserDefaults standardUserDefaults];
    [defaultSelectedSong setBool:NO forKey:@"Selected_ButtonNextSlideBar"];
    [defaultSelectedSong synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-- set data
-(void) setDataWhenViewDidLoad {
    
    //-- init char
    currentPageLoadMore = 0;
    currentIndex = indexOfAlbum;
    
    //-- create page scrolling
    [self createPageScrollAlbumMusic];
}

//-- create page scroll
-(void) createPageScrollAlbumMusic {
    
    numberOfViews = [segmentsArray count];
    
    scrollContainer.contentSize = CGSizeMake(scrollContainer.frame.size.width * numberOfViews, scrollContainer.frame.size.height);
    scrollContainer.showsHorizontalScrollIndicator = NO;
    scrollContainer.showsVerticalScrollIndicator = NO;
    scrollContainer.alwaysBounceVertical = NO;
    scrollContainer.pagingEnabled = YES;
    scrollContainer.scrollsToTop = NO;
    
    
    //-- Set up the array to hold the views for each page
    _pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < numberOfViews; ++i) {
        
        [self.pageViews addObject:[NSNull null]];
    }
    
    
    //-- Set the scroll view's content size, autoscroll to the stating tableview,
    //-- and setup the other display elements.
    [self setScrollViewContentSize];
    [self setCurrentIndex:indexOfAlbum];
    [self scrollToIndex:indexOfAlbum];
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
    NSInteger pageCount = numberOfViews;
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
    [segmentedControlAlbum setSelectedSegmentIndex:currentIndex];
    
    if (currentIndex == 0) {
        
        //-- change photo album
        self.imgCover.image = [UIImage imageNamed:@"album_img_noo.png"];
        
    }else {
        
        //-- get id album music
        NSString *albumImageStr = ((MusicAlbum *)[arrTracks objectAtIndex:currentIndex - 1]).thumbImagePath;
        [self.imgCover setClipsToBounds:YES];
        [self.imgCover setContentMode:UIViewContentModeScaleToFill]; //longnh

        [_imgCover setImageWithURL:[NSURL URLWithString:albumImageStr] placeholderImage:[UIImage imageNamed:@"album_img_noo.png"] options:SDWebImageProgressiveDownload progress:nil completed:nil];
        
        
        
        /*
        float scale = self.imgCover.frame.size.width / self.imgCover.frame.size.height;
        
        self.imgCover.image = [UIImage imageNamed:@"album_img_noo.png"];

        _tempImageView = [[UIImageView alloc] init];
        NSLog(@"url image:%@",albumImageStr);
        
        [_tempImageView setImageWithURL:[NSURL URLWithString:albumImageStr] placeholderImage:[UIImage imageNamed:@"album_img_noo.png"] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (!error) {
                //longnh fix
                float w = image.size.width;
                float h = image.size.width / scale;
                NSLog(@"origin w:%f h:%f",image.size.width,image.size.height);
                NSLog(@"resize w:%f h:%f",w,h);
                //crop image voi chieu rong fit chieu rong cua image, chieu cao lay tu top xuong theo dung ti le cua View
                CGImageRef cgImg = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, w, h));
                UIImage* part = [UIImage imageWithCGImage:cgImg];
                [_imgCover setImage:part];
                
            } else {
                NSLog(@"error load image");
            }
            [self.imgCover setClipsToBounds:YES];
            [self.imgCover setContentMode:UIViewContentModeScaleToFill]; //longnh
        }];
        [self.imgCover setClipsToBounds:YES];
        [self.imgCover setContentMode:UIViewContentModeScaleToFill]; //longnh
         */
         
    }
    
    //-- load data
    [self loadDataAlbum:currentIndex];
    
}

-(void)loadDataAlbum:(NSInteger)index
{
    if (index < 0 || index >= numberOfViews) {
        return;
    }
    
    //-- show loading
    if (![activityIndicator isAnimating]) {
        
        [activityIndicator setHidden:NO];
        [activityIndicator startAnimating];
    }
    
    if (index == 0) {
        //-- get all music
        [self fetchingMusicOfAllByIndex:index];
    }else {
        
        //-- get id album music
        albumIdStr = ((MusicAlbum *)[arrTracks objectAtIndex:index - 1]).albumId;
        
        //-- get album music
        [self fetchingMusicOfAlbum:albumIdStr ByIndex:index];
    }
}

- (void)unloadData:(NSInteger)index
{
    if (index < 0 || index >= numberOfViews) {
        return;
    }
    
    id currentTableView = [self.pageViews objectAtIndex:index];
    if ([currentTableView isKindOfClass:[BaseTableMusicViewController class]]) {
        [currentTableView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}


#pragma mark  UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
    if ((0< page <= [segmentsArray count]) && page != currentIndex) {
        [self setCurrentIndex:page];
    }
}

// Allow simultaneous recognition
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

// Handle pans by detecting swipes
- (void) handlePan: (UISwipeGestureRecognizer *) uigr
{
    // Only deal with scroll view superviews
    if (![scrollContainer.superview.superview isKindOfClass:[UIScrollView class]]) {
        
        // Extract superviews
        UIView *supersuper = scrollContainer.superview.superview;
        
        // Calculate location of touch
        CGPoint touchLocation = [uigr locationInView:supersuper];
        
        
        // Handle touch based on recognizer state
        
        if(uigr.state == UIGestureRecognizerStateBegan)
        {
            // Initialize recognizer
            startPoint = touchLocation;
        }
        
        if(uigr.state == UIGestureRecognizerStateChanged)
        {
            // Calculate whether a swipe has occurred
            float dx = DX(touchLocation, startPoint);
            float dy = DY(touchLocation, startPoint);
            
            BOOL finished = YES;
            if ((dx > SWIPE_DRAG_MIN) && (ABS(dy) < DRAGLIMIT_MAX))
                touchtype = TouchSwipeLeft;
            else if ((-dx > SWIPE_DRAG_MIN) && (ABS(dy) < DRAGLIMIT_MAX))
                touchtype = TouchSwipeRight;
            else if ((dy > SWIPE_DRAG_MIN) && (ABS(dx) < DRAGLIMIT_MAX))
                touchtype = TouchSwipeUp;
            else if ((-dy > SWIPE_DRAG_MIN) && (ABS(dx) < DRAGLIMIT_MAX))
                touchtype = TouchSwipeDown;
            else
                finished = NO;
            
            // If unhandled and a downward swipe, produce a new draggable view
            if (touchtype == TouchSwipeDown || touchtype == TouchSwipeUp)
            {
                [self.tableviewMusic.view setUserInteractionEnabled:YES];
                
            }else {
                
                if (self.tableviewMusic.tableView.dragging && self.tableviewMusic.tableView.decelerating) {
                    
                    [self.tableviewMusic.view setUserInteractionEnabled:NO];
                }else {
                    [self.tableviewMusic.view setUserInteractionEnabled:YES];
                }
            }
        }
        
        if(uigr.state == UIGestureRecognizerStateEnded)
        {
            //--
        }
    }
}

//---handle swipe gesture --
-(IBAction) handleSwipeGesture:(UIGestureRecognizer *)sender
{
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft: {
            
            currentIndex ++;
            
            //-- change segmanet
            [segmentedControlAlbum setSelectedSegmentIndex:currentIndex];
            
            //-- load data
            [self loadDataAlbum:currentIndex];
        }
            break;
        case UISwipeGestureRecognizerDirectionRight: {
            
            currentIndex --;
            
            //-- change segmanet
            [segmentedControlAlbum setSelectedSegmentIndex:currentIndex];
            
            //-- load data
            [self loadDataAlbum:currentIndex];
        }
            break;
            
        default:
            break;
    }
}

//*******************************************************************************//
#pragma mark - Set up UI

//-- setup view
-(void) setViewWhenViewDidLoad {
    
    //-- custom add barbutton to navigationbar
    [self addBarbutton];
    
    //-- add segment
    [self setUpSegmentControl];
    
    if (!isIphone5) {
        
        CGRect frameViewBT = [scrollContainer frame];
        frameViewBT.size.height = 192;
        [scrollContainer setFrame:frameViewBT];
    }
}

//-- add bar button
-(void) addBarbutton
{
    //-- back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(0, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
}


#pragma mark -- Segment

-(void) setUpSegmentControl
{
    //-- Segmented control with scrolling
    segmentedControlAlbum = [[HMSegmentedControl alloc] initWithSectionTitles:segmentsArray];
    segmentedControlAlbum.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 10);
    segmentedControlAlbum.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControlAlbum.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControlAlbum.scrollEnabled = YES;
    segmentedControlAlbum.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControlAlbum setFrame:CGRectMake(0, 138, 320, 45)];
    [segmentedControlAlbum addTarget:self action:@selector(segmentedControlChangedAlbumValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControlAlbum setTextColor:[UIColor grayColor]];
    segmentedControlAlbum.backgroundColor = COLOR_HOME_SEGMENT_BOLD;
    [segmentedControlAlbum setSelectedTextColor:[UIColor whiteColor]];
    [segmentedControlAlbum setSelectedSegmentIndex:currentIndex];
    segmentedControlAlbum.font = [UIFont systemFontOfSize:16.0f];
    
    [self.view addSubview:segmentedControlAlbum];
}

- (void)segmentedControlChangedAlbumValue:(HMSegmentedControl *)segmentedControl {
    
    if (segmentedControl.selectedSegmentIndex != currentIndex) {
        [self setCurrentIndex:segmentedControl.selectedSegmentIndex];
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
    }
}


//*******************************************************************************//
#pragma mark - Datasource

- (void)fetchingMusicOfAllByIndex:(int) byIndex
{
    //-- get all music from DB
    NSInteger countData = [self getAllMusicDataFromDataBaseByIndex:byIndex];
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    
    if (isErrorNetWork) {
        
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
        NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesMusicRefreshTime;
        if (([Setting sharedSetting].milestonesMusicRefreshTime!=0) && (compeTime < [Setting sharedSetting].musicRefreshTime*60) && (countData > 0))
            return;
        else
            [Setting sharedSetting].milestonesMusicRefreshTime = currentDate;
        
        //-- existing network request API get all music
        [self callAPIGetAllMusicByIndex:byIndex];
    }
}

//-- get all music from DB
-(NSInteger) getAllMusicDataFromDataBaseByIndex:(int) byIndex {
    
    NSInteger countData = 0;
    
    //-- remove lable nodata
    [self removeLableNoDataFrom:scrollContainer withIndex:byIndex];
    
    //-- read in cache
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    listData = [VMDataBase getAllTrackByAlbumId:nil];
    
    if (listData.count > 0) {
        
        countData = listData.count;
        
        //-- hidden loading
        [activityIndicator stopAnimating];
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        
        if (NO == [currentTableView isKindOfClass:[BaseTableMusicViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = [scrollContainer frame];
            frame.origin.x = frame.size.width * byIndex;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            tableviewMusic = [[BaseTableMusicViewController alloc] init];
            tableviewMusic.delegate = self;
            tableviewMusic.view.backgroundColor = [UIColor clearColor];
            [tableviewMusic.view setFrame:frame];
            [tableviewMusic.view setTag:byIndex];
            [tableviewMusic.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [tableviewMusic.tableView setSeparatorColor:COLOR_SEPARATOR_CELL];
            tableviewMusic.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

            tableviewMusic.listData  = listData;
            
            //-- add Refresh to tableview
            [self addRefreshAndLoadMoreForTableView:tableviewMusic.tableView WithIndex:byIndex];
            
            [scrollContainer addSubview:tableviewMusic.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:tableviewMusic];
            
        }else {
            
            tableviewMusic = (BaseTableMusicViewController *) currentTableView;
            
            tableviewMusic.listData  = listData;
            
            //-- reload data
            [tableviewMusic.tableView reloadData];
        }
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [scrollContainer frame];
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable nodata
        [self addLableNoDataTo:scrollContainer withIndex:byIndex withFrame:frame];
    }
    
    return countData;
}

//-- request API get all music
-(void) callAPIGetAllMusicByIndex:(int) byIndex {
    
    //-- request musics async
    [API getAllMusicAndVideoOfSinglerID:SINGER_ID
                          contentTypeId:ContentTypeIDMusic
                                  limit:@"10"
                                   page:[NSString stringWithFormat:@"%d",currentPageLoadMore]
                              isHotNode:@"0"
                                 months:@""
                                  appID:PRODUCTION_ID
                             appVersion:PRODUCTION_VERSION
                              completed:^(NSDictionary *responseDictionary, NSError *error) {
                                  
                                  //-- fetching
                                  [self createDataSourceAllSongFrom:responseDictionary ByIndex:byIndex];
                                  
                                  //-- hidden loading
                                  [activityIndicator stopAnimating];
                              }];
    
}

- (void)fetchingMusicOfAlbum:(NSString *)aId ByIndex:(int) byIndex
{
    //-- get music album from DB
    NSInteger countData = [self getMusicAlbumDataFromDataBaseMusicOfAlbum:aId ByIndex:byIndex];
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    
    if (isErrorNetWork) {
        
        //-- check time
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
        NSInteger compeTime = currentDate - [[Setting sharedSetting] milestonesMusicRefreshTimeForAlbumId:aId];
        
        if (([[Setting sharedSetting] milestonesMusicRefreshTimeForAlbumId:aId] != 0) && (compeTime < [Setting sharedSetting].musicRefreshTime*60) && countData > 0)
            return;
        else
            [[Setting sharedSetting] setMilestonesMusicRefreshTime:currentDate albumId:aId];
        
        //-- existing Network request API get music by AlbumID
        [self callAPIGetMusicByAlbumID:aId WithIndex:byIndex];
    }
    
}

//-- get music album from DB
-(NSInteger) getMusicAlbumDataFromDataBaseMusicOfAlbum:(NSString *)albumId ByIndex:(int) byIndex {
    
    NSInteger countData = 0;
    
    //-- remove lable nodata
    [self removeLableNoDataFrom:scrollContainer withIndex:byIndex];
    
    //-- hidden loading
    [activityIndicator stopAnimating];
    
    //-- read in cache
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    listData = [VMDataBase getAllTrackByAlbumId:albumId];
    
    if (listData.count > 0) {
        
        countData = listData.count;
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        
        if (NO == [currentTableView isKindOfClass:[BaseTableMusicViewController class]]) {
            
            //-- Load the photo view.
            CGRect frame = [scrollContainer frame];
            frame.origin.x = frame.size.width * byIndex;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            tableviewMusic = [[BaseTableMusicViewController alloc] init];
            tableviewMusic.delegate = self;
            tableviewMusic.view.backgroundColor = [UIColor clearColor];
            [tableviewMusic.view setFrame:frame];
            [tableviewMusic.view setTag:byIndex];
            [tableviewMusic.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [tableviewMusic.tableView setSeparatorColor:COLOR_SEPARATOR_CELL];
            tableviewMusic.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            tableviewMusic.listData  = listData;
            
            [scrollContainer addSubview:tableviewMusic.view];
            [self.pageViews replaceObjectAtIndex:byIndex withObject:tableviewMusic];
            
        }else {
            
            tableviewMusic = (BaseTableMusicViewController *) currentTableView;
            
            tableviewMusic.listData  = listData;
            
            //-- reload data
            [tableviewMusic.tableView reloadData];
        }
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [scrollContainer frame];
        frame.origin.x = frame.size.width * byIndex;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable no data
        [self addLableNoDataTo:scrollContainer withIndex:byIndex withFrame:frame];
    }
    
    return countData;
}

//-- request API get music by AlbumID
-(void) callAPIGetMusicByAlbumID:(NSString *)aId WithIndex:(int) byIndex {
    
    [API getNodeByAlbum:aId
          contentTypeId:ContentTypeIDMusic
                  limit:@"100"
                   page:@"0"
              isHotNode:@"0"
                  appID:PRODUCTION_ID
             appVersion:PRODUCTION_VERSION
              completed:^(NSDictionary *responseDictionary, NSError *error) {
                  
                  if (!error) {
                      //-- fetching
                      [self createDatasourceMusicOfAlbum:responseDictionary withAbId:aId ByIndex:byIndex];
                  }
                  
                  //-- hidden loading
                  [activityIndicator stopAnimating];
              }];
    
}


-(void)createDataSourceAllSongFrom:(NSDictionary *)aDictionary ByIndex:(int) byIndex
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"singer_list"];
    
    if ([arrSinger count] > 0)
    {
        NSMutableArray *nodeList = [[arrSinger objectAtIndex:0] objectForKey:@"node_list"];
        
        if ([nodeList count] > 0) {
            
            //-- add objects
            [self addObjectToListAndSaveDatabaseBy:nodeList withAbId:@"" ByIndex:byIndex isMusicAllSong:YES];
        }
    }
    
    //-- check for tableview all music
    if (byIndex == 0) {
        
        //-- get tableview All Video in scrollview
        if (scrollContainer.subviews.count > 0) {
            
            for (UITableView *viewTB in scrollContainer.subviews) {
                
                if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                    
                    //-- hidden loading
                    [viewTB.infiniteScrollingView stopAnimating];
                    
                    break;
                }
            }
        }
    }
}


- (void)createDatasourceMusicOfAlbum:(NSDictionary *)aDictionary withAbId:(NSString *)abId ByIndex:(int) byIndex
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"album_list"];
    
    if ([arrSinger count] > 0)
    {
        NSMutableArray *nodeList = [[arrSinger objectAtIndex:0] objectForKey:@"node_list"];
        
        if ([nodeList count] > 0) {
            
            //-- add objects
            [self addObjectToListAndSaveDatabaseBy:nodeList withAbId:abId ByIndex:byIndex isMusicAllSong:NO];
        }
    }
}

//-- add object
-(void) addObjectToListAndSaveDatabaseBy:(NSMutableArray *) nodeList withAbId:(NSString *)abId ByIndex:(int) byIndex isMusicAllSong:(BOOL) isAllSong {
    
    if (![abId isEqualToString:@""]) {
        [VMDataBase deleteAllTrackByAlbumId:abId];
    }
    for (NSInteger i = 0; i < [nodeList count]; i++)
    {
        MusicTrackNew *mTrack = [[MusicTrackNew alloc] init];
        
        mTrack.songRingbacktoneId = [[nodeList objectAtIndex:i] objectForKey:@"is_ringback_tone"];
        mTrack.nodeId = [[nodeList objectAtIndex:i] objectForKey:@"node_id"];
        mTrack.albumAuthorMusicId = [[nodeList objectAtIndex:i] objectForKey:@"album_author_music_id"];
        mTrack.albumDescription = [[nodeList objectAtIndex:i] objectForKey:@"album_description"];
        mTrack.albumEngName = [[nodeList objectAtIndex:i] objectForKey:@"album_english_name"];
        mTrack.albumId = [[nodeList objectAtIndex:i] objectForKey:@"album_id"];
        mTrack.albumIsHot = [[nodeList objectAtIndex:i] objectForKey:@"album_is_hot"];
        mTrack.albumMusicPublisherId = [[nodeList objectAtIndex:i] objectForKey:@"album_music_publisher_id"];
        mTrack.albumMusicType = [[nodeList objectAtIndex:i] objectForKey:@"album_music_type"];
        mTrack.albumName = [[nodeList objectAtIndex:i] objectForKey:@"album_name"];
        mTrack.albumPublishedYear = [[nodeList objectAtIndex:i] objectForKey:@"album_published_year"];
        mTrack.albumSetingTotalRating= [[nodeList objectAtIndex:i] objectForKey:@"setting_total_rating"];
        mTrack.albumSettingTotalView = [[nodeList objectAtIndex:i] objectForKey:@"album_setting_total_view"];
        mTrack.albumThumbImagePath = [[nodeList objectAtIndex:i] objectForKey:@"album_thumbnail_image_file_path"];
        mTrack.albumTotalTrack = [[nodeList objectAtIndex:i] objectForKey:@"album_total_track"];
        mTrack.albumTrueTotalRating = [[nodeList objectAtIndex:i] objectForKey:@"album_true_total_rating"];
        mTrack.albumTrueTotalView = [[nodeList objectAtIndex:i] objectForKey:@"album_true_total_view"];
        mTrack.content = [[nodeList objectAtIndex:i] objectForKey:@"content"];
        mTrack.countryId = [[nodeList objectAtIndex:i] objectForKey:@"country_id"];
        mTrack.engName = [[nodeList objectAtIndex:i] objectForKey:@"english_name"];
        mTrack.isHot = [[nodeList objectAtIndex:i] objectForKey:@"is_hot"];
        mTrack.musicPath = [[nodeList objectAtIndex:i] objectForKey:@"music_path"];
        mTrack.musicType = [[nodeList objectAtIndex:i] objectForKey:@"music_type"];
        mTrack.name = [[nodeList objectAtIndex:i] objectForKey:@"name"];
        mTrack.nodeId = [[nodeList objectAtIndex:i] objectForKey:@"node_id"];
        mTrack.numberOfTrack = [[nodeList objectAtIndex:i] objectForKey:@"number_of_track"];
        mTrack.settingTotalRating = [[nodeList objectAtIndex:i] objectForKey:@"setting_total_rating"];
        mTrack.settingTotalView = [[nodeList objectAtIndex:i] objectForKey:@"setting_total_view"];
        mTrack.thumbImagePath = [[nodeList objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
        mTrack.thumbImageType = [[nodeList objectAtIndex:i] objectForKey:@"thumbnail_image_type"];
        mTrack.translateContent = [[nodeList objectAtIndex:i] objectForKey:@"translated_content"];
        mTrack.trueTotalRating = [[nodeList objectAtIndex:i] objectForKey:@"true_total_rating"];
        mTrack.trueTotalView = [[nodeList objectAtIndex:i] objectForKey:@"true_total_view"];
        
        NSString *numberComment = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"sns_total_comment"]];
        NSString *numberLike = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"sns_total_like"]];
        NSString *isLiked = [NSString stringWithFormat:@"%@",[[nodeList objectAtIndex:i] objectForKey:@"is_liked"]];
        mTrack.snsTotalDisLike = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_dislike"];
        mTrack.snsTotalShare = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_share"];
        mTrack.snsTotalView = [[nodeList objectAtIndex:i] objectForKey:@"sns_total_view"];
        mTrack.snsTotalComment = numberComment;
        mTrack.snsTotalLike = numberLike;
        mTrack.isLiked = isLiked;
        
        MusicTrackNew *mTrackFromDB = nil;
        if ([abId isEqualToString: @""]) //all thi update theo id
            mTrackFromDB = [VMDataBase getATrackByNodeId:mTrack.nodeId];
        if (mTrackFromDB && mTrackFromDB.nodeId) {
            
            //-- neu mTrackFromDB.snsTotalComment < mTrack.snsTotalComment thi update vao Db
            if ([mTrackFromDB.snsTotalComment integerValue] > [mTrack.snsTotalComment integerValue]) {
                
                mTrack.snsTotalComment = mTrackFromDB.snsTotalComment;
            }
            
            //-- neu mTrackFromDB.snsTotalLike < mTrack.snsTotalLike thi update vao Db
            if ([mTrackFromDB.snsTotalLike integerValue] > [mTrack.snsTotalLike integerValue]) {
                
                mTrack.snsTotalLike = mTrackFromDB.snsTotalLike;
            }
            
            //-- update a Track by nodeId
            [VMDataBase updateTrackByAlbum:mTrack];
            
        }else {
            
            //-- insert into DB
            [VMDataBase insertTrackByAlbum:mTrack];
        }
    }
    
    if (byIndex == 0 && isAllSong == YES) {
        
        //-- get all music from DB
        [self getAllMusicDataFromDataBaseByIndex:byIndex];
        
    }else {
        
        //-- get music album from DB
        [self getMusicAlbumDataFromDataBaseMusicOfAlbum:abId ByIndex:byIndex];
    }
}


- (void) addRefreshAndLoadMoreForTableView:(UITableView *)aTableview WithIndex:(int) byIndex
{
    //-- refresh data
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:aTableview];
    [refreshControl addTarget:self action:@selector(refreshDataMusic:) forControlEvents:UIControlEventValueChanged];
    
    //-- load more from bottom
    __weak MusicAlbumViewController *myself = self;
    
    //  -- setup infinite scrolling
    [aTableview addInfiniteScrollingWithActionHandler:^{
        
        [myself loadMoreVideoWithIndex:byIndex];
    }];
}

//-- refresh tableview
-(void) refreshDataMusic:(ODRefreshControl *) refresh
{
    [refresh beginRefreshing];
    
    if (scrollContainer.subviews.count > 0) {
        
        UITableView *viewTableviewVideo = [scrollContainer.subviews objectAtIndex:currentIndex];
        
        [viewTableviewVideo reloadData];
    }
    
    [refresh endRefreshing];
}

//-- load more video
-(void)loadMoreVideoWithIndex:(int) byIndex
{
    //-- check time
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesMusicRefreshTime;
    
    if (([Setting sharedSetting].milestonesMusicRefreshTime != 0) && (compeTime < [Setting sharedSetting].musicRefreshTime*60))
    {
        for (UITableView *viewTB in scrollContainer.subviews) {
            
            if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                
                //-- hidden loading
                [viewTB.infiniteScrollingView stopAnimating];
                
                break;
            }
        }

        return;
    }
    else
        [Setting sharedSetting].milestonesMusicRefreshTime = currentDate;
    
    if (scrollContainer.subviews.count > 0) {
        
        //-- check and add tableview music
        id currentTableView = [self.pageViews objectAtIndex:byIndex];
        tableviewMusic = (BaseTableMusicViewController *) currentTableView;
        
        if (tableviewMusic.listData.count %10 == 0) {
            
            currentPageLoadMore ++;
            
            //-- get all music
            [self fetchingMusicOfAllByIndex:byIndex];
            
        }else {
            
            //-- hidden loading
            [activityIndicator stopAnimating];
            
            //-- check for tableview all music
            if (byIndex == 0) {
                
                for (UITableView *viewTB in scrollContainer.subviews) {
                    
                    if ([viewTB isKindOfClass:[UITableView class]] && viewTB.tag == byIndex) {
                        
                        //-- hidden loading
                        [viewTB.infiniteScrollingView stopAnimating];
                        
                        break;
                    }
                }
            }
        }
    }
}



//*******************************************************************************//
#pragma mark - BaseTableviewMusic delegate

//-- delegate play Music
-(void) goToMusicPlayViewControllerWithListData:(NSMutableArray *)listData withIndexRow:(int)indexRow
{
    MusicPlayViewController *mpVC = (MusicPlayViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"idMusicPlayViewControllerSb"];
    
    mpVC.arrTrack = listData;
    mpVC.indexOfSong = indexRow;
    mpVC.titleAlbum = [segmentsArray objectAtIndex:currentIndex];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:mpVC animated:YES];
    else
        [self.navigationController pushViewController:mpVC animated:NO];
    
    //longnh add
    MusicTrackNew *selectTrack = (MusicTrackNew*)[listData objectAtIndex:indexRow];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"play_song"  // Event action (required)
                                                           label:selectTrack.name
                                                           value:nil] build]];

}

//-- delegate Ringback and DownLoad
-(void) passDelegateGoToMusicAlbumViewController:(NSMutableArray *) listData withIndexRow:(int) indexRow ByDelegateType:(delegateTypes) delegateType {
    
    MusicTrackNew *msTrack = [listData objectAtIndex:indexRow];
    
    if (delegateType == delegateRingBackType) {
        
        //-- request get SongRingBackToneId
        [self callApiGetSongRingBackToneIdByMusicID:msTrack];
        
    }else {
        
        //-- BaseTableMusic pass Delegate thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}

//--Alertview Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int tag = alertView.tag;
    switch (tag) {
            
        case 100: {
            if (buttonIndex == 0) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *command_gateway = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_ringbackCommand_gateway]];
                
                NSString *songRingbacktoneId = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"SONG_RINGBACKTONEID_DEFAULT"]];
                
                NSString *tempBody = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_ringbackCommand_body]];
                NSString *command_body = [tempBody stringByReplacingOccurrencesOfString:@"SONG_RINGBACKTONE_ID" withString:songRingbacktoneId];
                
                [self sendSMSRingback:command_body recipientList:@[command_gateway]];
                
            }else return;
        }
            break;
            
        default:
            break;
    }
}

//-- result send Message
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"%s", __func__);
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
}

//-- title & content of SMS
- (void)sendSMSRingback:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        {
            [self presentModalViewController:controller animated:YES];
        }
        else
        {
            [self presentViewController:controller animated:YES completion:Nil];
        }
    }
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


//-- request get SONG_RINGBACKTONE_ID
-(void) callApiGetSongRingBackToneIdByMusicID:(MusicTrackNew *) msTrack {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *telcoCode = [userDefaults valueForKey:Key_telco_global_code];
    
    //-- show loading
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Getting..."];
    
    //-- request SONG_RINGBACKTONE_ID
    [API apiGetSongRingBackToneIDByMusicID:msTrack.nodeId distributorChannelId:DISTRIBUTOR_CHANNEL_ID telcoCode:telcoCode appID:PRODUCTION_ID appVersion:PRODUCTION_VERSION completed:^(NSDictionary *responseDictionary, NSError *error) {
        
        //-- hidden loading
        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:0.1f];
        
        NSDictionary *data = [responseDictionary valueForKey:@"data"];
        
        //-- fetching
        if (!error && data) {
            
            NSString *ringback_tone_code = [data valueForKey:@"ringback_tone_code"];
            
            if (ringback_tone_code && [ringback_tone_code length]>0) {
                
                //-- save ringback_tone_code
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:ringback_tone_code forKey:@"SONG_RINGBACKTONEID_DEFAULT"];
                [userDefaults synchronize];
                
                NSString *message = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:Key_ringbackMessage]];
                NSString *tempMessage = [message stringByReplacingOccurrencesOfString:@"SONG_NAME" withString:msTrack.name];
                
                //-- Send SMS Nhac Cho
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:kTitleMessageApp message:tempMessage delegate:nil cancelButtonTitle:@"Đồng ý" otherButtonTitles:@"Huỷ", nil];
                [alertview setDelegate:self];
                [alertview setTag:100];
                [alertview show];
                
            }else {
                
                //-- show error
                [self showMessageSystemError];
            }
            
        }else {
            
            //-- show error
            [self showMessageSystemError];
        }
        
    }];
}

//-- show error
-(void) showMessageSystemError {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
    
    [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
}

@end
