//
//  NewsCellCustom.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum{
    
    NewsCellCustomTypeForListNews=0
    
}NewsCellCustomType;

@interface NewsCellCustom : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgViewBackground;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewAvatar;
@property (nonatomic, strong) IBOutlet UILabel     *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel     *lblShortContent;
@property (nonatomic, strong) IBOutlet UILabel     *lblCommentCount;
@property (nonatomic, strong) IBOutlet UIButton    *btnComment;
@property (nonatomic, strong) IBOutlet UILabel     *lblDate;


+ (NewsCellCustom *) cellWithCustomType:(NewsCellCustomType) cellCustomEventType;

@end
