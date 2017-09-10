//
//  BaseTableMusicViewController.m
//  NooPhuocThinh
//
//  Created by longnh on 12/27/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "BaseTableMusicViewController.h"
#import "MusicCustomCellAlbum.h"
#import "SlideBarCenterViewController.h"
#import "AudioPlayer.h"
#import "ModelDownload.h"

@interface BaseTableMusicViewController ()

@end

@implementation BaseTableMusicViewController

@synthesize listData;
@synthesize listDownloadSelected;
@synthesize delegate;
@synthesize notice,noticeSuccess;
@synthesize musicDownloadsInProgress;

//****************************************************************************//
#pragma mark - Main

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!listDownloadSelected)
        listDownloadSelected = [[NSMutableArray alloc] init];
    else
        [listDownloadSelected removeAllObjects];
    
    
    //--set background for TableView
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
//    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    self.musicDownloadsInProgress = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSArray *allDownloads = [self.musicDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}


//****************************************************************************//
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicCustomCellAlbum *cell = [self setCustomTableViewCellForWithIndexPath:indexPath];
    
    return cell;
}

//-- set up table view cell for iPhone
-(MusicCustomCellAlbum *) setCustomTableViewCellForWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AudioCell";
    
    MusicCustomCellAlbum *cell = (MusicCustomCellAlbum *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MusicCustomCellAlbum" owner:self options:nil];
        cell = (MusicCustomCellAlbum *)[nibArray objectAtIndex:0];
        [cell configurePlayerButton];
    }
    
    
    //-- set color background for cell
//    if ((indexPath.row%2) == 0)
//        cell.imgBgCell.image = [UIImage imageNamed:@"img_Bg_CellMusic2.png"];
//    else
//        cell.imgBgCell.image = [UIImage imageNamed:@"img_Bg_CellMusic1.png"];

    if ((indexPath.row%2) == 0)
        cell.contentView.backgroundColor = COLOR_SCHEDULE_CELL_BOLD;
    else
        cell.contentView.backgroundColor = COLOR_SCHEDULE_CELL_REGULAR;

    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}

