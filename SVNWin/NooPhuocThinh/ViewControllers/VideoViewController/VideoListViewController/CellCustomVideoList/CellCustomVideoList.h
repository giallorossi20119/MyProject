//
//  CellCustomVideoList.h
//  NooPhuocThinh
//
//  Created by longnh on 1/3/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellCustomVideoList : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView        *imgViewVideo;
@property (weak, nonatomic) IBOutlet UIImageView        *imgLine;
@property (weak, nonatomic) IBOutlet UILabel            *lblNameVideo;
@property (weak, nonatomic) IBOutlet UILabel            *lblCountPlay;
@property (weak, nonatomic) IBOutlet UIButton           *btnLike;
@property (weak, nonatomic) IBOutlet UILabel            *lblCountLike;
@property (weak, nonatomic) IBOutlet UILabel            *lblCountComments;
@property (weak, nonatomic) IBOutlet UILabel            *lblCountShares;

@end
