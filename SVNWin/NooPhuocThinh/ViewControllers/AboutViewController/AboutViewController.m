//
//  AboutViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize imgCover, wvInfo, arrayData;

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
    _isProcessSyncAPI = false;
    
    //-- init datasource
    _dataSourceSinger = [[NSDictionary alloc] init];
    arrayData = [[NSMutableArray alloc] init];
    
    //--custom UI
    [self customNavigationBar];
    
    //-- fetchingMusicAlbum
    [self fetchingSingerDetailInfo];
    
    //-- custom webview
    [self customWebView:self.wvInfo];
    
    //-- begin load
    self.wvInfo.alpha = 0;
}

-(void) viewWillAppear:(BOOL)animated {
    
    self.screenName = @"About Screen";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Custom UI
- (void) redrawRightNavigartionBar:(bool) isLike totalLike:(int) totalLike
{
    //-- like button
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 20, 30);
    if (isLike)
        [btnRight setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
    else
        [btnRight setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(likeFanpage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    UILabel *numberLikers = [[UILabel alloc] initWithFrame:
                             CGRectMake(0,2,30,30)];
    numberLikers.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (totalLike<0)
        numberLikers.text = @"";
    else
        numberLikers.text = [NSString stringWithFormat:@"%d", totalLike];
    numberLikers.backgroundColor = [UIColor clearColor];
    numberLikers.font = [UIFont boldSystemFontOfSize:14];
    [numberLikers setTextColor:[UIColor whiteColor]];
    numberLikers.textAlignment = UITextAlignmentLeft;
    UIBarButtonItem *numberLikerBtn = [[UIBarButtonItem alloc] initWithCustomView:numberLikers];
    
//    numberLikers.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tapGesture =
//    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendLocalLog)];
//    [numberLikers addGestureRecognizer:tapGesture];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:numberLikerBtn,barItemRight, nil];
    
}


-(void) customNavigationBar
{
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self setTitle:@"Giới thiệu"];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem = barItemLeft;
    
    [self redrawRightNavigartionBar:false totalLike:-1];
    
}



#pragma mark - Call API

- (void)fetchingSingerDetailInfo
{
    //-- get txt from file
    NSError* error = nil;
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
    NSString *file = [NSString stringWithFormat:@"about_%@", [prodName lowercaseString]];
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType: @"txt"];
    _lblDefault = [NSString stringWithContentsOfFile: path encoding:NSUTF8StringEncoding error: &error];
    if (_lblDefault==nil)
        _lblDefault = @"";
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork)
    {
        [self loadData:_lblDefault imagePath:nil];
        //load tu cache
        [self showInfoFromCache];
        return;
    }
    [self showInfoFromCache];
    //xem co update khong
    if ([self isCacheSingerInfoTimeout:false]) {
    //-- set indicator
        [_activityIndicator startAnimating];
        _activityIndicator.hidden = NO;
    
        [API getNodeDetail:SINGER_ID
             contentTypeId:ContentTypeIDSinger
                     appId:PRODUCTION_ID
                appVersion:PRODUCTION_VERSION
                 completed:^(NSDictionary *responseDictionary, NSError *error) {
                 
                 //-- fetching
                 if (responseDictionary && !error) {
                     [self createDataSourceSingerInfo:responseDictionary fromCache:false];
                 }
        }];
    }
    else
        NSLog(@"Lay thong tin trong cache");
}

-(void)showInfoFromCache
{
    NSUserDefaults *defaultStorage = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictData = [defaultStorage valueForKey:ABOUT_INFO];
    [self createDataSourceSingerInfo:dictData fromCache:true];

}

/*
 Kiem tra cache xem 1 page trong 1 category co thoi gian timeout het chua
 */
- (bool) isCacheSingerInfoTimeout:(BOOL)updateCacheNow
{
    //-- check time
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger prvTime = [[Setting sharedSetting] milestonesSingerInfoRefreshTime];
    NSInteger compeTime = currentDate - prvTime;
    NSLog(@"%s timeout=%f crr=%d, prv=%d", __func__, [Setting sharedSetting].singerInfoRefreshTime*60, currentDate, prvTime);
    
    if (([[Setting sharedSetting] milestonesSingerInfoRefreshTime] != 0) && (compeTime < [Setting sharedSetting].singerInfoRefreshTime*60)) {
        return false;
    }
    if (updateCacheNow)
        [[Setting sharedSetting] setMilestonesSingerInfoRefreshTime:currentDate];
    
    return true;
}

