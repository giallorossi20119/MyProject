//
//  DetailCommentsViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/10/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "DetailCommentsViewController.h"

static DetailCommentsViewController *sharedSubComment = nil;

@interface DetailCommentsViewController ()

@end

@implementation DetailCommentsViewController

@synthesize nodeId;

+ (DetailCommentsViewController *)sharedDetailComment
{
    if (sharedSubComment == nil) {
        static dispatch_once_t threeToken;
        dispatch_once(&threeToken, ^{
            sharedSubComment = [[DetailCommentsViewController alloc] init];
        });
    }
    
    return sharedSubComment;
}


+ (void)initWithDelegateComment:(id<DetailCommentsViewControllerDelegate>) delegateDetailComment
{
    
    [[DetailCommentsViewController sharedDetailComment] addDelegateDetailComment:delegateDetailComment];
}

+ (void)addDelegateDetailComment:(id)delegateDetailComment
{
    [[DetailCommentsViewController sharedDetailComment] addDelegateDetailComment:delegateDetailComment];
}

+ (void)removeDelegateDetailComment:(id)delegateDetailComment
{
    [[DetailCommentsViewController sharedDetailComment] removeDelegate:delegateDetailComment];
}

- (void)addDelegateDetailComment:(id)delegate
{
    [delegatesDetailComment addDelegate:delegate];
}

- (void)removeDelegate:(id)delegate
{
    [delegatesDetailComment removeDelegate:delegate];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        delegatesDetailComment = (MulticastDelegate<DetailCommentsViewControllerDelegate>*) [[MulticastDelegate alloc] init];
    }
    return self;
}


#pragma mark - Main

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //-- set bool
    _isAutoScroll = YES;
    _isClickComment = NO;
    
    //--set navigation bar
    [self customNavigationBar];
    
    //-- add slidebar
    [self addSlideBarBaseViewController];
    
    //-- set delegate from BaseVC
    [self setDelegateBaseController:self];
    
    //-- init data for tableview
    [self fetchingCommentOfComment];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableViewDetailComments];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
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
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
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



#pragma mark - alloc data

- (void) fetchingCommentOfComment
{
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //-- start indicator
    [_indicator startAnimating];
    
    if (dataCenter.isNews == YES) {
        [self callApiGetDataComment:SINGER_ID contentId:nodeId contentTypeId:TYPE_ID_NEWS commentId:self.superComment.commentId getCommentOfComment:@"1"];
    }
    
    if (dataCenter.isPhotoView == YES) {
        [self callApiGetDataComment:SINGER_ID contentId:nodeId contentTypeId:TYPE_ID_PHOTO commentId:self.superComment.commentId getCommentOfComment:@"1"];
    }
    
    if (dataCenter.isSchedule == YES) {
        [self callApiGetDataComment:SINGER_ID contentId:nodeId contentTypeId:TYPE_ID_EVENT commentId:self.superComment.commentId getCommentOfComment:@"1"];
    }
    
    if (dataCenter.isMusic == YES) {
        [self callApiGetDataComment:SINGER_ID contentId:nodeId contentTypeId:TYPE_ID_MUSIC_SONG commentId:self.superComment.commentId getCommentOfComment:@"1"];
    }
    
    if (dataCenter.isVideo == YES) {
        [self callApiGetDataComment:SINGER_ID contentId:nodeId contentTypeId:TYPE_ID_VIDEO commentId:self.superComment.commentId getCommentOfComment:@"1"];
    }
}


//-- pass data comments Delegate
- (void)passCommentsDelegate:(NSMutableArray*) listDataComments
{
    self.superComment.arrSubComments = listDataComments;
    
    //-- stop indicator
    [_indicator stopAnimating];
    
    //-- reload tableview
    [_tableViewDetailComments reloadData];
    
    //-- auto scroll
    if (_isAutoScroll && ([self.superComment.arrSubComments count] > 5)){
        [_tableViewDetailComments beginUpdates];
        
        [_tableViewDetailComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.superComment.arrSubComments count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [_tableViewDetailComments endUpdates];
    }
    
}



#pragma mark - table delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *aComment = nil;
    CGFloat heightOfText = 0;
    
    if (indexPath.row == 0)
    {
        aComment = self.superComment;
        heightOfText = [Utility heightFromString:aComment.content maxWidth:255 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT_DETAIL]];
    }
    else
    {
        aComment = [self.superComment.arrSubComments objectAtIndex:(indexPath.row-1)];
        heightOfText = [Utility heightFromString:aComment.content maxWidth:210 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT_DETAIL]];
    }
    
    CGFloat heightForRow = 0;
    
    if (heightOfText < 45){
        heightForRow = 70;
    }else{
        heightForRow = heightOfText + 30;
    }
    
    return (heightForRow);
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.superComment)
        return ([self.superComment.arrSubComments count] +1);
    else
        return 0;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    DetailCommentCellCustom *cell = nil;
    Comment *aComment = nil;
    CGFloat heightOfText = 0;
    
    if (indexPath.row == 0)
    {
        identifier = @"superDetailCommentCellCustom";
        cell = [_tableViewDetailComments dequeueReusableCellWithIdentifier:identifier];
        aComment = self.superComment;
        heightOfText = [Utility heightFromString:aComment.content maxWidth:255 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT_DETAIL]];
    }
    else
    {
        identifier = @"subDetailCommentCellCustom";
        cell = [_tableViewDetailComments dequeueReusableCellWithIdentifier:identifier];
        aComment = [self.superComment.arrSubComments objectAtIndex:(indexPath.row-1)];
        heightOfText = [Utility heightFromString:aComment.content maxWidth:210 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT_DETAIL]];
    }
    
    if (heightOfText <= 45)
        heightOfText = heightOfText + 10;
    else
        heightOfText = heightOfText + 20;
    
    // fill data into cell
    CGRect frame = cell.txtViewComment.frame;
    frame.size.height = heightOfText;
    cell.txtViewComment.frame= frame;
    [Utility setHTMLContent:[Utility convertTextInit:aComment.content] forTextView:cell.txtViewComment];
    cell.txtViewComment.textColor = [UIColor whiteColor];
    
    //-- custom avatar of user to circle
    [cell.imgViewAvatar setImageWithURL:[NSURL URLWithString:aComment.profileUser.userImage] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"]];
    cell.imgViewAvatar.tag = indexPath.row;
    cell.imgViewAvatar.userInteractionEnabled = YES;
    cell.imgViewAvatar.layer.borderWidth = 1.0f;
    cell.imgViewAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.imgViewAvatar.layer.cornerRadius = 15;
    cell.imgViewAvatar.layer.masksToBounds = YES;
    
    //--add tap gesture
    UITapGestureRecognizer *tapSelectAvt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToTapDetailComments:)];
    [cell.imgViewAvatar addGestureRecognizer:tapSelectAvt];
    
    cell.lblNickName.text = aComment.profileUser.fullName;
    cell.lblPoint.text = aComment.profileUser.point;
    NSDate *dateOfComment = [NSDate dateWithTimeIntervalSince1970:[aComment.timeStamp doubleValue]];
    cell.lblDateTime.text = [Utility relativeTimeFromDate:dateOfComment];

    return cell;
}

