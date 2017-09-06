//
//  MusicAlbum.h
//  NooPhuocThinh
//
//  Created by HuntDo on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicAlbum : NSObject

@property (nonatomic, retain) NSString          *albumId;
@property (nonatomic, retain) NSString          *name;
@property (nonatomic, retain) NSString          *englishName;
@property (nonatomic, retain) NSString          *description;
@property (nonatomic, retain) NSString          *thumbImagePath;
@property (nonatomic, retain) NSString          *thumbImagePathThumb;//longnh add
@property (nonatomic, retain) NSString          *musicType;
@property (nonatomic, retain) NSString          *totalTrack;
@property (nonatomic, retain) NSString          *totalMusic;
@property (nonatomic, retain) NSString          *trueTotalView;
@property (nonatomic, retain) NSString          *settingTotalView;
@property (nonatomic, retain) NSString          *trueTotalRating;
@property (nonatomic, retain) NSString          *settingTotalRating;
@property (nonatomic, retain) NSString          *contentProviderId;
@property (nonatomic, retain) NSString          *authorMusicId;
@property (nonatomic, retain) NSString          *musicPublisherId;
@property (nonatomic, retain) NSString          *isHot;
@property (nonatomic, retain) NSString          *musicList;


@end
