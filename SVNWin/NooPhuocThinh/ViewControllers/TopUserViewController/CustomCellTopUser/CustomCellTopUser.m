//
//  CustomCellTopUser.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "CustomCellTopUser.h"

@implementation CustomCellTopUser

@synthesize imgAvt, lblFullName, lblNumber, lblPoints;

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
