//
//  VideosCustomCell.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/12/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "VideosCustomCell.h"

@implementation VideosCustomCell

@synthesize lblCategoryVideo, imgViewDetailIndicationCell, imgViewSeparatorCell;

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
