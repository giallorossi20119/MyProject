//
//  DetailsAlbumPhotoViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/26/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "DetailsAlbumPhotoViewController.h"

@interface DetailsAlbumPhotoViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;


@end

@implementation DetailsAlbumPhotoViewController

@synthesize arrayPhoto, indexOfPhoto, pageViews, number_of_images, radialProgress, scrollPhotoAlbum, albumTitle;
@synthesize autoFullName;

CGFloat lastScaleFactor = 1;

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
    
    //-- set view when did load
    [self setViewWhenViewDidLoad];
    
    //-- set data when did load
    [self setDataWhenViewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Detail Album Photos Screen";
    
    //-- turn off timer auto
    [_timerAuto invalidate];
    _timerAuto = nil;
}


//-- set view
- (void)setViewWhenViewDidLoad
{
    //-- custom navigation bar
    [self customNavigationBar];
    
    // set page
    NSInteger pageCount = number_of_images;
    
    // add tapgesture single for scrollViewImage
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(showOrHiddenHeaderView:)];
    
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self.scrollPhotoAlbum addGestureRecognizer:singleTap];
    
    // add doubletapgesture for scrollViewImage
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(handleDoubleTap:)];
    
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.scrollPhotoAlbum addGestureRecognizer:doubleTap];
    
    NSLog(@"in log %ld",(long)self.indexOfPhoto);
    //-- set status like button
    ListPhotosInAlbum *listData = (ListPhotosInAlbum *)[arrayPhoto objectAtIndex:self.indexOfPhoto];
    if ([listData.isLiked isEqualToString:@"0"])
        [btnLikePhoto setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
    else
        [btnLikePhoto setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
    
    // Set up the array to hold the views for each page
    pageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < pageCount; i++) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    // Set the scroll view's content size, autoscroll to the stating photo,
    // and setup the other display elements.
    //-- set up scroll content size
    [self setScrollViewContentSize];
    [self setCurrentIndex:indexOfPhoto];
    [self scrollToIndex:indexOfPhoto];
}

//-- load data
- (void)setDataWhenViewDidLoad
{
    //-- set bool
    _isPlaying = NO;
    
    [CommentsNewsViewController addDelegateComment:self];
    
    [self loadContentOfPhoto:indexOfPhoto];
}


//-- load content photo
- (void)loadContentOfPhoto:(NSInteger)index
{
    if (arrayPhoto.count >0) {
        ListPhotosInAlbum *listData = [arrayPhoto objectAtIndex:index];
        
        //-- set album title
        //-- auto text with title
        [self autoScrollText:[NSString stringWithFormat:@"%@ (%d/%d)", albumTitle, index+1, number_of_images]];
        //[self setTitle:[NSString stringWithFormat:@"%@ (%d/%d)", albumTitle, index+1, number_of_images]];
        
        //-- set button like image
        if ([listData.isLiked isEqualToString:@"1"])
            [btnLikePhoto setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
        else
            [btnLikePhoto setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
        
        lblNumberComment.text = listData.snsTotalComment;
        lblNumberLike.text = listData.snsTotalLike;
    }
}



#pragma mark - UI

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


-(void) customNavigationBar
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
    
    //-- comment button
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame= CGRectMake(15, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"icon_comments.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barItemRight;
}


- (void)showOrHiddenHeaderView:(UITapGestureRecognizer *) tapGesture
{
    //-- show or hide Header view
    [_timerAuto invalidate];
    _timerAuto = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        if (isIphone5)
            _viewHeader.frame = CGRectMake(0, 420, 320, 44);
        else
            _viewHeader.frame = CGRectMake(0, 332, 320, 44);
    }];
    
    //-- add slidebar
    [self addSlideBarBaseViewController];
}



#pragma mark - Action

- (IBAction)clickToBtnPlay:(id)sender
{
    _isPlaying = YES;
    
    //-- set auto scroll image
    _timerAuto = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(autoTimer)
                                                userInfo:nil
                                                 repeats:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        if (isIphone5)
            _viewHeader.frame = CGRectMake(0, 504, 320, 44);
        else
            _viewHeader.frame = CGRectMake(0, 416, 320, 44);
    }];
    
    //-- remove slidebar
    [self removeSlideBarBaseViewController];
}


