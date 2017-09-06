//
//  VideoDetailViewController.m
//  NooPhuocThinh
//
//  Created by longnh on 1/4/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "ModelDownload.h"

@interface VideoDetailViewController ()

@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

@end

@implementation VideoDetailViewController

@synthesize videoAllModelInfo,videoForAllInfo,videoForCategoryInfo,contentVideoTypeId;
@synthesize videoContainerView,thumbnailImageView;
@synthesize autoFullName;
@synthesize txtDescription;
@synthesize tableviewComments,scrollContent;
@synthesize timerPlayVideo;
@synthesize videoDownloadsInProgress;
@synthesize viewToolBar;
@synthesize videoPlayerViewController;
@synthesize isExistingVideoLocal;

int countVideo = 0;


//*************************************************************************//
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
    
    //-- Pause Music
    if ([[AudioPlayer sharedAudioPlayerMusic] isPlayingSong])
        [[AudioPlayer sharedAudioPlayerMusic] pauseSong];
    
    self.videoDownloadsInProgress = [NSMutableDictionary dictionary];
    
    //-- setup view
    [self setViewVideoWhenViewDidLoad];
    
    //-- load data
    [self setDataVideoWhenViewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSArray *allDownloads = [self.videoDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [timerPlayVideo invalidate];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Video Detail Screen";
    
    //-- Pause Music
    if ([[AudioPlayer sharedAudioPlayerMusic] isPlayingSong])
        [[AudioPlayer sharedAudioPlayerMusic] pauseSong];
    
    [timerPlayVideo invalidate];
    
    //-- remove slidebar
    [self removeSlideBarBaseViewController];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentVideoIndex"];
    
    //-- show navigationbar
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
}

//-- set View
-(void) setViewVideoWhenViewDidLoad
{
    //-- set bool
    _isAutoScroll = YES;
    
    //-- custom navigation bar
    [self customNavigationBar];
    
    NSString *isLike;
    
    if (contentVideoTypeId == ContentTypeIDAllVideo) {
        
        isLike = videoAllModelInfo.isLiked;
        
    }else if (contentVideoTypeId == ContentTypeIDVideo)
    {
        isLike = videoForAllInfo.isLiked;
    }else
    {
        isLike = videoForCategoryInfo.isLiked;
    }
    
    //-- set status like button
    if ([isLike isEqualToString:@"0"])
        [btnLike setImage:[UIImage imageNamed:@"btn_like_news.png"] forState:UIControlStateNormal];
    else
        [btnLike setImage:[UIImage imageNamed:@"btn_liked_news.png"] forState:UIControlStateNormal];
}


- (void)autoScrollText:(NSString*)text
{
    self.autoFullName.text = text;
    [self.autoFullName setFont:[UIFont systemFontOfSize:18]];
    self.autoFullName.textColor = [UIColor whiteColor];
    self.autoFullName.labelSpacing = 200; // distance between start and end labels
    self.autoFullName.pauseInterval = 0.3; // seconds of pause before scrolling starts again
    self.autoFullName.scrollSpeed = 30; // pixels per second
    self.autoFullName.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    self.autoFullName.fadeLength = 12.f;
    self.autoFullName.shadowOffset = CGSizeMake(-1, -1);
    self.autoFullName.scrollDirection = CBAutoScrollDirectionLeft;
}


//-- add barButton
-(void) customNavigationBar
{
    //-- back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(clickback:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- comment button
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame= CGRectMake(15, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(createComment:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barItemRight;
}

//-- check video path
-(void) checkVideoExistLocal {
    
    NSString *categoryIdStr = [NSString stringWithFormat:@"%d",contentVideoTypeId];
    NSString *nodeIdStr = @"";
    if (contentVideoTypeId == ContentTypeIDAllVideo)
        nodeIdStr = videoAllModelInfo.node_id;
    else if (contentVideoTypeId == ContentTypeIDVideo)
        nodeIdStr = videoForAllInfo.nodeId;
    else
        nodeIdStr = videoForCategoryInfo.nodeID;
    
    //-- check downloader video
    NSString *filePath = [Utility getVideoFilePathWithCategoryId:categoryIdStr withNodeId:nodeIdStr];
    BOOL isShowDownLoad = [Utility checkingAFileExistsWithPath:filePath];
    if (isShowDownLoad == YES) {
        
        isExistingVideoLocal = YES;
        btnDownloadVideo.enabled = NO;
        
    }else {
        
        isExistingVideoLocal = NO;
        btnDownloadVideo.enabled = YES;
    }
}

//-- get Data
-(void) setDataVideoWhenViewDidLoad
{
    //-- set delegate from BaseVC
    [self setDelegateBaseController:self];
    
    [timerPlayVideo invalidate];
    
    NSString *videoIdentifierStr = @"";
    NSString *videoTitleStr = @"";
    NSString *urlThumbnailImagePath = @"";
    NSString *descriptionStr = @"";
    
    //-- check video local
    [self checkVideoExistLocal];
    
    
    NSUserDefaults *defaultVideoPath = [NSUserDefaults standardUserDefaults];
    
    if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
    {
        if (contentVideoTypeId == ContentTypeIDAllVideo) {
            
            //-- call api data view
            [self apiDataView:videoAllModelInfo.node_id contentTypeId:TYPE_ID_VIDEO];
            
            descriptionStr = videoAllModelInfo.body;
            videoTitleStr = videoAllModelInfo.name;
            videoIdentifierStr = [Utility getVideoIdentifierFromYoutube_url:videoAllModelInfo.youtube_url];
            lblNumberLike.text = videoAllModelInfo.snsTotalLike;
            lblNumberPlay.text = videoAllModelInfo.snsTotalView;
            lblNumberComment.text = videoAllModelInfo.snsTotalComment;
            
            if ([videoAllModelInfo.thumbnail_image_file_path length] > 2) {
                
                urlThumbnailImagePath = videoAllModelInfo.thumbnail_image_file_path;
            }else {
                urlThumbnailImagePath = [Utility getImageNameFromYoutube_url:videoAllModelInfo.youtube_url];
            }
            
            if ([videoAllModelInfo.isLiked isEqualToString:@"1"])
                [btnLike setImage:[UIImage imageNamed:@"btn_liked_news.png"] forState:UIControlStateNormal];
            else
                [btnLike setImage:[UIImage imageNamed:@"btn_like_news.png"] forState:UIControlStateNormal];
            
            [defaultVideoPath setValue:videoAllModelInfo.video_file_path forKey:@"VideoPathDefault"];
            
        }else {
            
            //-- call api data view
            [self apiDataView:videoForAllInfo.nodeId contentTypeId:TYPE_ID_VIDEO];
            
            descriptionStr = videoForAllInfo.content;
            videoTitleStr = videoForAllInfo.name;
            videoIdentifierStr = [Utility getVideoIdentifierFromYoutube_url:videoForAllInfo.youtubeUrl];
            lblNumberLike.text = videoForAllInfo.snsTotalLike;
            lblNumberPlay.text = videoForAllInfo.snsTotalView;
            lblNumberComment.text = videoForAllInfo.snsTotalComment;
            
            if ([videoForAllInfo.thumbImagePath length] > 2) {
                
                urlThumbnailImagePath = videoForAllInfo.thumbImagePath;
            }else {
                urlThumbnailImagePath = [Utility getImageNameFromYoutube_url:videoForAllInfo.youtubeUrl];
            }
            
            if ([videoForAllInfo.isLiked isEqualToString:@"1"])
                [btnLike setImage:[UIImage imageNamed:@"btn_liked_news.png"] forState:UIControlStateNormal];
            else
                [btnLike setImage:[UIImage imageNamed:@"btn_like_news.png"] forState:UIControlStateNormal];
            
            [defaultVideoPath setValue:videoForAllInfo.musicPath forKey:@"VideoPathDefault"];
        }
        
    }else {
        
        //-- call api data view
        [self apiDataView:videoForCategoryInfo.nodeID contentTypeId:TYPE_ID_VIDEO];
        
        descriptionStr = videoForCategoryInfo.body;
        videoTitleStr = videoForCategoryInfo.title;
        videoIdentifierStr = [Utility getVideoIdentifierFromYoutube_url:videoForCategoryInfo.youtubeUrl];
        lblNumberLike.text = videoForCategoryInfo.snsTotalLike;
        lblNumberPlay.text = videoForCategoryInfo.snsTotalView;
        lblNumberComment.text = videoForCategoryInfo.snsTotalComment;
        
        if ([videoForCategoryInfo.thumbnailImagePath length] > 2) {
            
            urlThumbnailImagePath = videoForCategoryInfo.thumbnailImagePath;
        }else {
            urlThumbnailImagePath = [Utility getImageNameFromYoutube_url:videoForCategoryInfo.youtubeUrl];
        }
        
        if ([videoForCategoryInfo.isLiked isEqualToString:@"1"])
            [btnLike setImage:[UIImage imageNamed:@"btn_liked_news.png"] forState:UIControlStateNormal];
        else
            [btnLike setImage:[UIImage imageNamed:@"btn_like_news.png"] forState:UIControlStateNormal];
        
        [defaultVideoPath setValue:videoForCategoryInfo.videoFilePath forKey:@"VideoPathDefault"];
    }
    
    [defaultVideoPath synchronize];
    
    //-- set title
    //self.title = videoTitleStr;
    [self autoScrollText:videoTitleStr];
    //titleLabel.text = videoTitleStr;
    
    //-- set Description
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        if ([descriptionStr length] == 0)
            descriptionStr = @"Không có mô tả.";
        
        NSString *stringFormat = [NSString stringWithFormat:@"<div style=\"color: #fff; text-align: center; font-size: 14px; \">%@ </div>",descriptionStr];
        NSAttributedString *aStr = [[NSAttributedString alloc] initWithData:[stringFormat dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                              NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                         documentAttributes:nil error:nil];
        
        txtDescription.attributedText = aStr;
    }else{
        
        if ([descriptionStr length] == 0)
            descriptionStr = @"Không có mô tả.";
        
        [txtDescription setValue:descriptionStr forKey:@"contentToHTMLString"];
    }
    
    //-- image holder
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlThumbnailImagePath] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if(image !=nil)
             thumbnailImageView.image = image;
         else
             thumbnailImageView.image = [UIImage imageNamed:@"VideoDefault.png"];
         
     }];
    
    //-- add segment
    [self setUpAddSegmentControl];
    
    //-- fetching data comment
    [self fetchingListComment];
    
    //-- play video
    [self playVideoLinkYoutubeByVideoIdentifier:videoIdentifierStr];
    
}

