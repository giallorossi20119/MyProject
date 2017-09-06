//
//  MusicCustomCellAlbum.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "MusicCustomCellAlbum.h"

@implementation MusicCustomCellAlbum

@synthesize imgBgCell,lblArtist, btnDownload, btnPhone, btnPlay, audioButton = _audioButton;

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

- (void)configurePlayerButton
{
    // use initWithFrame to drawRect instead of initWithCoder from xib
    self.audioButton = [[AudioButton alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    [self.contentView addSubview:self.audioButton];
}

#pragma mark Spin for cell

- (void)startSpinWithCell
{
    if (!loadingView) {
        loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(255, 7, 35, 35)];
        loadingView.image = [UIImage imageNamed:@"loading.png"];
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
