//
//  VideoAllModel.h
//  NooPhuocThinh
//
//  Created by longnh on 2/21/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoAllModel : NSObject
{
    
}

//-- for All Video
@property (nonatomic, retain) NSString          *body;
@property (nonatomic, retain) NSString          *cms_user_id;
@property (nonatomic, retain) NSString          *content_type_id;
@property (nonatomic, retain) NSString          *created_date;
@property (nonatomic, retain) NSString          *description;
@property (nonatomic, retain) NSString          *last_update;
@property (nonatomic, retain) NSString          *name;
@property (nonatomic, retain) NSString          *node_id;
@property (nonatomic, retain) NSString          *isHot;
@property (nonatomic, retain) NSString          *snsTotalComment;
@property (nonatomic, retain) NSString          *snsTotalLike;
@property (nonatomic, retain) NSString          *snsTotalDisLike;
@property (nonatomic, retain) NSString          *snsTotalShare;
@property (nonatomic, retain) NSString          *snsTotalView;
@property (nonatomic, retain) NSString          *isLiked;
@property (nonatomic, retain) NSString          *thumbnail_image_file_path;
@property (nonatomic, retain) NSString          *thumbnail_image_file_type;
@property (nonatomic, retain) NSString          *video_file_path;
@property (nonatomic, retain) NSString          *video_order;
@property (nonatomic, retain) NSString          *youtube_url;

//-- properties additional
@property (nonatomic, assign) NSInteger         numberOfLike;
@property (nonatomic, retain) NSMutableArray    *arrComments;
@property (nonatomic, retain) NSString          *url;

@end