- (IBAction)clickToBtnDownload:(id)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        
        BOOL isDownload = [self checkUserDownloadWithDateByType:DownloadTypePhoto];
        
        if (isDownload == YES) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Bạn có muốn tải bức ảnh này không?" delegate:self cancelButtonTitle:@"Huỷ bỏ" otherButtonTitles:@"Có", nil];
            [alertView show];
            
        }else
            return;
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}


- (IBAction)clickToBtnComment:(id)sender
{
    NSString *numberComment = ((ListPhotosInAlbum *)[arrayPhoto objectAtIndex:_currentIndex]).snsTotalComment;
    
    if (![numberComment isEqualToString:@"0"] || ![lblNumberComment.text isEqualToString:@"0"]) {
        AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *nodeId = ((ListPhotosInAlbum *)[arrayPhoto objectAtIndex:_currentIndex]).nodeId;
        
        CommentsNewsViewController *cmtNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbCommentsNewsViewControllerId"];
        cmtNewsVC.delegateComment = self;
        cmtNewsVC.nodeId = nodeId;
        [dataCenter setIsPhotoView:YES];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
            [self.navigationController pushViewController:cmtNewsVC animated:YES];
        else
            [self.navigationController pushViewController:cmtNewsVC animated:NO];
    }
}


- (IBAction)clickToBtnShare:(id)sender
{
    ListPhotosInAlbum *listData = [arrayPhoto objectAtIndex:_currentIndex];
    
    NSString *title = albumTitle;
    //NSString *headline = [albumTitle stringByReplacingOccurrencesOfString:@" " withString:@" "];
    NSString *description = [NSString stringWithFormat:@"Tôi tìm thấy bức ảnh của %@ trong ứng dụng %@ tại %@", KEY_FB_SINGER_DISPLAY_NAME, KEY_FB_SINGER_DISPLAY_NAME, URL_APP_STORE];
    
    [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:listData.imagePath contentId:listData.nodeId contentTypeId:TYPE_ID_PHOTO];
}


