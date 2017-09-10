//
//  CustomCellListComments.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/5/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "CustomCellListComments.h"

@implementation CustomCellListComments

@synthesize lblContent, lblNumberCmt, lblTimer;
@synthesize imageAvt, imageBackgroundCmt, imageLine, viewCountComment;

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

+ (CustomCellListComments *) cellWithCustomType:(CellCustomFanZoneHomeType)cellCustomFanZoneHomeType{
    
    NSArray *objectLevelTop = [[NSBundle mainBundle] loadNibNamed:@"CustomCellListComments" owner:nil options:nil];
    
    return  (id)[objectLevelTop objectAtIndex:cellCustomFanZoneHomeType];
}


@end
