//
//  ViewNewsDetail.h
//  NooPhuocThinh
//
//  Created by longnh on 6/2/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewNewsDetail : UIView <NSCoding>

//@property(nonatomic, retain) IBOutlet UIScrollView           *scrollViewDetailNews;
@property(nonatomic, retain) IBOutlet UIWebView              *webViewNewsDetail;

//@property(nonatomic, retain) IBOutlet UIView                 *viewHeader;
//@property(nonatomic, retain) IBOutlet UIImageView            *imgAvatar;
//@property(nonatomic, retain) IBOutlet UILabel                *lblTitle;
//@property(nonatomic, retain) IBOutlet UILabel                *lblDate;
//@property(nonatomic, retain) IBOutlet UILabel                *lblCountComments;
//@property(nonatomic, retain) IBOutlet UIButton               *btnShowComments;

@property(nonatomic, retain) IBOutlet UIView                 *viewToolbar;
@property(nonatomic, retain) IBOutlet UIButton               *btnComment;
@property(nonatomic, retain) IBOutlet UIButton               *btnShare;
@property(nonatomic, retain) IBOutlet UIButton               *btnLikeNews;
@property(nonatomic, retain) IBOutlet UILabel                *lblNumberOfLike;
@property(nonatomic, retain) IBOutlet UILabel                *lblNumberOfComment;

@property(nonatomic, assign) BOOL                isLoaded;//longnh
@property(nonatomic, assign) NSInteger           currentIndex;

@end
