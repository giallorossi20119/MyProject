//
//  CellCustomStore.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 1/6/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "CellCustomStore.h"

@implementation CellCustomStore

@synthesize imvProduct1,imvProduct2,lblPrice1,lblPrice2,lblTitle1,lblTitle2;

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

+ (CellCustomStore *) cellWithCustomType:(CellCustomStoreType) cellCustomEventType
{
    
    NSArray *objectLevelTop = [[NSBundle mainBundle] loadNibNamed:@"CellCustomStore" owner:nil options:nil];
    
    return  (id)[objectLevelTop objectAtIndex:cellCustomEventType];
}

@end
