//
//  ListPhotosInAlbum.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/26/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListPhotosInAlbum : NSObject

@property (nonatomic, retain) NSString              *albumCreatedDate;
@property (nonatomic, retain) NSString              *albumDescription;
@property (nonatomic, retain) NSString              *albumId;
@property (nonatomic, retain) NSString              *albumImageFilePath;
@property (nonatomic, retain) NSString              *albumLastUpdate;
@property (nonatomic, retain) NSString              *albumName;
@property (nonatomic, retain) NSString              *createDate;
@property (nonatomic, retain) NSString              *imagePath;
//Add by TuanNM@20140827
//lay thungbnail tu imagePath, nhung ko luu vao DB truong nay
@property (nonatomic, retain) NSString              *thumbnailImagePath;
//End adding
@property (nonatomic, retain) NSString              *name;
@property (nonatomic, retain) NSString              *nodeId;
@property (nonatomic, retain) NSString              *snsTotalComment;
@property (nonatomic, retain) NSString              *snsTotalLike;
@property (nonatomic, retain) NSString              *snsTotalDisLike;
@property (nonatomic, retain) NSString              *snsTotalShare;
@property (nonatomic, retain) NSString              *snsTotalView;
@property (nonatomic, retain) NSString              *isLiked;


@end