-(void) playVideoLinkYoutubeByVideoIdentifier:(NSString *) videoIdentifier
{
    NSUserDefaults *defaultVideo = [NSUserDefaults standardUserDefaults];
    [defaultVideo setBool:YES forKey:@"isPlayVideoDefault"];
    [defaultVideo synchronize];
    
    self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoIdentifier];
    
    //-- get categoryId and nodeID
    self.videoPlayerViewController.videoCategoryId = [NSString stringWithFormat:@"%d",contentVideoTypeId];
    
    if (contentVideoTypeId == ContentTypeIDAllVideo)
        self.videoPlayerViewController.videoNodeId = videoAllModelInfo.node_id;
    else if (contentVideoTypeId == ContentTypeIDVideo)
        self.videoPlayerViewController.videoNodeId = videoForAllInfo.nodeId;
    else
        self.videoPlayerViewController.videoNodeId = videoForCategoryInfo.nodeID;
    
	
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveMetadata:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveMetadataNotification object:self.videoPlayerViewController];
    
	[defaultCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayerViewController.moviePlayer];
    
    [defaultCenter addObserver:self selector:@selector(nowPlayingMovieDidChange:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:self.videoPlayerViewController.moviePlayer];
    
    [defaultCenter addObserver:self selector:@selector(willEnterFullScreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:self.videoPlayerViewController.moviePlayer];
    [defaultCenter addObserver:self selector:@selector(willExitFullScreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.videoPlayerViewController.moviePlayer];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    [self.videoPlayerViewController presentInView:self.videoContainerView];
	[self.videoPlayerViewController.moviePlayer play];
}


//****************************************************************************//
#pragma mark -- Segment

-(void) setUpAddSegmentControl
{
    currentIndexSegment = 0;
    
    //-- Segmented control with scrolling
    segmentedControlComment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Mô Tả",@"Bình luận"]];
    segmentedControlComment.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 10);
    segmentedControlComment.segmentWidthMaxValue = 140;
    segmentedControlComment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControlComment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControlComment.scrollEnabled = YES;
    segmentedControlComment.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControlComment setFrame:CGRectMake(0, 0, 320, 40)];
    [segmentedControlComment addTarget:self action:@selector(segmentedControlChangedAlbumValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControlComment setTextColor:[UIColor grayColor]];
    segmentedControlComment.backgroundColor = COLOR_BG_MENU;
    [segmentedControlComment setSelectedTextColor:[UIColor whiteColor]];
    [segmentedControlComment setSelectedSegmentIndex:currentIndexSegment];
    segmentedControlComment.font = [UIFont systemFontOfSize:16.0f];
    
    [self.viewSegment addSubview:segmentedControlComment];
    
    //-- Set the scroll view's content size, autoscroll to the stating elements.
    [self setScrollViewContentSize];
    [self scrollToIndex:currentIndexSegment];
}

- (void)segmentedControlChangedAlbumValue:(HMSegmentedControl *)segmentedControl {
    
    if (segmentedControl.selectedSegmentIndex != currentIndexSegment) {
        
        currentIndexSegment = segmentedControl.selectedSegmentIndex;
        
        [self scrollToIndex:segmentedControl.selectedSegmentIndex];
    }
}


-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = self.scrollContent.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    
    [self.scrollContent scrollRectToVisible:frame animated:NO];
}

