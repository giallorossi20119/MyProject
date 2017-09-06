//
//  CommentCellCustom.m
//  NooPhuocThinh
//
//  Created by HuntDo on 12/6/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "CommentCellCustom.h"

@implementation CommentCellCustom

@synthesize imgAvatar, imgBackground, lblNickName, lblPointOfUser,lblDateTime, txtViewComment, btnShowListComments;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
