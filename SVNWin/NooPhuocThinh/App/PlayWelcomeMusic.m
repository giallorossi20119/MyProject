//
//  PlayWelcomeMusic.m
//  NooPhuocThinh
//
//  Created by longnh on 8/13/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "PlayWelcomeMusic.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "VMConstant.h"
#import "AudioPlayer.h"
#import "MusicTrackNew.h"
#import "AppDelegate.h"

@implementation PlayWelcomeMusic

-(void)getMusicOnServer {
    NSLog(@"%s", __func__);
    NSString *urlString = [NSString stringWithFormat:@"%@/gom_background_music.php",HOST_FOR_CONTENT];
//    NSString *urlString = [NSString stringWithFormat:@"http://service.soci.vn/?q=gom_services/gom_background_music.php"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@"0" forKey:@"current_music_id"];
    [paramDic setObject:SINGER_ID forKey:@"singer_id"];
    [paramDic setObject:@"15" forKey:@"distributor_channel_id"];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:paramDic];
//    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
//    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
//
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // Print the response body in text
//        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] initWithDictionary:JSON];
        NSLog(@"jsonDictionary:%@",jsonDic);
        
        NSUserDefaults *defaultMusic = [NSUserDefaults standardUserDefaults];
        NSInteger responseCode = [[[jsonDic objectForKey:@"data"] objectForKey:@"code"] intValue];
        BOOL isUpdateNewData = NO;
        
        if (responseCode == 1) {
            //khong su dung nhac nen
            
        } else {
            if ([defaultMusic objectForKey:@"startMusic"]) {
                //Modified by  TuanNM@20140828
                //kiem tra dua   theo last_update, ko phai id
                NSString *oldMusic = [[defaultMusic objectForKey:@"startMusic"] objectForKey:@"last_update"];
                NSString *newMusic = [[jsonDic objectForKey:@"data"] objectForKey:@"last_update"];
                //end
                if ([oldMusic isEqualToString:newMusic]) {
                    NSLog(@"startMusic:%@",[defaultMusic objectForKey:@"startMusic"]);
                    //do ko thay doi nen neu dang play thi ko can phai stop de play lai
                    if (![[AudioPlayer sharedAudioPlayerMusic] isPlayingSong])
                        [self playMusic:[defaultMusic objectForKey:@"startMusic"]];
                } else {
                    NSLog(@"startMusic: update current welcome music from last_update=%@ to %@", oldMusic, newMusic);
                    isUpdateNewData = YES;
                    
                    //longnh: xoa file music cache neu co
                    NSString *filePath = [[defaultMusic objectForKey:@"startMusic"] objectForKey:@"musicLocalPath"];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if (filePath && [fileManager fileExistsAtPath:filePath]) {
                        [fileManager removeItemAtPath:filePath error:nil];
                    }
                }
            } else {
                isUpdateNewData = NO;
            }
        }
        if (isUpdateNewData) {
            NSLog(@"startMusic: new welcome music");
            [defaultMusic setObject:[jsonDic objectForKey:@"data"] forKey:@"startMusic"];
            [defaultMusic synchronize];
            //add by TuanNM@20180428
            //stop lai moi play dc
            [[AudioPlayer sharedAudioPlayerMusic] stop];
            //end add
            [self playMusic:[defaultMusic objectForKey:@"startMusic"]];
        }
    }
    failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON) {
        NSLog(@"Failed: %@",[error localizedDescription]);
        NSUserDefaults *defaultMusic = [NSUserDefaults standardUserDefaults];
        if ([defaultMusic objectForKey:@"startMusic"]) {
            if ([[[defaultMusic objectForKey:@"startMusic"] objectForKey:@"code"] intValue] > 0) {
                [self playMusic:[defaultMusic objectForKey:@"startMusic"]];
            }
        }
    }];
    
    [operation start];
