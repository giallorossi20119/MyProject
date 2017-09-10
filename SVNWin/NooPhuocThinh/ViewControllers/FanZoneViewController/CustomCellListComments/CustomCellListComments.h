//
//  CustomCellListComments.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/5/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

typedef enum{
    
    CellCustomFanZoneHomeTypeLeft = 0,
    CellCustomFanZoneHomeTypeRight = 1
   
}CellCustomFanZoneHomeType;

#import <UIKit/UIKit.h>

@interface CustomCellListComments : UITableViewCell
{
    
}

@property (nonatomic, retain) IBOutlet UILabel      *lblContent;
@property (nonatomic, retain) IBOutlet UILabel      *lblTimer;
@property (nonatomic, retain) IBOutlet UILabel      *lblNumberCmt;
@property (nonatomic, retain) IBOutlet UIImageView  *imageAvt;
@property (nonatomic, retain) IBOutlet UIImageView  *imageBackgroundCmt;
@property (nonatomic, retain) IBOutlet UIImageView  *imageLine;
@property (nonatomic, retain) IBOutlet UIView       *viewCountComment;

+ (CustomCellListComments *) cellWithCustomType:(CellCustomFanZoneHomeType)cellCustomFanZoneHomeType;

@end
