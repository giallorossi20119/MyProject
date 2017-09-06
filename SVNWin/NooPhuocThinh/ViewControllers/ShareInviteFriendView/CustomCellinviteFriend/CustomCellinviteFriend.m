//
//  CustomCellinviteFriend.m
//  NooPhuocThinh
//
//  Created by longnh on 4/16/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "CustomCellinviteFriend.h"

@implementation CustomCellinviteFriend

@synthesize imgAvatar, imgBgCell, lblUserName;

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
