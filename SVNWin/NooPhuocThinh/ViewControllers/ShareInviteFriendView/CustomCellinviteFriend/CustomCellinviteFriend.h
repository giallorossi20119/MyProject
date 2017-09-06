//
//  CustomCellinviteFriend.h
//  NooPhuocThinh
//
//  Created by longnh on 4/16/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"

@interface CustomCellinviteFriend : UITableViewCell
{
    
}

@property (nonatomic,retain) IBOutlet UIImageView *imgBgCell;
@property (nonatomic,retain) IBOutlet UIImageView *imgAvatar;
@property (weak) IBOutlet CBAutoScrollLabel *lblUserName;

@end
