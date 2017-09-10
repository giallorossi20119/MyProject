//
//  SlideBarCenterViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "SlideBarCenterViewController.h"

#import "Notifications.h"
#import <AVFoundation/AVFoundation.h>

extern NSString *remoteControlPlayPauseButtonTapped;
extern NSString *remoteControlStopButtonTapped;
extern NSString *remoteControlForwardButtonTapped;
extern NSString *remoteControlBackwardButtonTapped;

@interface SlideBarCenterViewController ()

@end

static SlideBarCenterViewController *sharedSlideBar = nil;

@implementation SlideBarCenterViewController

@synthesize musicTrack, arrTrack;
@synthesize viewMusic,viewNews;
@synthesize sliderBar, sliderTimer, lblNameSong, lblTimeSong;
@synthesize btnPlayPause, btnNext, btnShowNews;
@synthesize btnHiddenNews,btnShowMusic;
@synthesize totalTimeString, indexOfSong;
@synthesize lblContentFZ;
@synthesize lblTitleNews;
@synthesize listMessagesFZ, imgViewVolume;


//***********************************************************************//
#pragma mark - Main

+ (SlideBarCenterViewController *)sharedSlideBarCenter
{
    if (sharedSlideBar == nil) {
        static dispatch_once_t threeToken;
        dispatch_once(&threeToken, ^{
            sharedSlideBar = [[SlideBarCenterViewController alloc] init];
        });
    }
    
    return sharedSlideBar;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        timerChangeView = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                           target:self
                                                         selector:@selector(autoTimerChangeView)
                                                         userInfo:nil
                                                          repeats:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //-- set Delegate
    [AudioPlayer addDelegateAudio:self];
    
    //-- custom UISlider
    [self customSlider];
    
    //-- get new Fanzone limit 5
    [self fetchingFanzoneNew];
    
    //-- default hidden view music
    viewMusic.alpha = 0;
    viewNews.alpha = 1;
    
    
    /*
     *  Listen for the appropriate notifications.
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlPlayPauseButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlStopButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlForwardButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlBackwardButtonTapped object:nil];
}


#pragma mark - Remote Handling

/*  This method logs out when a
 *  remote control button is pressed.
 *
 *  In some cases, it will also manipulate the stream.
 */

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:remoteControlPlayPauseButtonTapped]) {
        [[AudioPlayer sharedAudioPlayerMusic] play];
        
    } else if ([notification.name isEqualToString:remoteControlStopButtonTapped]) {
        
        [[AudioPlayer sharedAudioPlayerMusic] stop];
        
    } else if ([notification.name isEqualToString:remoteControlForwardButtonTapped]) {
        
        [[AudioPlayer sharedAudioPlayerMusic] playNextSong];
        
    } else if ([notification.name isEqualToString:remoteControlBackwardButtonTapped]) {
        
        [[AudioPlayer sharedAudioPlayerMusic] playPreviousSong];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    indexTapFanzone = @"0";
    
    //-- scroll news
    [self autoScrollNewsContent];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-- scroll news
- (void)autoScrollNewsContent
{
    self.lblTitleNews.hidden = NO;
    self.lblContentFZ.hidden = YES;
    
    //-- lable News default
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *default_MessageFZ = [userDefaults valueForKey:Key_Default_Message];
    if (!default_MessageFZ || [default_MessageFZ length] == 0) {
        default_MessageFZ = @"Click vào đây để giao lưu tương tác trực tuyến";
    }
    
    self.lblTitleNews.text = default_MessageFZ;
    [self.lblTitleNews setFont:[UIFont systemFontOfSize:13]];
    self.lblTitleNews.textColor = [UIColor whiteColor];
    self.lblTitleNews.labelSpacing = 200; // distance between start and end labels
    self.lblTitleNews.pauseInterval = 0.3; // seconds of pause before scrolling starts again
    self.lblTitleNews.scrollSpeed = 30; // pixels per second
    self.lblTitleNews.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    self.lblTitleNews.fadeLength = 12.f;
    self.lblTitleNews.shadowOffset = CGSizeMake(-1, -1);
    self.lblTitleNews.scrollDirection = CBAutoScrollDirectionLeft;
    
    
    //-- lable show content FanZone
    [self.lblContentFZ setFont:[UIFont systemFontOfSize:13]];
    self.lblContentFZ.textColor = [UIColor whiteColor];
    self.lblContentFZ.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
    self.lblContentFZ.shadowOffset = CGSizeMake(-1, -1);
    self.lblContentFZ.frame = CGRectMake(94, 11, 220, 18);
    
    //-- lable Name Song
    lblNameSong.textColor = [UIColor whiteColor];
    lblNameSong.font = [UIFont systemFontOfSize:12];
    lblNameSong.labelSpacing = 200; // distance between start and end labels
    lblNameSong.pauseInterval = 0.3; // seconds of pause before scrolling starts again
    lblNameSong.scrollSpeed = 30; // pixels per second
    lblNameSong.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
    lblNameSong.fadeLength = 12.f;
    lblNameSong.shadowOffset = CGSizeMake(-1, -1);
    lblNameSong.scrollDirection = CBAutoScrollDirectionLeft;
}

//-- Custom UISlider
- (void)customSlider
{
    NSURL *firstUrl = [[NSBundle mainBundle] URLForResource:@"icon_volume" withExtension:@"gif"];
    
    UIImageView *firstAnimation = [AnimatedGif getAnimationForGifAtUrl: firstUrl];
    [self.imgViewVolume addSubview:firstAnimation];
    
    [sliderBar setThumbImage:[UIImage imageNamed:@"slider_tincolor.png"] forState:UIControlStateNormal];
    [sliderBar setMinimumTrackImage:[[UIImage imageNamed:@"slide_max.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0.0] forState:UIControlStateNormal];
    [sliderBar setMaximumTrackImage:[[UIImage imageNamed:@"slider_min.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    sliderBar.value = 0;
    [sliderBar addTarget:self
                  action:@selector(sliderDidEndSliding:)
        forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
}


//***********************************************************************//
#pragma mark - Get Fanzone

-(void) fetchingFanzoneNew {
    
    [API getDataShoutBox:SINGER_ID
                   limit:@"5"
               startTime:@""
                 endTime:@""
                   appId:PRODUCTION_ID
              appVersion:PRODUCTION_VERSION
               completed:^(NSDictionary *responseDictionary, NSError *error) {
                   
                   if (!error) {
                       [self createDatasourceShoutData:responseDictionary];
                   }
               }];
}

- (void)createDatasourceShoutData:(NSDictionary *)aDict
{
    NSMutableArray *arrTmp = [aDict objectForKey:@"data"];
    
    if ([arrTmp count] > 0) {
        
        NSMutableArray *arrData = [[[aDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"];
        
        if (arrData.count > 0) {
            
            if (![[NSUserDefaults standardUserDefaults] valueForKey:@"firstRunFanzone"]) {
                
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"firstRunFanzone"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if (!listMessagesFZ) {
                listMessagesFZ = [[NSMutableArray alloc]init];
            }else {
                
                [listMessagesFZ removeAllObjects];
            }
            
            for (NSInteger i = (arrData.count - 1); i >= 0; i--) {
                
                NSDictionary *dict = [arrData objectAtIndex:i];
                
                Profile *profile    = [Profile new];
                profile.userId      = [dict objectForKey:@"user_id"];
                profile.userName    = [dict objectForKey:@"user_name"];
                profile.fullName    = [dict objectForKey:@"full_name"];
                profile.userImage   = [dict objectForKey:@"user_image"];
                
                Comment *comment                = [Comment new];
                comment.commentId               = [dict objectForKey:@"shout_id"];
                comment.commentSuperId          = @"";
                comment.content                 = [dict objectForKey:@"text"];
                comment.timeStamp               = [dict objectForKey:@"time_stamp"];
                comment.numberOfSubcommments    = [dict objectForKey:@"number_of_subcomments"];
                comment.arrSubComments          = [NSMutableArray new];
                comment.profileUser             = profile;
                
                //-- add to datasource
                [listMessagesFZ addObject:comment];
            }
        }
    }
    
    /*
     * Shoot latest message to music control. send total 5 messages
     * Pass data to Slidebar Bottom
     */
    
    if (listMessagesFZ.count >0) {
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
        [listMessagesFZ sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        totalCountScrollUpLable = 0;
        
        [timerScrollUp invalidate];
        timerScrollUp = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                         target:self
                                                       selector:@selector(scrollUpLableFanzone)
                                                       userInfo:nil
                                                        repeats:YES];
    }
    
}


//***********************************************************************//
#pragma mark - ACTION

//-- change show view by NSTimer
- (void) autoTimerChangeView {
    
    if (viewNews.alpha == 0) {
        
        CGRect frameViewMusic = [viewMusic frame];
        CGRect frameViewNews = [viewNews frame];
        
        frameViewMusic.origin.x -= 320;
        frameViewNews.origin.x += 320;
        
        [UIView animateWithDuration:0.45 animations:^{
            
            [viewMusic setFrame:frameViewMusic];
            [viewNews setFrame:frameViewNews];
            
            viewNews.alpha = 1;
            viewMusic.alpha = 0;
        }];
    }
}

- (IBAction)clickToBtnShowAndHiddenSlideMusic:(id)sender {
    NSLog(@"%s", __func__);
   
    CGRect frameViewMusic = [viewMusic frame];
    CGRect frameViewNews = [viewNews frame];
    
    if (viewNews.alpha == 1) {
        
        //-- change image button
        if ([[AudioPlayer sharedAudioPlayerMusic] isPlayingSong]) {
            
            //-- load data MusicSong
            [self loadDataMusicSong];
            
            [btnPlayPause setImage:[UIImage imageNamed:@"btn_pause_player.png"] forState:UIControlStateNormal];
        }else {
            
            [btnPlayPause setImage:[UIImage imageNamed:@"btn_play_player.png"] forState:UIControlStateNormal];
        }
        
        //-- change show view music
        frameViewMusic.origin.x += 320;
        frameViewNews.origin.x -=320;
        
        [UIView animateWithDuration:0.35 animations:^{
            
            [viewMusic setFrame:frameViewMusic];
            [viewNews setFrame:frameViewNews];
            
            viewNews.alpha = 0;
            viewMusic.alpha = 1;
        }];
        
    }else {
        
        frameViewMusic.origin.x -= 320;
        frameViewNews.origin.x += 320;
        
        [UIView animateWithDuration:0.35 animations:^{
            
            [viewMusic setFrame:frameViewMusic];
            [viewNews setFrame:frameViewNews];
            
            viewNews.alpha = 1;
            viewMusic.alpha = 0;
        }];
    }
}

- (IBAction)clickToBtnPlayPauseSongSlidBar:(id)sender
{
    NSLog(@"%s", __func__);
    if ([[[AudioPlayer sharedAudioPlayerMusic] listSongsAlbum] count] > 0) {
        
        if ([[AudioPlayer sharedAudioPlayerMusic] isPlayingSong]) {
            
            [btnPlayPause setImage:[UIImage imageNamed:@"btn_play_player.png"] forState:UIControlStateNormal];
            
            [[AudioPlayer sharedAudioPlayerMusic] pauseSong];
            
        }else {
            
            [btnPlayPause setImage:[UIImage imageNamed:@"btn_pause_player.png"] forState:UIControlStateNormal];
            
            //longnh add
//            NSArray *songArray = [[AudioPlayer sharedAudioPlayerMusic] listSongsAlbum];
//            musicTrack = [songArray objectAtIndex:[[AudioPlayer sharedAudioPlayerMusic] indexOfSong]];
//            NSLog(@"%@",musicTrack.musicType);
            if ([[AudioPlayer sharedAudioPlayerMusic] isStartMusic]) {
//            if ([musicTrack.musicType isEqualToString:@"welcome_music"]) {
                [[AudioPlayer sharedAudioPlayerMusic] play1];
                
            } else {
                [[AudioPlayer sharedAudioPlayerMusic] play];
            }
        }
        
        //-- Call notification reload data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload_MusicAlbumVC" object:nil];
        
    }else {
        
        //-- Call notification to MainVC
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Going_To_MusicHomeVC" object:nil];
    }
}


- (IBAction)clickToBtnNextSongSlidBar:(id)sender
{
    NSLog(@"%s", __func__);
    //-- stop song
    [[AudioPlayer sharedAudioPlayerMusic] stop];
    
    NSUserDefaults *defaultSelectedSong = [NSUserDefaults standardUserDefaults];
    [defaultSelectedSong setBool:YES forKey:@"Selected_ButtonNextSlideBar"];
    [defaultSelectedSong synchronize];
    
    if ([[[AudioPlayer sharedAudioPlayerMusic] listSongsAlbum] count] > 0) {
        
        sliderBar.value = 0;
        
        //-- play next song
        [[AudioPlayer sharedAudioPlayerMusic] playNextSong];
        
        //-- call api data view
        NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
        NSString *tempSongId = [NSString stringWithFormat:@"%@",[defaultSongId valueForKey:@"DefaultSongId"]];
        
        [self apiDataView:tempSongId contentTypeId:TYPE_ID_MUSIC_SONG];
        
        
        //-- load data MusicSong
        [self loadDataMusicSong];
    }
}


- (IBAction)clickToBtnPreviousSongSlidBar:(id)sender
{
    NSLog(@"%s", __func__);
    if ([[[AudioPlayer sharedAudioPlayerMusic] listSongsAlbum] count] > 0) {
        
        sliderBar.value = 0;
        
        //-- play previous song
        [[AudioPlayer sharedAudioPlayerMusic] playPreviousSong];
        
        //-- call api data view
        NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
        NSString *tempSongId = [NSString stringWithFormat:@"%@",[defaultSongId valueForKey:@"DefaultSongId"]];
        
        [self apiDataView:tempSongId contentTypeId:TYPE_ID_MUSIC_SONG];
        
        [btnPlayPause setImage:[UIImage imageNamed:@"btn_pause_player.png"] forState:UIControlStateNormal];
        
        //-- load data MusicSong
        [self loadDataMusicSong];
    }
}


- (IBAction)clickBtnHiddenNews:(id)sender
{
    NSLog(@"%s", __func__);
    //-- Call notification to MainVC
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Going_To_FanzoneVC" object:indexTapFanzone];
}


//***********************************************************************//
#pragma mark - Load Data

-(void) loadDataMusicSong {
    NSLog(@"%s", __func__);

    //-- setup scrolling label
    NSUserDefaults *defaultSong = [NSUserDefaults standardUserDefaults];
    
    lblNameSong.text = [defaultSong valueForKey:@"DefaultNameSong"];
    lblNameSong.textColor = [UIColor whiteColor];
    lblNameSong.font = [UIFont systemFontOfSize:12];
    lblNameSong.labelSpacing = 200; // distance between start and end labels
    lblNameSong.pauseInterval = 0.3; // seconds of pause before scrolling starts again
    lblNameSong.scrollSpeed = 30; // pixels per second
    lblNameSong.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
    lblNameSong.fadeLength = 12.f;
    lblNameSong.shadowOffset = CGSizeMake(-1, -1);
    lblNameSong.scrollDirection = CBAutoScrollDirectionLeft;
    
    //-- setup time
    lblTimeSong.text = @"";
}


//***********************************************************************//
#pragma mark - AudioPlayerDelegate

//-- reset data song
-(void) resetInfoMusicSong {
    NSLog(@"%s", __func__);
   
    //-- stop song
    [[AudioPlayer sharedAudioPlayerMusic] stop];
    
    sliderBar.value = 0;
    lblTimeSong.text = @"0:00";
    
    //-- Music completed
    [btnPlayPause setImage:[UIImage imageNamed:@"btn_play_player.png"] forState:UIControlStateNormal];
}


//-- update user
-(void) checkUpdateLevelOfUserWithSlider:(CGFloat)sliderValue {
//    NSLog(@"%s", __func__);
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (!userId) {
        
        //-- not exist music local
        if ([AudioPlayer sharedAudioPlayerMusic].fixedLength == NO) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger timeTrailerMusic = [[userDefaults valueForKey:Key_Trailer_Info_Music] integerValue];
            
            if (sliderValue >= timeTrailerMusic) {
                
                //-- reset data song
                [self resetInfoMusicSong];
                
                //-- thông báo nâng cấp user
                [self showMessageUpdateLevelOfUser];
            }
        }
    }
}

- (void)updateTimerSliderAudio:(NSString *)sliderTimerAudio WithSlider:(CGFloat)sliderValue withSliderMaxvalue:(CGFloat)maxvalue
{
    NSUserDefaults *defaultEditSlider = [NSUserDefaults standardUserDefaults];
    //NSLog(@"slide:%f max:%f",sliderValue,maxvalue);
    if ([defaultEditSlider boolForKey:@"isEditSlider"] == NO) {
        //longnh fix
        if ([[AudioPlayer sharedAudioPlayerMusic] isStartMusic] && sliderValue < maxvalue) {
            sliderBar.maximumValue = maxvalue;
            sliderBar.value = sliderValue;
            
        } else {
            if (maxvalue > 60 && sliderValue < maxvalue) {
                
                sliderBar.maximumValue = maxvalue;
                sliderBar.value = sliderValue;
            }
        }
        lblTimeSong.text = sliderTimerAudio;
        
        //-- get Music Name
        NSUserDefaults *defaultSong = [NSUserDefaults standardUserDefaults];
        lblNameSong.text = [defaultSong valueForKey:@"DefaultNameSong"];
        
        //-- check update level
        [self checkUpdateLevelOfUserWithSlider:sliderValue];
    }
}

- (void)sliderDidEndSliding:(NSNotification *)notification {
    NSLog(@"%s", __func__);

    if ([[AudioPlayer sharedAudioPlayerMusic] isPausedSong]) {
        
        [[AudioPlayer sharedAudioPlayerMusic] play];
    }
    
    //-- Fast skip the music when user scroll the UISlider
    [[AudioPlayer sharedAudioPlayerMusic] updateSlideChangedToTimeByValue:sliderBar.value];
    [self checkUpdateLevelOfUserWithSlider:sliderBar.value];
    
    [self performSelector:@selector(updateSliderAgainWhenHandleSilderBar) withObject:nil afterDelay:0.5];
}

-(void)updateSliderAgainWhenHandleSilderBar {
    NSLog(@"%s", __func__);

    NSUserDefaults *defaultEditSlider = [NSUserDefaults standardUserDefaults];
    [defaultEditSlider setBool:NO forKey:@"isEditSlider"];
    [defaultEditSlider synchronize];
}

- (IBAction)updateSlideChanged:(UISlider *)slider
{
    NSUserDefaults *defaultEditSlider = [NSUserDefaults standardUserDefaults];
    [defaultEditSlider setBool:YES forKey:@"isEditSlider"];
    [defaultEditSlider synchronize];
    
    sliderBar.value = slider.value;
}



//***********************************************************************//
#pragma mark - AudioPlay Delegate

- (void)setUpSlideBarBottomByIsPlaying:(BOOL) isplaying {
    
    CGRect frameViewMusic = [viewMusic frame];
    CGRect frameViewNews = [viewNews frame];
    
    if (viewNews.alpha == 1) {
        
        //-- load data MusicSong
        [self loadDataMusicSong];
        
        //-- change show view music
        frameViewMusic.origin.x += 320;
        frameViewNews.origin.x -=320;
        
        [UIView animateWithDuration:0.35 animations:^{
            
            [viewMusic setFrame:frameViewMusic];
            [viewNews setFrame:frameViewNews];
            
            viewNews.alpha = 0;
            viewMusic.alpha = 1;
        }];
        
    }
    
    if (isplaying == YES) {
        
        [btnPlayPause setImage:[UIImage imageNamed:@"btn_pause_player.png"] forState:UIControlStateNormal];
    }else {
        
        [btnPlayPause setImage:[UIImage imageNamed:@"btn_play_player.png"] forState:UIControlStateNormal];
    }
}

- (void)playFinishedAudio
{
    //-- Music completed
    [btnPlayPause setImage:[UIImage imageNamed:@"btn_play_player.png"] forState:UIControlStateNormal];
    
    //-- auto next song
    [self clickToBtnNextSongSlidBar:btnNext];
}


- (void)playFailedAudio
{
    //-- Music completed
    [btnPlayPause setImage:[UIImage imageNamed:@"btn_play_player.png"] forState:UIControlStateNormal];
    
    //------ Music Failed -----//
    [self showNotificationFailed];
    
    //-- request error network
    [self callRequestErrorNetwork];
}


//-- Fanzone Delegate
-(void) fanZoneViewController:(FanZoneViewController *)fanZoneViewController sendLatestMessages:(NSMutableArray *)latestMessages {
    
    if (latestMessages.count >0) {
        
        if (!listMessagesFZ) {
            listMessagesFZ = [[NSMutableArray alloc]init];
        }else {
            
            [listMessagesFZ removeAllObjects];
        }
        
        listMessagesFZ = latestMessages;
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
        [latestMessages sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        totalCountScrollUpLable = 0;
        
        [timerScrollUp invalidate];
        timerScrollUp = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                           target:self
                                                         selector:@selector(scrollUpLableFanzone)
                                                         userInfo:nil
                                                          repeats:YES];
    }
}

//-- scroll up text fanzone
-(void) scrollUpLableFanzone {
    
    self.lblTitleNews.hidden = YES;
    self.lblContentFZ.hidden = NO;
    
    self.lblContentFZ.alpha = 1;
    self.lblContentFZ.frame = CGRectMake(94, 39, 220, 18);
    
    if (totalCountScrollUpLable >= listMessagesFZ.count)
        totalCountScrollUpLable = 0;
        
    Comment *sbInfo = [listMessagesFZ objectAtIndex:totalCountScrollUpLable];
    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
//        
//        //-- create JSON
//        NSMutableAttributedString *AattrString = [[NSMutableAttributedString alloc] init];
//        
//        NSString *fullNameStr = [NSString stringWithFormat:@"%@: ",sbInfo.profileUser.fullName];
//        NSString *textStr = [NSString stringWithFormat:@"%@",sbInfo.content];
//        
//        //-- format content
//        NSDictionary *arialdict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName,[UIColor yellowColor],NSForegroundColorAttributeName, nil];
//        NSMutableAttributedString *fullName = [[NSMutableAttributedString alloc]initWithString:fullNameStr attributes:arialdict];
//        [AattrString appendAttributedString:fullName];
//        
//        NSDictionary *veradnadict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
//        NSMutableAttributedString *VattrString = [[NSMutableAttributedString alloc]initWithString:textStr attributes:veradnadict];
//        
//        [AattrString appendAttributedString:VattrString];
//        
//        self.lblContentFZ.attributedText = AattrString;
//        
//    }else {
//        
//        //-- create JSON
//        NSString *slideBarFZString = @"";
//        
//        slideBarFZString = [slideBarFZString stringByAppendingString:[NSString stringWithFormat:@"%@: %@",sbInfo.profileUser.userName,sbInfo.content]];
//        
//        if ([slideBarFZString length] > 0) {
//            
//            self.lblContentFZ.text = slideBarFZString;
//        }
//    }

    if ([sbInfo.timeStamp integerValue] < [self unixTimeForStartTimeToday])
        indexTapFanzone = @"1";
    else
        indexTapFanzone = @"0";
    
    NSString *textStr = [NSString stringWithFormat:@"%@",sbInfo.content];
    self.lblContentFZ.text = textStr;
    
    totalCountScrollUpLable ++;
    
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.lblContentFZ.frame = CGRectMake(94, 11, 220, 18);
        
    } completion:^(BOOL finished) {
        
        self.lblContentFZ.frame = CGRectMake(94, 11, 220, 18);
        
        [UIView animateWithDuration:1.0 animations:^{
            
            self.lblContentFZ.alpha = 0;
            self.lblContentFZ.frame = CGRectMake(94, 0, 220, 18);
        }];
        
    }];
    
}

- (NSInteger)unixTimeForStartTimeToday
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit //longnh add timezone
                                                   fromDate:now];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    NSDate *midnightUTC = [calendar dateFromComponents:dateComponents];
    
    return [midnightUTC timeIntervalSince1970];
}


@end
