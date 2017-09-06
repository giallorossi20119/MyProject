//
//  HomeFeedPageCell.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/27/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeFeedPageCell.h"

@implementation HomeFeedPageCell

@synthesize UserImage,Username,FeedTitle,TimePost,Description,NoView,NoComment,NoLike,NoShare,btnComment,btnLike,btnShare;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