- (void)setScrollViewContentSize
{
    CGSize size = CGSizeMake(self.scrollContent.frame.size.width * 2,
                             self.scrollContent.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [self.scrollContent setContentSize:size];
}


//****************************************************************************//
#pragma mark  UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollContent) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = floor(fractionalPage);
        if (page != currentIndexSegment) {
            
            currentIndexSegment = page;
            
            //-- change segmanet
            [segmentedControlComment setSelectedSegmentIndex:page];
        }
    }
}


//-- add tableview comment
-(void) addBaseTableViewCommentsToTabComments
{    
    tableviewComments = [[BaseCommentsTableViewController alloc] init];
    tableviewComments.delegateComments = self;
    tableviewComments.view.backgroundColor = [UIColor clearColor];
    tableviewComments.tableView.separatorColor = [UIColor clearColor];
    
    CGRect frameTable = [self.scrollContent frame];
    frameTable.origin.x = 320;
    frameTable.origin.y = 0;
    if (isIphone5)
        frameTable.size.height = 255;
    else
        frameTable.size.height = 167;
    
    [tableviewComments.view setFrame:frameTable];
    
    //-- pass list data
    tableviewComments.listDataComments = comments;
    
    [self.scrollContent addSubview:tableviewComments.view];
}

//-- pass delegate
-(void) goToCommentsScreenViewControllerWithListData:(NSMutableArray *)listDataComments withIndexRow:(int)indexRow
{
    Comment *comment = [listDataComments objectAtIndex:indexRow];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *nodeId;
    
    if (contentVideoTypeId == ContentTypeIDAllVideo) {
        
        nodeId = videoAllModelInfo.node_id;
        
    }else if (contentVideoTypeId == ContentTypeIDVideo)
    {
        nodeId = videoForAllInfo.nodeId;
    }else
    {
        nodeId = videoForCategoryInfo.nodeID;
    }
    
    [timerPlayVideo invalidate];
    [self.videoPlayerViewController.moviePlayer pause];
    
    DetailCommentsViewController *detailCommnetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailCommentsViewControllerId"];
    [dataCenter setIsVideo:YES];
    detailCommnetVC.superComment = comment;
    detailCommnetVC.nodeId = nodeId;
    detailCommnetVC.delegateDetailComment = self;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",indexRow] forKey:@"currentVideoIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:detailCommnetVC animated:YES];
    else
        [self.navigationController pushViewController:detailCommnetVC animated:NO];
}