-(MusicCustomCellAlbum *)setDataForTableViewCell:(MusicCustomCellAlbum *)cell withIndexPath:(NSIndexPath *)indexPath
{
    if ([listData count]>0) {
        
        MusicTrackNew *msTrack = [listData objectAtIndex:indexPath.row];
        
        //-- setup scrolling label
        cell.lblArtist.text = msTrack.name;
        cell.lblArtist.textColor = [UIColor whiteColor];
        cell.lblArtist.font = [UIFont systemFontOfSize:14];
        cell.lblArtist.labelSpacing = 200; // distance between start and end labels
        cell.lblArtist.pauseInterval = 0.3; // seconds of pause before scrolling starts again
        cell.lblArtist.scrollSpeed = 30; // pixels per second
        cell.lblArtist.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
        cell.lblArtist.fadeLength = 12.f;
        cell.lblArtist.shadowOffset = CGSizeMake(-1, -1);
        cell.lblArtist.scrollDirection = CBAutoScrollDirectionLeft;
        
        NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
        NSString *tempSongId = [NSString stringWithFormat:@"%@",[defaultSongId valueForKey:@"DefaultSongId"]];
        
        if ([msTrack.nodeId isEqualToString:tempSongId]) {
            
            if (_audioPlayer == nil) {
                _audioPlayer = [AudioPlayer sharedAudioPlayerMusic];
            }
            _audioPlayer.button = cell.audioButton;
            
            if ([[AudioPlayer sharedAudioPlayerMusic] isPlayingSong]) {
                
                _audioPlayer.button.image = [UIImage imageNamed:stopImage];
                cell.audioButton.image = [UIImage imageNamed:stopImage];
                
            }else {
                
                _audioPlayer.button.image = [UIImage imageNamed:playImage];
                cell.audioButton.image = [UIImage imageNamed:playImage];
            }
            
        }else {
            
            cell.audioButton.image = [UIImage imageNamed:playImage];
        }
        
        //-- Action Button
        cell.audioButton.tag = indexPath.row;
        [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //-- check downloader music
        NSString *filePath = [Utility getMusicFilePathWithCategoryId:msTrack.albumId withNodeId:msTrack.nodeId];
        BOOL isShowDownLoad = [Utility checkingAFileExistsWithPath:filePath];
        if (isShowDownLoad == YES) {
            
            cell.btnDownload.enabled = NO;
        }else {
         
            cell.btnDownload.enabled = YES;
            [cell.btnDownload addTarget:self action:@selector(clickDownloadButton:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnDownload.tag = indexPath.row;
        }
        
        //-- check show ringback
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *command_gateway = [userDefaults valueForKey:Key_ringbackCommand_gateway];
        NSString *command_body = [userDefaults valueForKey:Key_ringbackCommand_body];
        
        if (command_gateway && command_body) {
            
            if ([msTrack.songRingbacktoneId integerValue] == 1) {
                
                cell.btnPhone.enabled = YES;
                [cell.btnPhone addTarget:self action:@selector(clickPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
                cell.btnPhone.tag = indexPath.row;
                
            }else
                cell.btnPhone.enabled = NO;
            
        } else {
            cell.btnPhone.enabled = NO;
        }
        
        //-- check existing object of list downloader
        NSString *keyDownload = [NSString stringWithFormat:@"%@%@",msTrack.albumId,msTrack.nodeId];
        
        NSUserDefaults *defaultDownloadNodeId = [NSUserDefaults standardUserDefaults];
        NSString *keyDownloadDefault = [defaultDownloadNodeId valueForKey:keyDownload];
        
        if ([listDownloadSelected containsObject:keyDownload] || (keyDownloadDefault && [keyDownloadDefault length] > 0)) {
            //-- show image loading
            [cell startSpinWithCell];
        }else {
            //-- remove image loading
            [cell stopSpinWithCell];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MusicCustomCellAlbum *cell = (MusicCustomCellAlbum *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (_audioPlayer == nil) {
        _audioPlayer = [AudioPlayer sharedAudioPlayerMusic];
    }
    _audioPlayer.button = cell.audioButton;
    
    //-- pass Delegate
    [[self delegate] goToMusicPlayViewControllerWithListData:listData withIndexRow:indexPath.row];
}


//*******************************************************************************//
#pragma mark - Action Cell

//-- play music
- (void)playAudio:(AudioButton *)button
{
    NSLog(@"%s", __func__);
    NSUserDefaults *defaultSongId = [NSUserDefaults standardUserDefaults];
    
    if ([defaultSongId boolForKey:@"Selected_ButtonNextSlideBar"] == NO) {
        
        NSInteger indexOfSong = button.tag;
        MusicTrackNew *msTrack = [listData objectAtIndex:indexOfSong];
        
        //longnh add
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                              action:@"play_song"  // Event action (required)
                                                               label:msTrack.name
                                                               value:nil] build]];
        
        [defaultSongId setValue:msTrack.albumName forKey:@"DefaultAlbumName"];
        [defaultSongId setValue:msTrack.albumAuthorMusicId forKey:@"DefaultAuthorMusicId"];
        [defaultSongId setValue:msTrack.name forKey:@"DefaultNameSong"];
        [defaultSongId setValue:msTrack.albumThumbImagePath forKey:@"DefaultAlbumThumbImagePath"];
        [defaultSongId setValue:msTrack.nodeId forKey:@"DefaultSongId"];
        [defaultSongId synchronize];
        
        
        //-- init singleton AudioPlayer
        if (_audioPlayer == nil) {
            _audioPlayer = [AudioPlayer sharedAudioPlayerMusic];
        }
        
        //NSLog(@"listData:%@",listData);
        //-- pass arrTrack and indexSong to MediPlayer
        [_audioPlayer setListSongsAlbum:listData];
        [_audioPlayer setIndexOfSong:indexOfSong];
        
        //-- check downloader video
        NSString *filePath = [Utility getMusicFilePathWithCategoryId:msTrack.albumId withNodeId:msTrack.nodeId];
        BOOL isShowDownLoad = [Utility checkingAFileExistsWithPath:filePath];
        if (isShowDownLoad == YES) {
            
            // if existing musicPath is Play
            if ([_audioPlayer.button isEqual:button]) {
                [_audioPlayer play];
            } else {
                [_audioPlayer stop];
                
                _audioPlayer.button = button;
                _audioPlayer.url = [NSURL fileURLWithPath:filePath];;
                _audioPlayer.fixedLength = YES;
                [_audioPlayer play];
            }
            
        } else {
            
            if ([self checkExistMusicPath:msTrack.musicPath] == YES) {
                
                // if existing musicPath is Play
                if ([_audioPlayer.button isEqual:button]) {
                    [_audioPlayer play];
                } else {
                    [_audioPlayer stop];
                    
                    _audioPlayer.button = button;
                    _audioPlayer.url = [NSURL URLWithString:msTrack.musicPath];
                    _audioPlayer.fixedLength = NO;
                    
                    [_audioPlayer play];
                }
                
            }else {
                
                //-- if not existing musicPath is show message
                [self showNotificationFailed];
            }
        }
        
        //-- reload data
        [self.tableView reloadData];
    }
}

//-- validate MusicPath
-(BOOL) checkExistMusicPath:(NSString *) musicPathStr {
    
    //-- validate content
    NSString *tempMusicPath = [musicPathStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL thereAreJustSpaces = [tempMusicPath isEqualToString:@""];
    
    if( ((!thereAreJustSpaces) || [musicPathStr length] > 0))
        return YES;
    else
        return NO;
}

//-- show notification Failed
-(void) showNotificationFailed {
    
    noticeSuccess = [WBSuccessNoticeView successNoticeInView:self.view title:@"Bài hát đã bị lỗi không thể thực hiện."];
    [noticeSuccess show];
}


//-- Nhac cho
-(IBAction)clickPhoneButton:(id)sender {
    
    UIButton *btnSender = (UIButton *) sender;
    NSInteger indexAlbum = btnSender.tag;
    
    //-- pass Delegate
    [[self delegate] passDelegateGoToMusicAlbumViewController:listData withIndexRow:indexAlbum ByDelegateType:delegateRingBackType];
}

//-- Download
-(IBAction)clickDownloadButton:(id)sender {
    
    UIButton *btnSender = (UIButton *) sender;
    NSInteger indexAlbum = btnSender.tag;
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:MY_ACCOUNT_ID];
    if (userId) {
        
        BOOL isDownload = [self checkDownloadMusicLimit];
        
        if (isDownload == YES) {
            
            MusicTrackNew *msTrack = [listData objectAtIndex:indexAlbum];
            
            ModelDownload *modelDownload = [[[ModelDownload alloc] init] autorelease];
            
            modelDownload.linkUrlDownload = msTrack.musicPath;
            modelDownload.categoryId = msTrack.albumId;
            modelDownload.nodeId = msTrack.nodeId;
            modelDownload.fileName = msTrack.name;
            modelDownload.folderName = @"Music";
            
            //-- Download File
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexAlbum inSection:0];
            [self startMusicDownload:modelDownload forIndexPath:indexPath];
            
        }else
            return;
        
    }else {
        
        //-- pass Delegate thông báo nâng cấp user
        [[self delegate] passDelegateGoToMusicAlbumViewController:listData withIndexRow:indexAlbum ByDelegateType:delegateDownLoadType];
    }
}

//-- check download Music limit
-(BOOL) checkDownloadMusicLimit {
    
    NSUserDefaults *defaultDownload = [NSUserDefaults standardUserDefaults];
    NSInteger downloadable_music_nubmer = [[defaultDownload valueForKey:@"Key_downloadable_music_nubmer"] integerValue];
    //    NSInteger downloadable_music_start_time = [[defaultDownload valueForKey:@"Key_downloadable_music_start_time"] integerValue];
    NSInteger downloadable_music_period_time = [[defaultDownload valueForKey:@"Key_downloadable_music_period_time"] integerValue];
    NSString *downloadable_music_message_wranning = [defaultDownload valueForKey:@"Key_downloadable_music_message_wranning"];
    
    if (downloadable_music_nubmer == 0) {
        
        //-- show message download warning
        [self showMessageWithType:VMTypeMessageOk withMessage:downloadable_music_message_wranning withFriendName:nil needDelegate:NO withTag:6];
        return NO;
        
    }else {
        
        //-- check Refresh Download Private By Date
        NSDate *enddate = [[NSUserDefaults standardUserDefaults] valueForKey:@"DownloadPrivateByDate"];
        NSDate* currentdate = [NSDate date];
        
        NSTimeInterval distanceBetweenDates = [currentdate timeIntervalSinceDate:enddate];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates >= downloadable_music_period_time){
            
            //-- open Refresh Download Private By Date
            [defaultDownload setValue:currentdate forKey:@"DownloadPrivateByDate"];
            
            //-- set number of download limit
            [defaultDownload setValue:@"0" forKey:@"NumberOfDownloadPrivateMusic"];
            [defaultDownload synchronize];
            
            return YES;
            
        }else {
            
            //-- check number of Downloaded
            NSInteger numberOfDownloadPrivateMusic = [[defaultDownload valueForKey:@"NumberOfDownloadPrivateMusic"] integerValue];
            
            if (numberOfDownloadPrivateMusic >= downloadable_music_nubmer) {
                
                //-- show message download warning
                [self showMessageWithType:VMTypeMessageOk withMessage:downloadable_music_message_wranning withFriendName:nil needDelegate:NO withTag:6];
                return NO;
                
            }else {
                
                return YES;
            }
        }
    }
}


//*********************************************************************************//
#pragma mark - Download File Music

//-- start download Music
-(void) startMusicDownload:(ModelDownload *) modelDownload forIndexPath:(NSIndexPath *)indexPath
{
    MusicCustomCellAlbum *cell  =(MusicCustomCellAlbum *) [self.tableView cellForRowAtIndexPath:indexPath];
    
    Downloader *iconDownloader = [musicDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        //-- add list downloader
        MusicTrackNew *msTrack = [listData objectAtIndex:indexPath.row];
        NSString *keyDownload = [NSString stringWithFormat:@"%@%@",msTrack.albumId,msTrack.nodeId];
        [listDownloadSelected addObject:keyDownload];
        
        NSUserDefaults *defaultDownloadNodeId = [NSUserDefaults standardUserDefaults];
        [defaultDownloadNodeId setObject:keyDownload forKey:keyDownload];
        [defaultDownloadNodeId synchronize];
        
        cell.btnDownload.enabled = NO;
        
        //-- show image loading
        [cell startSpinWithCell];
        
        iconDownloader = [[Downloader alloc] init];
        iconDownloader.modelDownload = modelDownload;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegateDownload = self;
        [musicDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        
        [iconDownloader startDownload];
        
        //-- update number of download limit
        NSUserDefaults *defaultDownload = [NSUserDefaults standardUserDefaults];
        NSInteger numberOfDownloadPrivateMusic = [[defaultDownload valueForKey:@"NumberOfDownloadPrivateMusic"] integerValue];
        NSString *numberOfDownloadStr = [NSString stringWithFormat:@"%d",numberOfDownloadPrivateMusic+1];
        
        [defaultDownload setValue:numberOfDownloadStr forKey:@"NumberOfDownloadPrivateMusic"];
        [defaultDownload synchronize];
    }
}

//-- update Progress File Downloader
-(void) updateProgressFileDownloader:(NSString *)progress WithIndexPath:(NSIndexPath *)indexPath {
    
    //-- show Progress
    Downloader *iconDownloader = [musicDownloadsInProgress objectForKey:indexPath];
    
    MusicCustomCellAlbum *cell  =(MusicCustomCellAlbum *) [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
    
    [cell.btnDownload setImage:nil forState:UIControlStateNormal];
    [cell.btnDownload setTitle:progress forState:UIControlStateNormal];
}

//-- callback when download success and hidden button Download
-(void) delegateFileDownloader:(NSIndexPath *)indexPath
{
    //-- remove object from list downloader
    MusicTrackNew *msTrack = [listData objectAtIndex:indexPath.row];
    NSString *keyDownload = [NSString stringWithFormat:@"%@%@",msTrack.albumId,msTrack.nodeId];
    [listDownloadSelected removeObject:keyDownload];
    
    NSUserDefaults *defaultDownloadNodeId = [NSUserDefaults standardUserDefaults];
    [defaultDownloadNodeId removeObjectForKey:keyDownload];
    [defaultDownloadNodeId synchronize];
    
    Downloader *iconDownloader = [musicDownloadsInProgress objectForKey:indexPath];
    
    MusicCustomCellAlbum *cell  =(MusicCustomCellAlbum *) [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
    
    if (iconDownloader != nil) {
        
        cell.btnDownload.enabled = NO;
        
        //-- remove image loading
        [cell stopSpinWithCell];
    }else {
        
        cell.btnDownload.enabled = YES;
        
        //-- remove image loading
        [cell stopSpinWithCell];
    }
    
    [cell.btnDownload setImage:[UIImage imageNamed:@"album_download.png"] forState:UIControlStateNormal];
    [cell.btnDownload setTitle:@"" forState:UIControlStateNormal];
    
    //-- Call notification reload data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReDownLoadMusic_MusicPlayVC" object:nil];
}


//************************************************************************//
#pragma mark - ShowMessage

-(void) showMessageWithType:(VMTypeMessage) typeMessage withMessage:(NSString *) messageStr withFriendName:(NSString *)friendName needDelegate:(BOOL) needDelegate withTag:(NSInteger) tag
{
    UIAlertView *alertview = nil;
    
    switch (typeMessage) {
        case VMTypeMessageOk:
            alertview = [[UIAlertView alloc] initWithTitle:kTitleMessageApp message:messageStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            if (needDelegate == YES)
                [alertview setDelegate:self];
            break;
        case VMTypeMessageYesNo:
            alertview = [[UIAlertView alloc] initWithTitle:kTitleMessageApp message:messageStr delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            if (needDelegate == YES)
                [alertview setDelegate:self];
            break;
            
        default:
            break;
    }
    
    [alertview setTag:tag];
    [alertview show];
}


//--Alertview Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
