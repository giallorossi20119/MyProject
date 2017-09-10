//
//  MusicPlayViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "AudioPlayer.h"
#import "ModelDownload.h"

@interface MusicPlayViewController ()

@end

@implementation MusicPlayViewController

@synthesize musicTrack;
@synthesize imgCover, sliderBar, tableViewComment, viewLyric, imgTop;
@synthesize lblArtist, lblAlbum, lblCommented, lblLiked;
@synthesize txvLyric, btnPlayPause, sliderTimer;
@synthesize totalTimeString, indexOfSong, arrTrack;
@synthesize tableviewComments,scrollContent;
@synthesize viewTop;
@synthesize musicDownloadsInProgress;
@synthesize autoFullName;
@synthesize titleAlbum;

int taskCounter = 0;


//***********************************************************************//
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
    
    //-- set value default for repeat and suffer
    NSUserDefaults *repeatSufferFlagsDefault = [NSUserDefaults standardUserDefaults];
    [repeatSufferFlagsDefault setBool:NO forKey:@"RepeatFlags"];
    [repeatSufferFlagsDefault setBool:NO forKey:@"SufferFlags"];
    [repeatSufferFlagsDefault synchronize];
    
    //-- set Delegate
    [AudioPlayer addDelegateAudio:self];
    
    self.musicDownloadsInProgress = [NSMutableDictionary dictionary];
    
    //-- check user and going to Fanzone screen
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReDownLoadMusic) name:@"ReDownLoadMusic_MusicPlayVC" object:nil];
    
    //-- auto scroll title
    [self autoScrollTitle:titleAlbum];
    
    //-- set view
    [self setViewWhenViewDidLoad];
    
    //-- load data
    [self setDataWhenViewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Music Play Screen";
    
    //-- remove slidebar
    [self removeSlideBarBaseViewController];
    
    //--display status like button
    musicTrack = [self.arrTrack objectAtIndex:self.indexOfSong];
    
    if ([musicTrack.isLiked isEqualToString:@"0"]) {
        [btnLike setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
    }else{
        [btnLike setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentMusicIndex"];
    
    //-- show navigationbar
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    self.imgCover.layer.masksToBounds = YES;
    self.imgCover.layer.cornerRadius = 55;
    self.imgCover.layer.borderWidth = 1.5;
    self.imgCover.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //-- fix size
    [self.imgCover setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgCover setClipsToBounds:YES];
    
    [Utility scaleImage:self.imgCover.image toSize:CGSizeMake(110, 110)];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSArray *allDownloads = [self.musicDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)autoScrollTitle:(NSString*)text
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

-(void) ReDownLoadMusic {
    
    //-- check downloader music
    NSString *filePath = [Utility getMusicFilePathWithCategoryId:musicTrack.albumId withNodeId:musicTrack.nodeId];
    BOOL isShowDownLoad = [Utility checkingAFileExistsWithPath:filePath];
    if (isShowDownLoad == YES) {
        
        btnDownload.enabled = NO;
        
        //-- remove image loading
        if (loadingView) {
            [self stopSpinWithCell];
        }
        
    }else {
        
        NSString *keyDownload = [NSString stringWithFormat:@"%@%@",musicTrack.albumId,musicTrack.nodeId];
        
        NSUserDefaults *defaultDownloadNodeId = [NSUserDefaults standardUserDefaults];
        NSString *keyDownloadDefault = [defaultDownloadNodeId valueForKey:keyDownload];
        
        if (keyDownloadDefault && [keyDownloadDefault length] >0) {
            
            btnDownload.enabled = NO;
            
            //-- show image loading
            if (!loadingView) {
                [self startSpinWithCell];
            }
            
        }else {
            
            btnDownload.enabled = YES;
            
            //-- remove image loading
            if (loadingView) {
                [self stopSpinWithCell];
            }
        }
    }
    
    [btnDownload setImage:[UIImage imageNamed:@"play_btn_download.png"] forState:UIControlStateNormal];
    [btnDownload setTitle:@"" forState:UIControlStateNormal];
}

//-- setup view
-(void) setViewWhenViewDidLoad {
    
    //-- custom navigation bar
    [self customNavigationBar];
    
    //-- custom UISlider
    [self customSlider];
    
    //--set bool
    isLyric = YES;
    isComment = YES;
    isTimer = YES;
    _isAutoScroll = YES;
    
    [self.lblArtist setFont:[UIFont boldSystemFontOfSize:14]];
    self.lblArtist.textColor = [UIColor whiteColor];
    self.lblArtist.labelSpacing = 200; // distance between start and end labels
    self.lblArtist.pauseInterval = 0.3; // seconds of pause before scrolling starts again
    self.lblArtist.scrollSpeed = 30; // pixels per second
    self.lblArtist.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    self.lblArtist.fadeLength = 12.f;
    self.lblArtist.shadowOffset = CGSizeMake(-1, -1);
    self.lblArtist.scrollDirection = CBAutoScrollDirectionLeft;
    
    //-- lock muti touches
    viewTop.multipleTouchEnabled = NO;
    viewTop.exclusiveTouch = YES;
    
    //-- custom tableview
    [self.tableViewComment setSeparatorColor:[UIColor clearColor]];
    
    musicTrack = [self.arrTrack objectAtIndex:self.indexOfSong];
}


//***********************************************************************//
#pragma mark - Custom UISlider

- (void)customSlider
{
    [sliderBar setThumbImage:[UIImage imageNamed:@"play_icon_run.png"] forState:UIControlStateNormal];
    [sliderBar setMinimumTrackImage:[[UIImage imageNamed:@"play_slider_min.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0.0] forState:UIControlStateNormal];
    [sliderBar setMaximumTrackImage:[[UIImage imageNamed:@"play_slider_max.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    sliderBar.value = 0;
    [sliderBar addTarget:self
                  action:@selector(sliderDidEndSliding:)
        forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
}

//-- add barButton
-(void) customNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    //-- back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(0, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(clickback:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- comment button
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame= CGRectMake(0, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(createComment:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barItemRight;
}


//****************************************************************************//
#pragma mark - Segment

-(void) setUpAddSegmentControl
{
    currentIndexSegment = 0;
    
    //-- Segmented control with scrolling
    segmentedControlComment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Lời bài hát",@"Bình Luận"]];
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



#pragma mark - Call API get data

- (void)fetchingListComment
{
    [self callApiGetDataComment:SINGER_ID
                      contentId:musicTrack.nodeId
                  contentTypeId:TYPE_ID_MUSIC_SONG
                      commentId:@"0"
            getCommentOfComment:@"0"];
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
        if (_isAutoScroll && ([listDataComments count] > 2))
        {
            [tableviewComments.tableView beginUpdates];
            
            [tableviewComments.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([listDataComments count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            [tableviewComments.tableView endUpdates];
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, scrollContent.frame.origin.y/3, 300, scrollContent.frame.size.height/3)];
    label.text = @"Hiện chưa có bình luận nào. Bạn hãy là người đầu tiên bình luận cho bài hát này.";
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
    id index = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentMusicIndex"];
    Comment *aComment = [self.arrCommentData objectAtIndex:[index integerValue]];
    NSNumber *childComment = [NSNumber numberWithInteger:[aComment.numberOfSubcommments integerValue] + 1];
    aComment.numberOfSubcommments = [childComment stringValue];
    
    [tableviewComments.tableView reloadData];
}



//****************************************************************************//
#pragma mark - UIScrollViewDelegate

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
    musicTrack = [self.arrTrack objectAtIndex:self.indexOfSong];
    
    tableviewComments = [[BaseCommentsTableViewController alloc] init];
    tableviewComments.delegateComments = self;
    tableviewComments.view.backgroundColor = [UIColor clearColor];
    tableviewComments.tableView.separatorColor = [UIColor clearColor];
    
    CGRect frameTable = [self.scrollContent frame];
    frameTable.origin.x = 320;
    frameTable.origin.y = 0;
    [tableviewComments.view setFrame:frameTable];
    
    //-- pass list data
    tableviewComments.listDataComments = comments;
    tableviewComments.nodeId = musicTrack.nodeId;
    
    [self.scrollContent addSubview:tableviewComments.view];
}

//-- did selected a row of tableview
-(void) goToCommentsScreenViewControllerWithListData:(NSMutableArray *)listDataComments withIndexRow:(int)indexRow
{
    Comment *comment = [listDataComments objectAtIndex:indexRow];
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    DetailCommentsViewController *detailCommnetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailCommentsViewControllerId"];
    [dataCenter setIsMusic:YES];
    detailCommnetVC.superComment = comment;
    detailCommnetVC.nodeId = musicTrack.nodeId;
    detailCommnetVC.delegateDetailComment = self;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",indexRow] forKey:@"currentMusicIndex"];
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


//************************************************************************//
#pragma mark - Show Detail Song

//-- load data
-(void) setDataWhenViewDidLoad
{
    comments = [[NSMutableArray alloc] init];
    userProfiles = [[NSMutableArray alloc] init];
    
    //--set delegate from BaseVC
    [self setDelegateBaseController:self];
    
    //-- check show and hidden some button
    [self checkShowOrHiddenButtonNextPrevious];
    
    
    //-- load song
    [self loadContentOfSongAndPlay];
    
    
    //-- add segment
    [self setUpAddSegmentControl];
    
    
    //-- reset timer
    [btnTimer setTitle:@"0:00" forState:UIControlStateNormal];
    
    //-- init singleton AudioPlayer
    if (_audioPlayer == nil) {
        _audioPlayer = [AudioPlayer sharedAudioPlayerMusic];
    }
    //longnh add
//    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    if ([dataCenter checkExistSlideBarBottom]) {
//        dataCenter.slideBarController.btnNext.hidden = NO;
//    }
    
    //-- pass arrTrack and indexSong to MediPlayer
    [[AudioPlayer sharedAudioPlayerMusic] setListSongsAlbum:arrTrack];
    [[AudioPlayer sharedAudioPlayerMusic] setIndexOfSong:self.indexOfSong];
    [[AudioPlayer sharedAudioPlayerMusic] setVolumeMusic:1];
    
    NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
    NSString *tempSongId = [defaultSongId valueForKey:@"DefaultSongId"];
    if (![musicTrack.nodeId isEqualToString:tempSongId]) {
        
        [defaultSongId setValue:musicTrack.albumName forKey:@"DefaultAlbumName"];
        [defaultSongId setValue:musicTrack.albumAuthorMusicId forKey:@"DefaultAuthorMusicId"];
        [defaultSongId setValue:musicTrack.name forKey:@"DefaultNameSong"];
        [defaultSongId setValue:musicTrack.albumThumbImagePath forKey:@"DefaultAlbumThumbImagePath"];
        [defaultSongId setValue:musicTrack.nodeId forKey:@"DefaultSongId"];
        [defaultSongId synchronize];
        
        //-- play Music Stream
        [self startPlayMusic];
        
    }else {
        
        if ([[AudioPlayer sharedAudioPlayerMusic] isPlayingSong])
            [btnPlayPause setImage:[UIImage imageNamed:@"play_btn_pause.png"] forState:UIControlStateNormal];
        else
            [btnPlayPause setImage:[UIImage imageNamed:@"play_btn_play.png"] forState:UIControlStateNormal];
        
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *command_gateway = [userDefaults valueForKey:Key_ringbackCommand_gateway];
    NSString *command_body = [userDefaults valueForKey:Key_ringbackCommand_body];
    
    if (command_gateway && command_body) {
        
        if ([musicTrack.songRingbacktoneId integerValue] == 1)
            btnPhone.enabled = YES;
        else
            btnPhone.enabled = NO;
        
    }else
        btnPhone.enabled = NO;
}

//-- play Music Stream
-(void) startPlayMusic {
    
    [_audioPlayer stop];
    
    //-- check downloader video
    NSString *filePath = [Utility getMusicFilePathWithCategoryId:musicTrack.albumId withNodeId:musicTrack.nodeId];
    BOOL isShowDownLoad = [Utility checkingAFileExistsWithPath:filePath];
    if (isShowDownLoad == YES) {
        
        //-- if existing musicPath is Play
        _audioPlayer.url = [NSURL fileURLWithPath:filePath];
        _audioPlayer.fixedLength = YES;
        [_audioPlayer play];
        
    }else {
        
        if ([self checkExistMusicPath:musicTrack.musicPath] == YES) {
            
            //-- if existing musicPath is Play
            _audioPlayer.url = [NSURL URLWithString:musicTrack.musicPath];
            _audioPlayer.fixedLength = NO;
            [_audioPlayer play];
            
        }else {
            
            //-- if not existing musicPath is show message
            [self showNotificationFailed];
        }
    }
}


//-- validate MusicPath
-(BOOL) checkExistMusicPath:(NSString *) musicPathStr {
    
    //-- validate content
    NSString *tempMusicPath = [musicPathStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereAreJustSpaces = [tempMusicPath isEqualToString:@""];
    
    if( ((!thereAreJustSpaces) || [musicPathStr length] > 0))
        return YES;
    else
        return NO;
}


//***********************************************************************//
#pragma mark - ACTION

- (void)clickback:(id)sender
{
    //-- remove Delegate
    [AudioPlayer removeDelegateAudio:self];
    
    //-- add slidebar again
    [self addSlideBarBaseViewController];
    
    //-- Call notification reload data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload_MusicAlbumVC" object:nil];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}

- (void)createComment:(id)sender
{
    //-- create comments
    _isLike = NO;
    _isCreateComment = YES;
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        
        if (_isCreateComment)
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
    commentForAComment.arrSubComments = [NSMutableArray new];
    
    [comments addObject:commentForAComment];
    
    //-- reload tableview
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
    
    //-- call api
    [self callAPISyncData:kTypeComment text:content contentId:musicTrack.nodeId contentTypeId:TYPE_ID_MUSIC_SONG commentId:@"0"];
    
    [self.superComment.arrSubComments addObject:commentForAComment];
    
}

//-- if comment or like posted successfully

- (void)syncDataSuccessDelegate:(NSDictionary *)response
{
    //-- set id for comment at local
    NSDictionary   *dictData          = [response objectForKey:@"data"];
    NSMutableArray *arrComment        = [dictData objectForKey:@"comment"];
    
    MusicTrackNew *mTrack = (MusicTrackNew *)[arrTrack objectAtIndex:indexOfSong];
    
    if (_isCreateComment == YES)
    {
        if ([arrComment count] > 0)
        {
            NSDictionary *dictComment         = [arrComment objectAtIndex:0];
            NSString     *commentId           = [dictComment objectForKey:@"comment_id"];
            Comment      *recentComment       = [comments lastObject];
            if ([recentComment.commentId isEqualToString:@"0"])
                recentComment.commentId = commentId;
        }
        
        NSNumber *comment = [NSNumber numberWithInteger:[mTrack.snsTotalComment integerValue]+1];
        lblCommented.text = [NSString stringWithFormat:@"%d", [comment integerValue]];
        mTrack.snsTotalComment = [comment stringValue];

        _isCreateComment = NO;
        
        //-- show view comment
        [self clickToBtnComment:nil];
    }
    
    else if (_isLike == YES){

        if (btnLike.currentImage == [UIImage imageNamed:@"icon_like_photo.png"]) //-- unlike then -1
        {
            mTrack.isLiked = @"0";
            
            NSNumber *unlike = [NSNumber numberWithInteger:[mTrack.snsTotalLike integerValue]-1];
            if (unlike<0) {
                unlike = 0;
            }
            
            lblLiked.text = [NSString stringWithFormat:@"%d", [unlike integerValue]];
            
            mTrack.snsTotalLike = [unlike stringValue];
        }
        else //-- like then +1
        {
            mTrack.isLiked = @"1";
            
            NSNumber *like = [NSNumber numberWithInteger:[mTrack.snsTotalLike integerValue]+1];
            lblLiked.text = [NSString stringWithFormat:@"%d", [like integerValue]];
            
            mTrack.snsTotalLike = [like stringValue];
        }
        
        _isLike = NO;
    }
    
    //-- update to DB
    [VMDataBase updateTrackByAlbum:mTrack];
}


- (IBAction)clickToBtnRefresh:(id)sender
{
    //-- refresh
    [self resetInfoMusicSong];
    
    [_audioPlayer stop];
    [_audioPlayer play];
}

//-- set repeat
- (IBAction)clickToBtnRepeat:(id)sender
{
    NSUserDefaults *repeatSufferFlagsDefault = [NSUserDefaults standardUserDefaults];
    
    if ([repeatSufferFlagsDefault boolForKey:@"RepeatFlags"] == YES) {
        
        //-- not repeat
        [repeatSufferFlagsDefault setBool:NO forKey:@"RepeatFlags"];
        [repeatSufferFlagsDefault synchronize];
        
        [btnRepeat setImage:[UIImage imageNamed:@"play_btn_repeat.png"] forState:UIControlStateNormal];
    }
    else {
        
        //-- repeat
        [repeatSufferFlagsDefault setBool:YES forKey:@"RepeatFlags"];
        [repeatSufferFlagsDefault synchronize];
        
        [btnRepeat setImage:[UIImage imageNamed:@"play_btn_repeat_On.png"] forState:UIControlStateNormal];
    }
    
    //-- check show and hidden some button
    [self checkShowOrHiddenButtonNextPrevious];
}

//-- set Suffer
- (IBAction)clickToBtnSuffer:(id)sender
{
    NSUserDefaults *repeatSufferFlagsDefault = [NSUserDefaults standardUserDefaults];
    
    if ([repeatSufferFlagsDefault boolForKey:@"SufferFlags"] == YES) {
        
        //-- not Suffer
        [repeatSufferFlagsDefault setBool:NO forKey:@"SufferFlags"];
        [repeatSufferFlagsDefault synchronize];
        
        [btnSuffer setImage:[UIImage imageNamed:@"play_btn_suffer.png"] forState:UIControlStateNormal];
    }
    else {
        
        //-- Suffer
        [repeatSufferFlagsDefault setBool:YES forKey:@"SufferFlags"];
        [repeatSufferFlagsDefault synchronize];
        
        
        [btnSuffer setImage:[UIImage imageNamed:@"play_btn_suffer_On.png"] forState:UIControlStateNormal];
        
        if ([arrTrack count] >2) {
            
            //-- play random list song
            int indexRandom = (arc4random()%[arrTrack count]);
            
            while (indexRandom == self.indexOfSong) {
                
                indexRandom = (arc4random()%[arrTrack count]);
            }
            
            self.indexOfSong = indexRandom;
        }
    }
}

- (IBAction)clickToBtnPlayPause:(id)sender
{
    if (btnPlayPause.currentImage == [UIImage imageNamed:@"play_btn_pause.png"]) {
        [btnPlayPause setImage:[UIImage imageNamed:@"play_btn_play.png"] forState:UIControlStateNormal];
        
        [_audioPlayer pauseSong];
        
    }else{
        [btnPlayPause setImage:[UIImage imageNamed:@"play_btn_pause.png"] forState:UIControlStateNormal];
        
        [_audioPlayer play];
    }
}

- (IBAction)clickToBtnNext:(id)sender
{
    //-- reset data song
    [self resetInfoMusicSong];

    //-- check and next index
    if (self.indexOfSong < [arrTrack count]-1)
    {
        //-- play next song
        [[AudioPlayer sharedAudioPlayerMusic] playNextSong];
        
        self.indexOfSong += 1;
     
        //-- change song
        [self loadContentOfSongAndPlay];
        
    }else {
        
        NSUserDefaults *repeatSufferFlagsDefault = [NSUserDefaults standardUserDefaults];
        
        if ([repeatSufferFlagsDefault boolForKey:@"RepeatFlags"] == YES) {
            
            self.indexOfSong = 0;
            
            //-- load song
            [self loadContentOfSongAndPlay];
            
            [[AudioPlayer sharedAudioPlayerMusic] setIndexOfSong:self.indexOfSong];
            
            NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
            [defaultSongId setValue:musicTrack.nodeId forKey:@"DefaultSongId"];
            [defaultSongId synchronize];
            
            //-- play Music Stream
            [self startPlayMusic];
        }
    }
    
    //-- check show and hidden some button
    [self checkShowOrHiddenButtonNextPrevious];
}

- (IBAction)clickToBtnPrevious:(id)sender
{
    //-- reset data song
    [self resetInfoMusicSong];
    
    //-- check and Previous index
    if (self.indexOfSong >= 1)
    {
        //-- play next song
        [[AudioPlayer sharedAudioPlayerMusic] playPreviousSong];
        
        self.indexOfSong -= 1;
        
        //-- change song
        [self loadContentOfSongAndPlay];
        
    }
    else
    {
        NSUserDefaults *repeatSufferFlagsDefault = [NSUserDefaults standardUserDefaults];
        
        if ([repeatSufferFlagsDefault boolForKey:@"RepeatFlags"] == YES)
        {
            self.indexOfSong = [arrTrack count] -1;
            
            //-- load song
            [self loadContentOfSongAndPlay];
            
            [[AudioPlayer sharedAudioPlayerMusic] setIndexOfSong:self.indexOfSong];
            
            NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
            [defaultSongId setValue:musicTrack.nodeId forKey:@"DefaultSongId"];
            [defaultSongId synchronize];
            
            //-- play Music Stream
            [self startPlayMusic];
        }
    }
    
    //-- check show and hidden some button
    [self checkShowOrHiddenButtonNextPrevious];
}


//-- check show and hidden some button
-(void) checkShowOrHiddenButtonNextPrevious
{
    
    NSUserDefaults *repeatSufferFlagsDefault = [NSUserDefaults standardUserDefaults];
    
    if ([repeatSufferFlagsDefault boolForKey:@"RepeatFlags"] == YES) {
        
        [btnPrevious setEnabled:YES];
        [btnNext setEnabled:YES];
        
    } else {
        
        [btnPrevious setEnabled:YES];
        [btnNext setEnabled:YES];
        
        if (self.indexOfSong == 0)
            [btnPrevious setEnabled:NO];
        
        if (self.indexOfSong == [arrTrack count] -1)
            [btnNext setEnabled:NO];
    }
}


//-- reset data song
-(void) resetInfoMusicSong {
    
    sliderBar.value = 0;
    [btnTimer setTitle:@"0:00" forState:UIControlStateNormal];
    
    //-- Music completed
    [btnPlayPause setImage:[UIImage imageNamed:@"play_btn_play.png"] forState:UIControlStateNormal];
    
    //-- stop song
    [[AudioPlayer sharedAudioPlayerMusic] stop];
}

//-- load song
- (void)loadContentOfSongAndPlay
{
    musicTrack = [self.arrTrack objectAtIndex:self.indexOfSong];
    
    //-- call api data view
    [self apiDataView:musicTrack.nodeId contentTypeId:TYPE_ID_MUSIC_SONG];
    
    //--load data of song
    [self loadDataMusicSongByMusicTrack:musicTrack];
}


//--load data of song
-(void) loadDataMusicSongByMusicTrack:(MusicTrackNew *) mTrack {
    
    //--set title and album
    self.lblArtist.text = mTrack.name;
    self.lblAlbum.text = mTrack.albumName;
    
    //-- set number like, comment
    lblCommented.text = mTrack.snsTotalComment;
    lblLiked.text = mTrack.snsTotalLike;
    
    //-- lyric content
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        NSString *stringFormat = [NSString stringWithFormat:@"<div style=\"color: #fff; text-align: center; font-size: 14px; \">%@ </div>",mTrack.content];
        NSAttributedString *aStr = [[NSAttributedString alloc] initWithData:[stringFormat dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                              NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                         documentAttributes:nil error:nil];
        
        txvLyric.attributedText = aStr;
    }else{
        [txvLyric setValue:mTrack.content forKey:@"contentToHTMLString"];
    }
    
    //-- check downloader music
    NSString *filePath = [Utility getMusicFilePathWithCategoryId:musicTrack.albumId withNodeId:musicTrack.nodeId];
    BOOL isShowDownLoad = [Utility checkingAFileExistsWithPath:filePath];
    if (isShowDownLoad == YES) {
        
        btnDownload.enabled = NO;
        
        //-- remove image loading
        if (loadingView) {
            [self stopSpinWithCell];
        }
        
    }else {
        
        NSString *keyDownload = [NSString stringWithFormat:@"%@%@",musicTrack.albumId,musicTrack.nodeId];
        
        NSUserDefaults *defaultDownloadNodeId = [NSUserDefaults standardUserDefaults];
        NSString *keyDownloadDefault = [defaultDownloadNodeId valueForKey:keyDownload];
        
        if (keyDownloadDefault && [keyDownloadDefault length] >0) {
            
            btnDownload.enabled = NO;
            
            //-- show image loading
            [self startSpinWithCell];
            
        }else {
            
            btnDownload.enabled = YES;
            
            //-- remove image loading
            [self stopSpinWithCell];
        }
    }
    
    [btnDownload setImage:[UIImage imageNamed:@"play_btn_download.png"] forState:UIControlStateNormal];
    [btnDownload setTitle:@"" forState:UIControlStateNormal];
    
    
    //-- fetching data comments
    [self fetchingListComment];
    
    //-- set Like button status
    if ([mTrack.isLiked isEqualToString:@"0"])
    {
        [btnLike setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
    }
    else //-- like then +1
    {
        [btnLike setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
    }
    
    //--set download image cover
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:mTrack.albumThumbImagePath] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    }];
}


- (IBAction)clickToBtnTimer:(id)sender
{
    //-- Timer
}


- (IBAction)clickToBtnSpeaker:(id)sender
{
    if (btnSpeaker.currentImage == [UIImage imageNamed:@"play_icon_speaker"])
    {
        [[AudioPlayer sharedAudioPlayerMusic] setVolumeMusic:0];
        [btnSpeaker setImage:[UIImage imageNamed:@"play_btn_mute.png"] forState:UIControlStateNormal];
    }
    else
    {
        [[AudioPlayer sharedAudioPlayerMusic] setVolumeMusic:1];
        [btnSpeaker setImage:[UIImage imageNamed:@"play_icon_speaker"] forState:UIControlStateNormal];
    }
}


- (IBAction)clickToBtnComment:(id)sender
{
    //-- change segmanet
    [segmentedControlComment setSelectedSegmentIndex:1];
    [self scrollToIndex:1];
}


- (IBAction)clickToBtnShare:(id)sender
{
    //-- share
    
    MusicTrackNew *mTrack = (MusicTrackNew *)[arrTrack objectAtIndex:indexOfSong];
    
    NSString *title = mTrack.name;
    //NSString *headline = [mTrack.name stringByReplacingOccurrencesOfString:@" " withString:@" "];
    NSString *description = [NSString stringWithFormat:@"Tôi tìm thấy bài hát của %@ trong ứng dụng %@ tại %@", KEY_FB_SINGER_DISPLAY_NAME, KEY_FB_SINGER_DISPLAY_NAME, URL_APP_STORE];
    
    [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:mTrack.albumThumbImagePath contentId:mTrack.nodeId contentTypeId:TYPE_ID_MUSIC_SONG];
}

//-- download music
- (IBAction)clickToBtnDownload:(id)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (userId) {
        
        BOOL isDownload = [self checkUserDownloadWithDateByType:DownloadTypeMusic];
        
        if (isDownload == YES) {
            
            ModelDownload *modelDownload = [[ModelDownload alloc] init];
            
            modelDownload.linkUrlDownload = musicTrack.musicPath;
            modelDownload.categoryId = musicTrack.albumId;
            modelDownload.nodeId = musicTrack.nodeId;
            modelDownload.fileName = musicTrack.name;
            modelDownload.folderName = @"Music";
            
            //-- Download File
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.indexOfSong inSection:0];
            [self startMusicDownload:modelDownload forIndexPath:indexPath];
            
        }else
            return;
        
    }else {
        
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}

//-- Nhac Cho
- (IBAction)clickToBtnPhone:(id)sender
{
    //-- request get SongRingBackToneId
    [self callApiGetSongRingBackToneIdByMusicID:musicTrack];
}


- (IBAction)clickToBtnLike:(id)sender
{
    //-- Like
    _isLike = YES;
    _isCreateComment = NO;
    
    MusicTrackNew *mTrack = (MusicTrackNew *)[arrTrack objectAtIndex:indexOfSong];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        
        if (btnLike.currentImage == [UIImage imageNamed:@"icon_liked.png"]) //-- unlike then -1
        {
            [btnLike setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
            
            [self callAPISyncData:kTypeUnLike text:nil contentId:mTrack.nodeId contentTypeId:TYPE_ID_MUSIC_SONG commentId:nil];
        }
        else //-- like then +1
        {
            [btnLike setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
            
            [self callAPISyncData:kTypeLike text:nil contentId:mTrack.nodeId contentTypeId:TYPE_ID_MUSIC_SONG commentId:nil];
        }
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}


- (IBAction)clickToBtnViewLyric:(id)sender
{
    
    viewLyric.alpha = 1;
    tableViewComment.alpha = 0;
    
    isLyric = YES;
    isComment = NO;
    
    [btnViewLyric setSelected:YES];
    [btnViewComment setSelected:NO];
    
    btnViewLyric.userInteractionEnabled = NO;
    btnViewComment.userInteractionEnabled = YES;
}


- (IBAction)clickToBtnViewComment:(id)sender
{
    
    viewLyric.alpha = 0;
    tableViewComment.alpha = 1;
    
    isLyric = NO;
    isComment = YES;
    
    [btnViewLyric setSelected:YES];
    [btnViewComment setSelected:NO];
    
    btnViewLyric.userInteractionEnabled = YES;
    btnViewComment.userInteractionEnabled = NO;
}


- (void)clickAddComment:(id)sender
{
    //-- comments
}


//***********************************************************************//
#pragma mark - AudioPlayerDelegate

//-- update user
-(void) checkUpdateLevelOfUserWithSlider:(CGFloat)sliderValue {
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (!userId) {
        
        //-- not exist music local
        if ([AudioPlayer sharedAudioPlayerMusic].fixedLength == NO) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger timeTrailerMusic = [[userDefaults valueForKey:Key_Trailer_Info_Music] integerValue];
            
            if (sliderValue >= timeTrailerMusic) {
                
                //-- reset data song
                [self resetInfoMusicSong];
                
                //-- thông báo nâng cấp user
                [self showMessageUpdateLevelOfUser];
            }
        }
    }
}

- (void)updateTimerSliderAudio:(NSString *)sliderTimerAudio WithSlider:(CGFloat)sliderValue withSliderMaxvalue:(CGFloat)maxvalue
{
    NSUserDefaults *defaultEditSlider = [NSUserDefaults standardUserDefaults];
    if ([defaultEditSlider boolForKey:@"isEditSlider"] == NO) {
        //longnh fix 
        if ([[AudioPlayer sharedAudioPlayerMusic] isStartMusic] && sliderValue < maxvalue) {
            sliderBar.maximumValue = maxvalue;
            sliderBar.value = sliderValue;
            
        } else {
            if (maxvalue > 60 && sliderValue < maxvalue) {
                
                sliderBar.maximumValue = maxvalue;
                sliderBar.value = sliderValue;
            }
        }
        
        [btnTimer setTitle:sliderTimerAudio forState:UIControlStateNormal];
        
        //longnh
        if ([[AudioPlayer sharedAudioPlayerMusic] isStartMusic] == NO) {
            [self checkUpdateLevelOfUserWithSlider:sliderValue];
        }
    }
}

- (void)sliderDidEndSliding:(NSNotification *)notification {
    
    if ([[AudioPlayer sharedAudioPlayerMusic] isPausedSong]) {
        
        [[AudioPlayer sharedAudioPlayerMusic] play];
    }
    
    //-- Fast skip the music when user scroll the UISlider
    [[AudioPlayer sharedAudioPlayerMusic] updateSlideChangedToTimeByValue:sliderBar.value];
    [self checkUpdateLevelOfUserWithSlider:sliderBar.value];
    
    [self performSelector:@selector(updateSliderAgainWhenHandleSilderBar) withObject:nil afterDelay:0.5];
}

-(void)updateSliderAgainWhenHandleSilderBar {
    
    NSUserDefaults *defaultEditSlider = [NSUserDefaults standardUserDefaults];
    [defaultEditSlider setBool:NO forKey:@"isEditSlider"];
    [defaultEditSlider synchronize];
}

- (IBAction)updateSlideChanged:(UISlider *)slider
{
    NSUserDefaults *defaultEditSlider = [NSUserDefaults standardUserDefaults];
    [defaultEditSlider setBool:YES forKey:@"isEditSlider"];
    [defaultEditSlider synchronize];
    
    sliderBar.value = slider.value;
}


- (void)setUpSlideBarBottomByIsPlaying:(BOOL) isplaying {
    
    if (isplaying == YES) {
        
        [btnPlayPause setImage:[UIImage imageNamed:@"play_btn_pause.png"] forState:UIControlStateNormal];
    }else {
        
        [btnPlayPause setImage:[UIImage imageNamed:@"play_btn_play.png"] forState:UIControlStateNormal];
    }
}


- (void)playFinishedAudio
{
    //-- Music completed
    [btnPlayPause setImage:[UIImage imageNamed:@"play_btn_play.png"] forState:UIControlStateNormal];
    
    //-- reset data song
    [self resetInfoMusicSong];
    
    //-- check and next index
    if (self.indexOfSong < [arrTrack count]-1)
    {
        self.indexOfSong += 1;
        
        //-- change song
        [self loadContentOfSongAndPlay];
        
        //-- play next song
        [[AudioPlayer sharedAudioPlayerMusic] play];
        
    }else {
        
        NSUserDefaults *repeatSufferFlagsDefault = [NSUserDefaults standardUserDefaults];
        
        if ([repeatSufferFlagsDefault boolForKey:@"RepeatFlags"] == YES) {
            
            self.indexOfSong = 0;
            
            //-- load song
            [self loadContentOfSongAndPlay];
            
            [[AudioPlayer sharedAudioPlayerMusic] setIndexOfSong:self.indexOfSong];
            
            NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
            [defaultSongId setValue:musicTrack.nodeId forKey:@"DefaultSongId"];
            [defaultSongId synchronize];
            
            //-- play Music Stream
            [self startPlayMusic];
        }
    }
    
    //-- check show and hidden some button
    [self checkShowOrHiddenButtonNextPrevious];
}


- (void)playFailedAudio
{
    //-- Music completed
    [btnPlayPause setImage:[UIImage imageNamed:@"play_btn_play.png"] forState:UIControlStateNormal];
    
    //------ Music Failed -----//
    [self showNotificationFailed];
    
    //-- request error network
    [self callRequestErrorNetwork];
}


//***********************************************************************//
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comments count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicCustomCellPlay *cell2 = (MusicCustomCellPlay *)[self setTableViewCellWithIndexPath:indexPath];
    
    return cell2;
}


//-- set up table view cell for iPhone
-(MusicCustomCellPlay *) setTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"idMusicCustomCellPlaySb";
    
    MusicCustomCellPlay *cell = [self.tableViewComment dequeueReusableCellWithIdentifier:identifier];;
    
    //-- set data for cell
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}


-(MusicCustomCellPlay *)setDataForTableViewCell:(MusicCustomCellPlay *)cell withIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //-- set color background for cell
    if ((indexPath.row%2) == 0)
        cell.contentView.backgroundColor = COLOR_PLAY_CELL_BOLD;
    else
        cell.contentView.backgroundColor = COLOR_PLAY_CELL_REGULAR;

    cell.txtViewComment.text = [comments objectAtIndex:indexPath.row];
    cell.imgAvatar.image = [UIImage imageNamed:[userProfiles objectAtIndex:indexPath.row]];
    cell.imgAvatar.layer.masksToBounds = YES;
    cell.imgAvatar.layer.cornerRadius = 17;
    cell.imgAvatar.layer.borderWidth = 1.0;
    cell.imgAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //-- set action for button
    [cell.btnShowListComments addTarget:self action:@selector(clickAddComment:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnShowListComments.tag = indexPath.row;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click profile row: %d", indexPath.row);
}


//***********************************************************************//
#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self resignFirstResponder];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self resignFirstResponder];
}


//***********************************************************************//
#pragma mark - Base view controller delegate
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


//******************************************************************************************//
#pragma  mark - Alertview Delegate

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

//******************************************************************************************//
#pragma  mark - Send SMS

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


//*********************************************************************************//
#pragma mark - Download File Music

//-- start download Music
-(void) startMusicDownload:(ModelDownload *) modelDownload forIndexPath:(NSIndexPath *)indexPath
{
    Downloader *iconDownloader = [musicDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        //-- add list downloader
        MusicTrackNew *msTrack = [arrTrack objectAtIndex:indexPath.row];
        NSString *keyDownload = [NSString stringWithFormat:@"%@%@",msTrack.albumId,msTrack.nodeId];
        
        NSUserDefaults *defaultDownloadNodeId = [NSUserDefaults standardUserDefaults];
        [defaultDownloadNodeId setObject:keyDownload forKey:keyDownload];
        [defaultDownloadNodeId synchronize];
        
        btnDownload.enabled = NO;
        
        //-- show image loading
        [self startSpinWithCell];
        
        iconDownloader = [[Downloader alloc] init];
        iconDownloader.modelDownload = modelDownload;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegateDownload = self;
        [musicDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        
        [iconDownloader startDownload];
        
        //-- update number of download limit
        NSUserDefaults *defaultDownload = [NSUserDefaults standardUserDefaults];
        NSInteger numberOfDownloadPrivateMusic = [[defaultDownload valueForKey:@"NumberOfDownloadPrivateMusic"] integerValue];
        NSString *numberOfDownloadStr = [NSString stringWithFormat:@"%d",numberOfDownloadPrivateMusic+1];
        
        [defaultDownload setValue:numberOfDownloadStr forKey:@"NumberOfDownloadPrivateMusic"];
        [defaultDownload synchronize];
    }
}

//-- update Progress File Downloader
-(void) updateProgressFileDownloader:(NSString *)progress WithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.indexOfSong) {
        
        //-- show Progress
        [btnDownload setImage:nil forState:UIControlStateNormal];
        [btnDownload setTitle:progress forState:UIControlStateNormal];
    }
}

//-- callback when download success and hidden button Download
-(void) delegateFileDownloader:(NSIndexPath *)indexPath
{
    //-- add list downloader
    MusicTrackNew *msTrack = [arrTrack objectAtIndex:indexPath.row];
    NSString *keyDownload = [NSString stringWithFormat:@"%@%@",msTrack.albumId,msTrack.nodeId];
    
    NSUserDefaults *defaultDownloadNodeId = [NSUserDefaults standardUserDefaults];
    [defaultDownloadNodeId removeObjectForKey:keyDownload];
    [defaultDownloadNodeId synchronize];
    
    Downloader *iconDownloader = [musicDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil && indexPath.row == self.indexOfSong) {
        
        btnDownload.enabled = NO;
    }else {
        btnDownload.enabled = YES;
    }
    
    //-- remove image loading
    [self stopSpinWithCell];
    
    [btnDownload setImage:[UIImage imageNamed:@"play_btn_download.png"] forState:UIControlStateNormal];
    [btnDownload setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark Spin for cell

- (void)startSpinWithCell
{
    if (!loadingView) {
        
        CGRect frameBtnDownload = [btnDownload frame];
        loadingView = [[UIImageView alloc] initWithFrame:frameBtnDownload];
        loadingView.image = [UIImage imageNamed:@"loading.png"];
        [self.view addSubview:loadingView];
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
