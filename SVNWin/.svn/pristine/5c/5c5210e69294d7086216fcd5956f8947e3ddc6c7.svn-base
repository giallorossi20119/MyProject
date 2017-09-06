//
//  DetailsCommentViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/5/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellDetailComment.h"
#import "ProfileViewController.h"
#import "BaseViewController.h"
#import "Comment.h"
#import "Utility.h"
#import "DetailCommentsViewController.h"
#import "UIImageView+WebCache.h"
#import "ODRefreshControl.h"


@interface DetailsCommentViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, BaseViewControllerDelegate, UITextViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UIView                     *_viewHeader;
    IBOutlet UIButton                   *_btnBack;
    IBOutlet UIButton                   *_btnCreateComment;
    IBOutlet UITableView                *_tableDetailCmt;
    IBOutlet UIImageView                *_imgAvatar;
    IBOutlet UILabel                    *_lblFullName;
    IBOutlet UITextView                 *_txvContent;
    IBOutlet UILabel                    *_lblTime;
    IBOutlet UIImageView                *_imgLine;
    IBOutlet UIScrollView               *_scrollContainer;
    
    BOOL                                _isClickComment;
    BOOL                                _isAutoScroll;
    
    
    IBOutlet UIActivityIndicatorView    *_activityIndicator;
    
    NSMutableArray                      *_arrDataSource;
    NSInteger                            _countCommentLocal;
}

@property (nonatomic, retain) Comment   *superComment;

@end
