//
//  ProfileViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize avtProfile;
@synthesize lblFullName, lblJoinDate, lblOnlOff, lblRating, lblScore, txtStatus;
@synthesize tableViewProfile, userId, imgLogoLevelOfUser, viewStatus, scrollProfile;
@synthesize isSelectedProfile;
@synthesize userView,btnSuperVip,btnUserVip,btnUserLevelStatus;

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
    NSLog(@"%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //--custom navigation bar
    [self customNavigationBar];
    [tableViewProfile setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
    NSArray *arrList = [[NSArray alloc] initWithObjects:@"Total Point",
                        @"Likes",
                        @"Comments",
                        @"Post on FanZone",
                        @"Share",
                        @"Upgrade VIP",
                        @"Listen",
                        @"Watch Video", nil];
    
    NSArray *arrIcons = [[NSArray alloc] initWithObjects:@"Profile_totalpoint.png",
                        @"Profile_like.png",
                        @"Profile_comment.png",
                        @"Profile_Post.png",
                        @"Profile_share.png",
                        @"Profile_upgradevip.png",
                        @"Profile_listen.png",
                        @"Profile_watchvideo.png", nil];
    
    //-- alloc listprofiles
    _listProfiles   = [[NSMutableArray alloc] initWithArray:arrList];
    _listIcons      = [[NSMutableArray alloc] initWithArray:arrIcons];
    _listResults    = [NSMutableArray new];
    self.delegateBaseController = self;
    
    if (self.profileType == ProfileTypeMyAccount) {
        
        //-- allows change status
        self.txtStatus.userInteractionEnabled = YES;
        self.btnStatus.userInteractionEnabled = YES;
        
        if (!self.userId) { //-- haven't data of my account
            
            //-- thông báo nâng cấp user
            [self showMessageUpdateLevelOfUser];
        }
        else {
            
            if (isSelectedProfile) {
                
                [self fetchingProfileUserWithFacebookID:YES];
                
            }else {
                
                [self fetchingProfileUserWithFacebookID:NO];
            }
        }
    }

    if (self.profileType == ProfileTypeGuess) {
        
        //-- only view status
        self.txtStatus.userInteractionEnabled = NO;
        self.btnStatus.userInteractionEnabled = NO;
        
        if (!self.userId) { //-- haven't data of my account
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Không lấy được thông tin người dùng này!" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
            [self fetchingProfileUserWithFacebookID:NO];
    }
    
    [self setupUI];
}

-(void)setupUI
{
    [btnUserLevelStatus setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0]];
    btnUserLevelStatus.clipsToBounds = YES;
    btnUserLevelStatus.layer.cornerRadius = 10;
    btnUserLevelStatus.layer.borderColor = [UIColor clearColor].CGColor;
    btnUserLevelStatus.layer.borderWidth = 1.0f;
    
    [btnUserVip setBackgroundColor:[UIColor whiteColor]];
    btnUserVip.clipsToBounds = YES;
    btnUserVip.layer.cornerRadius = 10;
    btnUserVip.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnUserVip.layer.borderWidth = 1.0f;
    
    [btnSuperVip setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0]];
    btnSuperVip.clipsToBounds = YES;
    btnSuperVip.layer.cornerRadius = 10;
    btnSuperVip.layer.borderColor = [UIColor clearColor].CGColor;
    btnSuperVip.layer.borderWidth = 1.0f;
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer];
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    self.screenName = @"Profile Screen";
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"%s", __func__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom UI

-(void)customNavigationBar
{
    [self setTitle:@"Profile"];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    //-- back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(clickToBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barItemLeft;
}


#pragma mark - call api & cache

/*
 * get user's info
 */
- (void) fetchingProfileUserWithFacebookID:(BOOL) isParaFacebook
{
    NSLog(@"%s", __func__);
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Getting..."];
    
    NSString *fbUserId = @"";
    
    if (isParaFacebook == YES) {
        NSUserDefaults *defaultFacebookResult = [NSUserDefaults standardUserDefaults];
        NSDictionary *result =[defaultFacebookResult valueForKey:@"FacebookResult"];
        fbUserId = [result objectForKey:@"id"];
    }
    
    [API getUserInfo:self.userId withFaceBookID:fbUserId
        productionId:PRODUCTION_ID
   productionVersion:PRODUCTION_VERSION
          avatarSize:@"200"
           completed:^(NSDictionary *responseDictionary, NSError *error) {
        
        [self parseProfileWithDictinary:responseDictionary];
        [[SHKActivityIndicator currentIndicator] hideAfterDelayWithTime:1];
        
    }];
}