-(void) goToProfileScreenViewControllerByComment:(Comment *) aComment {
    
    ProfileViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idProfileViewControllerSb"];
    NSString *userId = aComment.profileUser.userId;
    NSString *myUserId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:MY_ACCOUNT_ID]];
    
    if ([userId isEqualToString:myUserId])
        pVC.profileType = ProfileTypeMyAccount;
    else
        pVC.profileType = ProfileTypeGuess;
    
    pVC.userId = userId;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:pVC animated:YES];
    else
        [self.navigationController pushViewController:pVC animated:NO];
}


//***********************************************************************//
#pragma mark - ACTION

- (void)clickback:(id)sender
{
    [timerPlayVideo invalidate];
    [self.videoPlayerViewController.moviePlayer stop];
    self.videoPlayerViewController = nil;
    
    NSUserDefaults *defaultVideo = [NSUserDefaults standardUserDefaults];
    [defaultVideo setBool:NO forKey:@"isPlayVideoDefault"];
    [defaultVideo synchronize];
    
    //-- add slidebar again
    [self addSlideBarBaseViewController];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}

- (void)createComment:(id)sender
{
    _isLike = NO;
    _isCreateComment = YES;
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        //-- create comments
        if (_isCreateComment)
            [self showDialogComments:CGPointZero title:@"Bình luận"];
    }else{
        
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
    if (!content || [content length] == 0)
        return;
    
    [super postComment];
    
    Comment *commentForAComment = [Comment new];
    commentForAComment.commentId = @"0";
    commentForAComment.content = content;
    commentForAComment.timeStamp = [Utility idFromTimeStamp];
    commentForAComment.profileUser = [Profile sharedProfile];
    commentForAComment.profileUser.point = [Profile sharedProfile].point;
    commentForAComment.numberOfSubcommments = @"0";
    commentForAComment.arrSubComments = [NSMutableArray new];
    
    [comments addObject:commentForAComment];
    
    [tableviewComments.tableView reloadData];
    
    //-- scroll view
    [tableviewComments.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tableviewComments.listDataComments count] - 2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //-- remove lable No data
    if (tableviewComments.listDataComments.count > 0) {
        for (UIView *viewC in tableviewComments.view.subviews) {
            
            if ([viewC isKindOfClass:[UILabel class]]) {
                [viewC removeFromSuperview];
            }
        }
    }
    
    //-- call API
    if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
    {
        if (contentVideoTypeId == ContentTypeIDAllVideo) {
            
            [self callAPISyncData:kTypeComment text:content contentId:videoAllModelInfo.node_id contentTypeId:TYPE_ID_VIDEO commentId:@"0"];
            
        }else {
            
            [self callAPISyncData:kTypeComment text:content contentId:videoForAllInfo.nodeId contentTypeId:TYPE_ID_VIDEO commentId:@"0"];
        }
    }
    else
    {
        [self callAPISyncData:kTypeComment text:content contentId:videoForCategoryInfo.nodeID contentTypeId:TYPE_ID_VIDEO commentId:@"0"];
    }
    
    [self.superComment.arrSubComments addObject:commentForAComment];
    
}

//-- id comment or like successfully

