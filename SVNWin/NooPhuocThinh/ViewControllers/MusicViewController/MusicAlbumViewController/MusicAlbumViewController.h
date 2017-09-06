//
//  MusicAlbumViewController.h
//  NooPhuocThinh
//
//  Created by HuntDo on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "MusicCustomCellAlbum.h"
#import "AppDelegate.h"
#import "MusicPlayViewController.h"
#import "MusicAlbum.h"
#import "MusicTrackNew.h"
#import "API.h"
#import "SHKActivityIndicator.h"
#import "VMDataBase.h"
#import "BaseTableMusicViewController.h"
#import "AudioPlayer.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#import "ODRefreshControl.h"
#import "Setting.h"

#define DX(p1, p2)    (p2.x - p1.x)
#define DY(p1, p2)    (p2.y - p1.y)

#define SWIPE_DRAG_MIN 16
#define DRAGLIMIT_MAX 8


// Categorize swipe types
typedef enum {
    TouchUnknown,
    TouchSwipeLeft,
    TouchSwipeRight,
    TouchSwipeUp,
    TouchSwipeDown,
} SwipeTypes;

@interface MusicAlbumViewController : BaseViewController
<UIScrollViewDelegate,BaseTableMusicViewControllerDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIScrollView               *scrollContainer;
    
    //-- init char
    NSInteger                           currentPageLoadMore;
    NSInteger                           currentIndex;
    
    //-- segment
    HMSegmentedControl                  *segmentedControlAlbum;
    
    // Initialize recognizer
    CGPoint startPoint;
    
    SwipeTypes touchtype;
}

@property (nonatomic, retain) IBOutlet UIImageView                *imgCover;
@property (nonatomic, retain) IBOutlet UIImageView                *tempImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView    *activityIndicator;

@property (nonatomic, retain) BaseTableMusicViewController  *tableviewMusic;

@property (nonatomic, retain) NSMutableArray                *segmentsArray;
@property (nonatomic, retain) NSMutableArray                *arrTracks;
@property (nonatomic, assign) NSInteger                     indexOfAlbum;

@property (nonatomic, retain) NSString                      *albumIdStr;

@end
