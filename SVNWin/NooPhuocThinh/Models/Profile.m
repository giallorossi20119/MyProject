//
//  Profile.m
//  NooPhuocThinh
//
//  Created by HuntDo on 12/30/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "Profile.h"

static Profile *currentProfile = nil;

@implementation Profile

@synthesize userId;
@synthesize userType;
@synthesize fullName;
@synthesize userImage;
@synthesize point;
@synthesize rankPosition;
@synthesize totalShare;
@synthesize totalChat;
@synthesize totalLike;
@synthesize totalComment;
@synthesize audioView;
@synthesize videoView;
@synthesize userStatusImage;
@synthesize status;
@synthesize userPremiumUpgrade;
@synthesize registerTime;
@synthesize facebookId;
@synthesize facebookURL;
@synthesize userName;
//-- encode
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:userId             forKey:@"userId"];
    [aCoder encodeObject:userType           forKey:@"userType"];
    [aCoder encodeObject:fullName           forKey:@"fullName"];
    [aCoder encodeObject:userImage          forKey:@"userImage"];
    [aCoder encodeObject:point              forKey:@"point"];
    [aCoder encodeObject:rankPosition       forKey:@"rankPosition"];
    [aCoder encodeObject:totalShare         forKey:@"totalShare"];
    [aCoder encodeObject:totalChat          forKey:@"totalChat"];
    [aCoder encodeObject:totalLike          forKey:@"totalLike"];
    [aCoder encodeObject:totalComment       forKey:@"totalComment"];
    [aCoder encodeObject:audioView          forKey:@"audioView"];
    [aCoder encodeObject:videoView          forKey:@"videoView"];
    [aCoder encodeObject:userStatusImage    forKey:@"userStatusImage"];
    [aCoder encodeObject:status             forKey:@"status"];
    [aCoder encodeObject:userPremiumUpgrade forKey:@"userPremiumUpgrade"];
    [aCoder encodeObject:registerTime       forKey:@"registerTime"];
    [aCoder encodeObject:facebookId         forKey:@"facebookId"];
    [aCoder encodeObject:facebookURL        forKey:@"facebookURL"];
    [aCoder encodeObject:userName           forKey:@"userName"];

}

//-- decode
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.userId                 = [aDecoder decodeObjectForKey:@"userId"];
        self.userType               = [aDecoder decodeObjectForKey:@"userType"];
        self.fullName               = [aDecoder decodeObjectForKey:@"fullName"];
        self.userImage              = [aDecoder decodeObjectForKey:@"userImage"];
        self.point                  = [aDecoder decodeObjectForKey:@"point"];
        self.rankPosition           = [aDecoder decodeObjectForKey:@"rankPosition"];
        self.totalShare             = [aDecoder decodeObjectForKey:@"totalShare"];
        self.totalChat              = [aDecoder decodeObjectForKey:@"totalChat"];
        self.totalLike              = [aDecoder decodeObjectForKey:@"totalLike"];
        self.totalComment           = [aDecoder decodeObjectForKey:@"totalComment"];
        self.audioView              = [aDecoder decodeObjectForKey:@"audioView"];
        self.videoView              = [aDecoder decodeObjectForKey:@"videoView"];
        self.userStatusImage        = [aDecoder decodeObjectForKey:@"userStatusImage"];
        self.status                 = [aDecoder decodeObjectForKey:@"status"];
        self.userPremiumUpgrade     = [aDecoder decodeObjectForKey:@"userPremiumUpgrade"];
        self.registerTime           = [aDecoder decodeObjectForKey:@"registerTime"];
        self.facebookId             = [aDecoder decodeObjectForKey:@"facebookId"];
        self.facebookURL            = [aDecoder decodeObjectForKey:@"facebookURL"];
        self.userName               = [aDecoder decodeObjectForKey:@"userName"];
        
    }
    
    return self;
}

//-- get profile
+(Profile*)sharedProfile
{
    /*
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_INFO];
    Profile *profile = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return profile;
     */
    if (!currentProfile)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            currentProfile = [Profile new];
        });
    }
    return currentProfile;
}

+ (void)setProfile:(Profile *)aProfile
{
    [self sharedProfile].userId             = aProfile.userId;
    [self sharedProfile].userType           = aProfile.userType;
    [self sharedProfile].fullName           = aProfile.fullName;
    [self sharedProfile].userImage          = aProfile.userImage;
    [self sharedProfile].point              = aProfile.point;
    [self sharedProfile].rankPosition       = aProfile.rankPosition;
    [self sharedProfile].totalShare         = aProfile.totalShare;
    [self sharedProfile].totalChat          = aProfile.totalChat;
    [self sharedProfile].totalLike          = aProfile.totalLike;
    [self sharedProfile].totalComment       = aProfile.totalComment;
    [self sharedProfile].audioView          = aProfile.audioView;
    [self sharedProfile].videoView          = aProfile.videoView;
    [self sharedProfile].userStatusImage    = aProfile.userStatusImage;
    [self sharedProfile].status             = aProfile.status;
    [self sharedProfile].userPremiumUpgrade = aProfile.userPremiumUpgrade;
    [self sharedProfile].registerTime       = aProfile.registerTime;
    [self sharedProfile].facebookId         = aProfile.facebookId;
    [self sharedProfile].facebookURL        = aProfile.facebookURL;
    [self sharedProfile].userName           = aProfile.userName;
}

@end
