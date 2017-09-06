//
//  CommentsNewsViewController.m
//  NooPhuocThinh
//
//  Created by HuntDo on 12/5/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "CommentsNewsViewController.h"

static CommentsNewsViewController *sharedCommentNews = nil;

@interface CommentsNewsViewController ()

@end

@implementation CommentsNewsViewController

@synthesize nodeId, myArrComments;

+ (CommentsNewsViewController *)sharedComment
{
    if (sharedCommentNews == nil) {
        static dispatch_once_t threeToken;
        dispatch_once(&threeToken, ^{
            sharedCommentNews = [[CommentsNewsViewController alloc] init];
        });
    }
    
    return sharedCommentNews;
}


+ (void)initWithDelegateComment:(id<CommentsNewsViewControllerDelegate>)delegateComment {
    
    [[CommentsNewsViewController sharedComment] addDelegate:delegateComment];
}

+ (void)addDelegateComment:(id)delegateComment
{
    [[CommentsNewsViewController sharedComment] addDelegate:delegateComment];
}

+ (void)removeDelegateComment:(id)delegateComment
{
    [[CommentsNewsViewController sharedComment] removeDelegate:delegateComment];
}

- (void)addDelegate:(id)delegate
{
    [delegatesComment addDelegate:delegate];
}

- (void)removeDelegate:(id)delegate
{
    [delegatesComment removeDelegate:delegate];
}


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        delegatesComment = (MulticastDelegate<CommentsNewsViewControllerDelegate>*) [[MulticastDelegate alloc] init];
    }
    return self;
}



#pragma mark - Main

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //--set navigation bar
    [self customNavigationBar];
    
    //-- set background for view
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    _isAutoScroll = YES;
    _isClickComment = NO;
    
    //-- start indicator
    [_indicator startAnimating];
    
    //-- fetching data
    [self fetchingDataComment];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableViewComments];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer];
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentIndex"];
    self.screenName = @"Comment News Screen";
    
    [self comment:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UI

-(void)customNavigationBar
{
    [self setTitle:@"Comments"];
    
//    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
//    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // back button
    UIButton *btnLeft= [UIButton buttonWithType:UIButtonTypeCustom];
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



#pragma mark - Call API get data

- (void)fetchingDataComment
{
    [self setDelegateBaseController:self];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (dataCenter.isNews == YES) {
        [self callApiGetDataComment:SINGER_ID
                          contentId:nodeId
                      contentTypeId:TYPE_ID_NEWS
                          commentId:@"0"
                getCommentOfComment:@"0"];
    }
    
    if (dataCenter.isPhotoView == YES) {
        [self callApiGetDataComment:SINGER_ID
                          contentId:nodeId
                      contentTypeId:TYPE_ID_PHOTO
                          commentId:@"0"
                getCommentOfComment:@"0"];
    }
    
    if (dataCenter.isSchedule == YES) {
        [self callApiGetDataComment:SINGER_ID
                          contentId:nodeId
                      contentTypeId:TYPE_ID_EVENT
                          commentId:@"0"
                getCommentOfComment:@"0"];
    }
    
    if (dataCenter.isMusic == YES) {
        [self callApiGetDataComment:SINGER_ID
                          contentId:nodeId
                      contentTypeId:TYPE_ID_MUSIC_SONG
                          commentId:@"0"
                getCommentOfComment:@"0"];
    }
    
    if (dataCenter.isPageFeed == YES) {
        [self callApiGetFeedDataComment:SINGER_ID
                          contentId:nodeId
                      contentTypeId:TYPE_ID_FEED_PAGE
                          commentId:@"0"
                getCommentOfComment:@"0"];
    }
    
    if (dataCenter.isLinkFeed == YES) {
        [self callApiGetFeedDataComment:SINGER_ID
                          contentId:nodeId
                      contentTypeId:TYPE_ID_FEED_LINK
                          commentId:@"0"
                getCommentOfComment:@"0"];
    }
    
    if (dataCenter.isPhotoFeed == YES) {
        [self callApiGetFeedDataComment:SINGER_ID
                          contentId:nodeId
                      contentTypeId:TYPE_ID_FEED_PHOTO
                          commentId:@"0"
                getCommentOfComment:@"0"];
    }
    
    if (dataCenter.isVideoFeed == YES) {
        [self callApiGetFeedDataComment:SINGER_ID
                          contentId:nodeId
                      contentTypeId:TYPE_ID_FEED_VIDEO
                          commentId:@"0"
                getCommentOfComment:@"0"];
    }
}


//-- pass data comments Delegate
- (void)passCommentsDelegate:(NSMutableArray*)listDataComments
{
    self.arrCommentData = listDataComments;
    
    //-- stop indicator
    [_indicator stopAnimating];
    
    //-- reload tableview
    [_tableViewComments reloadData];
    
    //-- auto scroll
    if (_isAutoScroll && ([self.arrCommentData count] > 5))
    {
        [_tableViewComments beginUpdates];
        
        [_tableViewComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.arrCommentData count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [_tableViewComments endUpdates];
    }
    
}



#pragma mark - alloc data

-(void) refreshData:(ODRefreshControl *) refreshControl
{
    [refreshControl beginRefreshing];
    
    [self fetchingDataComment];
    
    [_tableViewComments reloadData];
    [refreshControl endRefreshing];
}



#pragma mark - table delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0;
    Comment *aComment = [self.arrCommentData objectAtIndex:indexPath.row];
    //dynamic content textview
    CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:210 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT]];
    
    if (heightOfText < 60)
        heightForRow = 90;
    else
        heightForRow = heightOfText + 30;

    return heightForRow; 
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrCommentData){
        NSLog(@"[self.arrCommentData count]: %d",[self.arrCommentData count]);
        return [self.arrCommentData count];
    }
    else
        return 0;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CommentCellCustom";
    CommentCellCustom *cell = [_tableViewComments dequeueReusableCellWithIdentifier:identifier];
    
    //-- set background for cell