- (void) parseProfileWithDictinary:(NSDictionary *)aDictionary
{
    NSDictionary *dictData  =  [aDictionary objectForKey:@"data"];
    
    //longnh check truong hop accout da bi disable
    if (dictData == nil || [dictData objectForKey:@"user_id"] == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Tài khoản này hiện thời đang khóa nên không xem được thông tin"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Close", nil];
        [alert show];
        return;
    }
    
    if (dictData)
    {
        //-- get user's info
        _profile = [Profile new];
        _profile.userId         =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"user_id"]];
        _profile.userType       =  [dictData objectForKey:@"user_type"];
        _profile.fullName       =  [dictData objectForKey:@"full_name"];
        _profile.userImage      =  [dictData objectForKey:@"user_image"];
        _profile.point          =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"point"]];
        _profile.rankPosition   =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"rank_position"]];
        _profile.totalShare     =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"total_share"]];
        _profile.totalChat      =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"total_chat"]];
        _profile.totalLike      =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"total_like"]];
        _profile.audioView      =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"audio_view"]];
        _profile.videoView      =  [NSString stringWithFormat:@"%@",[dictData objectForKey:@"video_view"]];
        _profile.status         =  [dictData objectForKey:@"status"];
        _profile.userPremiumUpgrade = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"user_premium_upgrade"]];
        _profile.registerTime      = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"register_time"]];
        _profile.userStatusImage   =  [dictData objectForKey:@"user_status_image"];
        
        NSInteger totalCommentLevel1 = [[dictData objectForKey:@"total_comment"] integerValue];
        NSInteger totalCommentLevel2 = [[dictData objectForKey:@"total_comment_level_2"] integerValue];
        NSInteger totalSuperComment = totalCommentLevel1 + totalCommentLevel2;
        
        _profile.totalComment = [NSString stringWithFormat:@"%ld",(long)totalSuperComment];
        
        [Profile setProfile:_profile];
        
        [self showContentWithProfile:_profile];
    }
}


/*
 * write status
 */

- (IBAction)showDialogStatus:(id)sender
{
    [self setDelagateForTextComment:self];
    [self showDialogComments:CGPointZero title:@"Nhập trạng thái"];
}

//-- override
- (void)cancelComment
{
    NSLog(@"%s", __func__);
    [super cancelComment];
}

//-- override
- (void)postComment
{
    NSLog(@"%s", __func__);
    [super postComment];
    NSString *content = [self getContentOfComment];
    if (!content || [content length]==0)
        return;
    
    self.txtStatus.text = content;
    
    //CGSize sizeStatus = [Utility sizeFromString:content sizeMax:CGSizeMake(275, 57) font:[UIFont systemFontOfSize:12]];
    CGFloat heightText = [Utility heightFromString:content maxWidth:275 font:[UIFont systemFontOfSize:12]];
    
    [self changeSizeStatus:heightText];
    
    [self writeStatus:content];
}

- (void) writeStatus:(NSString *)status
{
   [API writeStatus:status
            user_id:self.userId
             app_id:APP_ID app_version:APP_VERSION
          completed:^(NSDictionary *responseDictionary, NSError *error) {
       
       [self parseResponseForStatus:responseDictionary];
      
   }];
}

