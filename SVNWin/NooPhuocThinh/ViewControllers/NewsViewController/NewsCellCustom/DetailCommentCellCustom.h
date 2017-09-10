//
//  DetailCommentCellCustom.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/10/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCommentCellCustom : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewAvatar;
@property (weak, nonatomic) IBOutlet UITextView  *txtViewComment;
@property (weak, nonatomic) IBOutlet UILabel     *lblNickName;
@property (weak, nonatomic) IBOutlet UILabel     *lblPoint;
@property (weak, nonatomic) IBOutlet UILabel     *lblDateTime;
@property (weak, nonatomic) IBOutlet UIView      *viewInfo;

@end