//    if ((indexPath.row%2) == 0)
//        cell.imgBackground.image = [UIImage imageNamed:@"img_bg_comment_of_comment_0.png"];
//    else
//        cell.imgBackground.image = [UIImage imageNamed:@"img_bg_comment_of_comment_1.png"];
    
    //-- custom avatar of user to circle
    cell.imgAvatar.layer.borderWidth = 1.0f;
    cell.imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.imgAvatar.layer.cornerRadius = 22;
    cell.imgAvatar.layer.masksToBounds = YES;
    
    // fill data into cell
    Comment *aComment = [self.arrCommentData objectAtIndex:indexPath.row];
   
    //dynamic content textview
    CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:210 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT]];
    if (heightOfText <= 50) {
        heightOfText = 50;
    }else{
        heightOfText = heightOfText + 20;
    }
    
    CGRect frame = cell.txtViewComment.frame;
    frame.size.height = heightOfText;
    cell.txtViewComment.frame= frame;
    [Utility setHTMLContent:[Utility convertTextInit:aComment.content] forTextView:cell.txtViewComment];
    
    cell.txtViewComment.scrollEnabled = NO;
    cell.txtViewComment.userInteractionEnabled = NO;
    cell.txtViewComment.editable = NO;
    cell.txtViewComment.textColor = [UIColor blackColor];
    
    cell.lblNickName.text = aComment.profileUser.fullName;
    cell.lblTotalChildComment.text = aComment.numberOfSubcommments;
    cell.lblDateTime.text = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[aComment.timeStamp integerValue]]];
    
    cell.lblPointOfUser.text = aComment.profileUser.point;
    
    [cell.imgAvatar setImageWithURL:[NSURL URLWithString:aComment.profileUser.userImage] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"] completed:nil];
    cell.imgAvatar.tag = indexPath.row;
    cell.imgAvatar.userInteractionEnabled = YES;
    
    //--add tap gesture
    UITapGestureRecognizer *tapSelectAvt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToTapComment:)];
    [cell.imgAvatar addGestureRecognizer:tapSelectAvt];
    
    //set custom separator for cell
    UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3,cell.frame.size.width,5)];
    additionalSeparator.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    [cell addSubview:additionalSeparator];
    
    return cell;
}

- (void)clickToTapComment:(UIGestureRecognizer *)sender
{
    NSInteger indexAlbum = [sender view].tag;
    
    Comment *aComment = [self.arrCommentData objectAtIndex:indexAlbum];
    
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


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.arrCommentData objectAtIndex:indexPath.row];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DetailCommentsViewController *detailCommnetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailCommentsViewControllerId"];;
    [dataCenter setIsNews:YES];
    detailCommnetVC.superComment = comment;
    detailCommnetVC.nodeId = nodeId;
    detailCommnetVC.delegateDetailComment = self;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"currentIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:detailCommnetVC animated:YES];
    else
        [self.navigationController pushViewController:detailCommnetVC animated:NO];
}