-(void)createDataSourceSingerInfo:(NSDictionary *)aDictionary fromCache:(bool) fromCache
{
    NSDictionary *dictData;
    if (aDictionary)
        dictData = [aDictionary objectForKey:@"data"];
    NSArray *arrData;
    if (dictData)
        arrData = [dictData objectForKey:@"node_list"];
    
    if (arrData && arrData.count > 0) {
        _dataSourceSinger = [arrData objectAtIndex:0];;
        //NSLog(@"%@", _dataSourceSinger.description);
        if ([_dataSourceSinger count] > 0)
        {
            SingerInfo *info = [[SingerInfo alloc] init];
            
            info.nodeId             = [_dataSourceSinger objectForKey:@"node_id"];
            info.countryId          = [_dataSourceSinger objectForKey:@"country_id"];
            info.countryName        = [_dataSourceSinger objectForKey:@"country_name"];
            info.name               = [_dataSourceSinger objectForKey:@"name"];
            info.trueName           = [_dataSourceSinger objectForKey:@"true_name"];
            info.nickName           = [_dataSourceSinger objectForKey:@"nick_name"];
            info.birthday           = [_dataSourceSinger objectForKey:@"birth_day"];
            info.facebookUrlLink    = [_dataSourceSinger objectForKey:@"facebook_url"];
            info.snsUrl             = [_dataSourceSinger objectForKey:@"sns_url"];
            info.description        = [_dataSourceSinger objectForKey:@"description"];
            info.smallAvatarImagePath = [_dataSourceSinger objectForKey:@"small_avatar_image_path"];
            info.avatarImagePath    = [_dataSourceSinger objectForKey:@"avatar_image_path"];
            info.bannerImagePath    = [_dataSourceSinger objectForKey:@"banner_image_path"];
            info.type               = [_dataSourceSinger objectForKey:@"type"];
            info.orderSinger        = [_dataSourceSinger objectForKey:@"order"];
            info.singerLevelId      = [_dataSourceSinger objectForKey:@"singer_level_id"];
            info.singerLevelName    = [_dataSourceSinger objectForKey:@"singer_level_name"];
            info.theloai            = [_dataSourceSinger objectForKey:@"the_loai"];
            info.isLiked            = [_dataSourceSinger objectForKey:@"is_liked"];
            info.snsTotalComment    = [_dataSourceSinger objectForKey:@"sns_total_comment"];
            info.snsTotalDisLike    = [_dataSourceSinger objectForKey:@"sns_total_dislike"];
            info.snsTotalLike       = [_dataSourceSinger objectForKey:@"sns_total_like"];
            info.snsTotalShare      = [_dataSourceSinger objectForKey:@"sns_total_share"];
            info.snsTotalView       = [_dataSourceSinger objectForKey:@"sns_total_view"];
            info.website            = [_dataSourceSinger objectForKey:@"website"];
            
            NSUserDefaults *defaultStorage = [NSUserDefaults standardUserDefaults];
            [defaultStorage setValue:aDictionary forKey:ABOUT_INFO];
            [defaultStorage synchronize];
            NSDictionary *likeInfo;
            if (fromCache) {
                likeInfo = [defaultStorage objectForKey:ABOUT_INFO_LIKE];
                if (likeInfo) {
                    NSLog(@"likeInfo from cache: %@", likeInfo.description);
                    info.isLiked = [likeInfo objectForKey:@"isLiked"];
                    info.snsTotalLike = [likeInfo objectForKey:@"snsTotalLike"];
                }
            }
            else {
                NSDictionary *likeInfo = @{
                                            @"isLiked" : info.isLiked,
                                            @"snsTotalLike": info.snsTotalLike
                                        };
                [defaultStorage setValue:likeInfo forKey:ABOUT_INFO_LIKE];
                [defaultStorage synchronize];
                [self isCacheSingerInfoTimeout:true];
            }
            
            iNumberLike = [info.snsTotalLike intValue];
            [self loadData:info.description imagePath:info.bannerImagePath];
            NSLog(@"new total like = %d, isLike = %@", iNumberLike, info.isLiked);
            //--set like button
            NSString *likeStatus = [NSString stringWithFormat:@"%@",info.isLiked];
            
            if ([likeStatus isEqualToString:@"0"]) {
                _isLike = NO;
            }
            else {
                _isLike = YES;
            }
            [self redrawRightNavigartionBar:_isLike totalLike: iNumberLike];

        }
    }else{
        [self loadData:_lblDefault imagePath:nil];
    }
    
    //-- set indicator stop
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
}


- (void)loadData:(NSString*)urlWeb imagePath:(NSString*)imagePath
{
    NSLog(@"%s", __func__);
    NSLog(@"image path:%@",imagePath);
    //-- set image
    [self.imgCover setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"cover_about"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
        float scale = self.imgCover.image.size.width / self.imgCover.image.size.height;
        CGRect imgRect = self.imgCover.frame;
        self.imgCover.frame = CGRectMake(imgRect.origin.x, imgRect.origin.y, imgRect.size.width, imgRect.size.width / scale);
        self.wvInfo.frame = CGRectMake(wvInfo.frame.origin.x,
                                       imgCover.frame.origin.y + imgCover.frame.size.height,
                                       wvInfo.frame.size.width,
                                       _scrollAbout.frame.size.height - imgCover.frame.size.height);
                       });

    }];
