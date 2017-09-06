 //
//  DNewsViewController.m
//  NooPhuocThinh
//
//  Created by longnh on 8/30/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "DNewsViewController.h"

@interface DNewsViewController ()

@end

@implementation DNewsViewController
@synthesize pageViewController = _pageViewController;
@synthesize arrNews = _arrNews;

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
    [self customNavigationBar];
    [self customWebView:webViewDetailNews];

    
    //create page view
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    CGRect frame = self.view.bounds;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        frame.origin.y += 64;
        frame.size.height -= 64;
    }
    _pageViewController.view.backgroundColor = [UIColor clearColor];
    _pageViewController.view.frame = frame;
//    _iCurrentPageIndex = _startIndex;
    [self.view addSubview:_pageViewController.view];
//    if ([self respondsToSelector:@selector(addChildViewController:)]) {
        [self addChildViewController:_pageViewController];
//    }
//    _currentIndex = self.indexOfNews;
    _currentTempIndex = self.indexOfNews;
    _cloneWebViewNewsDetail = [NSKeyedArchiver archivedDataWithRootObject:_viewNewsDetail];
    [self refreshView];
    _viewNewsDetail.hidden = YES;
}
-(void)customNavigationBar
{
    [self setTitle:@"Tin tức"];
    
    //-- back button
    UIButton *btnLeft= [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pages
/** this function make news view controller for news index and return
 @author ductc
 */
-(void)refreshView
{
    NSLog(@"%s", __func__);

    UIViewController *vc = [self viewControllerAtIndex:_currentTempIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:vc];

    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
//        [self didChangeCurrentNews];
    }];
    
    [_pageViewController didMoveToParentViewController:self];

}

