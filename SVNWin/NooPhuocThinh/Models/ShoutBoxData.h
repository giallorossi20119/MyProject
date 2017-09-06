//
//  ShoutBoxData.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/19/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoutBoxData : NSObject

@property (nonatomic, retain) NSString          *shoutId;
@property (nonatomic, retain) NSString          *userId;
@property (nonatomic, retain) NSString          *userName;
@property (nonatomic, retain) NSString          *userImage;
@property (nonatomic, retain) NSString          *userPoint;
@property (nonatomic, retain) NSString          *fullName;
@property (nonatomic, retain) NSString          *text;
@property (nonatomic, assign) NSInteger         timeStamp;
@property (nonatomic, assign) NSInteger         numberOfSubComment;

@end
