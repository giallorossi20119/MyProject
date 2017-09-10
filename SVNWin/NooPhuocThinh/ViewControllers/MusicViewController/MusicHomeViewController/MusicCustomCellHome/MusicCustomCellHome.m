//
//  MusicCustomCellHome.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "MusicCustomCellHome.h"

@implementation MusicCustomCellHome

@synthesize imgAvatar, lblArtist, lblComment, lblDownload, lblHeadphone, lblLike;
@synthesize imgComment, imgDownload, imgHeadphone, imgLike;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Spin for cell

- (void)startSpinWithCell
{
    if (!loadingView) {
        loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 48, 48)];
        loadingView.image = [UIImage imageNamed:@"loading@2x.png"];
        [self addSubview:loadingView];
    }
    
    loadingView.hidden = NO;
    
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [loadingView frame];
	loadingView.layer.anchorPoint = CGPointMake(0.5, 0.5);
	loadingView.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
    
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[loadingView.layer addAnimation:animation forKey:@"rotationAnimation"];
    
	[CATransaction commit];
}

- (void)stopSpinWithCell
{
    [loadingView.layer removeAllAnimations];
    loadingView.hidden = YES;
}

@end
