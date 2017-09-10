//
//  StoreDetailViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 1/6/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "ViewStoreDetail.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CBAutoScrollLabel.h"
#import "UIView+VMODEV.h"
#import "NSString+HTML.h"

@interface StoreDetailViewController : BaseViewController <UIWebViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIWebViewDelegate>
{
    IBOutlet UIWebView              *_webViewStoreDetail;
    IBOutlet UIScrollView           *_scrollViewStoreDetail;
    IBOutlet ViewStoreDetail        *_viewMain;
    IBOutlet UIImageView            *_imgViewMain;
    IBOutlet UILabel                *_lblValue;
    IBOutlet UILabel                *_lblCodeProduct;
    IBOutlet UILabel                *_lblPhone;
    IBOutlet UIScrollView           *_scrollViewMain;
    IBOutlet UIView                 *_viewValue;
    
    //-- scroll beetwen pages
    NSMutableArray                  *_arrWebviews;
    NSInteger                       _currentFontSize; //-- text font into webvie
    NSData                          *_cloneWebViewStoreDetail;   //-- copy webview
    
}

//-- passed from view controller another
@property(nonatomic, retain) Store                  *store;
@property(nonatomic, assign) NSInteger              currentIndex;
@property(nonatomic, retain) NSMutableArray         *arrStore;

@property (nonatomic, weak)   IBOutlet CBAutoScrollLabel         *autoFullName;

@end
