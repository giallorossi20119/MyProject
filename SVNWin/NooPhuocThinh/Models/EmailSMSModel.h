//
//  EmailSMSModel.h
//  FanZombie
//
//  Created by Duc Trong on 3/28/13.
//  Copyright (c) 2013 vmodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailSMSModel : NSObject
{
    NSString *firstName;
    NSString *lastName;
    NSString *fullName;
    NSString *phoneNumber;
    NSString *emailAddress;
    NSString *fullInfo;
    UIImage *imgContactList;
}

@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) NSString *fullName;
@property (nonatomic,retain) NSString *phoneNumber;
@property (nonatomic,retain) NSString *emailAddress;
@property (nonatomic,retain) NSString *fullInfo;
@property (nonatomic, retain) UIImage *imgContactList;

@end
