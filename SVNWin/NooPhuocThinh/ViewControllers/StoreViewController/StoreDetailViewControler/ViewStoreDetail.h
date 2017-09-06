//
//  ViewStoreDetail.h
//  NooPhuocThinh
//
//  Created by HuntDo on 1/7/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewStoreDetail : UIView <NSCoding>

@property(nonatomic, retain) IBOutlet UIWebView              *webViewStoreDetail;
@property(nonatomic, retain) IBOutlet UIImageView            *imgViewMain;
@property(nonatomic, retain) IBOutlet UILabel                *lblValue;
@property(nonatomic, retain) IBOutlet UILabel                *lblCodeProduct;
@property(nonatomic, retain) IBOutlet UILabel                *lblPhone;
@property(nonatomic, retain) IBOutlet UIScrollView           *scrollViewMain;
@property(nonatomic, retain) IBOutlet UIView                 *viewValue;

@end
