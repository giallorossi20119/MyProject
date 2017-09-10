//
//  HomeFeedPhotoCell.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/16/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeFeedPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *Username;
@property (weak, nonatomic) IBOutlet UILabel *FeedTitle;
@property (weak, nonatomic) IBOutlet UILabel *TimePost;
@property (weak, nonatomic) IBOutlet UILabel *Description;
@property (weak, nonatomic) IBOutlet UILabel *NoView;
@property (weak, nonatomic) IBOutlet UILabel *NoLike;
@property (weak, nonatomic) IBOutlet UILabel *NoComment;
@property (weak, nonatomic) IBOutlet UILabel *NoShare;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage1;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage21;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage22;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage31;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage32;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage33;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage41;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage42;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage43;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage44;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage51;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage52;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage53;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage54;
@property (weak, nonatomic) IBOutlet UIImageView *FeedImage55;
@property (weak, nonatomic) IBOutlet UILabel *MorePhoto;

@end