- (void)syncDataSuccessDelegate:(NSDictionary *)response
{
    //-- set id for comment at local
    NSDictionary   *dictData          = [response objectForKey:@"data"];
    NSMutableArray *arrComment        = [dictData objectForKey:@"comment"];
    NSMutableArray *arrShare        = [dictData objectForKey:@"share"];
    
    if (_isCreateComment == YES) {
        
        if ([arrComment count] > 0)
        {
            NSDictionary *dictComment         = [arrComment objectAtIndex:0];
            NSString     *commentId           = [dictComment objectForKey:@"comment_id"];
            Comment      *recentComment       = [comments lastObject];
            if ([recentComment.commentId isEqualToString:@"0"])
                recentComment.commentId = commentId;
        }

        if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
        {
            if (contentVideoTypeId == ContentTypeIDAllVideo) {
                
                NSNumber *comment = [NSNumber numberWithInteger:[videoAllModelInfo.snsTotalComment integerValue]+1];
                videoAllModelInfo.snsTotalComment = [comment stringValue];
                
                [VMDataBase updateVideosOfTBVideoAll:videoAllModelInfo];
                
                lblNumberComment.text = [NSString stringWithFormat:@"%d", [comment integerValue]];
                
            }else {
                
                NSNumber *comment = [NSNumber numberWithInteger:[videoForAllInfo.snsTotalComment integerValue]+1];
                videoForAllInfo.snsTotalComment = [comment stringValue];
                
                [VMDataBase updateVideosOffiCial:videoForAllInfo];
                
                lblNumberComment.text = [NSString stringWithFormat:@"%d", [comment integerValue]];
            }
        }
        else
        {
            NSNumber *comment = [NSNumber numberWithInteger:[videoForCategoryInfo.snsTotalComment integerValue]+1];
            videoForCategoryInfo.snsTotalComment = [comment stringValue];
            
            [VMDataBase updateVideosUnOffiCial:videoForCategoryInfo];
            lblNumberComment.text = [NSString stringWithFormat:@"%d", [comment integerValue]];
        }
        
       //-- [self fetchingListComment]; ko can load lai
        
        _isCreateComment = NO;
        
        //-- show view comment
        [self clickToBtnShowComment:nil];
    }
    else if (_isLike == YES) {
        
        if (btnLike.currentImage == [UIImage imageNamed:@"btn_like_news.png"]) //-- unlike then -1
        {
            if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
            {
                if (contentVideoTypeId == ContentTypeIDAllVideo) {
                    videoAllModelInfo.isLiked = @"0";
                    
                    NSNumber *unlike = [NSNumber numberWithInteger:[videoAllModelInfo.snsTotalLike integerValue]-1];
                    if (unlike<0) {
                        unlike = 0;
                    }
                    
                    lblNumberLike.text = [NSString stringWithFormat:@"%d", [unlike integerValue]];
                    
                    videoAllModelInfo.snsTotalLike = [unlike stringValue];
                    
                    [VMDataBase updateVideosOfTBVideoAll:videoAllModelInfo];
                    
                }else {
                    videoForAllInfo.isLiked = @"0";
                    
                    NSNumber *unlike = [NSNumber numberWithInteger:[videoForAllInfo.snsTotalLike integerValue]-1];
                    if (unlike<0) {
                        unlike = 0;
                    }
                    
                    lblNumberLike.text = [NSString stringWithFormat:@"%d", [unlike integerValue]];
                    
                    videoForAllInfo.snsTotalLike = [unlike stringValue];
                    
                    [VMDataBase updateVideosOffiCial:videoForAllInfo];
                }
            }
            else
            {
                videoForCategoryInfo.isLiked = @"0";
                
                NSNumber *unlike = [NSNumber numberWithInteger:[videoForCategoryInfo.snsTotalLike integerValue]-1];
                if (unlike<0) {
                    unlike = 0;
                }
                
                lblNumberLike.text = [NSString stringWithFormat:@"%d", [unlike integerValue]];
                
                videoForCategoryInfo.snsTotalLike = [unlike stringValue];
                
                [VMDataBase updateVideosUnOffiCial:videoForCategoryInfo];
            }
        }
        else //-- like then +1
        {
            if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
            {
                if (contentVideoTypeId == ContentTypeIDAllVideo) {
                    
                    videoAllModelInfo.isLiked = @"1";
                    
                    NSNumber *like = [NSNumber numberWithInteger:[videoAllModelInfo.snsTotalLike integerValue]+1];
                    lblNumberLike.text = [NSString stringWithFormat:@"%d", [like integerValue]];
                    
                    videoAllModelInfo.snsTotalLike = [like stringValue];
                    
                    [VMDataBase updateVideosOfTBVideoAll:videoAllModelInfo];
                    
                }else {
                    
                    videoForAllInfo.isLiked = @"1";
                    
                    NSNumber *like = [NSNumber numberWithInteger:[videoForAllInfo.snsTotalLike integerValue]+1];
                    lblNumberLike.text = [NSString stringWithFormat:@"%d", [like integerValue]];
                    
                    videoForAllInfo.snsTotalLike = [like stringValue];
                    
                    [VMDataBase updateVideosOffiCial:videoForAllInfo];
                }
            }
            else
            {
                videoForCategoryInfo.isLiked = @"1";
                
                NSNumber *like = [NSNumber numberWithInteger:[videoForCategoryInfo.snsTotalLike integerValue]+1];
                lblNumberLike.text = [NSString stringWithFormat:@"%d", [like integerValue]];
                
                videoForCategoryInfo.snsTotalLike = [like stringValue];
                
                [VMDataBase updateVideosUnOffiCial:videoForCategoryInfo];
            }
        }
    }
    
    if (arrShare.count > 0) {
        
        if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
        {
            if (contentVideoTypeId == ContentTypeIDAllVideo) {
                
                NSNumber *totalShare = [NSNumber numberWithInteger:[videoAllModelInfo.snsTotalShare integerValue]+1];
                videoAllModelInfo.snsTotalShare = [totalShare stringValue];
                
                [VMDataBase updateVideosOfTBVideoAll:videoAllModelInfo];
                
            }else {
                
                NSNumber *totalShare = [NSNumber numberWithInteger:[videoForAllInfo.snsTotalShare integerValue]+1];
                videoForAllInfo.snsTotalShare = [totalShare stringValue];
                
                [VMDataBase updateVideosOffiCial:videoForAllInfo];
            }
        }
        else
        {
            NSNumber *totalShare = [NSNumber numberWithInteger:[videoForCategoryInfo.snsTotalShare integerValue]+1];
            videoForCategoryInfo.snsTotalShare = [totalShare stringValue];
            
            [VMDataBase updateVideosUnOffiCial:videoForCategoryInfo];
        }
    }
}

