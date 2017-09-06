//
//  VideoForCategory.h
//  NooPhuocThinh
//
//  Created by HuntDo on 12/18/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>



/*
 Model for FANCAM , TV, Behind scene
*/

@interface VideoForCategory : NSObject

@property (nonatomic, retain) NSString          *nodeID;
@property (nonatomic, retain) NSString          *categoryID;
@property (nonatomic, retain) NSString          *title;
@property (nonatomic, retain) NSString          *thumbnailImagePath;
@property (nonatomic, retain) NSString          *videoFilePath;
@property (nonatomic, retain) NSString          *videoYoutubePath;
@property (nonatomic, retain) NSString          *videoFacebookPath;
@property (nonatomic, retain) NSString          *youtubeUrl;
@property (nonatomic, retain) NSString          *shortBody;
@property (nonatomic, retain) NSString          *body;
@property (nonatomic, retain) NSString          *trueTotalView;
@property (nonatomic, retain) NSString          *settingTotalView;
@property (nonatomic, retain) NSString          *countryID;
@property (nonatomic, retain) NSString          *orderVideo;
@property (nonatomic, retain) NSString          *isHot;
@property (nonatomic, retain) NSString          *snsTotalComment;
@property (nonatomic, retain) NSString          *snsTotalLike;
@property (nonatomic, retain) NSString          *snsTotalDisLike;
@property (nonatomic, retain) NSString          *snsTotalShare;
@property (nonatomic, retain) NSString          *snsTotalView;
@property (nonatomic, retain) NSString          *isLiked;

//-- properties additional
@property (nonatomic, assign) NSInteger         numberOfLike;
@property (nonatomic, retain) NSMutableArray    *arrComments;
@property (nonatomic, retain) NSString          *url;

@end
