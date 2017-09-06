//
//  HomeCommentViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/10/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeCommentViewController.h"

@interface HomeCommentViewController ()

@end

@implementation HomeCommentViewController
@synthesize viewComment,viewTop,tableViewComments;
@synthesize tempLinkData,indexP,indexValue,scrollTotal;
@synthesize imgCover,imageURLLink,title,titleLink,urlLink,btnPost,btnBack,btnCamera,btnComment,btnEmoticon,btnLike,btnShare,tfComment;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //-- get height of keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relayoutUI) name:@"relayout" object:nil];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [viewTop addGestureRecognizer:tap];
    
    [self removeBottomBarBaseViewController];
    
    scrollTotal.bounces = NO;
    
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"height of keyboard = %f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    desiredPlace = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"relayout" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupUI];
    
    [tfComment becomeFirstResponder];
}

- (void)callCommentView
{
    [tfComment becomeFirstResponder];
}

- (void)relayoutUI
{
    [viewComment setFrame:CGRectMake(0, self.view.frame.size.height - desiredPlace - 50, viewComment.frame.size.width, viewComment.frame.size.height)];
}

-(void) setupUI
{
    indexValue = [[NSString stringWithFormat:@"%@",indexP] integerValue];
    
    imageURLLink = [[tempLinkData objectAtIndex:indexValue]valueForKey:@"feedImage"];
    [self.imgCover setImageWithURL:[NSURL URLWithString:imageURLLink]];
    [self.btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnLike addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnComment addTarget:self action:@selector(callCommentView) forControlEvents:UIControlEventTouchUpInside];
    [self.btnShare addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lblComment.text = [NSString stringWithFormat:@"%@ Comments",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"snsTotalComment"]];
    self.lblLike.text = [NSString stringWithFormat:@"%@ Likes",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"snsTotalLike"]];
    self.lblShare.text = [NSString stringWithFormat:@"%@ Shares",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"snsTotalShare"]];
    self.lblView.text = [NSString stringWithFormat:@"%@ Views",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"snsTotalView"]];
    self.isLiked = [NSString stringWithFormat:@"%@",[[tempLinkData objectAtIndex:indexValue]valueForKey:@"isLiked"]];
    
    if ([self.isLiked isEqual:@"1"])
    {
        self.btnLike.selected = YES;
    }
    
    //-- tableview comment
    [self.viewBottom addSubview:tableViewComments];
    
    [btnPost addTarget:self
                action:@selector(postCommentImmediatly:)
         forControlEvents:UIControlEventTouchUpInside];
    [btnEmoticon addTarget:self
                    action:@selector(getEmoticon:)
      forControlEvents:UIControlEventTouchUpInside];
    [btnCamera addTarget:self
                  action:@selector(getCamera:)
      forControlEvents:UIControlEventTouchUpInside];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    ListFeedData *news = [tempLinkData objectAtIndex:indexValue];
    NSString *commentID;
    if ([news.feedType isEqual:@"pages_comment"])
    {
        typeComment = @"Pages";
        commentID = news.feedId;
        [dataCenter setIsPageFeed:YES];
        dataCenter.nodeCommentId = commentID;
    }
    else if ([news.feedType isEqual:@"link"])
    {
        typeComment = @"Link";
        commentID = news.feedId;
        [dataCenter setIsLinkFeed:YES];
        dataCenter.nodeCommentId = commentID;
    }
    else if ([news.feedType isEqual:@"photo"])
    {
        if ([news.albumId isEqual:@"0"])
        {
            tempPhotoFeedData = [[NSMutableArray alloc]init];
            tempPhotoFeedData = [VMDataBase getAllPhotoFeeds:((ListFeedData*)[tempLinkData objectAtIndex:indexValue]).albumId];
            for (int i = 0; i < tempPhotoFeedData.count; i++)
            {
                if ([((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).indexcell integerValue] == indexValue)
                {
                    typeComment = @"Photo";
                    commentID = ((PhotoListFeedData*)[tempPhotoFeedData objectAtIndex:i]).photoId;
                    [dataCenter setIsPhotoFeed:YES];
                    dataCenter.nodeCommentId = commentID;
                }
                else
                {}
            }
        }
        else
        {
            typeComment = @"Photo";
            commentID = news.albumId;
            [dataCenter setIsPhotoFeed:YES];
            dataCenter.nodeCommentId = commentID;
        }
    }
    else if ([news.feedType isEqual:@"video"])
    {
        typeComment = @"Video";
        commentID = news.feedId;
        [dataCenter setIsPhotoFeed:YES];
        dataCenter.nodeCommentId = commentID;
    }
    
    [self fetchingDataComment:commentID];
    
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

-(void)getEmoticon:(id)sender
{

}

-(void)getCamera:(id)sender
{

}

-(void)dismissKeyboard
{
    [tfComment resignFirstResponder];
    tfComment.text = nil;
    [UIView animateWithDuration:0.01
                          delay:0.01
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.viewComment.frame = CGRectMake(0, self.view.frame.size.height - 50, viewComment.frame.size.width, viewComment.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];

}

- (void)fetchingDataComment:(NSString *)nodeId
{
    if ([typeComment isEqual:@"Pages"])
    {
        [self callApiGetFeedDataComment:SINGER_ID
                              contentId:nodeId
                          contentTypeId:TYPE_ID_FEED_PAGE
                              commentId:@"0"
                    getCommentOfComment:@"0"];
    }
    
    if ([typeComment isEqual:@"Link"])
    {
        [self callApiGetFeedDataComment:SINGER_ID
                              contentId:nodeId
                          contentTypeId:TYPE_ID_FEED_LINK
                              commentId:@"0"
                    getCommentOfComment:@"0"];
    }
    
    if ([typeComment isEqual:@"Photo"])
    {
        [self callApiGetFeedDataComment:SINGER_ID
                              contentId:nodeId
                          contentTypeId:TYPE_ID_FEED_PHOTO
                              commentId:@"0"
                    getCommentOfComment:@"0"];
    }
    
    if ([typeComment isEqual:@"Video"])
    {
        [self callApiGetFeedDataComment:SINGER_ID
                              contentId:nodeId
                          contentTypeId:TYPE_ID_FEED_VIDEO
                              commentId:@"0"
                    getCommentOfComment:@"0"];
    }
}

- (void)callApiGetFeedDataComment:(NSString*)singerId contentId:(NSString*)contentId contentTypeId:(NSString*)contentTypeId commentId:(NSString*)commentId getCommentOfComment:(NSString*)getCommentOfComment
{
    NSLog(@"%s", __func__);
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) return;
    
    [API getCommentDataFeed:singerId
               productionId:PRODUCTION_ID
          productionVersion:PRODUCTION_VERSION
              contentTypeId:contentTypeId
                  contentId:contentId
                  commentId:commentId
               isGetComment:getCommentOfComment
                     isFeed:@"1"
                  completed:^(NSDictionary *responseDictionary, NSError *error)
     {
         NSLog(@"getCommentData: %@", responseDictionary);
         [self createDataSourceFeedComment:responseDictionary];
     }];
}

-(void)createDataSourceFeedComment:(NSDictionary *)aDictionary
{
    NSLog(@"%s", __func__);
    NSMutableArray *arrComment = [aDictionary objectForKey:@"data"];
    
    arrCommentData = [[NSMutableArray alloc] init];
    
    if (arrComment.count > 0)
    {
        for (NSInteger i = 0; i < [arrComment count]; i++)
        {
            Comment *comment = [[Comment alloc] init];
            
            Profile *profile = [[Profile alloc] init];
            
            profile.userId = [[arrComment objectAtIndex:i] objectForKey:@"user_id"];
            profile.fullName = [[arrComment objectAtIndex:i] objectForKey:@"full_name"];
            profile.point = [NSString stringWithFormat:@"%@",[[arrComment objectAtIndex:i] objectForKey:@"user_point"]];;
            profile.userImage = [[arrComment objectAtIndex:i] objectForKey:@"user_image"];
            profile.facebookURL = [[arrComment objectAtIndex:i] objectForKey:@"facebook_url"];
            profile.facebookId = [[arrComment objectAtIndex:i] objectForKey:@"facebook_id"];
            
            comment.commentId = [[arrComment objectAtIndex:i] objectForKey:@"comment_id"];
            comment.numberOfSubcommments = [[arrComment objectAtIndex:i] objectForKey:@"child_total"];
            comment.content = [[arrComment objectAtIndex:i] objectForKey:@"text"];
            comment.timeStamp = [[arrComment objectAtIndex:i] objectForKey:@"time_stamp"];
            comment.profileUser = profile;
            comment.arrSubComments = [NSMutableArray new];
            
            [arrCommentData addObject:comment];
        }
    }
    [self passDataCommentToTableView];
}

//-- pass data comments Delegate
- (void)passDataCommentToTableView
{
    //-- reload tableview
    [tableViewComments reloadData];
    
    if ([arrCommentData count] > 5)
    {
        [tableViewComments beginUpdates];
        
//        [tableViewComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([arrCommentData count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [tableViewComments endUpdates];
    }
    
    [tableViewComments layoutIfNeeded];

    [tableViewComments setFrame:CGRectMake(tableViewComments.frame.origin.x, tableViewComments.frame.origin.y, tableViewComments.frame.size.width, tableViewComments.contentSize.height)];
    [tableViewComments setScrollEnabled:NO];
    [scrollTotal setContentSize:CGSizeMake(scrollTotal.frame.size.width, tableViewComments.frame.size.height + viewTop.frame.size.height + 50)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"arrComment = %lu",(unsigned long)[arrCommentData count]);
    return [arrCommentData count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCellId"];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    CommentTableViewCell *tb=(CommentTableViewCell*)cell;
    //-- custom avatar of user to circle
    tb.imgAvatar.layer.borderWidth = 1.0f;
    tb.imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    tb.imgAvatar.layer.cornerRadius = 22;
    tb.imgAvatar.layer.masksToBounds = YES;
    
    // fill data into cell
    Comment *aComment = [arrCommentData objectAtIndex:indexPath.row];
    
    //dynamic content textview
    CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:210 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT]];
    if (heightOfText <= 50) {
        heightOfText = 50;
    }else{
        heightOfText = heightOfText + 20;
    }
    
    CGRect frame = tb.txtViewComment.frame;
    frame.size.height = heightOfText;
    tb.txtViewComment.frame= frame;
    [Utility setHTMLContent:[Utility convertTextInit:aComment.content] forTextView:tb.txtViewComment];
    
    tb.txtViewComment.scrollEnabled = NO;
    tb.txtViewComment.userInteractionEnabled = NO;
    tb.txtViewComment.editable = NO;
    tb.txtViewComment.textColor = [UIColor blackColor];
    
    tb.lblNickName.text = aComment.profileUser.fullName;
    tb.lblTotalChildComment.text = aComment.numberOfSubcommments;
    tb.lblDateTime.text = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[aComment.timeStamp integerValue]]];
    
    tb.lblPointOfUser.text = aComment.profileUser.point;
    
    [tb.imgAvatar sd_setImageWithURL:[NSURL URLWithString:aComment.profileUser.userImage] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"] completed:nil];
    tb.imgAvatar.tag = indexPath.row;
    tb.imgAvatar.userInteractionEnabled = YES;
    
    //--add tap gesture
    UITapGestureRecognizer *tapSelectAvt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToTapComment:)];
    [tb.imgAvatar addGestureRecognizer:tapSelectAvt];
    
    //    //set custom separator for cell
    //    UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3,cell.frame.size.width,5)];
    //    additionalSeparator.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    //    [cell addSubview:additionalSeparator];
    
    if (cell == nil) {
        return [[UITableViewCell alloc] init];
    }
    
    return cell;
}