//-- show comments
-(IBAction)clickToBtnShowComment:(id)sender {
    
    //-- change segmanet
    [segmentedControlComment setSelectedSegmentIndex:1];
    [self scrollToIndex:1];
}

- (IBAction)clickToBtnLike:(id)sender
{
    _isLike = YES;
    _isCreateComment = NO;
    
    NSString *nodeId;
    
    if (contentVideoTypeId == ContentTypeIDAllVideo) {
        
        nodeId = videoAllModelInfo.node_id;
        
    }else if (contentVideoTypeId == ContentTypeIDVideo)
    {
        nodeId = videoForAllInfo.nodeId;
    }else
    {
        nodeId = videoForCategoryInfo.nodeID;
    }
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        
        if (btnLike.currentImage == [UIImage imageNamed:@"btn_liked_news.png"]) //-- unlike then -1
        {
            [btnLike setImage:[UIImage imageNamed:@"btn_like_news.png"] forState:UIControlStateNormal];
            
            if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
            {
                if (contentVideoTypeId == ContentTypeIDAllVideo) {
                    
                    [self callAPISyncData:kTypeUnLike text:nil contentId:videoAllModelInfo.node_id contentTypeId:TYPE_ID_VIDEO commentId:nil];
                    
                }else {
                    
                    [self callAPISyncData:kTypeUnLike text:nil contentId:videoForAllInfo.nodeId contentTypeId:TYPE_ID_VIDEO commentId:nil];
                }
            }
            else
            {
                [self callAPISyncData:kTypeUnLike text:nil contentId:videoForCategoryInfo.nodeID contentTypeId:TYPE_ID_VIDEO commentId:nil];
            }
        }
        else //-- like then +1
        {
            [btnLike setImage:[UIImage imageNamed:@"btn_liked_news.png"] forState:UIControlStateNormal];
            
            if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
            {
                if (contentVideoTypeId == ContentTypeIDAllVideo) {
                    
                    [self callAPISyncData:kTypeLike text:nil contentId:videoAllModelInfo.node_id contentTypeId:TYPE_ID_VIDEO commentId:nil];
                    
                }else {
                    
                    [self callAPISyncData:kTypeLike text:nil contentId:videoForAllInfo.nodeId contentTypeId:TYPE_ID_VIDEO commentId:nil];
                }
            }
            else
            {
                [self callAPISyncData:kTypeLike text:nil contentId:videoForCategoryInfo.nodeID contentTypeId:TYPE_ID_VIDEO commentId:nil];
            }
        }
    }
    else
    {
        //-- thong bao nang cap user
        [self showMessageUpdateLevelOfUser];
    }
}


- (IBAction)clickToBtnShare:(id)sender
{
    //-- share
    NSString *title = nil;
    NSString *headline = nil;
    NSString *imagePath = nil;
    NSString *description = nil;
    
    if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
    {
        if (contentVideoTypeId == ContentTypeIDAllVideo) {
            
            title = videoAllModelInfo.name;
            headline = [videoAllModelInfo.name stringByReplacingOccurrencesOfString:@" " withString:@" "];
            imagePath = videoAllModelInfo.thumbnail_image_file_path;
            description = [NSString stringWithFormat:@"Tôi tìm thấy video của %@ trong ứng dụng %@ tại %@", KEY_FB_SINGER_DISPLAY_NAME, KEY_FB_SINGER_DISPLAY_NAME, URL_APP_STORE];
            
            [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:imagePath contentId:videoAllModelInfo.node_id contentTypeId:TYPE_ID_VIDEO];
            
        }else {
            
            title = videoForAllInfo.name;
            headline = [videoForAllInfo.name stringByReplacingOccurrencesOfString:@" " withString:@" "];
            imagePath = videoForAllInfo.albumThumbImagePath;
            description = [NSString stringWithFormat:@"Tôi tìm thấy video của %@ trong ứng dụng %@ tại %@", KEY_FB_SINGER_DISPLAY_NAME, KEY_FB_SINGER_DISPLAY_NAME, URL_APP_STORE];
            
            [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:imagePath contentId:videoForAllInfo.nodeId contentTypeId:TYPE_ID_VIDEO];
        }
    }
    else
    {
        title = videoForCategoryInfo.title;
        headline = [videoForCategoryInfo.title stringByReplacingOccurrencesOfString:@" " withString:@" "];
        imagePath = videoForCategoryInfo.thumbnailImagePath;
        description = [NSString stringWithFormat:@"Tôi tìm thấy video của %@ trong ứng dụng %@ tại %@", KEY_FB_SINGER_DISPLAY_NAME, KEY_FB_SINGER_DISPLAY_NAME, URL_APP_STORE];
        
        [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:imagePath contentId:videoForCategoryInfo.nodeID contentTypeId:TYPE_ID_VIDEO];
    }
}

