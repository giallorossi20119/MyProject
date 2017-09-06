//
//  CategoryBySinger.h
//  NooPhuocThinh
//
//  Created by HuntDo on 12/22/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryBySinger : NSObject

@property(nonatomic, retain) NSString *contentTypeId;
@property(nonatomic, retain) NSString *categoryId;
@property(nonatomic, retain) NSString *bigIconImageFilePath;
@property(nonatomic, retain) NSString *countryId;
@property(nonatomic, retain) NSString *countryName;
@property(nonatomic, retain) NSString *demographicDescription;
@property(nonatomic, retain) NSString *demographicId;
@property(nonatomic, retain) NSString *demographicName;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *forumLink;
@property(nonatomic, retain) NSString *iconImageFilePath;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) NSInteger order;
@property(nonatomic, retain) NSString *parentId;
@property(nonatomic, retain) NSString *thumbnailImagePath;

@end