-(void)postCommentImmediatly:(id)sender
{
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *content = [self getContentOfComment];
    if (!content || [content length]==0)
        return;
    
    Comment *commentForNews = [Comment new];
    commentForNews.commentId = @"0";
    commentForNews.content = content;
    commentForNews.timeStamp = [Utility idFromTimeStamp];
    commentForNews.profileUser = [Profile sharedProfile];
    commentForNews.profileUser.point = [Profile sharedProfile].point;
    commentForNews.numberOfSubcommments = @"0";
    commentForNews.arrSubComments = [NSMutableArray new];
    
    [arrCommentData addObject:commentForNews];
    [tableViewComments reloadData];
    
    if (arrCommentData==nil || [arrCommentData count]==0)
        return;
    
    [tableViewComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[arrCommentData count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self resizeContainSizeOfTableView];
    
    if (dataCenter.isPageFeed == YES) {
        [self callAPISyncData:kTypeFeed text:content contentId:dataCenter.nodeCommentId contentTypeId:TYPE_ID_FEED_PAGE commentId:@"0"];
    }
    
    if (dataCenter.isLinkFeed == YES) {
        [self callAPISyncData:kTypeFeed text:content contentId:dataCenter.nodeCommentId contentTypeId:TYPE_ID_FEED_LINK commentId:@"0"];
    }
    
    if (dataCenter.isPhotoFeed == YES) {
        [self callAPISyncData:kTypeFeed text:content contentId:dataCenter.nodeCommentId contentTypeId:TYPE_ID_FEED_PHOTO commentId:@"0"];
    }
    
    if (dataCenter.isVideoFeed == YES) {
        [self callAPISyncData:kTypeFeed text:content contentId:dataCenter.nodeCommentId contentTypeId:TYPE_ID_FEED_VIDEO commentId:@"0"];
    }
    
    [self dismissKeyboard];
}

-(void) resizeContainSizeOfTableView
{
    CGFloat heightOfTable = 0;
    
    for (NSInteger i = 0; i < [arrCommentData count]; i++)
    {
        Comment *aComment = [arrCommentData objectAtIndex:i];
        // set height for table
        
        CGFloat heightForRow = 0;
        CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:210 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT]];
        heightForRow = heightOfText + 40;
        
        if (heightForRow < 91)
            heightForRow = 91;
        
        heightOfTable += heightForRow;
    }
    tableViewComments.contentSize = CGSizeMake(tableViewComments.frame.size.width, heightOfTable);
}

-(NSString *)getContentOfComment
{
    NSString *content = @"";
    
    if ([self checkContentOfComment:tfComment.text] == NO)
    {
        content = @"";
    }
    else
    {
        content = tfComment.text;
    }
    return content;
}

- (BOOL)checkContentOfComment:(NSString *)contentComment
{
    //-- validate content
    NSString *tempComment = [contentComment stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereAreJustSpaces = [tempComment isEqualToString:@""];
    
    if(!thereAreJustSpaces)
        return YES;
    else
        return NO;
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


@end
