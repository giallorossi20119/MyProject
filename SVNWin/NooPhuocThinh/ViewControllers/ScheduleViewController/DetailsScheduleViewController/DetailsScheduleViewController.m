//
//  DetailsScheduleViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/30/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "DetailsScheduleViewController.h"

#define kWebCellTag -10000

enum
{
    VMContentTypeText = 0,
    VMContentTypeHTML = 1,
    VMContentPhone = 2
};

typedef NSUInteger VMContentType;

/**
 *  VMContent
 *----------------------------------------------------------------------*/
@interface VMContent : NSObject

/**
 *  content
 */
@property (nonatomic, retain) NSString *content;

/**
 *  image
 */
@property (nonatomic, retain) UIImage *imageIcon;

/**
 *  type
 *  type == 0 => plain text, type == 1 ==> html text
 */
@property (nonatomic, assign) VMContentType type;

/**
 *  cell's height
 */
@property (nonatomic, assign) float height;

/**
 *  doneResize
 *  if doneResize = NO, you should not load htmlContent from cell
 */
@property (nonatomic, assign) BOOL doneResize;


/**
 *  contentWithType
 */
+(VMContent*) contentWithType:(VMContentType)type image:(UIImage*)image text:(NSString*)text;

@end

@implementation VMContent

+(VMContent*) contentWithType:(NSUInteger)type image:(UIImage *)image text:(NSString *)text
{
    VMContent *ctx = [VMContent new];
    ctx.type = type;
    ctx.content = text;
    ctx.imageIcon = image;
    ctx.height = 44.0f;
    ctx.doneResize = (type == VMContentTypeText ? YES : NO);
    return ctx;
}

@end


@interface DetailsScheduleViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation DetailsScheduleViewController

@synthesize tableviewDetail, viewComment;
@synthesize dataSourceSchedule, dataSourceCell, schedule ;
@synthesize activityIndicator;
@synthesize pageViews = _pageViews;
@synthesize viewInfo, tempWebView;

NSInteger numberView = 0;

//hiepph
BOOL                                bigScroll_isPerformingToTop = false;
BOOL                                bigScroll_finishedOnTop = false;
BOOL                                bigScroll_isAnimatingTop = false;
BOOL                                tableView_isPerformingDown = false;
BOOL                                tableView_finishedDown = true;
BOOL                                tableView_isAnimatingDown = false;
float                               lastContentOffset_tableView = 0.0f;
float                               lastContentOffset_bigScroll = 0.0f;
float                               TOP_POSITION = 290.0f;
ScrollDirection                     scrollDirection_tableView;
ScrollDirection                     scrollDirection_bigScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark -
#pragma mark Inits

/**
 *  fetchingData
 */
