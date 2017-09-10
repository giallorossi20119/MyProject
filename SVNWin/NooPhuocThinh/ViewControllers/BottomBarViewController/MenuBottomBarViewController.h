//
//  MenuBottomBarViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/9/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuBottomBarViewController : BaseViewController<BaseViewControllerDelegate>

+ (MenuBottomBarViewController *) sharedBottomBarCenter;

@property (nonatomic, retain) IBOutlet UIButton       *btnHome;
@property (nonatomic, retain) IBOutlet UIButton       *btnChat;
@property (nonatomic, retain) IBOutlet UIButton       *btnNews;
@property (nonatomic, retain) IBOutlet UIButton       *btnMedia;
@property (nonatomic, retain) IBOutlet UIButton       *btnMusic;

@property (nonatomic, retain) IBOutlet UILabel        *lblHome;
@property (nonatomic, retain) IBOutlet UILabel        *lblChat;
@property (nonatomic, retain) IBOutlet UILabel        *lblNews;
@property (nonatomic, retain) IBOutlet UILabel        *lblMedia;
@property (nonatomic, retain) IBOutlet UILabel        *lblMusic;

@end
