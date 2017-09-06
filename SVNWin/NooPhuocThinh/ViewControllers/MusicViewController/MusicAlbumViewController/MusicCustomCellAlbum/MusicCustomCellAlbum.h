//
//  MusicCustomCellAlbum.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"
#import "AudioButton.h"

@interface MusicCustomCellAlbum : UITableViewCell
{
    UIImageView *loadingView;
}

@property (nonatomic, retain) IBOutlet UIImageView   *imgBgCell;
@property (weak)              IBOutlet CBAutoScrollLabel     *lblArtist;
@property (nonatomic, retain) IBOutlet UIButton      *btnPlay;
@property (nonatomic, retain) IBOutlet UIButton      *btnPhone;
@property (nonatomic, retain) IBOutlet UIButton      *btnDownload;

@property (strong, nonatomic) AudioButton *audioButton;

- (void)configurePlayerButton;

#pragma mark Spin for cell

- (void)startSpinWithCell;
- (void)stopSpinWithCell;

@end
