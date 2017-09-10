//
//  ViewStoreDetail.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 1/7/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "ViewStoreDetail.h"

@implementation ViewStoreDetail

@synthesize webViewStoreDetail;
@synthesize imgViewMain;
@synthesize lblValue;
@synthesize lblCodeProduct;
@synthesize lblPhone;
@synthesize scrollViewMain;
@synthesize viewValue;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.webViewStoreDetail    forKey:@"webViewStoreDetail"];
    [aCoder encodeObject:self.imgViewMain           forKey:@"imgViewMain"];
    [aCoder encodeObject:self.lblValue              forKey:@"lblValue"];
    [aCoder encodeObject:self.lblCodeProduct        forKey:@"lblCodeProduct"];
    [aCoder encodeObject:self.lblPhone              forKey:@"lblPhone"];
    [aCoder encodeObject:self.scrollViewMain        forKey:@"scrollViewMain"];
    [aCoder encodeObject:self.viewValue             forKey:@"viewValue"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.webViewStoreDetail     = [aDecoder decodeObjectForKey:@"webViewStoreDetail"];
        self.imgViewMain            = [aDecoder decodeObjectForKey:@"imgViewMain"];
        self.lblValue               = [aDecoder decodeObjectForKey:@"lblValue"];
        self.lblCodeProduct         = [aDecoder decodeObjectForKey:@"lblCodeProduct"];
        self.lblPhone               = [aDecoder decodeObjectForKey:@"lblPhone"];
        self.scrollViewMain         = [aDecoder decodeObjectForKey:@"scrollViewMain"];
        self.viewValue              = [aDecoder decodeObjectForKey:@"viewValue"];
    }
    return self;
}


@end
