//
//  OpenLinkViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 1/14/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenLinkViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView                  *_wvOpenLink;
    
    IBOutlet UIActivityIndicatorView    *_activityIndicator;
}

@property (nonatomic, retain) NSString         *urlString;

@end