-(void)loadDataToView:(ViewNewsDetail*)newViewMain newsInfo:(News*)newsInfo index:(NSInteger)index {
    NSLog(@"%s", __func__);
    
    if (!newViewMain) {
        return;
    }
//    newsInfo.viewNewsDetail = newViewMain;
    //    CGRect newFrame = viewNewsDetail.frame;
    //    newFrame.origin.x = viewNewsDetail.frame.size.width * index;
    //    newViewMain.frame = newFrame;
//    newViewMain.backgroundColor = [UIColor clearColor];
    if ([newViewMain respondsToSelector:@selector(backgroundColor)])
         newViewMain.backgroundColor = [UIColor clearColor];
    
    //    newViewMain.lblTitle.text = newsInfo.title;
    //    newViewMain.lblDate.text = [Utility relativeTimeFromDate:[Utility dateFromString:newsInfo.lastUpdate]];
    newViewMain.lblNumberOfComment.text = [NSString stringWithFormat:@"%d",newsInfo.snsTotalComment];
    newViewMain.lblNumberOfLike.text = [NSString stringWithFormat:@"%d",newsInfo.snsTotalLike];
    
    //-- set image for like button
    NSString *isLikedStatus = [NSString stringWithFormat:@"%d",newsInfo.isLiked];
    if ([isLikedStatus isEqualToString:@"0"])
        [newViewMain.btnLikeNews setImage:[UIImage imageNamed:@"btn_like_news.png"] forState:UIControlStateNormal];
    else
        [newViewMain.btnLikeNews setImage:[UIImage imageNamed:@"btn_liked_news.png"] forState:UIControlStateNormal];
    
    //    //longnh add
    //    if (i == self.indexOfNews) {
    
    //    [newViewMain.imgAvatar setImageWithURL:[NSURL URLWithString:newsInfo.thumbnailImagePath] placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
    //    [newViewMain.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    //    [newViewMain.imgAvatar setClipsToBounds:YES];
    //    [Utility scaleImage:newViewMain.imgAvatar.image toSize:CGSizeMake(101, 101)];
    
    
    [self customWebView:newViewMain.webViewNewsDetail];
    
    //    newViewMain.scrollViewDetailNews.contentSize = CGSizeMake(320, 2000);//longnh test
    //    CGRect webFrame = newViewMain.webViewNewsDetail.frame; // = CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    //    webFrame.size.height = 2000;
    //    newViewMain.webViewNewsDetail.frame = webFrame;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //-- load html
        //[self loadHTMLString:newsInfo.body forWebView:newViewMain.webViewNewsDetail];
        NSUserDefaults *defaultNotice = [NSUserDefaults standardUserDefaults];
        [defaultNotice setBool:NO forKey:@"ShowNoticeNooPhuocThinh"];
        [defaultNotice synchronize];
        [self checkAndShowErrorNoticeNetwork];
        [self loadHTMLStringNewsObject:newsInfo.body title:newsInfo.title createdDate:newsInfo.lastUpdate forWebView:newViewMain.webViewNewsDetail];
    });
    newViewMain.isLoaded = YES;
    //    }
    newViewMain.webViewNewsDetail.delegate = self;
    //    newViewMain.webViewNewsDetail.scrollView.scrollEnabled = NO;
    newViewMain.webViewNewsDetail.tag = index;
    
    //    newViewMain.scrollViewDetailNews.delegate = self;
    //    newViewMain.scrollViewDetailNews.scrollEnabled = NO;
    
    //-- add action
    //    [newViewMain.btnShowComments addTarget:self action:@selector(clickBtnShowComments:) forControlEvents:UIControlEventTouchUpInside];
    //    newViewMain.btnShowComments.tag = index;
    [newViewMain.btnComment addTarget:self action:@selector(clickBtnShowComments:) forControlEvents:UIControlEventTouchUpInside];
    newViewMain.btnComment.tag = index;
    [newViewMain.btnShare addTarget:self action:@selector(clickBtnShareNews:) forControlEvents:UIControlEventTouchUpInside];
    newViewMain.btnShare.tag = index;
    [newViewMain.btnLikeNews addTarget:self action:@selector(clickBtnLikeNews:) forControlEvents:UIControlEventTouchUpInside];
    newViewMain.btnLikeNews.tag = index;
    newViewMain.currentIndex = index;
    newViewMain.webViewNewsDetail.tag = index;
    
}
-(UIViewController*)viewControllerAtIndex:(NSInteger)index
{
    NSLog(@"%s:%d", __func__,index);
    UIViewController *viewController = [[UIViewController alloc] init];
//    viewController.delegate = self;
    
    News *newsInfo = [self.arrNews objectAtIndex:index];

    
    ViewNewsDetail *newViewMain = [NSKeyedUnarchiver unarchiveObjectWithData:_cloneWebViewNewsDetail];
//    [self loadDataToView:newViewMain newsInfo:newsInfo index:index];
    viewController.view.tag = index;
    newsInfo.viewNewsDetail = newViewMain;
    [viewController.view addSubview:newViewMain];
//    _currentNewsDetail = newViewMain;
//    _currentIndex = index;
//    NSLog(@"_currentIndex:%d",index);

    NSUserDefaults *defaultNotice = [NSUserDefaults standardUserDefaults];
    [defaultNotice setBool:NO forKey:@"ShowNoticeNooPhuocThinh"];
    [defaultNotice synchronize];
    
    
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) {
        NSLog(@"ERROR: No internet");
    }
    //kiem tra xem co can update lai news ko
    if (isErrorNetWork && [[Setting sharedSetting] isCacheForNodeTimeout:Node_news nodeId:newsInfo.nodeId updateCacheNow:false timeout:[Setting sharedSetting].newRefreshTime*60]) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Updating..."];
        
        [API getNodeDetail:newsInfo.nodeId
             contentTypeId:ContentTypeIDNews
                     appId:PRODUCTION_ID
                appVersion:PRODUCTION_VERSION
                 completed:^(NSDictionary *responseDictionary, NSError *error) {
                     //-- fetching
                     if (error) {
                         NSLog(@"%s ERROR: getNodeDetail: %@ failed: %@", __func__, newsInfo.nodeId, error.description);
                         [[SHKActivityIndicator currentIndicator] hide];
                         NSString *ntitle = [NSString stringWithFormat:@"Lỗi xảy ra khi lấy tin tức: %@. Bạn hãy thử lại.",newsInfo.title];
                         UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:ntitle delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alertview show];
                         
                     }
                     else if (responseDictionary) {
                         [self updateNewsInfo:responseDictionary nodeId:newsInfo.nodeId];
                     }
                 }];
        
        //-- set indicator stop
        //[_activityIndicator stopAnimating];
        //_activityIndicator.hidden = YES;
        
    } else {
        [self loadDataToView:newViewMain newsInfo:newsInfo index:index];

    }

    
    return viewController;
}

