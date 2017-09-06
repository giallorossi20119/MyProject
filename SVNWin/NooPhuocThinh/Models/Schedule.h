//
//  Schedule.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/27/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject

@property (nonatomic, assign) NSString          *categoryId;
@property (nonatomic, retain) NSString          *nodeId;
@property (nonatomic, retain) NSString          *name;
@property (nonatomic, retain) NSString          *imageFilePath;
@property (nonatomic, retain) NSString          *videoFilePath;
@property (nonatomic, retain) NSString          *startDate;
@property (nonatomic, retain) NSString          *endDate;
@property (nonatomic, retain) NSString          *desciption;
@property (nonatomic, retain) NSString          *price;
@property (nonatomic, retain) NSString          *phone;
@property (nonatomic, retain) NSString          *orderSchedule;
@property (nonatomic, retain) NSString          *organizationUnitName;
@property (nonatomic, retain) NSString          *countryId;
@property (nonatomic, retain) NSString          *countryName;
@property (nonatomic, retain) NSString          *cityId;
@property (nonatomic, retain) NSString          *cityName;
@property (nonatomic, retain) NSString          *cityLogoFilePath;
@property (nonatomic, retain) NSString          *cityDescription;
@property (nonatomic, retain) NSString          *locationEventId;
@property (nonatomic, retain) NSString          *locationEventName;
@property (nonatomic, retain) NSString          *locationEventAddress;
@property (nonatomic, retain) NSString          *locationEventPhone;
@property (nonatomic, retain) NSString          *locationEventEmail;
@property (nonatomic, retain) NSString          *locationEventWebsite;
@property (nonatomic, retain) NSString          *snsTotalComment;
@property (nonatomic, retain) NSString          *snsTotalLike;
@property (nonatomic, retain) NSString          *snsTotalDisLike;
@property (nonatomic, retain) NSString          *snsTotalShare;
@property (nonatomic, retain) NSString          *snsTotalView;
@property (nonatomic, retain) NSString          *isLiked;
@property (nonatomic, retain) NSString          *listSinger;

@end
