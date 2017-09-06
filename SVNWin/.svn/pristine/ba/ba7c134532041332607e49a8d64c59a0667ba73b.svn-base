//
//  DetailNewsViewController.m
//  NooPhuocThinh
//
//  Created by HuntDo on 12/5/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "DetailNewsViewController.h"

@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController

@synthesize numberOfNews, pageViews;

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
    [super viewDidLoad];
    
    //anhvt: hidden all old control
//    imgViewAvatar.hidden = YES;
//    lblTitle.hidden = YES;
//    lblDate.hidden = YES;
//    lblShortContent.hidden = YES;
//    lblCountComments.hidden = YES;
//    btnShowComments.hidden = YES;
//    webViewDetailNews.hidden = YES;
//    toolBarDetailNews.hidden = YES;
//    lblNumberOfLike.hidden = YES;
//    btnLikeNews.hidden = YES;
//    viewToolBar.hidden = YES;
    //scrollViewDetailNews.hidden = YES;
    //scrollViewContainer.hidden = YES;
//    viewShare.hidden = YES;
//    viewBarShare.hidden = YES;
//    viewHeader.hidden = YES;
//    btnHiddenViewShare.hidden = YES;
//    viewNewsDetail.hidden = YES;
    
	// Do any additional setup after loading the view.
    
    //--set delegate from BaseVC
    [self setDelegateBaseController:self];
    
    //-- set view when did load
    [self setViewWhenViewDidLoad];
    
    //-- set data when did load
    [self setDataWhenViewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    
    self.screenName = @"Detail News Screen";
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     self.navigationController.navigationItem.hidesBackButton=YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setViewWhenViewDidLoad
{
    //-- set background view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg_detail_news.png"]];
    
    //custom NavigationBar
    [self customNavigationBar];
    
    // custom webview
    [self customWebView:webViewDetailNews];
    
    //-- set up scroll content size
    [self setScrollViewContentSize];
}

// show content for news
- (void)setDataWhenViewDidLoad
{
    _arrWebviews = [[NSMutableArray alloc] init];
    
    //-- clone webview
    _cloneWebViewNewsDetail = [NSKeyedArchiver archivedDataWithRootObject:viewNewsDetail];
    
    [self addMultiWebViewsWithTotalPage:numberOfNews];
    
    //-- scrollTo currentIndex
    [self scrollToIndex:self.indexOfNews];
}


- (void) addMultiWebViewsWithTotalPage:(NSInteger)totalPage
{
    //-- change content size scroll
    scrollViewContainer.contentSize = CGSizeMake(320*totalPage, scrollViewContainer.contentSize.height); //anhvt fix bug
    
    //-- init array contain tableviews
    for (NSInteger i=0; i< totalPage; i++) {
        
        News *newsInfo = [self.arrNews objectAtIndex:i];
        /*
        if (i==0) {
         
            lblTitle.text = newsInfo.title;
            lblShortContent.text = newsInfo.shortBody;
            lblDate.text = [Utility relativeTimeFromDate:[Utility dateFromString:newsInfo.lastUpdate]];
            lblCountComments.text = [NSString stringWithFormat:@"%d",newsInfo.snsTotalComment];
            lblNumberOfLike.text = [NSString stringWithFormat:@"%d",newsInfo.snsTotalLike];
            
            //-- set image for like button
            NSString *isLikedStatus = [NSString stringWithFormat:@"%d",newsInfo.isLiked];
            if ([isLikedStatus isEqualToString:@"0"])
                [btnLikeNews setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
            else
                [btnLikeNews setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
            
            [imgViewAvatar setImageWithURL:[NSURL URLWithString:newsInfo.thumbnailImagePath] placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
            [imgViewAvatar setContentMode:UIViewContentModeScaleAspectFill];
            [imgViewAvatar setClipsToBounds:YES];
            [Utility scaleImage:imgViewAvatar.image toSize:CGSizeMake(101, 101)];
            
//            NSLog(@"newsInfo.body:%@",newsInfo.body);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //-- load html
                [self loadHTMLString:newsInfo.body forWebView:webViewDetailNews];
            });
            
            viewNewsDetail.webViewNewsDetail.delegate = self;
            viewNewsDetail.webViewNewsDetail.scrollView.scrollEnabled = NO;
            viewNewsDetail.webViewNewsDetail.tag = 0;
            
            viewNewsDetail.scrollViewDetailNews.delegate = self;
            
            [_arrWebviews addObject:viewNewsDetail];
            
            //-- add action
            [viewNewsDetail.btnShowComments addTarget:self action:@selector(clickBtnShowComments:) forControlEvents:UIControlEventTouchUpInside];
            
            [viewNewsDetail.btnComment addTarget:self action:@selector(clickBtnCommentForNews:) forControlEvents:UIControlEventTouchUpInside];
            
            [viewNewsDetail.btnShare addTarget:self action:@selector(clickBtnShareNews:) forControlEvents:UIControlEventTouchUpInside];
            
            [viewNewsDetail.btnLikeNews addTarget:self action:@selector(clickBtnLikeNews:) forControlEvents:UIControlEventTouchUpInside];
            viewNewsDetail.isLoaded = YES;
             
        } else {
            */
            //-- alloc new table view
            ViewNewsDetail *newViewMain = [NSKeyedUnarchiver unarchiveObjectWithData:_cloneWebViewNewsDetail];
            
            CGRect newFrame = viewNewsDetail.frame;
            newFrame.origin.x = viewNewsDetail.frame.size.width*i;
            newViewMain.frame = newFrame;
            newViewMain.backgroundColor = [UIColor clearColor];
            
            newViewMain.lblTitle.text = newsInfo.title;
            newViewMain.lblDate.text = [Utility relativeTimeFromDate:[Utility dateFromString:newsInfo.lastUpdate]];
            newViewMain.lblCountComments.text = [NSString stringWithFormat:@"%d",newsInfo.snsTotalComment];
            newViewMain.lblNumberOfLike.text = [NSString stringWithFormat:@"%d",newsInfo.snsTotalLike];
            
            //-- set image for like button
            NSString *isLikedStatus = [NSString stringWithFormat:@"%d",newsInfo.isLiked];
            if ([isLikedStatus isEqualToString:@"0"])
                [newViewMain.btnLikeNews setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
            else
                [newViewMain.btnLikeNews setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
            
            //anhvt add
            if (i == self.indexOfNews) {

                [newViewMain.imgAvatar setImageWithURL:[NSURL URLWithString:newsInfo.thumbnailImagePath] placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                [newViewMain.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
                [newViewMain.imgAvatar setClipsToBounds:YES];
                [Utility scaleImage:newViewMain.imgAvatar.image toSize:CGSizeMake(101, 101)];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //-- load html
                    [self loadHTMLString:newsInfo.body forWebView:newViewMain.webViewNewsDetail];
                });
                newViewMain.isLoaded = YES;
            }
            newViewMain.webViewNewsDetail.delegate = self;
            newViewMain.webViewNewsDetail.scrollView.scrollEnabled = NO;
            newViewMain.webViewNewsDetail.tag = i;
            
            newViewMain.scrollViewDetailNews.delegate = self;
            
            
            //-- add action
            [newViewMain.btnShowComments addTarget:self action:@selector(clickBtnShowComments:) forControlEvents:UIControlEventTouchUpInside];
            
            [newViewMain.btnComment addTarget:self action:@selector(clickBtnCommentForNews:) forControlEvents:UIControlEventTouchUpInside];
            
            [newViewMain.btnShare addTarget:self action:@selector(clickBtnShareNews:) forControlEvents:UIControlEventTouchUpInside];
            
            [newViewMain.btnLikeNews addTarget:self action:@selector(clickBtnLikeNews:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrollViewContainer addSubview:newViewMain];
            [_arrWebviews addObject:newViewMain];
//        }
    }
    viewNewsDetail.hidden = YES;

}


#pragma mark - Scroll

-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = scrollViewContainer.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [scrollViewContainer scrollRectToVisible:frame animated:NO];
}


- (void)setScrollViewContentSize
{
    NSInteger pageCount = numberOfNews;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(scrollViewContainer.frame.size.width * pageCount,
                             scrollViewContainer.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    
    [scrollViewContainer setContentSize:size];
}


#pragma  mark - navigation bar

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


#pragma mark - parse span tags html

- (NSString *)html:(NSString *)bodyHtml currentSize:(NSInteger)currentSize withPaddingSize:(NSInteger)paddingSize
{
    NSString *html = nil;
    
    switch (currentSize) {
            
        case 8:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 8+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 8pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
            
        case 9:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 9+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 9pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
            
        case 10:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 10+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 10pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
            
        case 11:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 11+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 11pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }

           
        case 12:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 12+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 12pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
          
        case 13:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 13+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 13pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
            
        case 14:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 14+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 14pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
            
        case 15:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 15+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 15pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
            
        case 16:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 16+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 16pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
            
        case 17:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 17+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 17pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
            
        case 18:
        {
            NSString *newString = [NSString stringWithFormat:@"<span style=\"font-size: %dpt;\">", 18+paddingSize];
            NSString *newBody =  [bodyHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 18pt;\">" withString:newString];
            
            html = newBody;
            
            break;
        }
            
        default:
            break;
    }
    
    
    if(html)
        return html;
    else
        return bodyHtml;
}


#pragma mark - Webview

-(void) loadHTMLString:(NSString *)body forWebView:(UIWebView *)aWebView
{
    NSLog(@"loadHTMLString:%@",body);
    //anhvt
    
    /*
    while (1) {
        NSRange range = [body rangeOfString:@"<span"];
        if (range.length) {
            NSRange closeRange = [body rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(range.location, [body length] - range.location)];
            if (closeRange.length) {
                NSString *spanString = [body substringWithRange:NSMakeRange(range.location, closeRange.location - range.location + 1)];
                body = [body stringByReplacingOccurrencesOfString:spanString withString:@""];
                body = [body stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            }
        } else {
            break;
        }
    }
     */
    
    NSLog(@"loadHTMLString:%@",body);

    [aWebView stringByEvaluatingJavaScriptFromString:@"document.open();document.close();"];
    
    NSMutableString *string = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"parternStore" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] mutableCopy];

    [string replaceOccurrencesOfString:@"**[txtadjust]**" withString:[NSString stringWithFormat:@"%i",_currentFontSize] options:0 range:NSMakeRange(0, string.length)];
    
    body = [body stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width = '300' height = auto "];
    
    //huntdo: <span huntdo="font-size: 10pt;">
   //NSString *newBody =  [body stringByReplacingOccurrencesOfString:@"<span style" withString:@"<span huntdo"];
     body = [self html:body currentSize:18 withPaddingSize:9];
     body = [self html:body currentSize:17 withPaddingSize:9];
     body = [self html:body currentSize:16 withPaddingSize:9];
     body = [self html:body currentSize:15 withPaddingSize:9];
     body = [self html:body currentSize:14 withPaddingSize:9];
     body = [self html:body currentSize:13 withPaddingSize:9];
     body = [self html:body currentSize:12 withPaddingSize:9];
     body = [self html:body currentSize:11 withPaddingSize:9];
     body = [self html:body currentSize:10 withPaddingSize:9];
     body = [self html:body currentSize:9 withPaddingSize:9];
     body = [self html:body currentSize:8 withPaddingSize:9];
    
     NSString *clearReadDocument = [string stringByReplacingOccurrencesOfString:@"**body**" withString:body options:0 range:NSMakeRange(0, string.length)];
    
    [aWebView loadHTMLString:clearReadDocument baseURL:[NSURL URLWithString:HOST_FOR_CONTENT]];
}


-(void)customWebView:(UIWebView*)aWebView
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FontSize"] == nil)
        _currentFontSize = 160;
    else
        _currentFontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"FontSize"];
        
     aWebView.scrollView.scrollEnabled = NO;
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
    aWebView.scalesPageToFit = YES;
    aWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}