- (IBAction)clickToBtnLikePhoto:(id)sender
{
    _isLike = YES;
    _isCreateComment = NO;
    
    [self setDelegateBaseController:self];
    
    ListPhotosInAlbum *listData = [arrayPhoto objectAtIndex:_currentIndex];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        if (btnLikePhoto.currentImage == [UIImage imageNamed:@"icon_liked.png"]) //-- unlike then -1
        {
            [btnLikePhoto setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
            
            [self callAPISyncData:kTypeUnLike text:nil contentId:listData.nodeId contentTypeId:TYPE_ID_PHOTO commentId:nil];
        }
        else //-- like then +1
        {
            [btnLikePhoto setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
            
            [self callAPISyncData:kTypeLike text:nil contentId:listData.nodeId contentTypeId:TYPE_ID_PHOTO commentId:nil];
        }
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}


- (void)back:(id)sender
{
    [self addSlideBarBaseViewController];
    [_timerAuto invalidate];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


-(void)comment:(id)sender
{
    _isLike = NO;
    _isCreateComment = YES;
    
    //-- set delegate
    [self setDelegateBaseController:self];
    
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
    
    NSString *nodeId = ((ListPhotosInAlbum *)[arrayPhoto objectAtIndex:_currentIndex]).nodeId;
    
    //-- call api
    [self callAPISyncData:kTypeComment
                     text:content
                contentId:nodeId
            contentTypeId:TYPE_ID_PHOTO
                commentId:@"0"];
    
    [self.superComment.arrSubComments addObject:commentForAComment];
}


- (void)syncDataSuccessDelegate:(NSDictionary*)response
{
    ListPhotosInAlbum *listData = [arrayPhoto objectAtIndex:_currentIndex];
    
    if (_isCreateComment == YES)
    {
        NSNumber *comment = [NSNumber numberWithInteger:[listData.snsTotalComment integerValue]+1];
        lblNumberComment.text = [NSString stringWithFormat:@"%d", [comment integerValue]];
        listData.snsTotalComment = [comment stringValue];
        
        //-- set NO for _isCreateComment after success
        _isCreateComment = NO;
    }
    else if (_isLike == YES) {
        
        if (btnLikePhoto.currentImage == [UIImage imageNamed:@"icon_like_photo.png"]) //-- unlike
        {
            listData.isLiked = @"0";
            
            //--save value @"is_liked" to dictionaryLike
            [self.dictionaryLike setObject:[NSNumber numberWithInteger:0] forKey:@"is_liked"];
            
            NSNumber *unlike = [NSNumber numberWithInteger:[listData.snsTotalLike integerValue]-1];
            if (unlike<0) {
                unlike = 0;
            }
            
            lblNumberLike.text = [NSString stringWithFormat:@"%d", [unlike integerValue]];
            
            [self.dictionaryLike setObject:unlike forKey:@"sns_total_like"];
            
            listData.snsTotalLike = [unlike stringValue];
        }
        else //-- like
        {
            listData.isLiked = @"1";
            
            //--save value @"is_liked" to dictionaryLike
            [self.dictionaryLike setObject:[NSNumber numberWithInteger:1] forKey:@"is_liked"];
            
            NSNumber *like = [NSNumber numberWithInteger:[listData.snsTotalLike integerValue]+1];
            lblNumberLike.text = [NSString stringWithFormat:@"%d", [like integerValue]];
            
            [self.dictionaryLike setObject:like forKey:@"sns_total_like"];
            
            listData.snsTotalLike = [like stringValue];
        }
        
        //-- set NO for _isLike after success
        _isLike = NO;
    }
    
    [VMDataBase updatePhotoInAlbumBySinger:listData];
}


-(void)commentSuccessDelegate
{
    ListPhotosInAlbum *listData = [arrayPhoto objectAtIndex:_currentIndex];
    
    //-- set album title
    //[self setTitle:[NSString stringWithFormat:@"%@ (%d/%d)", albumTitle, _currentIndex+1, number_of_images]];
    [self autoScrollText:[NSString stringWithFormat:@"%@ (%d/%d)", albumTitle, _currentIndex+1, number_of_images]];
    
    //-- set number of comment after added comment
    NSNumber *addNumberComment = [NSNumber numberWithInteger:[listData.snsTotalComment integerValue]+1];
    
    lblNumberComment.text = [NSString stringWithFormat:@"%d", [addNumberComment integerValue]];
    
    listData.snsTotalComment = [addNumberComment stringValue];
    
    [VMDataBase updatePhotoInAlbumBySinger:listData];
}


- (void) autoTimer
{
    NSInteger pageCount = number_of_images;
    
    CGFloat widthMax = self.scrollPhotoAlbum.frame.size.width * (pageCount - 1);
    
    // Updates the variable w, adding 320
    CGFloat w = self.scrollPhotoAlbum.contentOffset.x;
    
    //This makes the scrollView scroll to the desired position
    if (w == widthMax) {
        w = 0;
        self.scrollPhotoAlbum.contentOffset = CGPointMake(w, 0);
    } else {
        w += self.scrollPhotoAlbum.frame.size.width;
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.scrollPhotoAlbum.contentOffset = CGPointMake(w, 0);
        } completion:^(BOOL finished) {
            //
        }];
    }
    
    //-- auto scroll photos
    CGFloat pageWidth = scrollPhotoAlbum.frame.size.width;
    float fractionalPage = scrollPhotoAlbum.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
    
    if (page != _currentIndex && page >= 0) {
        
        //-- load photo
        [self setCurrentIndex:page];
        
        [self loadContentOfPhoto:page];
    }
}


- (void)saveLocally:(NSData *)imgData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDate *aDate = [NSDate date];
    NSTimeInterval interval = [aDate timeIntervalSince1970];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",(int)interval]];
    [imgData writeToFile:localFilePath atomically:YES];
}



#pragma mark - Scroll

-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = self.scrollPhotoAlbum.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [self.scrollPhotoAlbum scrollRectToVisible:frame animated:NO];
}


