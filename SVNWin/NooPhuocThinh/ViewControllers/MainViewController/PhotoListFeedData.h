//
//  PhotoListFeedData.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/15/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoListFeedData : NSObject

@property (nonatomic, retain) NSString              *albumId;
@property (nonatomic, retain) NSString              *photoId;
@property (nonatomic, retain) NSString              *photoTitle;
@property (nonatomic, retain) NSString              *imagePath;
@property (nonatomic, retain) NSString              *photoDescription;
@property (nonatomic, retain) NSString              *snsTotalView;
@property (nonatomic, retain) NSString              *snsTotalLike;
@property (nonatomic, retain) NSString              *snsTotalComment;
@property (nonatomic, retain) NSString              *snsTotalShare;
@property (nonatomic, retain) NSString              *isLiked;
@property (nonatomic, retain) NSString              *indexcell;

@end
