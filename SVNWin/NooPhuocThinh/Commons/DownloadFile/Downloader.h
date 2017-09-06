//
//  Downloader.h
//  NooPhuocThinh
//
//  Created by longnh on 4/18/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelDownload;

@protocol FileDownloaderDelegate

-(void) delegateFileDownloader:(NSIndexPath *)indexPath;
-(void) updateProgressFileDownloader:(NSString *)progress WithIndexPath:(NSIndexPath *)indexPath;

@end

@interface Downloader : NSObject
<NSURLConnectionDataDelegate>
{
    ModelDownload *modelDownload;
    NSIndexPath *indexPathInTableView;
    
    NSMutableData *activeDownload;
    NSURLConnection *fileConnection;
}

@property (nonatomic, retain) ModelDownload *modelDownload;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id<FileDownloaderDelegate> delegateDownload;

@property (nonatomic, retain)  NSMutableData *activeDownload;
@property (nonatomic, retain)  NSURLConnection *fileConnection;

- (void)startDownload;
- (void)cancelDownload;

@end