//    [self.imgCover setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"album_img_noo.png"] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize)
//     {
//         //
//     }
//                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
//     {
//         //--
//         if (image == nil)
//             self.imgCover.image = [UIImage imageNamed:@"album_img_noo.png"];
//     }];
    
    //longnh: bam va giu vao image khoang 5s thi gui log den server
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    gesture.minimumPressDuration = 5;
    [self.imgCover addGestureRecognizer:gesture];
    
    //-- get txt from file
    urlWeb = [urlWeb stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width = '300' height = auto "];
    NSString *metaHTML = @"<meta name=\"viewport\" content=\"width = 300,initial-scale = 1.0,maximum-scale = 1.0\" />";
    NSString *formatHTML = @"<html>%@<body style=\"background-color: clear color; font-size: 12; font-family: HelveticaNeue; text-align: justify; color: #ffffff;\">%@</body> </html>";
    NSString *contentHTML = [NSString stringWithFormat:formatHTML,metaHTML,urlWeb];
    
    //-- set webview data
    [self.wvInfo  loadHTMLString:contentHTML baseURL:[NSURL URLWithString:HOST_FOR_CONTENT]];
}



#pragma mark - Action

- (void)back:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


- (void)likeFanpage
{
    if (_isProcessSyncAPI)
        return;
    [self setDelegateBaseController:self];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        NSLog(@"process like start %@", [NSThread currentThread]);
        _isProcessSyncAPI = true;
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Processing..."];

        if (_isLike == NO) //-- like
        {
            //-- call api like fanpage
            if (![self callAPISyncData:kTypeLike text:nil contentId:@"0" contentTypeId:TYPE_ID_FANPAGE commentId:nil])
                _isProcessSyncAPI = false;
        }
        else //-- unlike
        {
            //-- call api like fanpage
            if (![self callAPISyncData:kTypeUnLike text:nil contentId:@"0" contentTypeId:TYPE_ID_FANPAGE commentId:nil])
                _isProcessSyncAPI = false;
        }
        
        [self redrawRightNavigartionBar:_isLike totalLike: iNumberLike];

    }
    else
    {
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
}



#pragma mark - BaseVCDelegate

- (void)syncDataSuccessDelegate:(NSDictionary *)response
{
    NSString *errorCode = [[[response objectForKey:@"error"] objectForKey:@"error_code"] stringValue];
    NSArray *dataLike = [[response objectForKey:@"data"] objectForKey:@"like"];
    NSLog(@"synsData success=%@", dataLike.description);
    
    //tin tong so like trong cache
    int addLike=0;
    if (errorCode && [errorCode isEqualToString:@"200"]) {
        _isLike = YES;
    }
    else {
        if (dataLike.count >0) {
            _isLike = YES;
            addLike = 1;
        }
        else {
            _isLike = NO;
            addLike = -1;
        }
    }

    NSUserDefaults *defaultStorage = [NSUserDefaults standardUserDefaults];
    NSDictionary *infoLike = [defaultStorage valueForKey:ABOUT_INFO_LIKE];
    if (infoLike) {
        NSMutableDictionary *likeInfoSave = [NSMutableDictionary dictionary];
        if (_isLike)
            [likeInfoSave setValue:@"1" forKey:@"isLiked"];
        else
            [likeInfoSave setValue:@"0" forKey:@"isLiked"];
        
        
        int totalLike = [[infoLike valueForKey:@"snsTotalLike"] integerValue];
        if (totalLike<0)
            totalLike = 0;
        totalLike = totalLike + addLike;
        NSString *tmp = [NSString stringWithFormat:@"%d", totalLike];
        [likeInfoSave setValue:tmp forKey:@"snsTotalLike"];
        [defaultStorage setValue:likeInfoSave forKey:ABOUT_INFO_LIKE];
        [defaultStorage synchronize];
    }

    [self showInfoFromCache];
    NSLog(@"process like finish %@", [NSThread currentThread]);
}

- (void)baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    [AppDelegate addLocalLogWithString:@"LG200" info:[Profile debugDescription]];
    [self likeFanpage];
}

- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
    _isProcessSyncAPI = false;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //
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
- (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *currentBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *msg = [NSString stringWithFormat:@"Version: %@\nBuild: %@\nBạn có muốn gửi thông báo lỗi không?",currentVersion,currentBuild];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"Bỏ qua"
                                          otherButtonTitles:@"Gửi", nil];
        [alert show];
    }

}

- (void)sendLocalLog
{
    [AppDelegate sendLog];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self sendLocalLog];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_activityIndicator) {
        [_activityIndicator stopAnimating];
        _activityIndicator.hidden = YES;
    }
    
    //-- finish load
    self.wvInfo.alpha = 1;
    
    float hw = self.wvInfo.scrollView.contentSize.height;
    
    //-- set webview frame
    self.wvInfo.frame = CGRectMake(wvInfo.frame.origin.x, wvInfo.frame.origin.y, webView.frame.size.width, hw);
    
    //-- set scrollview contentsize
    _scrollAbout.contentSize = CGSizeMake(320, wvInfo.frame.origin.y + hw);
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_activityIndicator) {
        [_activityIndicator stopAnimating];
        _activityIndicator.hidden = YES;
    }
}





@end