//-- zoom in/out
- (IBAction)fontSizePinch:(id)sender
{
    UIPinchGestureRecognizer *pinch = sender;
    if (pinch.state == UIGestureRecognizerStateRecognized)
    {
        [self changeFontSize:(pinch.scale > 1)?FontSizeChangeTypeIncrease:FontSizeChangeTypeDecrease];
    }
}


- (void)changeFontSize:(FontSizeChangeType)changeType
{
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
    
    if (_currentIndex == 0) {
        
        [webViewDetailNews stringByEvaluatingJavaScriptFromString:jsString];
    }else {
        
        ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
        [viewNews.webViewNewsDetail stringByEvaluatingJavaScriptFromString:jsString];
    }
}



- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    ViewNewsDetail *view = [_arrWebviews objectAtIndex:aWebView.tag];
    
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    //-- resize scrollView's content size
    view.scrollViewDetailNews.contentSize = CGSizeMake(320, view.webViewNewsDetail.frame.origin.y + frame.size.height + 20);
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
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
    News *news = [self.arrNews objectAtIndex:_currentIndex];
    NSString *title = [NSString stringWithFormat:@"%@",news.title];
    NSString *headline = [news.title stringByReplacingOccurrencesOfString:@" " withString:@" "];
    NSString *description = [NSString stringWithFormat:@"Tôi tìm thấy tin %@ trong ứng dụng NooPhuocThinh tại %@",headline, URL_APP_STORE];
    
    [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:news.thumbnailImagePath contentId:news.nodeId contentTypeId:TYPE_ID_NEWS];
}