- (void) parseResponseForStatus:(NSDictionary *)aDictionary
{
    NSString *message  =  [aDictionary objectForKey:@"message"];
    
    if ([message isEqualToString:@"Insert success"])
    {
        //-- save
        _profile.status = self.txtStatus.text;
        NSData *dataMyAccount = [NSKeyedArchiver archivedDataWithRootObject:_profile];
        [[NSUserDefaults standardUserDefaults] setObject:dataMyAccount forKey:MY_ACCOUNT_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark - Action

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];// this will do the trick
}

- (IBAction)clickToBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showContentWithProfile:(Profile *)aProfile
{
    //-- present to screen
    self.lblFullName.text   = aProfile.fullName;
    [self autoScrollText:aProfile.fullName];
    self.lblScore.text = [NSString stringWithFormat:@"%@ Scores",aProfile.point];
    self.lblRating.text = [NSString stringWithFormat:@"%@ Rating",aProfile.rankPosition];
    self.txtStatus.text     = aProfile.status;
    
    //CGSize sizeStatus = [Utility sizeFromString:aProfile.status sizeMax:CGSizeMake(275, 57) font:[UIFont systemFontOfSize:12]];
    CGFloat heightText = [Utility heightFromString:aProfile.status maxWidth:275 font:[UIFont systemFontOfSize:12]];

    [self changeSizeStatus:heightText];
    
    self.avtProfile.layer.masksToBounds = YES;
    self.avtProfile.layer.cornerRadius  = 44;
    self.avtProfile.layer.borderWidth   = 1.0;
    
    self.imgLogoLevelOfUser.layer.masksToBounds = YES;
    self.imgLogoLevelOfUser.layer.cornerRadius  = 4;
    self.imgLogoLevelOfUser.layer.borderWidth   = 1.0;
    
    self.avtProfile.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.avtProfile setImageWithURL:[NSURL URLWithString:aProfile.userImage] placeholderImage:[UIImage imageNamed:IMG_DEFAULT_AVATAR]];
    
    //-- fix size
    [self.avtProfile setContentMode:UIViewContentModeScaleAspectFill];
    [self.avtProfile setClipsToBounds:YES];
    [Utility scaleImage:self.avtProfile.image toSize:CGSizeMake(90, 90)];
    
    [self.imgLogoLevelOfUser setImageWithURL:[NSURL URLWithString:aProfile.userStatusImage] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"]];
    self.lblJoinDate.text = [NSString stringWithFormat:@"Tham gia từ ngày %@",[Utility stringFormatDayMonthYearFromUnixStamp:[aProfile.registerTime integerValue]]];
    
    //-- list results
    [_listResults addObject:aProfile.point];
    [_listResults addObject:aProfile.totalComment];
    [_listResults addObject:aProfile.totalLike];
    [_listResults addObject:aProfile.totalChat];
    [_listResults addObject:aProfile.totalShare];
    [_listResults addObject:aProfile.userPremiumUpgrade];
    [_listResults addObject:aProfile.audioView];
    [_listResults addObject:aProfile.videoView];
    
    //-- change contain size scroll
    [self.tableViewProfile reloadData];
    
}


- (void) changeSizeStatus:(CGFloat)height
{
    //-- resize view status
    if (height > 27) {
        [UIView view:self.viewStatus setHeight:height+5];
        [UIView view:self.btnStatus setHeight:height+5];
        [UIView view:self.txtStatus setHeight:height];
        
        [self changePositionViewsAndContentScrollView];
    }
    else
    {
        [UIView view:self.viewStatus setHeight:27];
        [UIView view:self.txtStatus setHeight:21];
        [self changePositionViewsAndContentScrollView];
    }
}

- (void) changePositionViewsAndContentScrollView
{
    //-- set content size for tableview profile
    self.tableViewProfile.contentSize = CGSizeMake(320, 8 * 40 + 300);
}

- (void)autoScrollText:(NSString*)text
{
    self.autoFullName.text = text;
    [self.autoFullName setFont:[UIFont boldSystemFontOfSize:18]];
    self.autoFullName.textColor = [UIColor blackColor];
    self.autoFullName.labelSpacing = 200; // distance between start and end labels
    self.autoFullName.pauseInterval = 0.3; // seconds of pause before scrolling starts again
    self.autoFullName.scrollSpeed = 45; // pixels per second
    self.autoFullName.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
    self.autoFullName.fadeLength = 12.f;
    self.autoFullName.shadowOffset = CGSizeMake(-1, -1);
    self.autoFullName.scrollDirection = CBAutoScrollDirectionLeft;
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 36)];
    if (_profile.registerTime)
    {
        lblDate.text = [NSString stringWithFormat:@"Have been registered at %@", [Utility stringFormatDayMonthYearFromUnixStamp:[_profile.registerTime integerValue]]];
    }
    else
    {
        lblDate.text = @"";
    }
    
    lblDate.font = [UIFont systemFontOfSize:13];
    lblDate.textColor = [UIColor grayColor];
    lblDate.textAlignment = NSTextAlignmentCenter;
    lblDate.backgroundColor = [UIColor clearColor];
    [view addSubview:lblDate];
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    view.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listResults count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"idCustomCellProfileInfoSb";
    
    CustomCellProfileInfo *cell = [self.tableViewProfile dequeueReusableCellWithIdentifier:identifier];
    if ([_listResults count] > 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblSubInfo.text = [_listProfiles objectAtIndex:indexPath.row];
        cell.lblNumberInfo.text = [_listResults objectAtIndex:indexPath.row];
        cell.imgIcon.image = [UIImage imageNamed:[_listIcons objectAtIndex:indexPath.row]];
    }
    //set custom separator for cell
    UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-1,cell.frame.size.width,1)];
    additionalSeparator.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    [cell addSubview:additionalSeparator];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click profile row: %ld", (long)indexPath.row);
}

#pragma textfield delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
}

#pragma mark - base view controller delegete

- (void) baseViewController:(BaseViewController *)baseViewController didCreateAccountSuscessful:(Profile *)Profile
{
    _profile= Profile;
    [self showContentWithProfile:_profile];
}

@end
