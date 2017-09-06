//
//  CellCustomStore.h
//  NooPhuocThinh
//
//  Created by HuntDo on 1/6/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

typedef enum
{
    CellCustomStoreTypeHome=0
}CellCustomStoreType;

#import <UIKit/UIKit.h>

@interface CellCustomStore : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imvProduct1;
@property (weak, nonatomic) IBOutlet UIImageView *imvProduct2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice1;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice2;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

+ (CellCustomStore *) cellWithCustomType:(CellCustomStoreType) cellCustomEventType;

@end
