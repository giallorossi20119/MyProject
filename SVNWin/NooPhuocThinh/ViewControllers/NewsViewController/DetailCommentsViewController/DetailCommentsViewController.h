//
//  DetailCommentsViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/10/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "DetailCommentCellCustom.h"
#import "Comment.h"
#import "BaseViewController.h"
#import "Utility.h"
#import "ODRefreshControl.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@protocol DetailCommentsViewControllerDelegate;

@interface DetailCommentsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, BaseViewControllerDelegate>
{
    IBOutlet UITableView                    *_tableViewDetailComments;
    IBOutlet UIActivityIndicatorView        *_indicator;
    BOOL                                    _isAutoScroll;
    BOOL                                    _isClickComment;
    
@public
    MulticastDelegate<DetailCommentsViewControllerDelegate> *delegatesDetailComment;
}

@property(nonatomic, retain) Comment        *superComment;
@property(nonatomic, retain) NSString       *nodeId;
@property (nonatomic, retain) id<DetailCommentsViewControllerDelegate> delegateDetailComment;

+ (DetailCommentsViewController *)sharedDetailComment;
+ (void)initWithDelegateComment:(id<DetailCommentsViewControllerDelegate>) delegateDetailComment;
+ (void)addDelegateDetailComment:(id)delegateDetailComment;
+ (void)removeDelegateDetailComment:(id)delegateDetailComment;


@end


@protocol DetailCommentsViewControllerDelegate <NSObject>

@optional

- (void)subCommentSuccessDelegate;

@end
