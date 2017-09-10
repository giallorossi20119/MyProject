//
//  HomeFeedPhoto1Cell.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 11/11/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeFeedPhoto1Cell.h"

@implementation HomeFeedPhoto1Cell
@synthesize UserImage,Username,FeedTitle,TimePost,btnComment,btnLike,btnShare,Description,NoComment,NoLike,NoShare,NoView;
@synthesize FeedImage1;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