-(void)updateNewsInfo:(NSDictionary *)aDictionary nodeId:(NSString *)nodeId
{
    NSLog(@"%s nodeId=%@ return: %@", __func__, nodeId, aDictionary);
  
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *nodeList = [dictData objectForKey:@"node_list"];
    if ([nodeList count]==1)
    {
        
        //xoa news nam trong category hien tai trong DB
        News *aNews                = [[News alloc] init];
        aNews.body                 = [[nodeList objectAtIndex:0] objectForKey:@"body"];
        aNews.createdDate          = [[nodeList objectAtIndex:0] objectForKey:@"created_date"];
        aNews.imageList            = [[nodeList objectAtIndex:0] objectForKey:@"image_list"];
        aNews.isHot                = [[[nodeList objectAtIndex:0] objectForKey:@"is_hot"] integerValue];
        aNews.lastUpdate           = [[nodeList objectAtIndex:0] objectForKey:@"last_update"];
        aNews.nodeId               = [[nodeList objectAtIndex:0] objectForKey:@"node_id"];
        aNews.order                = [[[nodeList objectAtIndex:0] objectForKey:@"order"] integerValue];
        aNews.settingTotalView     = [[[nodeList objectAtIndex:0] objectForKey:@"setting_total_view"] integerValue];
        aNews.shortBody            = [[nodeList objectAtIndex:0] objectForKey:@"short_body"];
        aNews.thumbnailImagePath   = [[nodeList objectAtIndex:0] objectForKey:@"thumbnail_image_path"];
        aNews.thumbnailImageType   = [[nodeList objectAtIndex:0] objectForKey:@"thumbnail_image_type"];
        aNews.title                = [[nodeList objectAtIndex:0] objectForKey:@"title"];
        aNews.trueTotalView        = [[[nodeList objectAtIndex:0] objectForKey:@"true_total_view"] integerValue];
        aNews.snsTotalComment      = [[[nodeList objectAtIndex:0] objectForKey:@"sns_total_comment"] integerValue];
        aNews.snsTotalDislike      = [[[nodeList objectAtIndex:0] objectForKey:@"sns_total_dislike"] integerValue];
        aNews.snsTotalLike         = [[[nodeList objectAtIndex:0] objectForKey:@"sns_total_like"] integerValue];
        aNews.snsTotalShare        = [[[nodeList objectAtIndex:0] objectForKey:@"sns_total_share"] integerValue];
        aNews.snsTotalView         = [[[nodeList objectAtIndex:0] objectForKey:@"sns_total_view"] integerValue];
        aNews.isLiked              = [[[nodeList objectAtIndex:0] objectForKey:@"is_liked"] integerValue];
        
        //-- properties additional
        [VMDataBase updateWithNews:aNews];
            
            //-- get data
            //lay dc ok thi update flag cache timeout
        [[Setting sharedSetting] isCacheForNodeTimeout:Node_news nodeId:aNews.nodeId updateCacheNow:true timeout:[Setting sharedSetting].newRefreshTime*60];
        News *newsInfo;
//        NSLog(@"new node id:%@",aNews.nodeId);
        for (int i = 0; i < [self.arrNews count]; i++) {
            newsInfo = [self.arrNews objectAtIndex:i];
//            NSLog(@"i:%d node id:%@",i,newsInfo.nodeId);
            if ([newsInfo.nodeId isEqualToString:aNews.nodeId]) {
                [self.arrNews setObject:aNews atIndexedSubscript:i];
                if (newsInfo.viewNewsDetail) {
                    aNews.viewNewsDetail = newsInfo.viewNewsDetail;
                    [self loadDataToView:aNews.viewNewsDetail newsInfo:aNews index:i];
                }
                break;
            }
        }
            //load lai new la current index
    }
    [[SHKActivityIndicator currentIndicator] hide];

    //-- stop indicator
    //[_activityIndicator stopAnimating];
    //_activityIndicator.hidden = YES;
}


-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"%s", __func__);
    NSInteger cIndex = viewController.view.tag;
    if (cIndex < [_arrNews count] - 1) {
        //longnh: them doan duoi de fix bug truy cap den viewNewsDetail khi da bi release
        for (int i = 0; i < [self.arrNews count]; i++) {
            News *newsInfo = [self.arrNews objectAtIndex:i];
            if ((i == cIndex) || (i == cIndex-1) || (i == cIndex+1)) {
                break;
            }
            newsInfo.viewNewsDetail = nil;
        }

        
        cIndex++;
        return [self viewControllerAtIndex:cIndex];
    }
    return nil;
}
-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"%s", __func__);
    NSInteger cIndex = viewController.view.tag;
    if (cIndex > 0) {
        
        //longnh: them doan duoi de fix bug truy cap den viewNewsDetail khi da bi release
        for (int i = 0; i < [self.arrNews count]; i++) {
            News *newsInfo = [self.arrNews objectAtIndex:i];
            if ((i == cIndex) || (i == cIndex-1) || (i == cIndex+1)) {
                break;
            }
            newsInfo.viewNewsDetail = nil;
        }

        
        cIndex--;
        return [self viewControllerAtIndex:cIndex];
    }
    return nil;
    
}
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSLog(@"%s completed:%d", __func__,completed);
    if (completed) {
        
    }