- (void)clickToTapDetailComments:(UIGestureRecognizer *)sender
{
    NSInteger indexAlbum = [sender view].tag;
    
    Comment *aComment = nil;
    
    if (indexAlbum == 0) {
        
        aComment = self.superComment;
    } else {
        aComment = [self.superComment.arrSubComments objectAtIndex:(indexAlbum - 1)];
    }
    
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


-(void) resizeContainSizeOfTableView
{
    CGFloat heightOfTable = 0;
    
    for (NSInteger i = 0; i < ([self.superComment.arrSubComments count]); i++)
    {
        Comment *aComment = [self.superComment.arrSubComments objectAtIndex:i];
        // set height for table
        
        CGFloat heightForRow = 0;
        CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:210 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT_DETAIL]];
        heightForRow = heightOfText + 30;
        
        if (heightForRow < 70)
            heightForRow = 70;
        
        heightOfTable += heightForRow;
    }
    
    CGFloat heightOfTextSuperComment = [Utility heightFromString:self.superComment.content maxWidth:255 font:[UIFont systemFontOfSize:FONT_SIZE_FOR_COMMENT_DETAIL]];
    CGFloat heightForRowSuperComment = heightOfTextSuperComment + 30;
    
    heightOfTable +=heightForRowSuperComment;
    _tableViewDetailComments.contentSize = CGSizeMake(_tableViewDetailComments.frame.size.width, heightOfTable);
}


-(void) refreshData:(ODRefreshControl *) refreshControl
{
    [refreshControl beginRefreshing];
    [_tableViewDetailComments reloadData];
    [refreshControl endRefreshing];
}



#pragma mark - actions

-(void)back:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
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
-(void) cancelComment
{
    [super cancelComment];
    
    _isClickComment = NO;
}


-(void) postComment
{
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *content = [self getContentOfComment];
    if (!content || [content length]==0)
        return;
    
    [super postComment];
    
    Comment *commentForNews = [Comment new];
    commentForNews.commentId = [Utility idFromTimeStamp];
    commentForNews.content = content;
    commentForNews.timeStamp = [Utility idFromTimeStamp];
    commentForNews.profileUser = [Profile sharedProfile];
    commentForNews.profileUser.point = [Profile sharedProfile].point;
    commentForNews.arrSubComments = [NSMutableArray new];
    
    [self.superComment.arrSubComments addObject:commentForNews];
    [_tableViewDetailComments reloadData];
    
    [_tableViewDetailComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.superComment.arrSubComments.count) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self resizeContainSizeOfTableView];
    
    if (dataCenter.isNews == YES) {
        [self callAPISyncData:kTypeComment text:content contentId:nodeId contentTypeId:TYPE_ID_NEWS commentId:self.superComment.commentId];
    }
    
    if (dataCenter.isPhotoView == YES) {
        [self callAPISyncData:kTypeComment text:content contentId:nodeId contentTypeId:TYPE_ID_PHOTO commentId:self.superComment.commentId];
    }
    
    if (dataCenter.isSchedule == YES) {
        [self callAPISyncData:kTypeComment text:content contentId:nodeId contentTypeId:TYPE_ID_EVENT commentId:self.superComment.commentId];
    }
    
    if (dataCenter.isMusic == YES) {
        [self callAPISyncData:kTypeComment text:content contentId:nodeId contentTypeId:TYPE_ID_MUSIC_SONG commentId:self.superComment.commentId];
    }
    
    if (dataCenter.isVideo == YES) {
        [self callAPISyncData:kTypeComment text:content contentId:nodeId contentTypeId:TYPE_ID_VIDEO commentId:self.superComment.commentId];
    }
    
    _isClickComment = NO;
}


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
    
    //-- pass delegate to screen before
    if ([self.delegateDetailComment respondsToSelector:@selector(subCommentSuccessDelegate)]) {
        [self.delegateDetailComment subCommentSuccessDelegate];
    }
}


#pragma mark - Base view controller delegate
- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
    //_isProcessLikeAPI = false;
}

- (void)baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    if (_isClickComment) {
        //-- post comment
        [self showDialogComments:CGPointZero title:@"Bình luận"];
    }
}



@end