- (IBAction)hiddenViewShare:(id)sender
{
    btnHiddenViewShare.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        viewShare.hidden = YES;
    }];
}


- (IBAction)shareSMS:(id)sender
{
    //-- hidden view share
    [self hiddenViewShare:nil];
   
    News *news = [self.arrNews objectAtIndex:_currentIndex];
    NSString *msgShareSMS = [NSString stringWithFormat:@"%@",news.title];
    [self sendSMS:msgShareSMS recipientList:nil];
}


- (IBAction)shareEmail:(id)sender
{
    //-- hidden view share
    [self hiddenViewShare:Nil];
    
    News *news = [self.arrNews objectAtIndex:_currentIndex];
    NSString *msgShareEmail = [NSString stringWithFormat:@"%@",news.title];
    [self sendEmail:msgShareEmail recipientList:nil addAttach:nil subject:nil];
}


- (IBAction)shareFacebook:(id)sender
{
    News *news = [self.arrNews objectAtIndex:_currentIndex];
    NSURL *urlNews = [NSURL URLWithString:news.url];
    NSURL *urlPictureOfNews = nil;
    
    FBShareDialogParams *params = [FBShareDialogParams new];
    params.link = urlNews;
    params.picture = urlPictureOfNews;
    params.name = news.title;
    params.caption = news.title;
    params.description = news.title;
    
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
                                       @"1480026525558727",@"app_id",
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
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommentsNewsViewController *commentsVC = (CommentsNewsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"sbCommentsNewsViewControllerId"];
    
    News *newsCurrent = [self.arrNews objectAtIndex:_currentIndex];
    commentsVC.nodeId = newsCurrent.nodeId;
    commentsVC.delegateComment = self;
    [dataCenter setIsNews:YES];
    commentsVC.myArrComments = newsCurrent.arrComments;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:commentsVC animated:YES];
    else
        [self.navigationController pushViewController:commentsVC animated:NO];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([segue.identifier isEqualToString:@"showComments"])
    {
        CommentsNewsViewController *commentsVC = (CommentsNewsViewController *)segue.destinationViewController;
        News *newsCurrent = [self.arrNews objectAtIndex:_currentIndex];
        commentsVC.nodeId = newsCurrent.nodeId;
        commentsVC.delegateComment = self;
        [dataCenter setIsNews:YES];
        commentsVC.myArrComments = newsCurrent.arrComments;
    }
}


