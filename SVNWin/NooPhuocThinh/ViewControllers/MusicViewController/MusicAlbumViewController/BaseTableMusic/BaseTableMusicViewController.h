//
//  BaseTableMusicViewController.h
//  NooPhuocThinh
//
//  Created by longnh on 12/27/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayViewController.h"
#import "MusicTrackNew.h"
#import "WBNoticeView.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "Downloader.h"

// delegate types
typedef enum {
    
    delegateRingBackType,
    delegateDownLoadType
    
} delegateTypes;

@class AudioPlayer;

@protocol BaseTableMusicViewControllerDelegate<NSObject>

@optional

-(void) goToMusicPlayViewControllerWithListData:(NSMutableArray *) listData withIndexRow:(int) indexRow;
-(void) passDelegateGoToMusicAlbumViewController:(NSMutableArray *) listData withIndexRow:(int) indexRow ByDelegateType:(delegateTypes) delegateType;

@end


@interface BaseTableMusicViewController : UITableViewController
<FileDownloaderDelegate>
{
    NSMutableArray *listData;
    id<BaseTableMusicViewControllerDelegate> delegate;
    
    AudioPlayer *_audioPlayer;

    WBErrorNoticeView *notice;
    WBSuccessNoticeView *noticeSuccess;
}

@property (nonatomic, retain) WBErrorNoticeView *notice;
@property (nonatomic, retain) WBSuccessNoticeView *noticeSuccess;

@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) NSMutableArray *listDownloadSelected;
@property (nonatomic, assign) id <BaseTableMusicViewControllerDelegate> delegate;

@property (nonatomic, retain) NSMutableDictionary *musicDownloadsInProgress;




@end
