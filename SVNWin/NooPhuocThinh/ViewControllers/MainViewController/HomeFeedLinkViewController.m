//
//  HomeFeedLinkViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/27/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeFeedLinkViewController.h"

@interface HomeFeedLinkViewController ()

@end

@implementation HomeFeedLinkViewController
@synthesize titleLink,imageURLLink,urlLink;
@synthesize txtNoComment,txtNoLike,txtNoShare,txtNoView,tempLinkData,indexP,indexValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //--hidden navigation and tabbar
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    //--custom UI
    [self setupUI];
    
    //-- custom webview
    [self customWebView:self.webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupUI
{
    indexValue = [[NSString stringWithFormat:@"%@",indexP] integerValue];
    
    imageURLLink = [[tempLinkData objectAtIndex:indexValue]valueForKey:@"feedImage"];
    [self.imageLink setImageWithURL:[NSURL URLWithString:imageURLLink]];
    [self.btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnLike addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnShare addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
    
    self.NoComment.text = [NSString stringWithFormat:@"%@ Comments",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"snsTotalComment"]];
    self.NoLike.text = [NSString stringWithFormat:@"%@ Likes",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"snsTotalLike"]];
    self.NoShare.text = [NSString stringWithFormat:@"%@ Shares",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"snsTotalShare"]];
    self.NoView.text = [NSString stringWithFormat:@"%@ Views",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"snsTotalView"]];
    self.isLiked = [NSString stringWithFormat:@"%@",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"isLiked"]];
    
    if ([self.isLiked isEqual:@"1"])
    {
        self.btnLike.selected = YES;
    }
    
    urlLink = [[tempLinkData objectAtIndex:indexValue]valueForKey:@"feedLink"];
    [self loadData:urlLink];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer];
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onLike:(id)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId)
    {
        UIButton *aButton = (UIButton *)sender;
        if (aButton.selected)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Bạn đã like thông tin này rồi !"
                                                           delegate:self
                                                  cancelButtonTitle:@"Thoát"
                                                  otherButtonTitles:@"Đồng ý", nil];
            [alert show];
        }
        else
        {
            aButton.selected = YES;
            //-- create JSON
            NSString *jSonData = @"";
            
            ListFeedData *tempData = (ListFeedData *)[tempLinkData objectAtIndex:indexValue];
            NSInteger noLike = [tempData.snsTotalLike integerValue] + 1;
            tempData.snsTotalLike = [NSString stringWithFormat:@"%ld",(long)noLike];
            tempData.isLiked = @"1";
            [self setupUI];
            [VMDataBase updateLikeCommentShare:tempData];
            
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
                                                                             message:@"Bạn đã like thông tin này rồi!"
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

-(void) onComment:(id)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId)
    {
        AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        CommentsNewsViewController *commentsVC = (CommentsNewsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"sbCommentsNewsViewControllerId"];
        
        ListFeedData *news = [tempLinkData objectAtIndex:indexValue];
        commentsVC.nodeId = news.feedId;
        commentsVC.delegateComment = self;
        [dataCenter setIsLinkFeed:YES];
        
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}

-(void)commentSuccessDelegate
{
    ListFeedData *tempData = (ListFeedData *)[tempLinkData objectAtIndex:indexValue];
    NSInteger noComment = [tempData.snsTotalComment integerValue] + 1;
    tempData.snsTotalComment = [NSString stringWithFormat:@"%ld",(long)noComment];
    [self setupUI];
    [VMDataBase updateLikeCommentShare:tempData];
}