- (IBAction)clickBtnCommentForNews:(id)sender
{
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
    NSString *content = [self getContentOfComment];
    if (!content || [content length]==0)
        return;
    
    [super postComment];
    
    Comment *commentForNews = [Comment new];
    commentForNews.commentId = @"0";
    commentForNews.content = content;
    commentForNews.timeStamp = [Utility idFromTimeStamp];
    commentForNews.profileUser = [Profile sharedProfile];
    commentForNews.profileUser.point = [Profile sharedProfile].point;
    commentForNews.numberOfSubcommments = @"0";
    commentForNews.arrSubComments = [NSMutableArray new];
    
    News *newsCurrent = (News *)[self.arrNews objectAtIndex:_currentIndex];
    [newsCurrent.arrComments addObject:commentForNews];
    
    if (_currentIndex == 0) {
        
        lblCountComments.text = [NSString stringWithFormat:@"%d",newsCurrent.snsTotalComment];
    }else {
        ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
        viewNews.lblCountComments.text = [NSString stringWithFormat:@"%d",newsCurrent.snsTotalComment];
    }
    
    [self callAPISyncData:kTypeComment
                     text:content
                contentId:newsCurrent.nodeId
            contentTypeId:TYPE_ID_NEWS
                commentId:@"0"];
}

//-- delegate shoot from CommentsNewsViewController: to update number of comment
- (void)commentSuccessDelegate
{
    News *newsCurrent = (News *)[self.arrNews objectAtIndex:_currentIndex];
    
    //-- set number of comment after added comment
    NSNumber *addNumberComment = [NSNumber numberWithInteger:newsCurrent.snsTotalComment+1];
    
    if (_currentIndex == 0) {
        
        lblCountComments.text = [NSString stringWithFormat:@"%d", [addNumberComment integerValue]];
    }else {
        ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
        viewNews.lblCountComments.text = [NSString stringWithFormat:@"%d", [addNumberComment integerValue]];
    }
    
    newsCurrent.snsTotalComment = [addNumberComment integerValue];
    
    [VMDataBase updateWithNews:newsCurrent];
}


