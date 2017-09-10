//
//  HomeCommentViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/10/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "CommentTableViewCell.h"

@interface HomeCommentViewController : BaseViewController<BaseViewControllerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    float                   desiredPlace;
    NSMutableArray          *arrCommentData;
    NSString                *typeComment;
    NSMutableArray          *tempPhotoFeedData;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollTotal;
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (nonatomic, retain) IBOutlet UITableView *tableViewComments;
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblView;
@property (weak, nonatomic) IBOutlet UILabel *lblLike;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblShare;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) NSString *isLiked;

@property (weak, nonatomic) IBOutlet UIView *viewComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (nonatomic, retain) IBOutlet UITextField *tfComment;
@property (weak, nonatomic) IBOutlet UIButton *btnEmoticon;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;

@property (nonatomic, retain) NSMutableArray *tempLinkData;
@property (nonatomic, retain) NSString *indexP;
@property (nonatomic, assign) NSInteger indexValue;
@property (weak, nonatomic) NSString *titleLink;
@property (weak, nonatomic) NSString *urlLink;
@property (weak, nonatomic) NSString *imageURLLink;

@end