//    for (int i = 0; i < [previousViewControllers count]; i++) {
//        UIViewController *vController = [previousViewControllers objectAtIndex:i];
//        NSLog(@"index:%d tag:%d",i,vController.view.tag);
//    }
//    [self didChangeCurrentNews];
}

/** This function update current news
 */
//-(void)didChangeCurrentNews
//{
//    SCNewsViewController *current = [self getCurrentNewsView];
//    NSNumber *newsId = [current.newsDetail objectForKey:k_news_id];
//    BOOL isSave = [DBAccess isSavedNews:newsId];
//    [_btSave setSelected:isSave];
//    
//    //indicator
//    if (_listNews.count <1) {
//        [_indicatorView setPercent:0];
//    }else{
//        [_indicatorView setPercent:(float)current.currentPageIndex/(_listNews.count-1)];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Webview

-(void) loadHTMLStringNewsObject:(NSString *)body title:(NSString *)title createdDate:(NSString *)createdDate forWebView:(UIWebView *)aWebView
{
    NSLog(@"%s", __func__);
    
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.open();document.close();"];
    
    NSMutableString *string = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"parternStore" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] mutableCopy];
    
    //NSString *body = [newsInfo.body stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width = '100%' height = auto "];
    
    
    NSString *clearReadDocument = [string stringByReplacingOccurrencesOfString:@"{{ news_body }}" withString:body];
    clearReadDocument = [clearReadDocument stringByReplacingOccurrencesOfString:@"{{ news_title }}" withString:title];
    clearReadDocument = [clearReadDocument stringByReplacingOccurrencesOfString:@"{{ news_date }}" withString:[Utility relativeTimeFromDate:[Utility dateFromString:createdDate]]];

    [aWebView loadHTMLString:clearReadDocument baseURL:[NSURL URLWithString:HOST_FOR_CONTENT]];
}

-(void) loadHTMLString:(NSString *)body forWebView:(UIWebView *)aWebView
{
    NSLog(@"%s", __func__);
 
    
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.open();document.close();"];
    
    NSMutableString *string = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"parternStore" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] mutableCopy];
    
    [string replaceOccurrencesOfString:@"**[txtadjust]**" withString:[NSString stringWithFormat:@"%i",_currentFontSize] options:0 range:NSMakeRange(0, string.length)];
    
    body = [body stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width = '300px' height = auto "];
    
    NSString *clearReadDocument = [string stringByReplacingOccurrencesOfString:@"**body**" withString:body options:0 range:NSMakeRange(0, string.length)];
    
    [aWebView loadHTMLString:clearReadDocument baseURL:[NSURL URLWithString:HOST_FOR_CONTENT]];
}


-(void)customWebView:(UIWebView*)aWebView
{
    NSLog(@"%s", __func__);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FontSize"] == nil)
        _currentFontSize = 160;
    else
        _currentFontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"FontSize"];
    
//    aWebView.scrollView.scrollEnabled = NO;
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
//    aWebView.scalesPageToFit = YES;
//    aWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

/*
//-- zoom in/out
- (IBAction)fontSizePinch:(id)sender
{
    NSLog(@"%s", __func__);
    UIPinchGestureRecognizer *pinch = sender;
    if (pinch.state == UIGestureRecognizerStateRecognized)
    {
        [self changeFontSize:(pinch.scale > 1)?FontSizeChangeTypeIncrease:FontSizeChangeTypeDecrease];
    }
}


- (void)changeFontSize:(FontSizeChangeType)changeType
{
    NSLog(@"%s", __func__);
    if (changeType == FontSizeChangeTypeIncrease && _currentFontSize == 160) return;
    if (changeType == FontSizeChangeTypeDecrease && _currentFontSize == 50) return;
    if (changeType != FontSizeChangeTypeNone)
    {
        _currentFontSize = (changeType == FontSizeChangeTypeIncrease) ? _currentFontSize + 5 : _currentFontSize - 5;
        [[NSUserDefaults standardUserDefaults] setInteger:_currentFontSize forKey:@"ftsz"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                          _currentFontSize];
    
//    if (_currentIndex == 0) {
//        
//        [webViewDetailNews stringByEvaluatingJavaScriptFromString:jsString];
//    }else {
    
//        ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
        [_currentNewsDetail.webViewNewsDetail stringByEvaluatingJavaScriptFromString:jsString];
//    }
}
*/


- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    NSLog(@"%s index:%d", __func__,aWebView.tag);
//    ViewNewsDetail *view = [_arrWebviews objectAtIndex:aWebView.tag];
    /*
    News *news = [self.arrNews objectAtIndex:aWebView.tag];

    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    NSLog(@"frame size w:%f h:%f",frame.size.width,frame.size.height);
    //-- resize scrollView's content size
    
    news.viewNewsDetail.scrollViewDetailNews.contentSize = CGSizeMake(320, news.viewNewsDetail.webViewNewsDetail.frame.origin.y + frame.size.height + 20);
     */
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s", __func__);
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
    
    //-- set YES ==> open webbr
    return YES;
}


#pragma mark - share

- (IBAction)clickBtnShareNews:(id)sender
{
    NSLog(@"%s", __func__);
    UIButton *button = (UIButton*)sender;
    News *news = [self.arrNews objectAtIndex:button.tag];
    _currentTempIndex = button.tag;
    
    NSString *title = [NSString stringWithFormat:@"%@",news.title];
    NSString *headline = [news.title stringByReplacingOccurrencesOfString:@" " withString:@" "];
    NSString *description = [NSString stringWithFormat:@"Tôi tìm thấy tin %@ trong ứng dụng %@ tại %@",headline, KEY_FB_SINGER_DISPLAY_NAME, URL_APP_STORE];
    
    [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:news.thumbnailImagePath contentId:news.nodeId contentTypeId:TYPE_ID_NEWS];
}


- (IBAction)hiddenViewShare:(id)sender
{
    NSLog(@"%s", __func__);
    btnHiddenViewShare.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        viewShare.hidden = YES;
    }];
}


- (IBAction)shareSMS:(id)sender
{
    NSLog(@"%s", __func__);
    //-- hidden view share
    [self hiddenViewShare:nil];
    
//    UIButton *button = (UIButton*)sender;
    News *news = [self.arrNews objectAtIndex:_currentTempIndex];
    NSString *msgShareSMS = [NSString stringWithFormat:@"%@",news.title];
    [self sendSMS:msgShareSMS recipientList:nil];
}


- (IBAction)shareEmail:(id)sender
{
    NSLog(@"%s", __func__);
    //-- hidden view share
    [self hiddenViewShare:Nil];
    
//    UIButton *button = (UIButton*)sender;
    News *news = [self.arrNews objectAtIndex:_currentTempIndex];
    NSString *msgShareEmail = [NSString stringWithFormat:@"%@",news.title];
    [self sendEmail:msgShareEmail recipientList:nil addAttach:nil subject:nil];
}


