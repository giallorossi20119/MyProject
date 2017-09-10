//
//  AboutViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMDataBase.h"
#import "API.h"
#import "SingerInfo.h"

@interface AboutViewController : BaseViewController<UIWebViewDelegate, BaseViewControllerDelegate, UIScrollViewDelegate>
{
    NSDictionary                        *_dataSourceSinger;
    
    IBOutlet UIScrollView               *_scrollAbout;
    IBOutlet UIActivityIndicatorView    *_activityIndicator;
    int                                 iNumberLike;
    NSString                            *_lblDefault;
    
    BOOL _isLike;
    BOOL _isProcessSyncAPI;
}

@property (nonatomic, weak) IBOutlet UIImageView            *imgCover;
@property (nonatomic, retain) IBOutlet UIWebView            *wvInfo;
@property (nonatomic, retain) NSMutableArray                *arrayData;

- (void) redrawRightNavigartionBar:(bool) isLike totalLike:(int)totalLike;

@end
