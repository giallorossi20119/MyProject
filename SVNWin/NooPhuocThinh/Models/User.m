//
//  User.m
//  NooPhuocThinh
//
//  Created by HuntDo on 12/6/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize idUser;
@synthesize nameUser;
@synthesize pointOfUser;
@synthesize urlAvatarUser;

+ (User *) myAccount
{
    User *my = [User new];
    my.idUser = @"2851990";
    my.nameUser = @"Hunt";
    my.pointOfUser = @"500";
    my.urlAvatarUser = @"avt05.png";
    return my;
}
@end