-(void) resizeContainSizeOfTableView
{
    CGFloat heightOfTable = 0;
    
    for (NSInteger i = 0; i < [self.arrCommentData count]; i++)
    {
        Comment *aComment = [self.arrCommentData objectAtIndex:i];
        // set height for table
        
        CGFloat heightForRow = 0;
        CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:210 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT]];
        heightForRow = heightOfText + 40;
        
        if (heightForRow < 91)
            heightForRow = 91;
        
        heightOfTable += heightForRow;
    }
    _tableViewComments.contentSize = CGSizeMake(_tableViewComments.frame.size.width, heightOfTable);
}



#pragma mark - storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    if ([segue.identifier isEqualToString:@"showDetailComments"])
    {
        
        UIButton *buttonClicked = (UIButton *) sender;
        
        CommentCellCustom *cell = (CommentCellCustom *)buttonClicked.superview.superview;
        NSIndexPath *indexPath = [_tableViewComments indexPathForCell:cell];
        Comment *comment = [self.arrCommentData objectAtIndex:indexPath.row];
        
        AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        DetailCommentsViewController *detailCommnetVC = segue.destinationViewController;
        [dataCenter setIsNews:YES];
        detailCommnetVC.superComment = comment;
        detailCommnetVC.nodeId = nodeId;
    }
     */
}



#pragma mark - actions

