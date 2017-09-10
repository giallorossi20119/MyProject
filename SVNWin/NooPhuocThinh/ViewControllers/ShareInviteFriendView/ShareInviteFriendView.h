//
//  ShareInviteFriendView.h
//  NooPhuocThinh
//
//  Created by longnh on 4/16/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareInviteFriendView : UIView
{
    
}

//-- Share Invite
@property (nonatomic, retain) IBOutlet UIView *viewShareInvite;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UIButton *btnHiddenView;

@property (nonatomic, retain) IBOutlet UILabel *lblFacebook;
@property (nonatomic, retain) IBOutlet UIButton *btnFacebook;

@property (nonatomic, retain) IBOutlet UILabel *lblSMS;
@property (nonatomic, retain) IBOutlet UIButton *btnSMS;

@end