-(void) fetchingData
{
    //-- alloc objs
    if (_listData) {
        
        [_listData removeAllObjects];
        [self.tableviewDetail reloadData];
        
    } else {
        _listData = [NSMutableArray new];
    }
    NSLog(@"fetchingData: %f - %f", bigScrollview.contentOffset.y,self.tableviewComment.contentOffset.y);
    //hiepph
    if (bigScrollview.contentOffset.y == TOP_POSITION) {
        tableviewDetail.scrollEnabled = true;
        self.tableviewComment.scrollEnabled = true;
    }
    else {
        tableviewDetail.scrollEnabled = false;
        self.tableviewComment.scrollEnabled = false;
    }
    
    bigScroll_isAnimatingTop = false;
    bigScroll_finishedOnTop = false;
    bigScroll_isPerformingToTop = false;
    tableView_finishedDown = true;
    tableView_isAnimatingDown = false;
    tableView_isPerformingDown = false;
    lastContentOffset_bigScroll = 0.0f;
    lastContentOffset_tableView = 0.0f;
    
    _queueH = [NSMutableArray new];
    _condition = [[NSCondition alloc] init];
    
    //-- get txt from file
    NSString *contentString = schedule.desciption;
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width = '300' height = auto "];
    NSString *metaHTML = @"<meta name=\"viewport\" content=\"width = 300,initial-scale = 1.0,maximum-scale = 1.0\" />";
    NSString *formatHTML = @"<html>%@<body style=\"background-color: clear color; font-size: 12; font-family: HelveticaNeue; color: #000000\">%@</body> </html>";
    NSString *contentHTML = [NSString stringWithFormat:formatHTML,metaHTML,contentString];
    
    //-- init list
    //-- content time
    // commented by hiepph
    NSString *timeStr = [Utility convertScheduleTime:schedule.startDate];
//    [_listData addObject:[VMContent contentWithType:VMContentTypeText image:[UIImage imageNamed:@"schedule_icon_watch.png"] text:timeStr]];
//    
//    //-- content address
//    [_listData addObject:[VMContent contentWithType:VMContentTypeText image:[UIImage imageNamed:@"schedule_icon_map.png"] text:schedule.locationEventAddress]];
//    
//    //-- content list singer
//    //[_listData addObject:[VMContent contentWithType:VMContentTypeText image:[UIImage imageNamed:@"schedule_icon_singer.png"] text:schedule.listSinger]];
    
    //-- validate content phone
    NSString *tempnamePhone = [schedule.phone stringByReplacingOccurrencesOfString:@"0" withString:@""];
    BOOL thereArePhone = [tempnamePhone isEqualToString:@""];
    if(!thereArePhone) {
        lblPhone.text = schedule.phone;
    }
    else {
        lblPhone.text = @"no number";
    }
    
    //hiepph - new labels
    lblAddress.text = schedule.locationEventAddress;
    lblTime.text = timeStr;
    
    //-- validate content price
    NSString *tempnamePrice = [schedule.price stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereArePrice = [tempnamePrice isEqualToString:@""];
    
//    if(!thereArePrice) {
//        [_listData addObject:[VMContent contentWithType:VMContentTypeText image:[UIImage imageNamed:@"schedule_icon_cash.png"] text:schedule.price]];
//    }
    
    //-- validate content detail infor
//    [_listData addObject:[VMContent contentWithType:VMContentTypeText image:[UIImage imageNamed:@"schedule_icon_info.png"] text:@"Thông tin chi tiết:"]];
    
    //-- validate content price
    [_listData addObject:[VMContent contentWithType:VMContentTypeHTML image:nil text:contentHTML]];
    
#if 0
    [self.tableView setHidden:YES];
    [self.tempWebView loadHTMLString:contentHTML baseURL:nil];
    
#else
    //-- estm to reload
    [self.tempWebView setDelegate:self];
    [self estimatingCellHeightComplete:^(NSError *error) {
        [self.tempWebView setHidden:YES];
        [tableviewDetail reloadData];
    }];
#endif
    
    //hiepph
    bigScrollview.contentSize = CGSizeMake(bigScrollview.frame.size.width, self.view.frame.size.height * 2); //hiepph
    bigScrollview.showsHorizontalScrollIndicator = NO;
    bigScrollview.showsVerticalScrollIndicator = NO;
    bigScrollview.alwaysBounceVertical = NO;
    bigScrollview.pagingEnabled = NO;
    bigScrollview.scrollsToTop = YES;
    
    //hiepph - tableViewDetail auto fit data
    CGRect contentRect = CGRectZero;
    for (UIView *view in tableviewDetail.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    tableviewDetail.contentSize = contentRect.size;
    self.tableviewComment.contentSize = contentRect.size;
}

-(void)estimateHeightForContent:(VMContent *)ctx
{
    if (ctx.type == VMContentTypeHTML) {
        NSInteger index = [_listData indexOfObject:ctx];
        [self.tempWebView setTag:index];
        [self.tempWebView loadHTMLString:ctx.content baseURL:nil];
    }
}

-(void)estimateHeightForRowText:(VMContent *)ctx
{
    [Utility heightFromString:ctx.content maxWidth:300 font:[UIFont systemFontOfSize:12.0f]];
}

-(void) estimatingCellHeightComplete:(void (^)(NSError * error)) completed
{
    dispatch_queue_t clientQueue = dispatch_queue_create("com.vmodev.hc",NULL);
    dispatch_async( clientQueue, ^{
        
        //-- loop via html content
        for (int ii = 0; ii < [_listData count]; ii++) {
            
            //-- html context
            VMContent *ctx = [_listData objectAtIndex:ii];
            
            //-- lock to load HTMl
            [_condition lock];
            if (ctx.type == VMContentTypeHTML)
            {
                [self performSelectorOnMainThread:@selector(estimateHeightForContent:) withObject:ctx waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(estimateHeightForRowText:) withObject:ctx waitUntilDone:NO];
                [_condition unlock];
                continue;

            }
            
            [_queueH addObject:ctx];
            
            //-- wait for next
            if ([_queueH count])
                [_condition wait];
            
            [_condition unlock];
        }
        
        //-- done
        dispatch_sync(dispatch_get_main_queue(), ^{
            completed(nil);
        });
    });
}



#pragma mark - Main

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:@"LD"];
    
//    -- set up view
    [self setViewWhenViewDidLoad];
    
//    -- set data
    [self setDataWhenViewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Detail Schedule Screen";
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentScheduleIndex"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-- setup view
-(void) setViewWhenViewDidLoad
{
    //-- custom add barbutton to navigationbar
    [self customNavigationBar];
    
    //-- set button like image
    if ([schedule.isLiked isEqualToString:@"1"])
    {
        [btnLiked setImage:[UIImage imageNamed:@"like_active.png"] forState:UIControlStateNormal];
        lblLiked.text = @"Liked";
    }
    else
    {
        [btnLiked setImage:[UIImage imageNamed:@"like_normal.png"] forState:UIControlStateNormal];
        lblLiked.text = @"Like";
    }
    
    lblNumberComment.text =  [NSString stringWithFormat:@"%@ comment",schedule.snsTotalComment];
    lblNumberLike.text = [NSString stringWithFormat:@"%@ like",schedule.snsTotalLike];
    lblNumberShare.text = [NSString stringWithFormat:@"%@ share",schedule.snsTotalShare];
    lblNumberView.text = [NSString stringWithFormat:@"%@ view",schedule.snsTotalView];
    
    NSArray *arrSeg = [NSArray arrayWithObjects:@"Thông tin", @"Bình luận",nil];
    segmentArray  = [[NSMutableArray alloc] initWithArray:arrSeg];
    
    [self setUpSegmentControl];
    
    [self createPageScrollSchedule];
    
    //-- set frame for viewInfo
    CGRect frameViewInfo = self.viewInfo.frame;
    frameViewInfo.origin.x = 0;
    self.viewInfo.frame = frameViewInfo;
    
    //-- set frame for viewComment
    CGRect frameViewComment = self.viewComment.frame;
    frameViewComment.origin.x = 320;
    self.viewComment.frame = frameViewComment;
    
    _isAutoScroll = YES;
    
    //hiepph - comment action
    [btnComment addTarget:self action:@selector(clickcomment:) forControlEvents:UIControlEventTouchUpInside];
    
    //hiepph - scroll event
    bigScrollview.delegate = self;
}

#pragma mark - Scroll events

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (!decelerate) {
//        //Do your  Stuff
//        NSLog(@"scrollViewDidEndDragging");
//        if (scrollView == bigScrollview) {
//            CGRect frame = [viewSegment convertRect:viewSegment.frame toView:self.view];
//            
//            NSLog(@"scrollViewDidEndDragging: %f",frame.origin.y);
//            if (frame.origin.y < 230.0f) {
//                [bigScrollview setContentOffset:CGPointMake(0, 230.0f) animated:NO];
//                tableviewDetail.scrollEnabled = true;
//            }
//            else {
//                tableviewDetail.scrollEnabled = false;
//            }
//        }
//    }
}
//hiepph - begin
#pragma mark  - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollContainer) {
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = floor(fractionalPage);
        if (page != _currentIndex) {
            [self setCurrentIndex:page];
        }
        else if (page == 0) {
            NSLog(@"back screen");
            if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
                [self.navigationController popViewControllerAnimated:YES];
            else
                [self.navigationController popViewControllerAnimated:NO];
        }
    }
    else if (scrollView == bigScrollview)
    {
        NSLog(@"scrollViewDidEndDecelerating: %f",bigScrollview.frame.origin.y);
    }
    else if (scrollView == tableviewDetail || scrollView == self.tableviewComment)
    {
        
        NSLog(@"check end scrolling tableviewDetail: %d, %d",bigScroll_isPerformingToTop,tableView_isPerformingDown);
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation: %f",scrollView.frame.origin.y);
    if (scrollView == bigScrollview)
    {
        NSLog(@"scrollViewDidEndScrollingAnimation - bigScrollView: %f",bigScrollview.contentOffset.y);
        if (bigScrollview.contentOffset.y == TOP_POSITION) {
            NSLog(@"scrollViewDidEndScrollingAnimation - bigScrollview at TOP_POSITION");
            bigScroll_finishedOnTop = true;
            bigScroll_isPerformingToTop = false;
            tableView_finishedDown = false;
            tableView_isPerformingDown = false;
            bigScroll_isAnimatingTop = false;
            tableView_isAnimatingDown = false;
            bigScrollview.scrollEnabled = false;
            tableviewDetail.scrollEnabled = true;
            self.tableviewComment.scrollEnabled = true;
        }
        else if(scrollView.contentOffset.y == 0.0f) {
            NSLog(@"scrollViewDidEndScrollingAnimation - bigScrollview at 0.0");
            bigScroll_finishedOnTop = false;
            bigScroll_isPerformingToTop = false;
            bigScrollview.scrollEnabled = true;
            tableView_isPerformingDown = false;
            tableView_isAnimatingDown = false;
            tableView_finishedDown = true;
        }
    }
    else if (scrollView == tableviewDetail || scrollView == self.tableviewComment)
    {
        
        NSLog(@"check end scrolling tableviewDetail: %d",bigScroll_isPerformingToTop);
        if (scrollView.contentOffset.y == 0.0f)
        {
            NSLog(@"scrollViewDidEndScrollingAnimation - tableView at 0.0");
            tableView_finishedDown = true;
            bigScroll_finishedOnTop = false;
            tableView_isPerformingDown = false;
            bigScroll_isPerformingToTop = false;
            tableView_isAnimatingDown = false;
            bigScroll_isAnimatingTop = false;
            tableviewDetail.scrollEnabled = false;
            self.tableviewComment.scrollEnabled = false;
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
//    NSLog(@"scrollViewDidScroll: %d - %d",bigScroll_isPerformingToTop,tableView_isPerformingDown);
    //hiepph - to check view & expand segment info while scrolling
    // stop scrolling when viewSegment reach top
    
    if (scrollView == bigScrollview) {
        
        float scrollOffset = scrollView.contentOffset.y;
        
        if (lastContentOffset_tableView > scrollView.contentOffset.y)
            scrollDirection_bigScroll = ScrollDirectionDown;
        else if (lastContentOffset_tableView < scrollView.contentOffset.y)
            scrollDirection_bigScroll = ScrollDirectionUp;
        
        CGRect frame = [viewSegment convertRect:viewSegment.frame toView:self.view];
        
        if (scrollDirection_bigScroll == ScrollDirectionUp) {
            bigScroll_isPerformingToTop = true;
            tableView_isPerformingDown = false;
        }
        else if (scrollDirection_bigScroll == ScrollDirectionDown) {
            bigScroll_isPerformingToTop = false;
        }
        
        NSLog(@"bigScrollview - scrollViewDidScroll: %d - %d - %d - %d ",bigScroll_isPerformingToTop,tableView_isPerformingDown, bigScroll_isAnimatingTop, tableView_isAnimatingDown);
        
        if (frame.origin.y < 395.0f && bigScroll_isPerformingToTop && !tableView_isPerformingDown && !bigScroll_isAnimatingTop && !tableView_isAnimatingDown) {
            NSLog(@"gotoTop: %d - %d - %d - %d", bigScroll_finishedOnTop, bigScroll_isPerformingToTop, tableView_finishedDown, tableView_isPerformingDown);
            bigScroll_isPerformingToTop = true;
            tableView_isPerformingDown = false;
            bigScroll_finishedOnTop = false;
            tableView_finishedDown = false;
            [bigScrollview setContentOffset:CGPointMake(0, TOP_POSITION) animated:YES];
            tableviewDetail.scrollEnabled = true;
            self.tableviewComment.scrollEnabled = true;
            bigScrollview.scrollEnabled = false;
            bigScroll_isAnimatingTop = true;
            tableView_isAnimatingDown = false;
        }
        else if (frame.origin.y >= 395.0f && bigScroll_isPerformingToTop && !tableView_isPerformingDown) {
            NSLog(@"else cdg");
            tableView_finishedDown = false;
            bigScroll_isAnimatingTop = false;
        }
        
        lastContentOffset_bigScroll = scrollView.contentOffset.y;
    }
    else if(scrollView == tableviewDetail || scrollView == self.tableviewComment) {
        float scrollOffset = scrollView.contentOffset.y;
        
        if (lastContentOffset_tableView > scrollView.contentOffset.y)
            scrollDirection_tableView = ScrollDirectionDown;
        else if (lastContentOffset_tableView < scrollView.contentOffset.y)
            scrollDirection_tableView = ScrollDirectionUp;
        
        if (scrollDirection_tableView == ScrollDirectionDown) {
            tableView_isPerformingDown = true;
            bigScroll_isPerformingToTop = false;
        }
        else if (scrollDirection_tableView == ScrollDirectionUp) {
            tableView_isPerformingDown = false;
            bigScroll_isPerformingToTop = false;
        }
        
        if (scrollOffset < 100.0f && tableView_isPerformingDown && !bigScroll_isPerformingToTop && !tableView_isAnimatingDown) {
            NSLog(@"==========================================");
            tableView_isPerformingDown = false;
            bigScroll_isPerformingToTop = false;
            [bigScrollview setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
            [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
            tableviewDetail.scrollEnabled = false;
            self.tableviewComment.scrollEnabled = false;
            bigScrollview.scrollEnabled = true;
            tableView_isAnimatingDown = true;
            bigScroll_isAnimatingTop = false;
        }
        else if (scrollOffset >= 100 && tableView_isPerformingDown && !bigScroll_isPerformingToTop) {
            tableView_isAnimatingDown = false;
        }
        
        lastContentOffset_tableView = scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == bigScrollview) {
        NSLog(@"Will begin dragging");
        
    }
}
//hiepph - end
//-- set data
-(void) setDataWhenViewDidLoad
{
    //[self customWebView:self.tempWebView];
    [self.tempWebView setDelegate:self];
    
    //--set delegate from BaseVC
    [self setDelegateBaseController:self];
    
    //-- set name event
    lblCity.text = schedule.name;
    
    //-- download image cover
    NSString *urlStr = schedule.imageFilePath;
    
    //-- download image
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
        //
    }];
}



//*******************************************************************************//
#pragma mark - Set up UI

-(void) customNavigationBar
{
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
    
    //-- comment button
//    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
//    btnRight.frame= CGRectMake(15, 0, 30, 30);
//    [btnRight setImage:[UIImage imageNamed:@"icon_comments.png"] forState:UIControlStateNormal];
//    [btnRight addTarget:self action:@selector(clickcomment:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
//    self.navigationItem.rightBarButtonItem=barItemRight;
    
}


#pragma mark - Segment

-(void) setUpSegmentControl
{
    //-- Segmented control with scrolling
    segmentedDetailSchedule = [[HMSegmentedControlOriginal alloc] initWithSectionTitles:segmentArray];
    segmentedDetailSchedule.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 10);
    segmentedDetailSchedule.selectionStyle = HMSegmentedControlOriginalSelectionStyleTextWidthStripe;
    segmentedDetailSchedule.selectionIndicatorLocation = HMSegmentedControlOriginalSelectionIndicatorLocationDown;
    segmentedDetailSchedule.scrollEnabled = YES;
    segmentedDetailSchedule.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
//    [segmentedDetailSchedule setFrame:CGRectMake(0, 240, 320, 36)];
    [segmentedDetailSchedule setFrame:CGRectMake(0, 0, 320, 36)];
    [segmentedDetailSchedule addTarget:self action:@selector(segmentedControlChangeValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedDetailSchedule setTextColor:[UIColor grayColor]];
    segmentedDetailSchedule.backgroundColor = [UIColor clearColor];
    [segmentedDetailSchedule setSelectedTextColor:[UIColor darkGrayColor]];
    [segmentedDetailSchedule setSelectedSegmentIndex:_currentIndex];
    [segmentedDetailSchedule setSelectionIndicatorColor:[UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0]];
    segmentedDetailSchedule.font = [UIFont systemFontOfSize:15.0f weight:bold];
    
    segmentedDetailSchedule.selectionIndicatorHeight = 2;
    [viewSegment addSubview:segmentedDetailSchedule]; //hiepph
}


- (void)segmentedControlChangeValue:(HMSegmentedControlOriginal *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex != _currentIndex) {
        [self setCurrentIndex:segmentedControl.selectedSegmentIndex];
        _currentIndex = segmentedControl.selectedSegmentIndex;
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
    }
}


//-- create page scroll
-(void) createPageScrollSchedule
{
    _scrollContainer.contentSize = CGSizeMake(_scrollContainer.frame.size.width * segmentArray.count, _scrollContainer.frame.size.height);
    
//    _scrollContainer.contentSize = CGSizeMake(_scrollContainer.frame.size.width * segmentArray.count, self.view.frame.size.height); //hiepph
    _scrollContainer.showsHorizontalScrollIndicator = NO;
    _scrollContainer.showsVerticalScrollIndicator = NO;
    _scrollContainer.alwaysBounceVertical = NO;
    _scrollContainer.pagingEnabled = YES;
    _scrollContainer.scrollsToTop = NO;
    
    //-- Set up the array to hold the views for each page
    _pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < segmentArray.count; ++i) {
        
        [self.pageViews addObject:[NSNull null]];
    }
    
    //-- Set the scroll view's content size, autoscroll to the stating tableview,
    //-- and setup the other display elements.
    [self setScrollViewContentSize];
    [self setCurrentIndex:0];
    [self scrollToIndex:0];
}


- (void)setScrollViewContentSize
{
    NSInteger pageCount = segmentArray.count;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    //commented these 2 lines by hiepph
//    CGSize size = CGSizeMake(_scrollContainer.frame.size.width * pageCount,
//                             _scrollContainer.frame.size.height / 1);   // Cut in half to prevent horizontal scrolling.
//    [_scrollContainer setContentSize:size];
}


- (void)setCurrentIndex:(NSInteger)newIndex
{
    _currentIndex = newIndex;
    
    //-- change segmanet
    [segmentedDetailSchedule setSelectedSegmentIndex:_currentIndex];
    
    
    //-- load data
    if (_currentIndex == 0) {
        
        isInfo = YES;
        isComment = NO;
        
        viewInfo.alpha = 1;
        viewComment.alpha = 0;
        
        [_listData removeAllObjects];
        [self.tableviewDetail reloadData];
        
        [_arrCommentData removeAllObjects];
        [self.tableviewComment reloadData];
        
        [self fetchingData];
        
    }else{
        
        isInfo = NO;
        isComment = YES;
        
        viewInfo.alpha = 0;
        viewComment.alpha = 1;
        
        [_listData removeAllObjects];
        [self.tableviewDetail reloadData];
        
        [_arrCommentData removeAllObjects];
        [self.tableviewComment reloadData];
        
        [self fetchingDataComment];
    }
}


-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = _scrollContainer.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [_scrollContainer scrollRectToVisible:frame animated:NO];
}