-(void)back:(id)sender
{
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (dataCenter.isNews == YES) {
        [dataCenter setIsNews:NO];
    }
    
    if (dataCenter.isPhotoView == YES) {
        [dataCenter setIsPhotoView:NO];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    self.navigationController.navigationBarHidden = YES;
}


-(void)comment:(id)sender
{
    _isClickComment = YES;
    
    //-- set delegate
    [self setDelegateBaseController:self];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    
    if (userId) {
        
        if (_isClickComment)
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
    
    _isClickComment = NO;
}


-(void) postComment
{
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //loi arrayComment
    
    NSString *content = [self getContentOfComment];
    if (!content || [content length]==0)
        return;
    
//    if (dataCenter.isPageFeed || dataCenter.isLinkFeed || dataCenter.isPhotoFeed || dataCenter.isVideoFeed)
//    {
//        [self apiPostFeedComment:content];
//    }
    
    [super postComment];
    
    //-- comment has "level 1"
    Comment *commentForNews = [Comment new];
    commentForNews.commentId = @"0";
    commentForNews.content = content;
    commentForNews.timeStamp = [Utility idFromTimeStamp];
    commentForNews.profileUser = [Profile sharedProfile];
    commentForNews.profileUser.point = [Profile sharedProfile].point;
    commentForNews.numberOfSubcommments = @"0";
    commentForNews.arrSubComments = [NSMutableArray new];
    
    [self.arrCommentData addObject:commentForNews];
    [_tableViewComments reloadData];
    
    if (self.arrCommentData==nil || [self.arrCommentData count]==0)
        return;
    
    [_tableViewComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrCommentData count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self resizeContainSizeOfTableView];
    
    if (dataCenter.isNews == YES) {
        [self callAPISyncData:kTypeComment text:content contentId:nodeId contentTypeId:TYPE_ID_NEWS commentId:@"0"];
    }
    
    if (dataCenter.isPhotoView == YES) {
        [self callAPISyncData:kTypeComment text:content contentId:nodeId contentTypeId:TYPE_ID_PHOTO commentId:@"0"];
    }
    
    if (dataCenter.isSchedule == YES) {
        [self callAPISyncData:kTypeComment text:content contentId:nodeId contentTypeId:TYPE_ID_EVENT commentId:@"0"];
    }
    
    if (dataCenter.isMusic == YES) {
        [self callAPISyncData:kTypeComment text:content contentId:nodeId contentTypeId:TYPE_ID_MUSIC_SONG commentId:@"0"];
    }
    
    if (dataCenter.isPageFeed == YES) {
        [self callAPISyncData:kTypeFeed text:content contentId:nodeId contentTypeId:TYPE_ID_FEED_PAGE commentId:@"0"];
    }
    
    if (dataCenter.isLinkFeed == YES) {
        [self callAPISyncData:kTypeFeed text:content contentId:nodeId contentTypeId:TYPE_ID_FEED_LINK commentId:@"0"];
    }
    
    if (dataCenter.isPhotoFeed == YES) {
        [self callAPISyncData:kTypeFeed text:content contentId:nodeId contentTypeId:TYPE_ID_FEED_PHOTO commentId:@"0"];
    }
    
    if (dataCenter.isVideoFeed == YES) {
        [self callAPISyncData:kTypeFeed text:content contentId:nodeId contentTypeId:TYPE_ID_FEED_VIDEO commentId:@"0"];
    }
    
    _isClickComment = NO;
}

- (void)apiPostFeedComment:(NSString *)content
{
//    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:MY_ACCOUNT_ID];
//    
//    [API postCommentFeed:SINGER_ID
//                  fanzoneId:self.superComment.commentId
//                     userId:userId
//                       text:content
//           isGetNewShoutBox:@"0"
//                  startTime:@""
//                    endTime:@""
//                      limit:@"100"
//               productionId:PRODUCTION_ID
//          productionVersion:PRODUCTION_VERSION
//                  completed:^(NSDictionary *responseDictionary, NSError *error) {
//                      //create datasource
//                      NSLog(@"postCommentFanzone success");
//                      //longnh
//                      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                      [userDefaults setObject:@"1" forKey:Key_Refresh_Now];
//                      [userDefaults synchronize];
//                      //-- reload data
//                      [self fetchingDataComment];
//                  }];
}

//+ (void)postCommentFeed:(NSString*)pageId
//                 fanzoneId:(NSString*)fanzoneId
//                    userId:(NSString*)userId
//                      text:(NSString*)text
//          isGetNewShoutBox:(NSString*)isGetNewShoutBox
//                 startTime:(NSString*)startTime
//                   endTime:(NSString*)endTime
//                     limit:(NSString*)limit
//              productionId:(NSString*)productionId
//         productionVersion:(NSString*)productionVersion
//                 completed:(void (^)(NSDictionary *responseDictionary, NSError *error))completed
//{
//    NSLog(@"%s", __func__);
//    NSDictionary *dictParameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    pageId,@"page_id",
//                                    fanzoneId,@"fanzone_id",
//                                    userId,@"user_id",
//                                    text,@"text",
//                                    isGetNewShoutBox,@"is_get_new_shoutbox",
//                                    startTime,@"start_time",
//                                    endTime,@"end_time",
//                                    limit,@"limit",
//                                    productionId, @"production_id",
//                                    productionVersion, @"production_version",nil];
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@/add_shoutbox_comment.php",HOST_FOR_USER];
//    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
//    [client setAllowsInvalidSSLCertificate:YES];
//    [client setParameterEncoding:AFFormURLParameterEncoding];
//    [client postPath:urlString parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        //-- data return
//        NSDictionary *dictResponse = [operation.responseString JSONValue];
//        
//        if ([operation.response statusCode] == 200) { //-- good data
//            completed(dictResponse,nil);
//        }
//        else { //-- bad data
//            
//            NSError *error = [NSError errorWithDomain:@"www.noopt.com" code:-1 userInfo:nil];
//            completed(nil,error);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        //-- error
//        completed(nil,error);
//        
//    }];
//}

//-- if comment posted successfully

- (void)syncDataSuccessDelegate:(NSDictionary *)response
{
    //-- set id for comment at local
    NSDictionary   *dictData          = [response objectForKey:@"data"];
    NSMutableArray *arrComment        = [dictData objectForKey:@"comment"];
    
    if ([arrComment count] > 0)
    {
        NSDictionary *dictComment         = [arrComment objectAtIndex:0];
        NSString     *commentId           = [dictComment objectForKey:@"comment_id"];
        Comment      *recentComment       = [self.arrCommentData lastObject];
        if ([recentComment.commentId isEqualToString:@"0"])
            recentComment.commentId = commentId;
    }

    //-- pass delegate to screen before: to update number of comment
    if ([self.delegateComment respondsToSelector:@selector(commentSuccessDelegate)]) {
            [self.delegateComment commentSuccessDelegate];
    }
}


- (void)subCommentSuccessDelegate
{
    // fill data into cell
    id index = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentIndex"];
    
    Comment *aComment = [self.arrCommentData objectAtIndex:[index integerValue]];
    NSNumber *childComment = [NSNumber numberWithInteger:[aComment.numberOfSubcommments integerValue] + 1];
    aComment.numberOfSubcommments = [childComment stringValue];
    
    [_tableViewComments reloadData];
}



#pragma mark - Base view controller delegate
- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
    //_isProcessLikeAPI = false;
}

- (void)baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    [AppDelegate addLocalLogWithString:@"LG200" info:[Profile debugDescription]];
    
    if (_isClickComment) {
        [AppDelegate addLocalLog:@"isLike"];
        //-- post comment
        [self showDialogComments:CGPointZero title:@"Bình luận"];
    }
}



@end
