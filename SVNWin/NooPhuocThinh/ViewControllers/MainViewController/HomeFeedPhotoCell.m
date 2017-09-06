//
//  HomeFeedPhotoCell.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/16/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeFeedPhotoCell.h"

@implementation HomeFeedPhotoCell

@synthesize UserImage,Username,FeedTitle,TimePost,btnComment,btnLike,btnShare,Description,NoComment,NoLike,NoShare,NoView;
@synthesize FeedImage1,FeedImage21,FeedImage22,FeedImage31,FeedImage32,FeedImage33,FeedImage41,FeedImage42,FeedImage43,FeedImage44, FeedImage51,FeedImage52,FeedImage53,FeedImage54,FeedImage55;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