-(void) onShare:(id)sender
{
    ListFeedData *tempData = (ListFeedData *)[tempLinkData objectAtIndex:indexValue];
    NSInteger noShare = [tempData.snsTotalShare integerValue] + 1;
    tempData.snsTotalShare = [NSString stringWithFormat:@"%ld",(long)noShare];
    [self setupUI];
    [VMDataBase updateLikeCommentShare:tempData];
    
    NSString *title = @"Title";
    NSString *headline = @"Headline";
    //        NSString *headline = [schedule.name stringByReplacingOccurrencesOfString:@" " withString:@" "];
    NSString *description = [NSString stringWithFormat:@"Tôi muốn chia sẻ %@ trong ứng dụng %@ tại %@",headline, KEY_FB_SINGER_DISPLAY_NAME, URL_APP_STORE];
    
    [self addViewShareInviteWithTitle:title content:description url:URL_APP_STORE imagePath:@"NewDefault.png" contentId:@"" contentTypeId:TYPE_ID_EVENT];
}

#pragma mark - UIWebviewDelegate

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
    //-- finish load
    [self._indicatorWeb stopAnimating];
    self._indicatorWeb.hidden = YES;
    
    self.webView.alpha = 1;
    
    float hw = self.webView.scrollView.contentSize.height;
    
    //-- set webview frame
    self.webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, hw);
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
    
    //-- set scrollview contentsize
    _scrollView.contentSize = CGSizeMake(320, webView.frame.origin.y + hw);
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self._indicatorWeb.hidden = NO;
    [self._indicatorWeb startAnimating];
}

- (void)loadData:(NSString*)urlWeb
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlWeb]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)getListParaKeyOfItem:(NSInteger)typeSync
{
    NSLog(@"%s", __func__);
    NSMutableArray *paraKey = [[NSMutableArray alloc] init];
    
    if (typeSync == kTypeComment)
    {
        [paraKey addObject:@"content_id"];
        [paraKey addObject:@"content_type_id"];
        [paraKey addObject:@"comment_id"];
        [paraKey addObject:@"text"];
        [paraKey addObject:@"time_stamp"];
    }
    else if (typeSync == kTypeFeed)
    {
        [paraKey addObject:@"comment_id"];
        [paraKey addObject:@"item_id"];
        [paraKey addObject:@"content_type_id"];
        [paraKey addObject:@"content"];
        [paraKey addObject:@"parent_user_id"];
        [paraKey addObject:@"owner_user_id"];
        [paraKey addObject:@"time"];
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
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (userId==nil)
        userId=@"";
    else {
        if ([userId isKindOfClass:[NSString class]]) {
            if ([userId length] == 0)
                userId = @"";
        }
        else {
            userId = @"";
        }
    }
    
    if ([contentTypeId isEqualToString:TYPE_ID_NEWS])
    {
        contentTypeId = @"blog";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_PHOTO])
    {
        contentTypeId = @"photo";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_PHOTO_ALBUM])
    {
        contentTypeId = @"photo_album";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_MUSIC_SONG])
    {
        contentTypeId = @"music_song";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_MUSIC_ALBUM])
    {
        contentTypeId = @"music_album";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_EVENT])
    {
        contentTypeId = @"event";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_VIDEO])
    {
        contentTypeId = @"video";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_FEED_PAGE])
    {
        contentTypeId = @"pages_comment";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_FEED_LINK])
    {
        contentTypeId = @"link";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_FEED_PHOTO])
    {
        contentTypeId = @"photo";
    }
    else if ([contentTypeId isEqualToString:TYPE_ID_VIDEO])
    {
        contentTypeId = @"video";
    }
    
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%ld",(long)timeStamp];
    
    if (typeSync == kTypeComment)
    {
        [paraArr addObject:contentId];
        [paraArr addObject:contentTypeId];
        [paraArr addObject:commentId];
        [paraArr addObject:text];
        [paraArr addObject:timeString];
    }
    else if (typeSync == kTypeFeed)
    {
        [paraArr addObject:@""];
        [paraArr addObject:contentId];
        [paraArr addObject:contentTypeId];
        [paraArr addObject:text];
        [paraArr addObject:@"1"];
        [paraArr addObject:userId];
        [paraArr addObject:timeString];
    }
    else
    {
        [paraArr addObject:contentId];
        [paraArr addObject:contentTypeId];
        [paraArr addObject:timeString];
    }
    
    return paraArr;
}

@end