//-- download Video
- (IBAction)clickToBtnDownloadVideo:(id)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (userId) {
        
        BOOL isDownload = [self checkUserDownloadWithDateByType:DownloadTypeVideo];
        
        if (isDownload == YES) {
            
            ModelDownload *modelDownload = [[ModelDownload alloc] init];
            
            if (contentVideoTypeId == ContentTypeIDAllVideo) {
                
                modelDownload.linkUrlDownload = videoAllModelInfo.video_file_path;
                modelDownload.nodeId = videoAllModelInfo.node_id;
                modelDownload.fileName = videoAllModelInfo.name;
                
            }else if (contentVideoTypeId == ContentTypeIDVideo) {
                
                modelDownload.linkUrlDownload = videoForAllInfo.musicPath;
                modelDownload.nodeId = videoForAllInfo.nodeId;
                modelDownload.fileName = videoForAllInfo.name;
                
            }else {
                
                modelDownload.linkUrlDownload = videoForCategoryInfo.videoFilePath;
                modelDownload.nodeId = videoForCategoryInfo.nodeID;
                modelDownload.fileName = videoForCategoryInfo.title;
            }
            
            modelDownload.categoryId = [NSString stringWithFormat:@"%d",contentVideoTypeId];
            modelDownload.folderName = @"Video";
            
            //-- Download File
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startMusicDownload:modelDownload forIndexPath:indexPath];
            
        }else
            return;
        
    }else {
        
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}


#pragma mark - Call API get data

- (void)fetchingListComment
{
    if (videoForAllInfo.nodeId==nil)
        return;
    //[_indicatorComment startAnimating];
    if (contentVideoTypeId == ContentTypeIDVideo || contentVideoTypeId == ContentTypeIDAllVideo)
    {
        if (contentVideoTypeId == ContentTypeIDAllVideo) {
            
            [self callApiGetDataComment:SINGER_ID contentId:videoAllModelInfo.node_id contentTypeId:TYPE_ID_VIDEO commentId:@"0" getCommentOfComment:@"0"];
            
        }else {
            
            [self callApiGetDataComment:SINGER_ID contentId:videoForAllInfo.nodeId contentTypeId:TYPE_ID_VIDEO commentId:@"0" getCommentOfComment:@"0"];
        }
    }
    else
    {
        [self callApiGetDataComment:SINGER_ID contentId:videoForCategoryInfo.nodeID contentTypeId:TYPE_ID_VIDEO commentId:@"0" getCommentOfComment:@"0"];
    }
}


//-- pass data comments Delegate
- (void)passCommentsDelegate:(NSMutableArray*) listDataComments
{
    comments = listDataComments;
    
    //-- add tableview comment
    if (!tableviewComments) {
        
        [self addBaseTableViewCommentsToTabComments];
        
    }else {
        
        tableviewComments.listDataComments = comments;
        
        //-- reload tableview
        [tableviewComments.tableView reloadData];
        
        //-- auto scroll
        if (_isAutoScroll && ([comments count] > 2))
        {
            [tableviewComments.tableView beginUpdates];
            
            [tableviewComments.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([comments count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            [tableviewComments.tableView endUpdates];
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, scrollContent.frame.origin.y/3, 300, scrollContent.frame.size.height/3)];
    label.text = @"Hiện chưa có bình luận nào. Bạn hãy là người đầu tiên bình luận cho video này.";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    
    if (comments.count == 0)
        [tableviewComments.view addSubview:label];
    else{
        for (UIView *viewC in tableviewComments.view.subviews) {
            
            if ([viewC isKindOfClass:[UILabel class]]) {
                [viewC removeFromSuperview];
            }
        }
    }
}


//-- pass delegate from DetailsComment
- (void)subCommentSuccessDelegate
{
    // fill data into cell
    id index = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentVideoIndex"];
    Comment *aComment = [self.arrCommentData objectAtIndex:[index integerValue]];
    NSNumber *childComment = [NSNumber numberWithInteger:[aComment.numberOfSubcommments integerValue] + 1];
    aComment.numberOfSubcommments = [childComment stringValue];
    
    [tableviewComments.tableView reloadData];
}



//************************************************************************//
#pragma mark - Notifications

- (void) videoPlayerViewControllerDidReceiveMetadata:(NSNotification *)notification
{
	NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (!userId) {
        
        if (isExistingVideoLocal == NO) { //-- not exist video local
            timerPlayVideo = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(changeStatusSlideBar)
                                                            userInfo:nil
                                                             repeats:YES];
        }
    }
}


- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
	NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
	if (error)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
		[alertView show];
	}
}