- (void)setScrollViewContentSize
{
    NSInteger pageCount = number_of_images;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(self.scrollPhotoAlbum.frame.size.width * pageCount,
                             self.scrollPhotoAlbum.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    
    [self.scrollPhotoAlbum setContentSize:size];
}


- (void)setCurrentIndex:(NSInteger)newIndex
{
    _currentIndex = newIndex;
    
    [self loadPhoto:_currentIndex];
}


-(void)loadPhoto:(NSInteger)index
{
    if (index < 0 || index >= number_of_images)
    {
        return;
    }
    
    NSString *urlImage = ((ListPhotosInAlbum *)[arrayPhoto objectAtIndex:index]).imagePath;
    
    if (![self.pageViews containsObject:urlImage])
    {
        //-- add scrollzoome
        [self addScrollZoomToScrollMainByIndex:index];
        
    }else {
        
        if (scrollPhotoAlbum.subviews.count > 0) {
            
            for (UIView *scrollViewTB in scrollPhotoAlbum.subviews) {
                
                if (scrollViewTB.tag == index) {
                    
                    [scrollViewTB removeFromSuperview];
                    break;
                }
            }
            
            //-- add scrollzoome
            [self addScrollZoomToScrollMainByIndex:index];
        }
    }
}

//-- add object to scrollview
-(void) addScrollZoomToScrollMainByIndex:(NSInteger)index {
    
    NSString *urlImage = ((ListPhotosInAlbum *)[arrayPhoto objectAtIndex:index]).imagePath;
    
    CGRect frameScroll = [scrollPhotoAlbum frame];
    if (isIphone5)
        frameScroll.size.height = 464;
    else
        frameScroll.size.height = 376;
    [scrollPhotoAlbum setFrame:frameScroll];
    
    // Load the photo view.
    CGRect frame = self.scrollPhotoAlbum.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0.0f;
    frame = CGRectInset(frame, 5.0f, 0.0f);
    
    
    _scrollZoom = [[UIScrollView alloc] initWithFrame:frame];
    _scrollZoom.tag = index;
    _scrollZoom.maximumZoomScale = 2.0f;
    _scrollZoom.minimumZoomScale = 0.5f;
    _scrollZoom.showsVerticalScrollIndicator = NO;
    _scrollZoom.showsHorizontalScrollIndicator = NO;
    _scrollZoom.bouncesZoom = YES;
    _scrollZoom.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollZoom.delegate = self;
    [_scrollZoom setZoomScale:0.5 animated:YES];
    
    newPageView = [[UIImageView alloc] init];
    newPageView.frame = frame;
    
    [self callGetImageUrlForCellWithIndex:index withImageView:newPageView];
    
    
    [_scrollZoom addSubview:newPageView];
    
    [self.scrollPhotoAlbum addSubview:_scrollZoom];
    
    [self.pageViews replaceObjectAtIndex:index withObject:urlImage];
}

//-- get image url
-(void) callGetImageUrlForCellWithIndex:(NSInteger)index withImageView:(UIImageView *)pageView
{
    NSString *urlImage = ((ListPhotosInAlbum *)[arrayPhoto objectAtIndex:index]).imagePath;
    
    __weak typeof(pageView) weakSelf = pageView;
    
    NSString *imgBgCell = @"VideoDefault.png";
    if (index %2 == 0) {
        imgBgCell = @"VideoDefault.png";
    }
    
    if (self.radialProgress == nil)
    {
        CGSize defaultSize = (CGSize){50, 50};
        defaultSize = (CGSize){30, 30};
        self.radialProgress = [[JPRadialProgressView alloc] initWithFrame:(CGRect){30, 30, defaultSize}];
        [self.view addSubview:self.radialProgress];
        self.radialProgress.emptyColor = [UIColor colorWithRed:74.0f/256.0f green:74.0f/256.0f blue:74.0f/256.0f alpha:1.0];
        
        CGRect frame = self.view.frame;
        self.radialProgress.frame = CGRectMake(frame.size.width/2 -  self.radialProgress.frame.size.width/2, frame.size.height/2 -  self.radialProgress.frame.size.height/2, self.radialProgress.frame.size.width, self.radialProgress.frame.size.height);
        self.radialProgress.fillColor = [UIColor whiteColor];
        [self.view addSubview:self.radialProgress];
    }
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlImage] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
         self.radialProgress.progress = 0.0f;
         self.radialProgress.hidden = YES;
         
         if(image !=nil)
             weakSelf.image = image;
         else
             weakSelf.image = [UIImage imageNamed:imgBgCell];
         
         
         // Load the photo view.
         CGRect frame = self.scrollPhotoAlbum.frame;
         frame.origin.x = frame.size.width * index;
         frame.origin.y = 0.0f;
         frame = CGRectInset(frame, 5.0f, 0.0f);
         
         [newPageView setContentMode:UIViewContentModeScaleAspectFit];
         [newPageView sizeToFit];
         newPageView.frame = frame;
         
         [self setImage:newPageView.image withIndex:index];
         [self setImageViewCenter];
     }];
}



