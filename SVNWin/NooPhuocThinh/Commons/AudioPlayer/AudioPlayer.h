//
//  AudioPlayer.h
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MulticastDelegate.h"

@class AudioButton;
@class AudioStreamer;

@protocol AudioPlayerDelegate;

@interface AudioPlayer : NSObject {
    
    AudioStreamer *streamer;
    AudioButton *button;
    
    NSURL *url;
    NSTimer *timer;
    
@public
    MulticastDelegate<AudioPlayerDelegate> *delegatesAudio;
}

+ (AudioPlayer *)sharedAudioPlayerMusic;

@property (nonatomic, retain) id<AudioPlayerDelegate>   delegateAudio;

@property (nonatomic, retain) AudioStreamer     *streamer;
@property (nonatomic, retain) AudioButton       *button;
@property (nonatomic, retain) NSURL             *url;

@property (nonatomic, retain) NSMutableArray    *listSongsAlbum;
@property (nonatomic, assign) NSInteger         indexOfSong;
@property (nonatomic, retain) NSString          *totalTimeString;
@property (nonatomic, retain) NSString          *sliderTimer;
@property (nonatomic, retain) UISlider          *sliderBar;
@property (nonatomic) BOOL                      fixedLength;
@property (nonatomic) BOOL                      isStartMusic;

+ (void)initWithDelegateAudio:(id<AudioPlayerDelegate>) delegateAudio;
+ (void)addDelegateAudio:(id)delegateAudio;
+ (void)removeDelegateAudio:(id)delegateAudio;

- (void)play;
- (void)play1;
- (void)stop;
- (BOOL)isProcessing;

- (BOOL)isFinishingSong;
- (BOOL)isPlayingSong;
- (BOOL)isPausedSong;
- (BOOL)isWaitingSong;
- (BOOL)isIdleSong;

- (void)setVolumeMusic:(float)Level;

-(void) pauseSong;
-(void) updateSlideChangedToTimeByValue:(double) sliderValue;

- (void)playNextSong;
- (void)playPreviousSong;
//Add by TuanNM@20140828
//kiem tra xem co phai dang play welcome music ko
- (bool)isPlayWelcomeMusic;
// Chon bai hat de play dang welcome hay la trong album
- (void)setSongToPlay;
//end adding
@end

@protocol AudioPlayerDelegate <NSObject>

@optional

- (void)updateTimerSliderAudio:(NSString *)sliderTimerAudio WithSlider:(CGFloat)sliderValue withSliderMaxvalue:(CGFloat)maxvalue;

- (void)setUpSlideBarBottomByIsPlaying:(BOOL) isplaying;

- (void)playFinishedAudio;
- (void)playFailedAudio;

@end
