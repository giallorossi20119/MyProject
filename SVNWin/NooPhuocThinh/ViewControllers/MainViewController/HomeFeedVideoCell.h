//
//  HomeFeedVideoCell.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/22/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HomeFeedVideoCell : UITableViewCell
{
    MPMoviePlayerController *player;
}
@property (strong, nonatomic) IBOutlet UIWebView *wvImage;
@property (weak, nonatomic) IBOutlet UILabel *Username;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
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

@end