#pragma mark - set Image view

-(void)setImage:(UIImage *)imageV withIndex:(NSInteger)index
{
    _scrollZoom.zoomScale = 0.5f;
    _scrollZoom.hidden = NO;
    UIImage* image = imageV;
    
    float width =  _scrollZoom.frame.size.width/image.size.width;
    if (image.size.width<self.view.frame.size.width) {
        width = 1;
    }
    
    float height = _scrollZoom.frame.size.height/image.size.height;
    if (image.size.height<self.view.frame.size.height) {
        height = 1;
    }
    
    float f = 0;
    
    if (width < height)
    {
        f = width;
    }
    else
    {
        f = height;
    }
    
    newPageView.frame = CGRectMake(0, 0, image.size.width*f, image.size.height*f);
    
    CGRect frame = _scrollZoom.frame;
    _scrollZoom.contentSize = frame.size;
    newPageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
}


-(void)setImageViewCenter
{
    CGRect frame = _scrollZoom.frame;
    newPageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return newPageView;
    
}



#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollPhotoAlbum.frame.size.width;
    float fractionalPage = scrollPhotoAlbum.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
    
    if (page != _currentIndex && page >= 0) {
        
        //-- load photo
        [self setCurrentIndex:page];
        
        [self loadContentOfPhoto:page];
    }
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [_scrollZoom setZoomScale:scale+0.01 animated:NO];
    [_scrollZoom setZoomScale:scale animated:NO];
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    float width = 0;
    float height = 0;
    
    if (newPageView.frame.size.width < _scrollZoom.frame.size.width)
    {
        width = _scrollZoom.frame.size.width;
        
        if (newPageView.frame.size.height < _scrollZoom.frame.size.height)
        {
            height = _scrollZoom.frame.size.height;
        }
        else
        {
            height = _scrollZoom.contentSize.height;
        }
    }
    else
    {
        width = _scrollZoom.contentSize.width;
        
        if (newPageView.frame.size.height < _scrollZoom.frame.size.height)
        {
            height = _scrollZoom.frame.size.height;
        }
        else
        {
            height = _scrollZoom.contentSize.height;
        }
    }
    
    newPageView.center = CGPointMake(width/2, height/2);
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
//    // double tap zooms in
//    float newScale = [_scrollZoom zoomScale] * 2;

    CGRect zoomRect;
    if(_scrollZoom.zoomScale > _scrollZoom.minimumZoomScale)
        zoomRect = [self zoomRectForScale:_scrollZoom.minimumZoomScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    else
        zoomRect = [self zoomRectForScale:_scrollZoom.maximumZoomScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    
    
    [_scrollZoom zoomToRect:zoomRect animated:NO];

}



#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [_scrollZoom frame].size.height / scale;
    zoomRect.size.width  = [_scrollZoom frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}



#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSString *urlImage = ((ListPhotosInAlbum *)[arrayPhoto objectAtIndex:_currentIndex]).imagePath;
        
        UIImageView *currentImage = [[UIImageView alloc] init];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlImage] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //--save photo into album
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
        
        //-- update number of download limit
        NSUserDefaults *defaultDownload = [NSUserDefaults standardUserDefaults];
        NSInteger numberOfDownloadPrivatePhoto = [[defaultDownload valueForKey:@"NumberOfDownloadPrivatePhoto"] integerValue];
        NSString *numberOfDownloadStr = [NSString stringWithFormat:@"%ld",numberOfDownloadPrivatePhoto+1];
        
        [defaultDownload setValue:numberOfDownloadStr forKey:@"NumberOfDownloadPrivatePhoto"];
        [defaultDownload synchronize];
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	//-- show message when store image did success
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Bạn đã lưu thành công. Vui lòng vào Thư viện ảnh để xem. Cảm ơn!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}



#pragma  mark - base view controller delegate
- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
//    _isProcessLikeAPI = false;
}

- (void)baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    [AppDelegate addLocalLogWithString:@"LG200" info:[Profile debugDescription]];
    if (_isCreateComment)
        [self showDialogComments:CGPointZero title:@"Bình luận"];
    else if (_isLike){
        [self clickToBtnLikePhoto:btnLikePhoto];
    }
}

@end
