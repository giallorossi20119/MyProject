//
//  UserType.m
//  NooPhuocThinh
//
//  Created by HuntDo on 1/10/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "UserType.h"

@implementation UserType

@synthesize upUserType;  //-- upgrade level user
@synthesize userContentTypeSetting; //-- rule for content type
@synthesize userRegister;
@synthesize userMaxTotalPoint;
@synthesize userMinTotalPoint;
@synthesize userTypeDescription;
@synthesize userTypeId;
@synthesize userTypeKey;
@synthesize userTypeName;


//-- encode
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:upUserType                 forKey:@"upUserType"];
    [aCoder encodeObject:userContentTypeSetting     forKey:@"userContentTypeSetting"];
    [aCoder encodeObject:userRegister               forKey:@"userRegister"];
    [aCoder encodeObject:userMaxTotalPoint          forKey:@"userMaxTotalPoint"];
    [aCoder encodeObject:userMinTotalPoint          forKey:@"userMinTotalPoint"];
    [aCoder encodeObject:userTypeDescription        forKey:@"userTypeDescription"];
    [aCoder encodeObject:userTypeId                 forKey:@"userTypeId"];
    [aCoder encodeObject:userTypeKey                forKey:@"userTypeKey"];
    [aCoder encodeObject:userTypeName               forKey:@"userTypeName"];
    
}

//-- decode
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.upUserType                 = [aDecoder decodeObjectForKey:@"upUserType"];
        self.userContentTypeSetting     = [aDecoder decodeObjectForKey:@"userContentTypeSetting"];
        self.userRegister               = [aDecoder decodeObjectForKey:@"userRegister"];
        self.userMaxTotalPoint          = [aDecoder decodeObjectForKey:@"userMaxTotalPoint"];
        self.userMinTotalPoint          = [aDecoder decodeObjectForKey:@"userMinTotalPoint"];
        self.userTypeDescription        = [aDecoder decodeObjectForKey:@"userTypeDescription"];
        self.userTypeId                 = [aDecoder decodeObjectForKey:@"userTypeId"];
        self.userTypeKey                = [aDecoder decodeObjectForKey:@"userTypeKey"];
        self.userTypeName               = [aDecoder decodeObjectForKey:@"userTypeName"];
    }
    
    return self;
}


@end
