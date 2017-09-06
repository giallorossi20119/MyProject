//
//  VideoDetailViewController.h
//  NooPhuocThinh
//
//  Created by longnh on 1/4/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "BaseViewController.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "VideoAllModel.h"
#import "VideoForAll.h"
#import "VideoForCategory.h"
#import "UIImageView+WebCache.h"
#import "BaseCommentsTableViewController.h"
#import "AudioPlayer.h"
#import "HMSegmentedControl.h"
#import "Comment.h"
#import "VMDataBase.h"
#import "Downloader.h"

@interface VideoDetailViewController : BaseViewController <BaseCommentsTableViewControllerDelegate,UIScrollViewDelegate, BaseViewControllerDelegate, DetailCommentsViewControllerDelegate, FileDownloaderDelegate>
{
    //-- segment
    HMSegmentedControl                  *segmentedControlComment;
    NSInteger                           currentIndexSegment;
    BOOL                                _isAutoScroll;
    NSMutableArray                      *comments;
    
    IBOutlet UIButton                   *btnPlay;
    IBOutlet UIButton                   *btnShare;
    IBOutlet UIButton                   *btnLike;
    IBOutlet UILabel                    *lblNumberComment;
    IBOutlet UILabel                    *lblNumberLike;
    IBOutlet UILabel                    *lblNumberPlay;
    IBOutlet UIButton                   *btnDownloadVideo;
    
    BOOL                                _isLike;
    BOOL                                _isCreateComment;
    BOOL                                _isShare;
    
    float totalTimePlayVideo;
    
    //-- download video
    UIImageView *loadingView;
    BOOL isExistingVideoLocal;
}

@property (nonatomic, retain) NSTimer               *timerPlayVideo;

@property (nonatomic, retain) IBOutlet UIView                   *viewSegment;
@property (nonatomic, retain) IBOutlet UIView                   *viewAddScroll;
@property (nonatomic, retain) IBOutlet UIView                   *viewToolBar;
@property (nonatomic, retain) IBOutlet UIScrollView             *scrollContent;
@property (nonatomic, retain) BaseCommentsTableViewController  *tableviewComments;
@property (nonatomic, weak)   IBOutlet UIButton                 *actionButtonPlayOrPause;
@property (nonatomic, weak)   IBOutlet UIView                   *videoContainerView;
@property (nonatomic, weak)   IBOutlet UIImageView              *thumbnailImageView;
//@property (nonatomic, weak)   IBOutlet UILabel                  *titleLabel;
@property (nonatomic, weak)   IBOutlet UIView                   *viewDescription;
@property (nonatomic, weak)   IBOutlet UITextView               *txtDescription;
@property (nonatomic, weak)   IBOutlet CBAutoScrollLabel        *autoFullName;

//-- download video
@property (nonatomic, retain) NSMutableDictionary *videoDownloadsInProgress;
@property (nonatomic, assign) BOOL isExistingVideoLocal;

//-- pass data from video list
@property (nonatomic, assign) VideoForCategory  *videoForCategoryInfo;
@property (nonatomic, assign) VideoForAll       *videoForAllInfo;
@property (nonatomic, assign) VideoAllModel     *videoAllModelInfo;
@property (nonatomic, assign) NSInteger         contentVideoTypeId;

@property (nonatomic, assign) Comment           *superComment;

//-- action
- (IBAction)clickToBtnLike:(id)sender;
- (IBAction)clickToBtnShare:(id)sender;
- (IBAction)clickToBtnDownloadVideo:(id)sender;

//-- show comments
-(IBAction)clickToBtnShowComment:(id)sender;


@end
