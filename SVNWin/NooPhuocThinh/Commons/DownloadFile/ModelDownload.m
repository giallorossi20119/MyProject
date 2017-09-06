//
//  ModelDownload.m
//  NooPhuocThinh
//
//  Created by longnh on 4/18/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "ModelDownload.h"

@implementation ModelDownload

@synthesize linkUrlDownload;
@synthesize categoryId;
@synthesize nodeId;
@synthesize fileName;
@synthesize folderName;

//***********************************************************************//

//-- init with URL
-(ModelDownload *) initWithUrlString:(NSString *) urlString
{
    self = [super init];
    if (self){
        self.linkUrlDownload = urlString;
    }
    return self;
}

@end
