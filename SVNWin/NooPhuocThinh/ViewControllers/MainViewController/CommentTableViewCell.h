//
//  CommentTableViewCell.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 11/26/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView   *imgAvatar;
@property (nonatomic, retain) IBOutlet UIImageView   *imgBackground;
@property (nonatomic, retain) IBOutlet UILabel       *lblNickName;
@property (nonatomic, retain) IBOutlet UILabel       *lblPointOfUser;
@property (nonatomic, retain) IBOutlet UILabel       *lblDateTime;
@property (nonatomic, retain) IBOutlet UILabel       *lblTotalChildComment;
@property (nonatomic, retain) IBOutlet UITextView    *txtViewComment;
@property (nonatomic, retain) IBOutlet UIButton      *btnShowListComments;
@property (nonatomic, retain) IBOutlet UIView        *viewInfo;

@end
