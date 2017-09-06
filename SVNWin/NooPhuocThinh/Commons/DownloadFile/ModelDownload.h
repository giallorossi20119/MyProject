//
//  ModelDownload.h
//  NooPhuocThinh
//
//  Created by longnh on 4/18/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelDownload : NSObject
{
    NSString    *linkUrlDownload;
    NSString    *categoryId;
    NSString    *nodeId;
    NSString    *fileName;
    
    NSString    *folderName;
}

@property (nonatomic, retain) NSString    *linkUrlDownload;
@property (nonatomic, retain) NSString    *categoryId;
@property (nonatomic, retain) NSString    *nodeId;
@property (nonatomic, retain) NSString    *fileName;
@property (nonatomic, retain) NSString    *folderName;

-(ModelDownload *) initWithUrlString:(NSString *) urlString;

@end