//Data response:
//    {
//        "current_time" = 1409215774;
//        data =     {
//            code = 2;
//            "last_update" = 20140828103538;
//            "music_id" = 1137;
//            "music_path" = "http://123.30.169.117/cms_final/data_file/music_files_2014/music-background/nhac-mo-dau-noo-phuoc-thinh-gat-di-nuoc-mat-lwmlp.mp3";
//            name = "G\U1ea1t \U0111i n\U01b0\U1edbc m\U1eaft";
//        };
//        "request_name" = "gom_background_music";
//    }
}

-(void)playMusic:(NSDictionary*)musicDic {
    NSLog(@"%s", __func__);
    //longnh add
//    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    if ([dataCenter checkExistSlideBarBottom]) {
//        dataCenter.slideBarController.btnNext.hidden = YES;
//    }
    
    NSUserDefaults *defaultCenter = [NSUserDefaults standardUserDefaults];
    [defaultCenter removeObjectForKey:@"DefaultAlbumName"];
    [defaultCenter removeObjectForKey:@"DefaultAuthorMusicId"];
    [defaultCenter removeObjectForKey:@"DefaultNameSong"];
    [defaultCenter removeObjectForKey:@"DefaultAlbumThumbImagePath"];
    [defaultCenter removeObjectForKey:@"DefaultSongId"];
    
    [defaultCenter setObject:[musicDic objectForKey:@"name"] forKey:@"DefaultNameSong"];
    [defaultCenter setObject:[musicDic objectForKey:@"music_id"] forKey:@"DefaultSongId"];

    [defaultCenter synchronize];

    
    
    

    NSMutableArray *listData = [[NSMutableArray alloc] init];
    MusicTrackNew *msTrack = [[MusicTrackNew alloc] init];
    msTrack.musicPath = [musicDic  objectForKey:@"music_path"];
    msTrack.name = [musicDic objectForKey:@"name"];
    msTrack.musicType = @"welcome_music";
    [listData addObject:msTrack];
    
    AudioPlayer *audioPlayer = [AudioPlayer sharedAudioPlayerMusic];
    [audioPlayer setListSongsAlbum:listData];
    [audioPlayer setIndexOfSong:0];
    audioPlayer.isStartMusic = YES;
    BOOL isLoadFileFromServer = NO;
    //Kiem tra xem da download file music chua?
    if ([musicDic objectForKey:@"musicLocalPath"]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:[musicDic objectForKey:@"musicLocalPath"]]) {
            audioPlayer.url = [NSURL fileURLWithPath:[musicDic objectForKey:@"musicLocalPath"]];
            audioPlayer.fixedLength = YES;
        } else {
            isLoadFileFromServer = YES;
        }
    } else {
        isLoadFileFromServer = YES;
    }

    if (isLoadFileFromServer) {
        audioPlayer.url = [NSURL URLWithString:[musicDic objectForKey:@"music_path"]];
        [self downloadFileMusic:[musicDic objectForKey:@"music_path"]];
        audioPlayer.fixedLength = NO;
    }
    
    [audioPlayer play1];
}
-(void)downloadFileMusic:(NSString*)urlString {
    NSLog(@"%s", __func__);
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *storePath = [basePath stringByAppendingPathComponent:[url lastPathComponent]];
    NSLog(@"storePath:%@",storePath);
    
//	NSFileManager *fileManager = [NSFileManager defaultManager];
    
//	if ([fileManager fileExistsAtPath:storePath]) {
//        [fileManager removeItemAtPath:storePath error:NULL];
//	}
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
//        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSData *fileData = [NSData dataWithData:responseObject];
        if  ([fileData writeToFile:storePath atomically:YES]) {
            NSUserDefaults *defaultMusic = [NSUserDefaults standardUserDefaults];
            if ([defaultMusic objectForKey:@"startMusic"]) {
                NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[defaultMusic objectForKey:@"startMusic"]];
                [dataDic setObject:storePath forKey:@"musicLocalPath"];
                [defaultMusic setObject:dataDic forKey:@"startMusic"];
                [defaultMusic synchronize];
                NSLog(@"Finished write file:%@",storePath);
            }

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error download file: %@", error);
    }];
    [operation start];
    

}
@end
