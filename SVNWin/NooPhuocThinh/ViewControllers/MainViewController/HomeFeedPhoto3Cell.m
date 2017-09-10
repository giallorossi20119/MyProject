//
//  HomeFeedPhoto3Cell.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 11/16/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeFeedPhoto3Cell.h"

@implementation HomeFeedPhoto3Cell
@synthesize UserImage,Username,FeedTitle,TimePost,btnComment,btnLike,btnShare,Description,NoComment,NoLike,NoShare,NoView;
@synthesize FeedImage31,FeedImage32,FeedImage33;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
