//
//  Profile.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/30/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject <NSCoding>

@property(nonatomic, retain) NSString  *userId;
@property(nonatomic, retain) NSString  *userType;
@property(nonatomic, retain) NSString  *fullName;
@property(nonatomic, retain) NSString  *userName;
@property(nonatomic, retain) NSString  *userImage;
@property(nonatomic, retain) NSString  *point;
@property(nonatomic, retain) NSString  *rankPosition;
@property(nonatomic, retain) NSString  *totalShare;
@property(nonatomic, retain) NSString  *totalChat;
@property(nonatomic, retain) NSString  *totalLike;
@property(nonatomic, retain) NSString  *totalComment;
@property(nonatomic, retain) NSString  *audioView;
@property(nonatomic, retain) NSString  *videoView;
@property(nonatomic, retain) NSString  *userStatusImage; //-- logo normal, vip, supervip...
@property(nonatomic, retain) NSString  *status;
@property(nonatomic, retain) NSString  *userPremiumUpgrade;
@property(nonatomic, retain) NSString  *registerTime;
@property(nonatomic, retain) NSString  *facebookId;
@property(nonatomic, retain) NSString  *facebookURL;

+(Profile*)sharedProfile;
+ (void)setProfile:(Profile *)aProfile;

@end