- (void)syncDataSuccessDelegate:(NSDictionary*)response
{
    //-- set id for comment at local
    NSDictionary   *dictData          = [response objectForKey:@"data"];
    NSMutableArray *arrComment        = [dictData objectForKey:@"comment"];
    
    News *newsCurrent = (News *)[self.arrNews objectAtIndex:_currentIndex];
    
    if (_isComment == YES) {
        
        //-- set number of comment after added comment
        NSNumber *addNumberComment = [NSNumber numberWithInteger:newsCurrent.snsTotalComment+1];
        
        if (_currentIndex == 0) {
            
            lblCountComments.text = [NSString stringWithFormat:@"%d", [addNumberComment integerValue]];
        }else {
            ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
            viewNews.lblCountComments.text = [NSString stringWithFormat:@"%d", [addNumberComment integerValue]];
        }
        
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
            
            ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
            
            if (viewNews.btnLikeNews.currentImage == [UIImage imageNamed:@"icon_like_photo.png"]) //-- unlike then -1
            {
                newsCurrent.isLiked = 0;
                
                NSNumber *unlike = [NSNumber numberWithInteger:newsCurrent.snsTotalLike-1];
                if (unlike<0) {
                    unlike = 0;
                }
                
                viewNews.lblNumberOfLike.text = [NSString stringWithFormat:@"%d", [unlike integerValue]];
                
                newsCurrent.snsTotalLike = [unlike integerValue];
            }
            else //-- like then +1
            {
                newsCurrent.isLiked = 1;
                
                NSNumber *like = [NSNumber numberWithInteger:newsCurrent.snsTotalLike+1];
                viewNews.lblNumberOfLike.text = [NSString stringWithFormat:@"%d", [like integerValue]];
                
                newsCurrent.snsTotalLike = [like integerValue];
            }
        }
    }
    
    [VMDataBase updateWithNews:newsCurrent];
}



