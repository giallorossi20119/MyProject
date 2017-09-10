//
//  ProfileDetailViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 1/6/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HMSegmentedControlOriginal.h"
#import "UserType.h"

@interface ProfileDetailViewController : BaseViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView              *_webviewProfileDetail;
    IBOutlet UIScrollView           *_scrollViewProfileDetail;
    HMSegmentedControlOriginal      *_segmentControl;
    
    NSMutableArray                  *_arrWebviews;
    NSInteger                       _currentFontSize; //-- text font into webvie
    NSData                          *_cloneWebViewProfileDetail;   //-- copy webview
    
}
@property (nonatomic, retain) NSMutableArray    *arrSegments; //-- title for segments
@property (nonatomic, retain) NSMutableArray    *arrUsers; //list kind of users
@property (nonatomic, assign) NSInteger         currentIndexSegments;

//-- upgrade user
- (IBAction)clickToUpgradeUser:(id)sender;

@end
