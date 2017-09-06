//
//  Downloader.m
//  NooPhuocThinh
//
//  Created by longnh on 4/18/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "Downloader.h"
#import "ModelDownload.h"

@interface Downloader ()

@property (nonatomic) double totalBytesFileWritten;
@property (nonatomic) long long expectedFileTotalBytes;

@end

@implementation Downloader

@synthesize indexPathInTableView;
@synthesize delegateDownload;
@synthesize activeDownload;
@synthesize fileConnection;
@synthesize modelDownload;

-(void) startDownload
{
    self.activeDownload = [NSMutableData data];
    
    //--alloc + init and start an NSURL Connection; release on completion/failure;
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.modelDownload.linkUrlDownload]] delegate:self];
    
    self.fileConnection = conn;
}

-(void) cancelDownload
{
    [self.fileConnection cancel];
    
    self.fileConnection = nil;
    self.activeDownload = nil;
}


//****************************************************************//
#pragma mark - Download support (NSURLConnectionDelegate)

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSDictionary * headers = ((NSHTTPURLResponse *)response).allHeaderFields;
    //if content-range is not set (this is not a range download), content-length is the length of the file
    if ([headers objectForKey:(@"Content-Range")] == nil) {
        
        self.expectedFileTotalBytes = [[headers objectForKey:(@"Content-Length")] longLongValue];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
    
    self.totalBytesFileWritten += data.length;
    double percent = ((double)self.totalBytesFileWritten/(double)self.expectedFileTotalBytes)*100;
    
    NSString *percentProgress =[NSString stringWithFormat:@"%.0f%%", percent];
    [self.delegateDownload updateProgressFileDownloader:percentProgress WithIndexPath:self.indexPathInTableView];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //--clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    //--release the connection nơ that'sí finished
    self.fileConnection =  nil;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    //-- get folder path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@",self.modelDownload.folderName,self.modelDownload.categoryId]];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error]; //-- Create folder
    
    NSString *filePath = @"";
    if ([self.modelDownload.folderName isEqualToString:@"Video"])
        filePath = [NSString stringWithFormat:@"%@/%@.mp4", folderPath,self.modelDownload.nodeId];
    else
        filePath = [NSString stringWithFormat:@"%@/%@.mp3", folderPath,self.modelDownload.nodeId];
    
    
    if ([self.activeDownload writeToFile:filePath options:NSAtomicWrite error:nil] == NO)
    {
        //-- download error --//
        
        //--release the connection now that it's finished
        self.activeDownload = nil;
        self.fileConnection = nil;
        
        [self.delegateDownload delegateFileDownloader:self.indexPathInTableView];
    }
    else
    {
        //-- download success --//
        
        //--release the connection now that it's finished
        self.activeDownload = nil;
        self.fileConnection = nil;
        
        [self.delegateDownload delegateFileDownloader:self.indexPathInTableView];
    }
}


@end
