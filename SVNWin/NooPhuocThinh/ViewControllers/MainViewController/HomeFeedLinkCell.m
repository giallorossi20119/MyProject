//
//  HomeFeedLinkCell.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/28/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeFeedLinkCell.h"

@implementation HomeFeedLinkCell
@synthesize UserImage,Username,FeedImage,FeedTitle,TimePost,Description,NoView,NoLike,NoComment,NoShare,btnComment,btnLike,btnShare,btnDescription;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
