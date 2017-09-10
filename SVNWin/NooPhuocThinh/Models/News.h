//
//  News.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewNewsDetail.h"
@interface News : NSObject

@property (nonatomic, retain) NSString                          *nodeId;
@property (nonatomic, retain) NSString                          *title;
@property (nonatomic, retain) NSString                          *thumbnailImagePath;
@property (nonatomic, retain) NSString                          *thumbnailImageType;
@property (nonatomic, retain) NSString                          *shortBody;
@property (nonatomic, retain) NSString                          *body;
@property (nonatomic, assign) NSInteger                         order;
@property (nonatomic, assign) NSInteger                         trueTotalView;
@property (nonatomic, assign) NSInteger                         settingTotalView;
@property (nonatomic, assign) NSInteger                         isHot;
@property (nonatomic, retain) NSString                          *createdDate;
@property (nonatomic, retain) NSString                          *lastUpdate;
@property (nonatomic, retain) NSString                          *imageList;
@property (nonatomic, assign) NSInteger                         snsTotalComment;
@property (nonatomic, assign) NSInteger                         snsTotalDislike;
@property (nonatomic, assign) NSInteger                         snsTotalLike;
@property (nonatomic, assign) NSInteger                         snsTotalShare;
@property (nonatomic, assign) NSInteger                         snsTotalView;

//-- additional
@property (nonatomic, assign) NSInteger                         isLiked;
@property (nonatomic, assign) NSInteger                         numberOfLike;
@property (nonatomic, retain) NSMutableArray                    *arrComments;
@property (nonatomic, retain) NSString                          *url;
@property (nonatomic, retain) NSString                          *categoryID; // Tin Tuc or NooPhuocThinh
@property (nonatomic, assign) ViewNewsDetail                    *viewNewsDetail;

@end
