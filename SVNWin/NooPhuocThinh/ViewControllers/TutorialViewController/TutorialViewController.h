//
//  TutorialViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/2/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : BaseViewController<BaseViewControllerDelegate>

- (void) redrawRightNavigartionBar:(bool) isLike totalLike:(int)totalLike;

@end