- (IBAction)shareFacebook:(id)sender
{
    NSLog(@"%s", __func__);
//    UIButton *button = (UIButton*)sender;
    News *news = [self.arrNews objectAtIndex:_currentTempIndex];
    NSURL *urlNews = [NSURL URLWithString:news.url];
    NSURL *urlPictureOfNews = nil;
    
    FBShareDialogParams *params = [FBShareDialogParams new];
    params.link = urlNews;
    params.picture = urlPictureOfNews;
    params.name = news.title;
    params.caption = news.title;
//    params.description = news.title;
    
    if ([FBDialogs canPresentShareDialogWithParams:params])
    {
        [FBDialogs presentShareDialogWithParams:params
                                    clientState:nil
                                        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                            if (error)
                                            {
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lỗi" message:[NSString stringWithFormat:@"Không thể chia sẻ facebook. Do \"%@\"",[error localizedDescription] ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [alert show];
                                            }
                                            
                                            // call Facebook 's iOS 6 integration
                                            if (call == nil)
                                            {
                                                [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                                         initialText:news.title
                                                                                               image:[UIImage imageWithData:[NSData dataWithContentsOfURL:urlPictureOfNews]]
                                                                                                 url:urlNews
                                                                                             handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                                                                                                 
                                                                                                 if (result == FBOSIntegratedShareDialogResultError) {
                                                                                                     if (error!=nil) {
                                                                                                         NSLog(@"[Facebook 's iOS 6 integration] the dialog could not be shown - %@", [error localizedDescription]);
                                                                                                     }
                                                                                                 }
                                                                                                 else if (result ==FBOSIntegratedShareDialogResultCancelled)
                                                                                                 {
                                                                                                     NSLog(@"[Facebook 's iOS 6 integration] dialog action was cancelled");
                                                                                                 }
                                                                                                 else
                                                                                                 {
                                                                                                     NSLog(@"the dialog action completed successfully");
                                                                                                     
                                                                                                 }
                                                                                                 
                                                                                                 
                                                                                             }];
                                                
                                                
                                            }
                                            
                                            
                                        }];
        
        
    }
    else
    {
        
        //        NSDictionary* params = @{@"name": dataCenter.newsTitle,
        //                                 @"caption":dataCenter.newsDateCreated,
        //                                 @"description": dataCenter.newsShortContent,
        //                                 @"link": dataCenter.urlNews,
        //                                 @"image": dataCenter.newsImagePath};
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       KEY_FB_APP_ID, @"app_id",
                                       news.title, @"name",
                                       news.title, @"caption",
                                       news.title,@"description",
                                       urlNews, @"link",
                                       urlPictureOfNews,@"picture",
                                       nil];
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      // handle response or error
                                                      
                                                      if (error)
                                                      {
                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lỗi" message:[NSString stringWithFormat:@"Lỗi do: %@", [error localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                          [alert show];
                                                      }
                                                      else
                                                      {
                                                          if (result==FBWebDialogResultDialogNotCompleted)
                                                          {
                                                              //   NSLog(@"User canceled story publishing");
                                                          }
                                                          else
                                                          {
                                                              // Handle the puslish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              if (![urlParams valueForKey:@"post_id"])
                                                              {
                                                                  // User clicked the Cancel button
                                                                  //NSLog(@"User canceled story publishing.");
                                                              }
                                                              else
                                                              {
                                                                  // User clicked the Share button
                                                                  NSString *msg = [NSString stringWithFormat:
                                                                                   @"Posted story, id: %@",
                                                                                   [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"%@", msg);
                                                                  
                                                              }
                                                          }
                                                          
                                                          
                                                      }
                                                      
                                                  }];
        
        
    }
    
}


/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}



#pragma mark - UIMessage

//result send Message
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


//result send Email
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
}


//title & content of SMS
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    NSLog(@"%s", __func__);
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


//title & content of Email
- (void)sendEmail:(NSString *)bodyOfEmail recipientList:(NSArray *)recipients addAttach:(NSData *)imgAttach subject:(NSString *)subTitle
{
    NSLog(@"%s", __func__);
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mailer.mailComposeDelegate = self;
        [mailer setMessageBody:bodyOfEmail isHTML:NO];
        [mailer setToRecipients:recipients];
        [mailer setSubject:subTitle];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        {
            [self presentModalViewController:mailer animated:YES];
        }
        else
        {
            [self presentViewController:mailer animated:YES completion:Nil];
        }
    }
}



#pragma mark - comments

- (IBAction)clickBtnShowComments:(id)sender
{
    NSLog(@"%s", __func__);
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommentsNewsViewController *commentsVC = (CommentsNewsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"sbCommentsNewsViewControllerId"];
    
    UIButton *button = (UIButton*)sender;
    News *news = [self.arrNews objectAtIndex:button.tag];
    _currentTempIndex = button.tag;
    commentsVC.nodeId = news.nodeId;
    commentsVC.delegateComment = self;
    [dataCenter setIsNews:YES];
    commentsVC.myArrComments = news.arrComments;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:commentsVC animated:YES];
    else
        [self.navigationController pushViewController:commentsVC animated:NO];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __func__);
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([segue.identifier isEqualToString:@"showComments"])
    {
        CommentsNewsViewController *commentsVC = (CommentsNewsViewController *)segue.destinationViewController;
//        UIButton *button = (UIButton*)sender;
        News *news = [self.arrNews objectAtIndex:_currentTempIndex];
        commentsVC.nodeId = news.nodeId;
        commentsVC.delegateComment = self;
        [dataCenter setIsNews:YES];
        commentsVC.myArrComments = news.arrComments;
    }
}


