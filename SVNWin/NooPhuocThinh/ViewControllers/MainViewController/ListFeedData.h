//
//  ListFeedData.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/14/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListFeedData : NSObject

//feed general
@property (nonatomic, retain) NSString              *feedId;
@property (nonatomic, retain) NSString              *feedType;
@property (nonatomic, retain) NSString              *feedTimeStamp;
@property (nonatomic, retain) NSString              *feedTimeUpdate;
@property (nonatomic, retain) NSString              *feedUserId;
@property (nonatomic, retain) NSString              *feedUserName;
@property (nonatomic, retain) NSString              *feedUserImage;
@property (nonatomic, retain) NSString              *feedLink;
@property (nonatomic, retain) NSString              *feedImage;
@property (nonatomic, retain) NSString              *feedTitle;
@property (nonatomic, retain) NSString              *feedParentId;
@property (nonatomic, retain) NSString              *feedDescription;
@property (nonatomic, retain) NSString              *snsTotalComment;
@property (nonatomic, retain) NSString              *snsTotalLike;
@property (nonatomic, retain) NSString              *snsTotalShare;
@property (nonatomic, retain) NSString              *snsTotalView;
@property (nonatomic, retain) NSString              *isLiked;

//feed photo
@property (nonatomic, retain) NSMutableArray        *photoList;
@property (nonatomic, assign) NSUInteger            NoPhoto;
@property (nonatomic, retain) NSString              *albumId;
@property (nonatomic, retain) NSString              *albumLike;
@property (nonatomic, retain) NSString              *albumComment;
@property (nonatomic, retain) NSString              *albumView;
@property (nonatomic, retain) NSString              *albumShare;

//feed video
@property (nonatomic, retain) NSString              *videoURL;

@end