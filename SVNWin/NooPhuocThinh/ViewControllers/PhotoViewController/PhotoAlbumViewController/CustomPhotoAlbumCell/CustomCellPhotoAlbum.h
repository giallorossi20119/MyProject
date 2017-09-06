//
//  CustomCellPhotoAlbum.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/26/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellPhotoAlbum : UITableViewCell

@property (weak) IBOutlet UIImageView          *imageLeft;
@property (weak) IBOutlet UIImageView          *imageCenter;
@property (weak) IBOutlet UIImageView          *imageRight;
@property (nonatomic) IBOutlet UIActivityIndicatorView      *indicatorLeft;
@property (nonatomic) IBOutlet UIActivityIndicatorView      *indicatorCenter;
@property (nonatomic) IBOutlet UIActivityIndicatorView      *indicatorRight;


@end
