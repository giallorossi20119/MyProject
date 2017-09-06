//
//  MusicCustomCellHome.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"

@interface MusicCustomCellHome : UITableViewCell
{
    UIImageView *loadingView;
}

@property (nonatomic, retain) IBOutlet UILabel               *lblTatca;
@property (weak)              IBOutlet UIImageView           *imgAvatar;
@property (nonatomic, retain) IBOutlet UIImageView           *imgArrowNext;
@property (weak)              IBOutlet CBAutoScrollLabel     *lblArtist;

@property (nonatomic, retain) IBOutlet UILabel               *lblHeadphone;
@property (nonatomic, retain) IBOutlet UIImageView           *imgHeadphone;
@property (nonatomic, retain) IBOutlet UILabel               *lblLike;
@property (nonatomic, retain) IBOutlet UIImageView           *imgLike;
@property (nonatomic, retain) IBOutlet UILabel               *lblDownload;
@property (nonatomic, retain) IBOutlet UIImageView           *imgDownload;
@property (nonatomic, retain) IBOutlet UILabel               *lblComment;
@property (nonatomic, retain) IBOutlet UIImageView           *imgComment;

#pragma mark Spin for cell

- (void)startSpinWithCell;
- (void)stopSpinWithCell;

@end
