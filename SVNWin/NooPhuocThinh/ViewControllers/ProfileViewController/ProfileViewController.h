//
//  ProfileViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellProfileInfo.h"
#import "User.h"
#import "Profile.h"
#import "UIImageView+WebCache.h"
#import "ProfileDetailViewController.h"
#import "CBAutoScrollLabel.h"
#import "UIView+VMODEV.h"


typedef enum
{
    ProfileTypeMyAccount,
    ProfileTypeGuess
    
}ProfileType;

@interface ProfileViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, BaseViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UIButton           *_btnBack;
    NSMutableArray              *_listProfiles;
    NSMutableArray              *_listResults;
    NSMutableArray              *_listIcons;
    Profile                     *_profile;
    IBOutlet UIView             *_viewUpgrade;
    
    BOOL isSelectedProfile;
}

@property (nonatomic, assign) BOOL isSelectedProfile;

@property (nonatomic, retain) IBOutlet UITableView               *tableViewProfile;
@property (nonatomic, retain) IBOutlet UIImageView               *avtProfile;
@property (nonatomic, retain) IBOutlet UILabel                   *lblFullName;
@property (nonatomic, weak)   IBOutlet CBAutoScrollLabel         *autoFullName;
@property (nonatomic, retain) IBOutlet UILabel                   *lblOnlOff;
@property (nonatomic, retain) IBOutlet UILabel                   *lblScore;
@property (nonatomic, retain) IBOutlet UILabel                   *lblRating;
@property (nonatomic, retain) IBOutlet UILabel                   *txtStatus;
@property (nonatomic, retain) IBOutlet UILabel                   *lblJoinDate;
@property (nonatomic, retain) IBOutlet UIImageView               *imgLogoLevelOfUser;
@property (nonatomic, retain) IBOutlet UIView                    *viewStatus;
@property (nonatomic, retain) IBOutlet UIButton                  *btnStatus;
@property (nonatomic, retain) IBOutlet UIScrollView              *scrollProfile;
@property (nonatomic, retain) IBOutlet UIView                    *userView;
@property (nonatomic, retain) IBOutlet UIButton                  *btnUserVip;
@property (nonatomic, retain) IBOutlet UIButton                  *btnSuperVip;
@property (nonatomic, retain) IBOutlet UIButton                  *btnUserLevelStatus;

//-- passed from class another
@property (nonatomic, retain) NSString                           *userId;
@property (nonatomic, assign) ProfileType                        profileType;

- (IBAction)showDialogStatus:(id)sender;

@end
