//
//  WifiLoginView.h
//  NooPhuocThinh
//
//  Created by longnh on 3/5/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiLoginView : UIView
{
    
}

@property (nonatomic, retain) IBOutlet UIView *viewTop;
@property (nonatomic, retain) IBOutlet UIView *viewBottom;
@property (nonatomic, retain) IBOutlet UIImageView *imgBackground;

@property (nonatomic, retain) IBOutlet UILabel *lblTitleLogin;
@property (nonatomic, retain) IBOutlet UITextView *txtMessageLogin;

@property (nonatomic, retain) IBOutlet UITextField *txtPhoneNumber;
@property (nonatomic, retain) IBOutlet UITextField *txtPassWord;

@property (nonatomic, retain) IBOutlet UIButton *btnLogin;
@property (nonatomic, retain) IBOutlet UIButton *btnCreateAccount;
@property (nonatomic, retain) IBOutlet UIButton *btnExist;

@property (nonatomic, retain) IBOutlet UIButton *btnForgotPassword;
@property (nonatomic, retain) IBOutlet UILabel *lblForgotPassword;

@end
