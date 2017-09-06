//
//  HomeFeedVideoCell.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/22/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeFeedVideoCell.h"

@implementation HomeFeedVideoCell

@synthesize wvImage,UserImage,FeedTitle,Username,TimePost,Description,NoView,NoLike,NoComment,NoShare,btnComment,btnLike,btnShare;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