#pragma mark - Call API get data

- (void)fetchingDataComment
{
    [CommentsNewsViewController addDelegateComment:self];
    
    [_indicatorComment startAnimating];
    
    [self callApiGetDataComment:SINGER_ID contentId:schedule.nodeId contentTypeId:TYPE_ID_EVENT commentId:@"0" getCommentOfComment:@"0"];
}


//-- pass data comments Delegate
- (void)passCommentsDelegate:(NSMutableArray*) listDataComments
{
    NSLog(@"%s", __func__);
    _arrCommentData = listDataComments;
    
    //-- reload tableview
    [_tableviewComment reloadData];
    
    [_tableviewComment scrollsToTop];
    
    //-- auto scroll
    if (_isAutoScroll && ([_arrCommentData count] > 3)){
        [_tableviewComment beginUpdates];
        
        [_tableviewComment scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([_arrCommentData count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [_tableviewComment endUpdates];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
    label.text = @"Hiện chưa có bình luận nào. Bạn hãy là người đầu tiên bình luận cho lịch diễn này.";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 2000;
    
    if (_arrCommentData.count == 0) {
        for (UIView *viewC in self.tableviewComment.subviews) {
            
            if ([viewC isKindOfClass:[UILabel class]]) {
                [viewC removeFromSuperview];
            }
        }
    
        [self.tableviewComment addSubview:label];
    }
    else{
        for (UIView *viewC in self.tableviewComment.subviews) {
            
            if ([viewC isKindOfClass:[UILabel class]]) {
                [viewC removeFromSuperview];
            }
        }
    }
    
    [_indicatorComment stopAnimating];
}


//-- pass delegate from DetailsComment
- (void)subCommentSuccessDelegate
{
    // fill data into cell
    id index = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentScheduleIndex"];
    Comment *aComment = [self.arrCommentData objectAtIndex:[index integerValue]];
    NSNumber *childComment = [NSNumber numberWithInteger:[aComment.numberOfSubcommments integerValue] + 1];
    aComment.numberOfSubcommments = [childComment stringValue];
    
    [_tableviewComment reloadData];
}



//*******************************************************************************//
#pragma mark - Action

- (IBAction)back:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


-(IBAction)clickcomment:(id)sender
{
    _isLike = NO;
    _isComment = YES;
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        
        if (_isComment)
            [self showDialogComments:CGPointZero title:@"Bình luận"];
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}


//-- override
-(void) cancelComment
{
    [super cancelComment];
}


-(void) postComment
{
    NSString *content = [self getContentOfComment];
    if (!content || [content length]==0)
        return;
    
    [super postComment];
    
    Comment *commentForAComment = [Comment new];
    commentForAComment.commentId = @"0";
    commentForAComment.content = content;
    commentForAComment.timeStamp = [Utility idFromTimeStamp];
    commentForAComment.profileUser = [Profile sharedProfile];
    commentForAComment.profileUser.point = [Profile sharedProfile].point;
    commentForAComment.numberOfSubcommments = @"0";
    commentForAComment.arrSubComments = [[NSMutableArray alloc] init];
    
    [_arrCommentData addObject:commentForAComment];
    [_tableviewComment reloadData];
    
    //-- auto scroll
    if (_isAutoScroll && ([_arrCommentData count] > 3))
    {
        [_tableviewComment beginUpdates];
        
        [_tableviewComment scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([_arrCommentData count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [_tableviewComment endUpdates];
    }
    
    [self resizeContainSizeOfTableView];
    
    NSString *nodeId = schedule.nodeId;
    
    //-- call api
    [self callAPISyncData:kTypeComment
                     text:content
                contentId:nodeId
            contentTypeId:TYPE_ID_EVENT
                commentId:@"0"];
    
    [self.superComment.arrSubComments addObject:commentForAComment];
    
}


- (void)syncDataSuccessDelegate:(NSDictionary *)response
{
    Schedule *schel = (Schedule *)[dataSourceSchedule objectAtIndex:self.indexOfSchedule];
    
    if (_isComment == YES) {
        
        //-- set id for comment at local
        NSDictionary   *dictData          = [response objectForKey:@"data"];
        NSMutableArray *arrComment        = [dictData objectForKey:@"comment"];
        
        if ([arrComment count] > 0)
        {
            NSDictionary *dictComment         = [arrComment objectAtIndex:0];
            NSString     *commentId           = [dictComment objectForKey:@"comment_id"];
            Comment      *recentComment       = [_arrCommentData lastObject];
            if ([recentComment.commentId isEqualToString:@"0"])
                recentComment.commentId = commentId;
        }
        
        NSNumber *comment = [NSNumber numberWithInteger:[schel.snsTotalComment integerValue]+1];
        lblNumberComment.text = [NSString stringWithFormat:@"%ld comment", (long)[comment integerValue]];
        
        schel.snsTotalComment = [comment stringValue];
        
        _isComment = NO;
        
        //-- show view comment
        [self clickToBtnComment:nil];
        
    }else if (_isLike == YES) {
        
        if (btnLiked.currentImage == [UIImage imageNamed:@"icon_like_photo.png"]) //-- unlike then -1
        {
            schedule.isLiked = @"0";
            
            NSNumber *unlike = [NSNumber numberWithInteger:[schel.snsTotalLike integerValue]-1];
            if (unlike<0) {
                unlike = 0;
            }
            
            lblNumberLike.text = [NSString stringWithFormat:@"%d like", [unlike integerValue]];
            
            schel.snsTotalLike = [unlike stringValue];
        }
        else //-- like then +1
        {
            schel.isLiked = @"1";
            
            NSNumber *like = [NSNumber numberWithInteger:[schel.snsTotalLike integerValue]+1];
            lblNumberLike.text = [NSString stringWithFormat:@"%d like", [like integerValue]];
            
            schel.snsTotalLike = [like stringValue];
        }
    }
    
    //-- update Database
    [VMDataBase updateSchedule:schel];
}


- (IBAction)clickToBtnComment:(id)sender
{
    [self setCurrentIndex:1];
    
    [self scrollToIndex:1];
    
    //-- fetching data
    [self fetchingDataComment];
    
    [_tableviewComment reloadData];
}


- (IBAction)clickToBtnShare:(id)sender
{
    //-- share
    
    NSString *title = schedule.name;
    NSString *headline = [schedule.name stringByReplacingOccurrencesOfString:@" " withString:@" "];
    NSString *description = [NSString stringWithFormat:@"Tôi tìm thấy lịch diễn %@ trong ứng dụng %@ tại %@",headline, KEY_FB_SINGER_DISPLAY_NAME, URL_APP_STORE];
    
    [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:schedule.imageFilePath contentId:schedule.nodeId contentTypeId:TYPE_ID_EVENT];
}


- (IBAction)clickToBtnLike:(id)sender
{
    _isLike = YES;
    _isComment = NO;
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        if (btnLiked.currentImage == [UIImage imageNamed:@"icon_liked.png"]) //-- unlike then -1
        {
            [btnLiked setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
            
            [self callAPISyncData:kTypeUnLike text:nil contentId:schedule.nodeId contentTypeId:TYPE_ID_EVENT commentId:nil];
        }
        else //-- like then +1
        {
            [btnLiked setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
            
            [self callAPISyncData:kTypeLike text:nil contentId:schedule.nodeId contentTypeId:TYPE_ID_EVENT commentId:nil];
        }
        
    }else{
        
        //-- thong bao nang cap user
        [self showMessageUpdateLevelOfUser];
    }
}


//****************************************************************************//
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberRow = 0;
    
    if (isComment) {
        numberRow = [_arrCommentData count];
    }else{
        numberRow = [_listData count];
    }
    
    return numberRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isInfo) {
        CustomCellDetailSchedule *cell = [self.tableviewDetail dequeueReusableCellWithIdentifier:@"sbCustomCellDetailScheduleId" forIndexPath:indexPath];
        
        //-- set color background for cell
        if ((indexPath.row%2) == 0)
            cell.contentView.backgroundColor = COLOR_DETAIL_SCHEDULE_BOLD;
        else
            cell.contentView.backgroundColor = COLOR_DETAIL_SCHEDULE_REGULAR;
        
        //-- set selectionStyle
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [tableView setSeparatorColor:[UIColor clearColor]];
        [tableView setBackgroundColor:[UIColor clearColor]];
        
        VMContent *content = [_listData objectAtIndex:indexPath.row];
        
        [cell.wvSchel setDelegate:self];
        [cell.wvSchel setUserInteractionEnabled:YES];
        
        //-- set cell image icon
        cell.imgIcon.image = content.imageIcon;
        
        //-- set cell content
        if (content.type == VMContentTypeText || content.type == VMContentPhone)
        {
            cell.wvSchel.alpha = 0;
//            cell.txvCell.alpha = 1;
//            cell.txvCell.text = content.content;
//            cell.txvCell.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
//            
//            if ([content.content isEqualToString:@"Thông tin chi tiết:"]) {
//                cell.contentView.backgroundColor = COLOR_DETAIL_SCHEDULE_INFO;
//            }
//            
//            CGFloat heightCell = [Utility heightFromString:content.content maxWidth:275 font:[UIFont systemFontOfSize:13.0f]];
//            
//            if (heightCell > 24)
//                cell.txvCell.frame = CGRectMake(cell.txvCell.frame.origin.x, cell.txvCell.frame.origin.y, cell.txvCell.frame.size.width, heightCell + 30);
//            else
//                cell.txvCell.frame = CGRectMake(cell.txvCell.frame.origin.x, cell.txvCell.frame.origin.y, cell.txvCell.frame.size.width, cell.txvCell.frame.size.width);
        }
        else {
            cell.txvCell.alpha = 0;
            cell.wvSchel.alpha = 1;
            cell.contentView.backgroundColor = [UIColor clearColor];
            [cell.wvSchel setDelegate:self];
            [cell.wvSchel setTag:kWebCellTag];
            cell.wvSchel.scrollView.scrollEnabled = NO;
            
            if (content.doneResize){
                NSLog(@"webContent: %@", content.content);
                [cell.wvSchel loadHTMLString:content.content baseURL:nil];
            }
        }
        
        return cell;
        
    }else{
        CustomCellCommentSchedule *cell = [_tableviewComment dequeueReusableCellWithIdentifier:@"sbCustomCellCommentScheduleId" forIndexPath:indexPath];
        
        [tableView setSeparatorColor:[UIColor clearColor]];
        
        //-- custom avatar of user to circle
        cell.imgAvatar.layer.borderWidth = 1.0f;
        cell.imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.imgAvatar.layer.cornerRadius = 22;
        cell.imgAvatar.layer.masksToBounds = YES;
        
        // fill data into cell
        Comment *aComment = [_arrCommentData objectAtIndex:indexPath.row];
        
        if (!(_arrCommentData.count > 0)) {
            //-- Load the news
            CGRect frame = [_tableviewComment frame];
            frame.origin.x = 0.0f;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            //-- add lable no data
            [self addLableNoDataToTableView:_tableviewComment withIndex:indexPath.row withFrame:frame byTitle:TITLE_NoData_Default];
            
        }else{
            
            [self removeLableNoDataFromTableView:_tableviewComment withIndex:indexPath.row];
        }
        
        //dynamic content textview
//        CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:200 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT]];
        
//        if (heightOfText < 50)
//            heightOfText = 50;
//        else
//            heightOfText = heightOfText + 20;
//        
//        CGRect frame = cell.txtViewComment.frame;
//        frame.size.height = heightOfText;
//        cell.txtViewComment.frame= frame;
        
        cell.txtViewComment.text = aComment.content;
//        [Utility setHTMLContent:[Utility convertTextInit:aComment.content] forTextView:cell.txtViewComment];
        cell.txtViewComment.scrollEnabled = NO;
        cell.txtViewComment.userInteractionEnabled = NO;
        cell.txtViewComment.editable = NO;
        cell.txtViewComment.textColor = [UIColor blackColor];
        
        cell.lblTotalChildComment.text = aComment.numberOfSubcommments;
        cell.lblNickName.text = aComment.profileUser.fullName;
        [cell.lblNickName sizeToFit];
        
        cell.lblDateTime.text = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[aComment.timeStamp integerValue]]];
        [cell.lblDateTime sizeToFit];
        cell.lblPointOfUser.text = aComment.profileUser.point;
        [cell.imgAvatar setImageWithURL:[NSURL URLWithString:aComment.profileUser.userImage] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"] completed:nil];
        
        CGRect fr;
        fr = cell.lblDateTime.frame;
        fr.origin.x = cell.lblNickName.frame.origin.x + cell.lblNickName.frame.size.width + 5;
        cell.lblDateTime.frame = fr;
        
        return cell;
    }
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger heightRow = 0;
    
    if (isComment) {
        Comment *aComment = [_arrCommentData objectAtIndex:indexPath.row];
        //dynamic content textview
        CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:200 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT]];

        if (heightOfText < 60)
//            heightRow = 90; hiepph
            heightRow = 65;
        else
            heightRow = heightOfText + 30;
        
    }else{
        VMContent *content = [_listData objectAtIndex:indexPath.row];
        
        if (content.type == VMContentTypeHTML) {
            heightRow = content.height;
        }else{
            heightRow = [Utility heightFromString:content.content maxWidth:275 font:[UIFont systemFontOfSize:12.0f]];
            if (heightRow < 24)
                heightRow = 30;
            else
                heightRow = heightRow + 15;
        }
    }
    
    return heightRow;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isInfo == YES)
    {
        VMContent *content = [_listData objectAtIndex:indexPath.row];
        
        NSString *tempnamePhone = [schedule.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        BOOL thereArePhone = [tempnamePhone isEqualToString:@""];
        if(!thereArePhone) {
            
            if (content.type == VMContentPhone) {
                
                AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                [dataCenter setSchedulePhone:schedule.phone];
                
                NSString *mess = [NSString stringWithFormat:@"Bạn có muốn thực hiện cuộc gọi tới số \"%@\" không?",schedule.phone];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kTitleMessageApp message:mess delegate:self cancelButtonTitle:@"Huỷ bỏ" otherButtonTitles:@"Có", nil];
                
                alertView.tag = 999;
                [alertView show];
            }
        }
        
        isInfo = NO;
    }
    
    if (isComment == YES)
    {
        Comment *comment = [_arrCommentData objectAtIndex:indexPath.row];
        
        AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        DetailCommentsViewController *detailCommnetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailCommentsViewControllerId"];
        [dataCenter setIsSchedule:YES];
        detailCommnetVC.superComment = comment;
        detailCommnetVC.nodeId = schedule.nodeId;
        detailCommnetVC.delegateDetailComment = self;
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"currentScheduleIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
            [self.navigationController pushViewController:detailCommnetVC animated:YES];
        else
            [self.navigationController pushViewController:detailCommnetVC animated:NO];
    }
    
}



#pragma mark - Resize table content

-(void) resizeContainSizeOfTableView
{
    CGFloat heightOfTable = 0;
    
    for (NSInteger i = 0; i < [_arrCommentData count]; i++)
    {
        Comment *aComment = [_arrCommentData objectAtIndex:i];
        // set height for table
        
        CGFloat heightForRow = 0;
        CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:200 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT]];
        heightForRow = heightOfText + 40;
        
        if (heightForRow <91)
            heightForRow = 91;
        
        heightOfTable += heightForRow;
    }
    _tableviewComment.contentSize = CGSizeMake(_tableviewComment.frame.size.width, heightOfTable);
}


