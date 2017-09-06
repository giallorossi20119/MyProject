//
//  CommentsNewsViewController.h
//  NooPhuocThinh
//
//  Created by HuntDo on 12/5/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "CommentCellCustom.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailCommentsViewController.h"
#import  "ODRefreshControl.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MulticastDelegate.h"

@protocol CommentsNewsViewControllerDelegate;

@interface CommentsNewsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, BaseViewControllerDelegate, DetailCommentsViewControllerDelegate>
{
    IBOutlet UITableView                *_tableViewComments;
    IBOutlet UIActivityIndicatorView    *_indicator;
    BOOL                                _isAutoScroll;
    BOOL                                _isClickComment;
    NSInteger                           _currentIndex;
    
@public
    MulticastDelegate<CommentsNewsViewControllerDelegate> *delegatesComment;
}

@property (nonatomic, retain) NSMutableArray  *myArrComments;
@property (nonatomic, retain) NSString        *nodeId;
@property (nonatomic, retain) id<CommentsNewsViewControllerDelegate>   delegateComment;

+ (CommentsNewsViewController *)sharedComment;
+ (void)initWithDelegateComment:(id<CommentsNewsViewControllerDelegate>) delegateComment;
+ (void)addDelegateComment:(id)delegateComment;
+ (void)removeDelegateComment:(id)delegateComment;


@end


@protocol CommentsNewsViewControllerDelegate <NSObject>

@optional

- (void)commentSuccessDelegate;

@end