- (void) nowPlayingMovieDidChange:(NSNotification *)notification
{
    NSUserDefaults *defaultVideo = [NSUserDefaults standardUserDefaults];
    BOOL isPlayvideo = [defaultVideo boolForKey:@"isPlayVideoDefault"];
    
    if (isPlayvideo == NO) {
        
        [timerPlayVideo invalidate];
        [self.videoPlayerViewController.moviePlayer stop];
        self.videoPlayerViewController = nil;
    }
}

- (void) willEnterFullScreen:(NSNotification *)notification
{
    self.videoPlayerViewController.moviePlayer.fullscreen = YES;
}

- (void) willExitFullScreen:(NSNotification *)notification
{
    self.videoPlayerViewController.moviePlayer.fullscreen = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(setStatusBarVisible:) userInfo:nil repeats:NO];
}

- (void) setStatusBarVisible: (NSTimer *)timer {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            if (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight)
            {
                self.videoPlayerViewController.moviePlayer.fullscreen = NO;
            }
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            if (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight)
            {
                self.videoPlayerViewController.moviePlayer.fullscreen = NO;
            }
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            self.videoPlayerViewController.moviePlayer.fullscreen = YES;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            self.videoPlayerViewController.moviePlayer.fullscreen = YES;
            break;
            
        default:
            break;
    };
}

-(void) changeStatusSlideBar {
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (!userId) {
        
        if (isExistingVideoLocal == NO) { //-- not exist video local
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger timeTrailerVideo = [[userDefaults valueForKey:Key_Trailer_Info_Video] integerValue];
            
            CGFloat sliderValue = self.videoPlayerViewController.moviePlayer.currentPlaybackTime;
            
            if (sliderValue >= timeTrailerVideo) {
                
                //-- Thông báo nâng cấp user
                [self showMessageUpdateLevelOfUser];
                
                
                self.videoPlayerViewController.moviePlayer.fullscreen = NO;
                [self.videoPlayerViewController.moviePlayer pause];
                self.videoPlayerViewController.moviePlayer.currentPlaybackTime = 0;
            }
        }
    }
}

#pragma  mark - base view controller delegate
- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
//    _isProcessLikeAPI = false;
}

- (void)baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    if (_isCreateComment)
        [self showDialogComments:CGPointZero title:@"Bình luận"];
    else if (_isLike)
        [self clickToBtnLike:btnLike];
}

//*********************************************************************************//
#pragma mark - Download File Music

//-- start download Music
-(void) startMusicDownload:(ModelDownload *) modelDownload forIndexPath:(NSIndexPath *)indexPath
{
    Downloader *iconDownloader = [videoDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        btnDownloadVideo.enabled = NO;
        
        //-- show image loading
        [self startSpinWithCell];
        
        iconDownloader = [[Downloader alloc] init];
        iconDownloader.modelDownload = modelDownload;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegateDownload = self;
        [videoDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        
        [iconDownloader startDownload];
        
        //-- update number of download limit
        NSUserDefaults *defaultDownload = [NSUserDefaults standardUserDefaults];
        NSInteger numberOfDownloadPrivateVideo = [[defaultDownload valueForKey:@"NumberOfDownloadPrivateVideo"] integerValue];
        NSString *numberOfDownloadStr = [NSString stringWithFormat:@"%d",numberOfDownloadPrivateVideo+1];
        
        [defaultDownload setValue:numberOfDownloadStr forKey:@"NumberOfDownloadPrivateVideo"];
        [defaultDownload synchronize];
    }
}

//-- update Progress File Downloader
-(void) updateProgressFileDownloader:(NSString *)progress WithIndexPath:(NSIndexPath *)indexPath {
    
    //-- show Progress
    [btnDownloadVideo setImage:nil forState:UIControlStateNormal];
    [btnDownloadVideo setTitle:progress forState:UIControlStateNormal];
}

//-- callback when download success and hidden button Download
-(void) delegateFileDownloader:(NSIndexPath *)indexPath
{
    Downloader *iconDownloader = [videoDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil) {
        
        btnDownloadVideo.enabled = NO;
        
        //-- remove image loading
        [self stopSpinWithCell];
    }else {
        
        btnDownloadVideo.enabled = YES;
        
        //-- remove image loading
        [self stopSpinWithCell];
    }
    
    [btnDownloadVideo setImage:[UIImage imageNamed:@"icon_download_big.png"] forState:UIControlStateNormal];
    [btnDownloadVideo setTitle:@"" forState:UIControlStateNormal];
    
}

#pragma mark Spin for cell

- (void)startSpinWithCell
{
    if (!loadingView) {
        
        CGRect frameBtnDownload = [btnDownloadVideo frame];
        loadingView = [[UIImageView alloc] initWithFrame:frameBtnDownload];
        loadingView.image = [UIImage imageNamed:@"loading.png"];
        [self.viewToolBar addSubview:loadingView];
    }
    
    loadingView.hidden = NO;
    
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [loadingView frame];
	loadingView.layer.anchorPoint = CGPointMake(0.5, 0.5);
	loadingView.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
    
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[loadingView.layer addAnimation:animation forKey:@"rotationAnimation"];
    
	[CATransaction commit];
}

- (void)stopSpinWithCell
{
    [loadingView.layer removeAllAnimations];
    loadingView.hidden = YES;
}

@end
