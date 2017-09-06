//
//  CustomCellScheduleHome.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/27/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellScheduleHome : UITableViewCell
{
    //
}
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, retain) IBOutlet UILabel          *lblMonth;
@property (nonatomic, retain) IBOutlet UILabel          *lblDay;
@property (nonatomic, retain) IBOutlet UILabel          *lblEventTitle;
@property (nonatomic, retain) IBOutlet UILabel          *lblCity;
@property (nonatomic, retain) IBOutlet UILabel          *lblAddress;
@property (nonatomic, retain) IBOutlet UILabel          *lblTimer;

@end
