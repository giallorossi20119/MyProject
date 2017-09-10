//
//  User.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/6/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic, retain) NSString       *idUser;
@property(nonatomic, retain) NSString       *nameUser;
@property(nonatomic, retain) NSString       *pointOfUser;
@property(nonatomic, retain) NSString       *urlAvatarUser;

+ (User *) myAccount;

@end
