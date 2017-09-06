//
//  ListAlbumPhoto.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/26/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListAlbumPhoto : NSObject

@property (nonatomic, retain) NSString              *albumId;
@property (nonatomic, retain) NSString              *name;
@property (nonatomic, retain) NSString              *thumbImagePath;
@property (nonatomic, retain) NSString              *albumThumbnailImagePath;
@property (nonatomic, retain) NSString              *description;
@property (nonatomic, retain) NSString              *order;
@property (nonatomic, retain) NSString              *totalPhoto;
@property (nonatomic, retain) NSString              *snsTotalComment;
@property (nonatomic, retain) NSString              *snsTotalLike;
@property (nonatomic, retain) NSString              *snsTotalDisLike;
@property (nonatomic, retain) NSString              *snsTotalShare;
@property (nonatomic, retain) NSString              *snsTotalView;
@property (nonatomic, retain) NSMutableArray        *photoList;

@end
