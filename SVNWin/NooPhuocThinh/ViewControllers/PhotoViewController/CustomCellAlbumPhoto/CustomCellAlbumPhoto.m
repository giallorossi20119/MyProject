//
//  CustomCellAlbumPhoto.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/25/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "CustomCellAlbumPhoto.h"

@implementation CustomCellAlbumPhoto

@synthesize lblAlbumTitle, imgCover, lblAlbumNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
