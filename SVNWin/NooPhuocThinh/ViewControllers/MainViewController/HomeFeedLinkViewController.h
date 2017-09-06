//
//  HomeFeedLinkViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/27/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface HomeFeedLinkViewController : BaseViewController<UIWebViewDelegate,UIScrollViewDelegate,BaseViewControllerDelegate,CommentsNewsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imageLink;
@property (weak, nonatomic) IBOutlet UILabel *NoView;
@property (weak, nonatomic) IBOutlet UILabel *NoLike;
@property (weak, nonatomic) IBOutlet UILabel *NoComment;
@property (weak, nonatomic) IBOutlet UILabel *NoShare;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *_indicatorWeb;
@property (weak, nonatomic) NSString *titleLink;
@property (weak, nonatomic) NSString *urlLink;
@property (weak, nonatomic) NSString *imageURLLink;

@property (weak, nonatomic) NSString *txtNoView;
@property (weak, nonatomic) NSString *txtNoLike;
@property (weak, nonatomic) NSString *txtNoShare;
@property (weak, nonatomic) NSString *txtNoComment;
@property (weak, nonatomic) NSString *isLiked;

@property (nonatomic, retain) NSMutableArray *tempLinkData;
@property (nonatomic, retain) NSString *indexP;
@property (nonatomic, assign) NSInteger indexValue;

@end
