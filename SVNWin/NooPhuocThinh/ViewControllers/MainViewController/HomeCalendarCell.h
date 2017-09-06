//
//  HomeCalendarCell.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/21/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCalendarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imvCalendar;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDatetime;

@end
