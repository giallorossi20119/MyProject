//
//  PhotoAlbumViewCell.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/2/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"

@interface PhotoAlbumViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView          *imgArrow;
@property (nonatomic, retain) IBOutlet CBAutoScrollLabel    *lblAlbumTitle;
@property (nonatomic, retain) IBOutlet UILabel              *lblAlbumNumber;

@end
