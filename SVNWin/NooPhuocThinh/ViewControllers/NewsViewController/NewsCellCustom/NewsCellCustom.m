//
//  NewsCellCustom.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "NewsCellCustom.h"

@implementation NewsCellCustom

@synthesize imgViewBackground,
imgViewAvatar,
lblTitle,
lblShortContent,
lblCommentCount,
btnComment, lblDate;

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

+ (NewsCellCustom *) cellWithCustomType:(NewsCellCustomType) cellCustomEventType {
    
    NSArray *objectLevelTop = [[NSBundle mainBundle] loadNibNamed:@"NewsCellCustom" owner:nil options:nil];
    
    return  (id)[objectLevelTop objectAtIndex:cellCustomEventType];
    
}

@end