- (IBAction)clickBtnCommentForNews:(id)sender
{
    NSLog(@"%s", __func__);
    
    UIButton *button = (UIButton*)sender;
//    News *news = [self.arrNews objectAtIndex:button.tag];
    _currentTempIndex = button.tag;

    
    _isLike = NO;
    _isComment = YES;
    
    //-- set delegate
    [self setDelegateBaseController:self];
    
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
-(void)cancelComment
{
    [super cancelComment];
}


//-- override
-(void)postComment
{
    NSLog(@"%s", __func__);
    NSString *content = [self getContentOfComment];
    if (!content || [content length]==0)
        return;
    
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Updating..."];

    [super postComment];
    
    Comment *commentForNews = [Comment new];
    commentForNews.commentId = @"0";
    commentForNews.content = content;
    commentForNews.timeStamp = [Utility idFromTimeStamp];
    commentForNews.profileUser = [Profile sharedProfile];
    commentForNews.profileUser.point = [Profile sharedProfile].point;
    commentForNews.numberOfSubcommments = @"0";
    commentForNews.arrSubComments = [NSMutableArray new];
    
    News *newsCurrent = (News *)[self.arrNews objectAtIndex:_currentTempIndex];
    [newsCurrent.arrComments addObject:commentForNews];
    /*
    if (_currentIndex == 0) {
        
        lblCountComments.text = [NSString stringWithFormat:@"%d",newsCurrent.snsTotalComment];
    }else {
     */
//        ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
        newsCurrent.viewNewsDetail.lblNumberOfComment.text = [NSString stringWithFormat:@"%d",newsCurrent.snsTotalComment];
//    }
    
    [self callAPISyncData:kTypeComment
                     text:content
                contentId:newsCurrent.nodeId
            contentTypeId:TYPE_ID_NEWS
                commentId:@"0"];
}

//-- delegate shoot from CommentsNewsViewController: to update number of comment
- (void)commentSuccessDelegate
{
    News *newsCurrent = (News *)[self.arrNews objectAtIndex:_currentTempIndex];
    
    //-- set number of comment after added comment
    NSNumber *addNumberComment = [NSNumber numberWithInteger:newsCurrent.snsTotalComment+1];
    /*
    if (_currentIndex == 0) {
        
        lblCountComments.text = [NSString stringWithFormat:@"%d", [addNumberComment integerValue]];
    }else {
     */
//        ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
        newsCurrent.viewNewsDetail.lblNumberOfComment.text = [NSString stringWithFormat:@"%d", [addNumberComment integerValue]];
//    }
    
    newsCurrent.snsTotalComment = [addNumberComment integerValue];
    
    [VMDataBase updateWithNews:newsCurrent];
    [[SHKActivityIndicator currentIndicator] hide];
}


- (void)syncDataSuccessDelegate:(NSDictionary*)response
{
    NSLog(@"%s", __func__);
    //-- set id for comment at local
    NSDictionary   *dictData          = [response objectForKey:@"data"];
    NSMutableArray *arrComment        = [dictData objectForKey:@"comment"];
    
    News *newsCurrent = (News *)[self.arrNews objectAtIndex:_currentTempIndex];
    
    if (_isComment == YES) {
        
        //-- set number of comment after added comment
        NSNumber *addNumberComment = [NSNumber numberWithInteger:newsCurrent.snsTotalComment+1];
        
//        if (_currentIndex == 0) {
//            
//            lblCountComments.text = [NSString stringWithFormat:@"%d", [addNumberComment integerValue]];
//        }else {
//            ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
            newsCurrent.viewNewsDetail.lblNumberOfComment.text = [NSString stringWithFormat:@"%d", [addNumberComment integerValue]];
//        }
        
        newsCurrent.snsTotalComment = [addNumberComment integerValue];
        
        if ([arrComment count] > 0)
        {
            NSDictionary *dictComment         = [arrComment objectAtIndex:0];
            NSString     *commentId           = [dictComment objectForKey:@"comment_id"];
            Comment      *recentComment       = [self.arrCommentData lastObject];
            if ([recentComment.commentId isEqualToString:@"0"])
                recentComment.commentId = commentId;
        }
        _isComment = NO;
    }
    
    else if (_isLike == YES) {
        /*
        if (_currentIndex == 0) {
            
            if (btnLikeNews.currentImage == [UIImage imageNamed:@"icon_like_photo.png"]) //-- unlike then -1
            {
                newsCurrent.isLiked = 0;
                
                NSNumber *unlike = [NSNumber numberWithInteger:newsCurrent.snsTotalLike-1];
                if (unlike<0) {
                    unlike = 0;
                }
                
                lblNumberOfLike.text = [NSString stringWithFormat:@"%d", [unlike integerValue]];
                
                newsCurrent.snsTotalLike = [unlike integerValue];
            }
            else //-- like then +1
            {
                newsCurrent.isLiked = 1;
                
                NSNumber *like = [NSNumber numberWithInteger:newsCurrent.snsTotalLike+1];
                lblNumberOfLike.text = [NSString stringWithFormat:@"%d", [like integerValue]];
                
                newsCurrent.snsTotalLike = [like integerValue];
            }
            
        }else {
        */
//            ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
            
            if (newsCurrent.viewNewsDetail.btnLikeNews.currentImage == [UIImage imageNamed:@"btn_like_news.png"]) //-- unlike then -1
            {
                newsCurrent.isLiked = 0;
                
                NSNumber *unlike = [NSNumber numberWithInteger:newsCurrent.snsTotalLike-1];
                if (unlike<0) {
                    unlike = 0;
                }
                
                newsCurrent.viewNewsDetail.lblNumberOfLike.text = [NSString stringWithFormat:@"%d", [unlike integerValue]];
                
                newsCurrent.snsTotalLike = [unlike integerValue];
            }
            else //-- like then +1
            {
                newsCurrent.isLiked = 1;
                
                NSNumber *like = [NSNumber numberWithInteger:newsCurrent.snsTotalLike+1];
                newsCurrent.viewNewsDetail.lblNumberOfLike.text = [NSString stringWithFormat:@"%d", [like integerValue]];
                
                newsCurrent.snsTotalLike = [like integerValue];
            }
//        }
    }
    
    [VMDataBase updateWithNews:newsCurrent];
    [[SHKActivityIndicator currentIndicator] hide];

}



#pragma mark - Like

- (IBAction)clickBtnLikeNews:(id)sender
{
    NSLog(@"%s", __func__);
    
    UIButton *button = (UIButton*)sender;
    News *news = [self.arrNews objectAtIndex:button.tag];
    _currentTempIndex = button.tag;

    
    _isLike = YES;
    _isComment = NO;
    
//    News *news = [self.arrNews objectAtIndex:_currentIndex];
    
    //-- set delegate
    [self setDelegateBaseController:self];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Updating..."];

        /*
        if (_currentIndex == 0) {
            
            if (btnLikeNews.currentImage == [UIImage imageNamed:@"icon_liked.png"]) //-- unlike then -1
            {
                [btnLikeNews setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
                
                [self callAPISyncData:kTypeUnLike text:nil contentId:news.nodeId contentTypeId:TYPE_ID_NEWS commentId:nil];
            }
            else //-- like then +1
            {
                [btnLikeNews setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
                
                [self callAPISyncData:kTypeLike text:nil contentId:news.nodeId contentTypeId:TYPE_ID_NEWS commentId:nil];
            }
            
        }else {
          */
//            ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
            
            if (button.currentImage == [UIImage imageNamed:@"btn_liked_news.png"]) //-- unlike then -1
            {
                [button setImage:[UIImage imageNamed:@"btn_like_news.png"] forState:UIControlStateNormal];
                
                [self callAPISyncData:kTypeUnLike text:nil contentId:news.nodeId contentTypeId:TYPE_ID_NEWS commentId:nil];
            }
            else //-- like then +1
            {
                [button setImage:[UIImage imageNamed:@"btn_liked_news.png"] forState:UIControlStateNormal];
                
                [self callAPISyncData:kTypeLike text:nil contentId:news.nodeId contentTypeId:TYPE_ID_NEWS commentId:nil];
            }
//        }
        
        [VMDataBase updateWithNews:news];
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}



#pragma mark - actions other

-(void)back:(id) sender
{
    NSLog(@"%s", __func__);
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}

- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
    //_isProcessLikeAPI = false;
}

- (void) baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    [AppDelegate addLocalLogWithString:@"LG200" info:[Profile debugDescription]];

    if (_isComment)
        [self showDialogComments:CGPointZero title:@"Bình luận"];
    else if (_isLike) {
        
//        if (_currentIndex == 0) {
//            
//            [self clickBtnLikeNews:btnLikeNews];
//        }else {
        
        News *news = [self.arrNews objectAtIndex:_currentTempIndex];
        [self clickBtnLikeNews:news.viewNewsDetail.btnLikeNews];
//        }
    }
    
}


@end
