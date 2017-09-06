//
//  CustomCellScheduleHome.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/27/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "CustomCellScheduleHome.h"

@implementation CustomCellScheduleHome

@synthesize lblAddress, lblCity, lblDay, lblMonth, lblTimer, lblEventTitle, imgView;

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
