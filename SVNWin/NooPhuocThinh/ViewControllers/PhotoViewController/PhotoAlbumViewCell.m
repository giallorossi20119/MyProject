//
//  PhotoAlbumViewCell.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/2/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "PhotoAlbumViewCell.h"

@implementation PhotoAlbumViewCell

@synthesize lblAlbumTitle,lblAlbumNumber,imgArrow;

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