#pragma mark - Like

- (IBAction)clickBtnLikeNews:(id)sender
{
    _isLike = YES;
    _isComment = NO;
    
    News *news = [self.arrNews objectAtIndex:_currentIndex];
    
    //-- set delegate
    [self setDelegateBaseController:self];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        
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
            
            ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
            
            if (viewNews.btnLikeNews.currentImage == [UIImage imageNamed:@"icon_liked.png"]) //-- unlike then -1
            {
                [viewNews.btnLikeNews setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
                
                [self callAPISyncData:kTypeUnLike text:nil contentId:news.nodeId contentTypeId:TYPE_ID_NEWS commentId:nil];
            }
            else //-- like then +1
            {
                [viewNews.btnLikeNews setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
                
                [self callAPISyncData:kTypeLike text:nil contentId:news.nodeId contentTypeId:TYPE_ID_NEWS commentId:nil];
            }
        }
        
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
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}

- (void) baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    if (_isComment)
        [self showDialogComments:CGPointZero title:@"Bình luận"];
    else if (_isLike) {
        
        if (_currentIndex == 0) {
            
            [self clickBtnLikeNews:btnLikeNews];
        }else {
            
            ViewNewsDetail *viewNews = [_arrWebviews objectAtIndex:_currentIndex];
            [self clickBtnLikeNews:viewNews.btnLikeNews];
        }
    }
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollViewContainer.frame.size.width;
    float fractionalPage = scrollViewContainer.contentOffset.x / pageWidth;
    NSInteger page = ceil(fractionalPage);
    
    if (page != _currentIndex && page >= 0 && page < [_arrWebviews count]) {
        //anhvt
        ViewNewsDetail *newViewMain = [_arrWebviews objectAtIndex:page];
        if (!newViewMain.isLoaded) {
        News *newsInfo = [self.arrNews objectAtIndex:page];
            [newViewMain.imgAvatar setImageWithURL:[NSURL URLWithString:newsInfo.thumbnailImagePath] placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
            [newViewMain.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
            [newViewMain.imgAvatar setClipsToBounds:YES];
            [Utility scaleImage:newViewMain.imgAvatar.image toSize:CGSizeMake(101, 101)];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //-- load html
                [self loadHTMLString:newsInfo.body forWebView:newViewMain.webViewNewsDetail];
            });
            newViewMain.isLoaded = YES;
        }
    }
    
}


- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollViewContainer.frame.size.width;
    float fractionalPage = scrollViewContainer.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
    
    if (page != _currentIndex && page >= 0) {
        
//        if (_currentIndex > 0) {
            //anhvt: xoa data tren trang hien thi truoc do di cho nhe memory
            ViewNewsDetail *newViewMain = [_arrWebviews objectAtIndex:_currentIndex];
            newViewMain.imgAvatar.image = nil;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //-- load html
                [self loadHTMLString:@"" forWebView:newViewMain.webViewNewsDetail];
            });
            newViewMain.isLoaded = NO;
//        }
        _currentIndex = page;
        /*
        //anhvt
        News *newsInfo = [self.arrNews objectAtIndex:_currentIndex];
        ViewNewsDetail *newViewMain = [_arrWebviews objectAtIndex:_currentIndex];
        [newViewMain.imgAvatar setImageWithURL:[NSURL URLWithString:newsInfo.thumbnailImagePath] placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
        [newViewMain.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
        [newViewMain.imgAvatar setClipsToBounds:YES];
        [Utility scaleImage:newViewMain.imgAvatar.image toSize:CGSizeMake(101, 101)];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //-- load html
            [self loadHTMLString:newsInfo.body forWebView:newViewMain.webViewNewsDetail];
        });
        */
        //-- load photo
        //[self setCurrentIndex:page];
    }
}



@end