#pragma mark - UIWebViewDelegate

-(void)customWebView:(UIWebView*)aWebView
{
    aWebView.scrollView.scrollEnabled = YES;
    //-- remove background of webView and disable scroll view of webview
    [aWebView setOpaque:NO];
    [aWebView setBackgroundColor:[UIColor clearColor]];
    for (UIView* subView in [aWebView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            //-- disable scroll view of webview
            // ((UIScrollView *)(subView)).scrollEnabled = NO;
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                    [shadowView setHidden:YES];
            }
        }
    }
    //-- set attribute for webview
    aWebView.delegate=self;
    aWebView.scalesPageToFit = NO;
    aWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.tag != kWebCellTag)
    {
        NSString *newHeightString = [webView stringByEvaluatingJavaScriptFromString:@"document.height"];
        NSInteger idx = webView.tag;
        //NSLog(@"%s:[%d] %@",__FUNCTION__,webView.tag,newHeightString);
        
        if ([newHeightString length]) {
            //-- ctx
            VMContent *content = [_listData objectAtIndex:idx];
            content.height = [newHeightString floatValue];
            
            //-- if you done a ctx, send a signal to next ctx
            [_condition lock];
            [_queueH removeObject:content];
            [content setDoneResize:YES];
            [_condition signal];
            [_condition unlock];
        }
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //-- neu la webivew trong cell thi lam
    if (webView.tag == kWebCellTag) {
        
        //-- neu la dang lick to link
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            
            NSString *urlString = request.URL.absoluteString;
            
            OpenLinkViewController * opVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbOpenLinkViewControllerId"];
            opVC.urlString = urlString;
            
            if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
                [self.navigationController pushViewController:opVC animated:YES];
            else
                [self.navigationController pushViewController:opVC animated:NO];
            
            return NO;
        }
        
        //-- ret YES ==> open webbr
        return YES;
    }
    
    //-- return YES to next processing
    return YES;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //
}


#pragma  mark - base view controller delegate
- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
//    _isProcessLikeAPI = false;
}

- (void)baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    [AppDelegate addLocalLogWithString:@"LG200" info:[Profile debugDescription]];

    if (_isComment)
        [self showDialogComments:CGPointZero title:@"Bình luận"];
    else if (_isLike)        
        [self clickToBtnLike:btnLiked];
}



@end
