//
//  Comment.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/6/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Comment : NSObject

@property (nonatomic, retain) NSString          *commentId; //-- id of current comment
@property (nonatomic, retain) NSString          *commentSuperId; //-- id of super comment
@property (nonatomic, retain) NSString          *content;
@property (nonatomic, retain) NSString          *numberOfSubcommments;
@property (nonatomic, retain) NSString          *timeStamp;
@property (nonatomic, retain) Profile           *profileUser;
@property (nonatomic, retain) NSMutableArray    *arrSubComments;

@end
