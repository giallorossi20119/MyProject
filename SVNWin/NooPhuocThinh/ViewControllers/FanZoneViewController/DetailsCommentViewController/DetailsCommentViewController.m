//
//  DetailsCommentViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/5/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "DetailsCommentViewController.h"

@interface DetailsCommentViewController ()

@end

@implementation DetailsCommentViewController

@synthesize superComment;

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
    [_tableDetailCmt setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableDetailCmt setSeparatorColor:COLOR_SEPARATOR_CELL];
    _tableDetailCmt.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _isClickComment = NO;
    _isAutoScroll = YES;
    _countCommentLocal = 0;
    
    //-- alloc array
    _arrDataSource  = [[NSMutableArray alloc] init];
    
    //-- custom navigation bar
    [self customNavigationBar];
    
    //-- set background for view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [self setupData];
}


- (void) setupData
{
    //-- set delegate from BaseVC
    [self setDelegateBaseController:self];
    
    //-- fetching data
    [self fetchingDataComment];
    
    //--set frame for button avatar
    UIButton *btnSelectAvt = [[UIButton alloc] initWithFrame:CGRectMake(_imgAvatar.frame.origin.x, _imgAvatar.frame.origin.y, _imgAvatar.frame.size.width, _imgAvatar.frame.size.height)];
    btnSelectAvt.highlighted = NO;
    
    //--add tap gesture
    UITapGestureRecognizer *tapSelectAvt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToTap:)];
    [btnSelectAvt addGestureRecognizer:tapSelectAvt];
    [self.view addSubview:btnSelectAvt];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Detail Comment Fanzone Screen";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)customNavigationBar
{
    [self setTitle:@"Fanzone"];
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- comment button
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame= CGRectMake(15, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(clickToBtnCreateComment:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barItemRight;
}



#pragma mark - ACTION

- (void)saveNumberOfComment
{
    self.superComment.numberOfSubcommments = [NSString stringWithFormat:@"%d",[self.superComment.arrSubComments count]];
    [VMDataBase updateShoutBoxData:self.superComment];
}


- (void)clickToTap:(UIGestureRecognizer *)sender
{
    ProfileViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idProfileViewControllerSb"];
    NSString *userId = self.superComment.profileUser.userId;
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


- (IBAction)clickBack:(id)sender
{
    [self saveNumberOfComment];

    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - Call API get data

- (void)fetchingDataComment
{
    if (!_activityIndicator)
        [_activityIndicator startAnimating];
    
    [API getShoutBoxDataComment:self.superComment.commentId
                      startTime:@""
                        endTime:@""
                          limit:@"100"
                   productionId:PRODUCTION_ID
              productionVersion:PRODUCTION_VERSION
                      completed:^(NSDictionary *responseDictionary, NSError *error) {
                          NSLog(@"createDataSourceCommentFromDict: %@",responseDictionary);
                          [self createDataSourceCommentFromDict:responseDictionary];
    }];
}


- (void)createDataSourceCommentFromDict:(NSDictionary*)dict
{
    NSArray *arrData = [dict objectForKey:@"data"];
    if ([arrData count] >0) {
        
        NSMutableArray *dataComment = [[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"];
        
        /*
        //-- delete message at local
        if (_countCommentLocal > 0 && [dataComment count] >0)
        {
            for (NSInteger i = _countCommentLocal; i > 0; i--)
            {
                _countCommentLocal--;
                
                NSInteger indexDelete = [_arrDataSource count] - 1;
                [_arrDataSource removeObjectAtIndex:indexDelete];
            }
        }
         */
        [self.superComment.arrSubComments removeAllObjects];
        
        CGFloat heightAllRow = 0;
        
        for (NSInteger i = 0; i < dataComment.count; i ++) {
            
            NSString *tmpID = [[dataComment objectAtIndex:i] objectForKey:@"shout_id"];
            
            if (![[ self.superComment.arrSubComments valueForKey:@"commentId"] containsObject:tmpID]) {
                
                NSDictionary *dict  = (NSDictionary *)[dataComment objectAtIndex:i];
                Profile *profile    = [Profile new];
                profile.userId      = [dict objectForKey:@"user_id"];
                profile.userName    = [dict objectForKey:@"user_name"];
                profile.fullName    = [dict objectForKey:@"full_name"];
                profile.userImage   = [dict objectForKey:@"user_image"];
                profile.point       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user_point"]];
                
                Comment *comment                = [[Comment alloc] init];
                comment.commentId               = [dict objectForKey:@"shout_id"];
                comment.commentSuperId          = self.superComment.commentId;
                comment.content                 = [dict objectForKey:@"text"];
                comment.timeStamp               = [dict objectForKey:@"time_stamp"];
                comment.numberOfSubcommments    = [dict objectForKey:@"number_of_subcomments"];
                comment.arrSubComments          = [NSMutableArray new];
                comment.profileUser             = profile;
                
                [self.superComment.arrSubComments addObject:comment];
                
                //-- get hieght
                CGFloat heightText = [Utility heightFromString:comment.content maxWidth:255 font:[UIFont systemFontOfSize:13.0f]];
                
                heightAllRow += heightText + 60;
            }
        }
        
        [_tableDetailCmt reloadData];
        [self performSelector:@selector(adjustTableAndScroll) withObject:nil afterDelay:0.5];
        
//        CGRect frameTB = [_tableDetailCmt frame];
//        frameTB.size.height = heightAllRow + _viewHeader.frame.size.height + 100;
//        [_tableDetailCmt setFrame:frameTB];
//        
//        //-- resize scrollView's content size
//        _scrollContainer.contentSize = CGSizeMake(320,frameTB.size.height);
    }
    
    [_activityIndicator stopAnimating];
}
-(void)adjustTableAndScroll {
    CGRect frame = _tableDetailCmt.frame;
    frame.size.height = _tableDetailCmt.contentSize.height;
    _tableDetailCmt.frame = frame;
    _scrollContainer.contentSize = frame.size;
}


#pragma mark - comments

- (IBAction)clickToBtnCreateComment:(id)sender
{
    _isClickComment = YES;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID]) {
        
        //-- thông báo nâng cấp user
        [self showMessageUpdateLevelOfUser];
    }
    else
    {
        if (_isClickComment) {
            //-- post comment
            [self showDialogComments:CGPointZero title:@"Bình luận"];
        }
    }
}


-(void) postComment
{
    NSString *content = [self getContentOfComment];
    if (!content || [content length]==0)
        return;
    [self apiPostComment:content];
    
    [super postComment];
    
    Comment *commentForAComment = [Comment new];
    commentForAComment.commentId = @"0";
    commentForAComment.content = content;
    commentForAComment.timeStamp = [Utility idFromTimeStamp];
    commentForAComment.profileUser = [Profile sharedProfile];
    commentForAComment.profileUser.point = [Profile sharedProfile].point;
    commentForAComment.numberOfSubcommments = @"0";
    commentForAComment.arrSubComments = [NSMutableArray new];
    
    [self.superComment.arrSubComments addObject:commentForAComment];
    
    _countCommentLocal++;
    
    NSInteger heightAllRow = 0;
    
    for (NSInteger i = 0; i < self.superComment.arrSubComments.count; i ++) {
        
        //-- get hieght
        CGFloat heightText = [Utility heightFromString:commentForAComment.content maxWidth:255 font:[UIFont systemFontOfSize:13.0f]];
        
        heightAllRow += heightText + 50;
    }
    
//    CGRect frameTB = [_tableDetailCmt frame];
//    frameTB.size.height = heightAllRow + _viewHeader.frame.size.height + 100;
//    [_tableDetailCmt setFrame:frameTB];
//    //-- resize scrollView's content size
//    _scrollContainer.contentSize = CGSizeMake(320,_tableDetailCmt.contentSize.height);
    
    [_tableDetailCmt reloadData];
    [self performSelector:@selector(adjustTableAndScroll) withObject:nil afterDelay:0.5];

//    [_tableDetailCmt scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.superComment.arrSubComments count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    _isClickComment = NO;
}


- (void)apiPostComment:(NSString *)content
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:MY_ACCOUNT_ID];
    
    [API postCommentFanzone:SINGER_ID
                  fanzoneId:self.superComment.commentId
                     userId:userId
                       text:content
           isGetNewShoutBox:@"0"
                  startTime:@""
                    endTime:@""
                      limit:@"100"
               productionId:PRODUCTION_ID
          productionVersion:PRODUCTION_VERSION
                  completed:^(NSDictionary *responseDictionary, NSError *error) {
                      //create datasource
                      NSLog(@"postCommentFanzone success");
                      //longnh
                      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                      [userDefaults setObject:@"1" forKey:Key_Refresh_Now];
                      [userDefaults synchronize];
                      //-- reload data
                      [self fetchingDataComment];
                  }];
}


- (void)cancelComment
{
    [super cancelComment];
    
    _isClickComment = NO;
}


#pragma mark - Base view controller delegate

- (void)notifyReceiveSyncAPIResponse:(bool)isSuccess;
{
//    _isProcessLikeAPI = false;
}

- (void)baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    if (_isClickComment) {        
        //-- post comment
        [self showDialogComments:CGPointZero title:@"Bình luận"];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.superComment.arrSubComments count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *aComment =  [self.superComment.arrSubComments objectAtIndex:indexPath.row];
    CGFloat heightText = [Utility heightFromString:aComment.content maxWidth:255 font:[UIFont systemFontOfSize:13.0f]];
    CGFloat heightRow = 0;

    if (heightText < 45)
        heightRow = 70;
    else
        heightRow = heightText + 60;
    NSLog(@"row:%d height:%f",indexPath.row,heightRow);
    return heightRow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierLeft = @"idCustomCellDetailCommentSb";
    
    CustomCellDetailComment *cell = [_tableDetailCmt dequeueReusableCellWithIdentifier:identifierLeft];
    
    //-- set background color
    if (indexPath.row % 2 == 0)
        cell.contentView.backgroundColor = COLOR_BG_CELL_0;
    else
        cell.contentView.backgroundColor = COLOR_BG_CELL_1;
    
    if (indexPath.row == 0)
        cell.imgLine.alpha = 1;
    else
        cell.imgLine.alpha = 0;
    
    //-- datasource
    Comment *aComment =  [self.superComment.arrSubComments objectAtIndex:indexPath.row];
    
    //-- layer avatar image
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.avtFriend.layer.masksToBounds = YES;
    cell.avtFriend.layer.cornerRadius = 15;
    cell.avtFriend.layer.borderWidth = 1.0;
    cell.avtFriend.layer.borderColor = [[UIColor whiteColor] CGColor];
    [cell.avtFriend setImageWithURL:[NSURL URLWithString:aComment.profileUser.userImage] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"]];
    
    //-- dynamic content textview
    NSLog(@"comment:%@",aComment.content);
    CGFloat heightOfText = [Utility heightFromString:aComment.content maxWidth:255 font:[UIFont systemFontOfSize:13.0f]];
    
    if (heightOfText < 45) {
        heightOfText = 45;
    } else {
        heightOfText = heightOfText + 20;
    }
    NSLog(@"heightOfText:%f",heightOfText);
    
    CGRect frame = cell.txtContentChat.frame;
    frame.size.height = heightOfText;
    cell.txtContentChat.frame= frame;
    [Utility setHTMLContent:[Utility convertTextInit:aComment.content] forTextView:cell.txtContentChat];
    [cell.txtContentChat setFont:[UIFont systemFontOfSize:13.0f]];
    cell.txtContentChat.scrollEnabled = NO;
    cell.txtContentChat.userInteractionEnabled = NO;
    cell.txtContentChat.editable = NO;
    cell.txtContentChat.textColor = [UIColor whiteColor];
    
    //-- content name
    NSString *nameStr = aComment.profileUser.fullName;
    cell.lblNameFriend.text = [NSString stringWithFormat:@"%@",nameStr];
    
    //-- time
    NSString *timeStr = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[aComment.timeStamp integerValue]]];
    cell.lblTimeChat.text = [NSString stringWithFormat:@"%@",timeStr];
    
    //-- content user point
    cell.lblPointOfUser.text = aComment.profileUser.point;
    
    return cell;
}



#pragma mark - UITableviewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //-- set image avatar
    [_imgAvatar setImageWithURL:[NSURL URLWithString:superComment.profileUser.userImage] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"]];
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius = 25;
    _imgAvatar.layer.borderWidth = 1.0;
    _imgAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //-- show fullname
    _lblFullName.text = self.superComment.profileUser.fullName;
    
    //-- show content
    NSString *aaa = [NSString stringWithFormat:@"%@",self.superComment.content];
    _txvContent.text = aaa;
    
    //-- show time label and frame
    _lblTime.text = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[self.superComment.timeStamp integerValue]]];
    
    //-- show content label and frame
    CGFloat heightText = [Utility heightFromString:aaa maxWidth:270 font:[UIFont systemFontOfSize:13.0f]];
    CGFloat heightLabel = 0;
    
    if (heightText < 28) {
        heightLabel = 30;
        
        _txvContent.frame = CGRectMake(_txvContent.frame.origin.x, _txvContent.frame.origin.y, _txvContent.frame.size.width, _txvContent.frame.size.height+ 20);
        
        //-- frame time label
        _lblTime.frame = CGRectMake(_lblTime.frame.origin.x, _lblTime.frame.origin.y , _lblTime.frame.size.width, _lblTime.frame.size.height);
        
        //-- frame time label
        _imgLine.frame = CGRectMake(_imgLine.frame.origin.x, _imgLine.frame.origin.y, _imgLine.frame.size.width, _imgLine.frame.size.height);
        
        //-- resize scrollView's content size
        _scrollContainer.contentSize = CGSizeMake(320,_tableDetailCmt.contentSize.height);
        
    }else{
        heightLabel = heightText + 10;
        
        _txvContent.frame = CGRectMake(_txvContent.frame.origin.x, _txvContent.frame.origin.y, _txvContent.frame.size.width, _txvContent.frame.size.height + heightLabel - 15);
        
        //-- frame time label
        _lblTime.frame = CGRectMake(_lblTime.frame.origin.x, _txvContent.frame.origin.y + heightLabel + 15, _lblTime.frame.size.width, _lblTime.frame.size.height);
        
        //-- frame time label
        _imgLine.frame = CGRectMake(_imgLine.frame.origin.x, _imgLine.frame.origin.y + heightText - 15, _imgLine.frame.size.width, _imgLine.frame.size.height);
        
        //-- resize scrollView's content size
        _scrollContainer.contentSize = CGSizeMake(320, heightText - 15 + _tableDetailCmt.contentSize.height);
    }
    
    return _viewHeader;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //-- show content label and frame
    CGFloat heightText = [Utility heightFromString:self.superComment.content maxWidth:270 font:[UIFont systemFontOfSize:13.0f]];
    
    NSInteger heightHeader = 0;
    
    if (heightText < 28) {
        
        heightHeader = 121;
        
    }else{
        
        heightHeader = 121 + heightText - 18;
    }
    
    return heightHeader;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}



#pragma mark - reload

- (void)addRefreshAndLoadMoreForTableView:(UITableView *)aTableview
{
    //-- refresh data
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableDetailCmt];
    [refreshControl addTarget:self action:@selector(refreshDataComments:) forControlEvents:UIControlEventValueChanged];
}


-(void)refreshDataComments:(ODRefreshControl *)refreshControl
{
    [refreshControl beginRefreshing];
    [self fetchingDataComment];
    [refreshControl endRefreshing];
}



@end
