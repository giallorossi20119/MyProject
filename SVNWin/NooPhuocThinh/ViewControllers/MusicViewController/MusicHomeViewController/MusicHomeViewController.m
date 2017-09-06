//
//  MusicHomeViewController.m
//  NooPhuocThinh
//
//  Created by HuntDo on 12/9/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "MusicHomeViewController.h"
#import "SearchViewController.h"

@interface MusicHomeViewController ()

@end

@implementation MusicHomeViewController

@synthesize tableViewMusicHome, musicHome, indexOfAlbums;
@synthesize artists;
ODRefreshControl *refreshControl=nil;


//*************************************************************************//
#pragma mark - Main

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    tableViewMusicHome.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableViewMusicHome.separatorColor = COLOR_SEPARATOR_CELL;
    //-- set view
    [self setViewWhenViewDidLoad];
    
    //-- load data
    [self setDataWhenViewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Music Home Screen";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationItem.hidesBackButton=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-- set view
-(void) setViewWhenViewDidLoad {
    
    //--set navigation bar: back button, search button, background...
    [self customNavigationBar];
    [self setTitle:@"Music"];
    
    //-- refresh data
    refreshControl = [[ODRefreshControl alloc] initInScrollView:tableViewMusicHome];
    [refreshControl addTarget:self action:@selector(refreshDataMusicHome:) forControlEvents:UIControlEventValueChanged];
}

//-- add BarButton to navigationBar
-(void) customNavigationBar
{
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- search button
    UIButton *btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 30, 30);
    [btnRight setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(searchMusicAlbum:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barItemRight;
}


//*******************************************************************//
#pragma mark - Load Data

//-- refresh tableview
-(void) refreshDataMusicHome:(ODRefreshControl *) refresh
{
    if (_dataSourceAlbum.count > 0) {
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
        NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesMusicAlbumRefreshTime;
        NSLog(@"%s timeout=%f crr=%d, prv=%f", __func__, [Setting sharedSetting].musicAlbumRefreshTime*60, currentDate, [Setting sharedSetting].milestonesMusicAlbumRefreshTime);

        if (([Setting sharedSetting].milestonesMusicAlbumRefreshTime !=0) && (compeTime < [Setting sharedSetting].musicAlbumRefreshTime*60))
        {
            [refresh endRefreshing];
            return;
        }
        else
            [Setting sharedSetting].milestonesMusicAlbumRefreshTime = currentDate;
    }
    [refresh beginRefreshing];
    
    [_activityIndicator startAnimating];
    
    [API getAlbumOfSinglerID:SINGER_ID
               contentTypeId:ContentTypeIDMusic
                       limit:@"200"
                        page:[NSString stringWithFormat:@"%d",_currentPage]
                   isGetBody:@"1"
                    isGetHot:@"0"
                       appID:PRODUCTION_ID

     
     
                  appVersion:PRODUCTION_VERSION
                   completed:^(NSDictionary *responseDictionary, NSError *error) {
                       
                       //-- fetching
                       [self createDataSourceAlbumFrom:responseDictionary];
                   }];
    
    [refresh endRefreshing];
}


//-- load data
-(void) setDataWhenViewDidLoad {
    
    _dataSourceAlbum = [[NSMutableArray alloc] init];
    
    //-- set bool
    _isCacheDataSourceAlbum = YES;
    
    //-- init arguments for api (page == 0)
    _currentPage = 0;
    
    
    //-- Fetching Data
    [self fetchingMusicAlbum];
}


//-- load caches or Call service API
- (void)fetchingMusicAlbum
{
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    if (!isErrorNetWork) {
        
        //-- remove lable no data
        [self removeLableNoDataFromTableView:tableViewMusicHome withIndex:0];
        
        //-- read in cache
        _dataSourceAlbum = [VMDataBase getAllAlbumForContentType:ContentTypeIDMusic];
        
        if (_dataSourceAlbum.count > 0) {
            
            //-- reload data tableview
            [tableViewMusicHome reloadData];
            
        }else {
            
            //-- Load the photo view.
            CGRect frame = [tableViewMusicHome frame];
            frame.origin.x = 0.0f;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            //-- add lable no data
            [self addLableNoDataToTableView:tableViewMusicHome withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
        }
        
    }else {
        //modified by TuanNM@20140830
        
        //-- read in cache
        _dataSourceAlbum = [VMDataBase getAllAlbumForContentType:ContentTypeIDMusic];
        
        if (_dataSourceAlbum.count > 0) {
            
            //-- reload data tableview
            [tableViewMusicHome reloadData];
            
        }
        
        //kiem tra xem co can load tren server ko
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
        NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesMusicAlbumRefreshTime;
        NSLog(@"%s timeout=%f crr=%d, prv=%f", __func__, [Setting sharedSetting].musicAlbumRefreshTime*60, currentDate, [Setting sharedSetting].milestonesMusicAlbumRefreshTime);
        
        if (([Setting sharedSetting].milestonesMusicAlbumRefreshTime !=0) && (compeTime < [Setting sharedSetting].musicAlbumRefreshTime*60))
        {
            return;
        }

        //doc moi nhat tu server va     update vao cache
        [_activityIndicator startAnimating];
        
        [API getAlbumOfSinglerID:SINGER_ID
                   contentTypeId:ContentTypeIDMusic
                           limit:@"200"
                            page:[NSString stringWithFormat:@"%d",_currentPage]
                       isGetBody:@"1"
                        isGetHot:@"0"
                           appID:PRODUCTION_ID
                      appVersion:PRODUCTION_VERSION
                       completed:^(NSDictionary *responseDictionary, NSError *error) {
                           if (error==nil)
                           //-- fetching
                               [self createDataSourceAlbumFrom:responseDictionary];
                           else
                               [self showConnectionError];
                           //-- stop indicator
                           [_activityIndicator stopAnimating];

                       }];
    }
}


-(void)createDataSourceAlbumFrom:(NSDictionary *)aDictionary
{
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"singer_list"];
    
    //-- remove lable no data
    [self removeLableNoDataFromTableView:tableViewMusicHome withIndex:0];
    
    if ([arrSinger count] > 0)
    {
        NSMutableArray *arrAlbums = [[arrSinger objectAtIndex:0] objectForKey:@"album_list"];
        
        if ([arrAlbums count] > 0)
        {
            //-- delete cache
            if (_currentPage == 0) {
                
                [VMDataBase deleteAllAlbumFromDB];
                [_dataSourceAlbum removeAllObjects];
            }
            
            for (NSInteger i = 0; i < [arrAlbums count]; i++)
            {
                MusicAlbum *aAlbums = [[MusicAlbum alloc] init];
                aAlbums.albumId = [[arrAlbums objectAtIndex:i] objectForKey:@"album_id"];
                aAlbums.name = [[arrAlbums objectAtIndex:i] objectForKey:@"name"];
                aAlbums.englishName = [[arrAlbums objectAtIndex:i] objectForKey:@"english_name"];
                aAlbums.description = [[arrAlbums objectAtIndex:i] objectForKey:@"description"];
                aAlbums.thumbImagePath = [[arrAlbums objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
                aAlbums.thumbImagePathThumb = [[arrAlbums objectAtIndex:i] objectForKey:@"thumbnail_image_path_thumbnail"];//longnh
                aAlbums.musicType = [[arrAlbums objectAtIndex:i] objectForKey:@"music_type"];
                aAlbums.totalTrack = [[arrAlbums objectAtIndex:i] objectForKey:@"total_track"];
                aAlbums.trueTotalView= [[arrAlbums objectAtIndex:i] objectForKey:@"true_total_view"];
                aAlbums.settingTotalView = [[arrAlbums objectAtIndex:i] objectForKey:@"setting_total_view"];
                aAlbums.trueTotalRating = [[arrAlbums objectAtIndex:i] objectForKey:@"true_total_rating"];
                aAlbums.settingTotalRating = [[arrAlbums objectAtIndex:i] objectForKey:@"setting_total_rating"];
                aAlbums.contentProviderId = [[arrAlbums objectAtIndex:i] objectForKey:@"content_provider_id"];
                aAlbums.authorMusicId = [[arrAlbums objectAtIndex:i] objectForKey:@"author_music_id"];
                aAlbums.musicPublisherId = [[arrAlbums objectAtIndex:i] objectForKey:@"music_publisher_id"];
                aAlbums.isHot = [[arrAlbums objectAtIndex:i] objectForKey:@"is_hot"];
                aAlbums.totalMusic = [[arrAlbums objectAtIndex:i] objectForKey:@"total_music"];
                
                [_dataSourceAlbum addObject:aAlbums];
                
                //-- insert into DB
                [VMDataBase insertAlbumBySinger:aAlbums];
            }
            
            
        }else {
            
            //-- Load the photo view.
            CGRect frame = [tableViewMusicHome frame];
            frame.origin.x = 0.0f;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            //-- add lable no data
            [self addLableNoDataToTableView:tableViewMusicHome withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
        }
        
        //-- reload data tableview
        [self.tableViewMusicHome reloadData];
        [Setting sharedSetting].milestonesMusicAlbumRefreshTime = [[NSDate date] timeIntervalSince1970];
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [tableViewMusicHome frame];
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable no data
        [self addLableNoDataToTableView:tableViewMusicHome withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
    }
}


//************************************************************************//
#pragma mark - UITableViewDataSource


//-- number section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceAlbum count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicCustomCellHome *cell2 = (MusicCustomCellHome *)[self setTableViewCellWithIndexPath:indexPath];
    
    return cell2;
}

//-- set up table view cell for iPhone
-(MusicCustomCellHome *) setTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierHome = @"idMusicCustomCellHomeSb";
    
    MusicCustomCellHome *cell = [self.tableViewMusicHome dequeueReusableCellWithIdentifier:identifierHome];
    
    //-- set data for cell
    cell = [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}


-(MusicCustomCellHome *)setDataForTableViewCell:(MusicCustomCellHome *)cell withIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_dataSourceAlbum count] > 0) {
        
        if (indexPath.row == 0) {
            
            //-- remove image loading
            [cell stopSpinWithCell];
            
            //-- set color background for cell
            cell.contentView.backgroundColor = COLOR_HOME_CELL_BOLD;
            
            cell.lblTatca.alpha = 1;
            cell.lblTatca.text = @"Tất cả";
            
            cell.imgArrowNext.frame = CGRectMake(300, 12, 8, 16);
            cell.imgArrowNext.alpha = 1;
            
            cell.imgAvatar.alpha = 0;
            cell.lblArtist.alpha = 0;
            
        }else{
            
            //-- set color background for cell
            if ((indexPath.row%2) == 0)
                cell.contentView.backgroundColor = COLOR_HOME_CELL_BOLD;
            else
                cell.contentView.backgroundColor = COLOR_HOME_CELL_REGULAR;
            
            cell.lblTatca.alpha = 0;
            cell.imgAvatar.alpha = 1;
            cell.lblArtist.alpha = 1;
            cell.imgArrowNext.alpha = 1;
            
            //-- get Music info
            MusicAlbum *msAlbum = (MusicAlbum *)[_dataSourceAlbum objectAtIndex:indexPath.row-1];
            
            //-- remove image loading
            [cell stopSpinWithCell];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:msAlbum.thumbImagePathThumb] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                
                if(image !=nil) {
                    cell.imgAvatar.image = image;
                }
                else
                    cell.imgAvatar.image = [UIImage imageNamed:@"PhotoDefault.png"];
                
                [cell.imgAvatar setContentMode:UIViewContentModeScaleToFill];//UIViewContentModeScaleAspectFill //longnh
                [cell.imgAvatar setClipsToBounds:YES];
                NSLog(@"w:%f h:%f",cell.imgAvatar.frame.size.width,cell.imgAvatar.frame.size.height);
//                [Utility scaleImage:cell.imgAvatar.image toSize:CGSizeMake(80, 50)];
            }];
            
            
            //-- setup scrolling label
            cell.lblArtist.text = msAlbum.name;
            cell.lblArtist.textColor = [UIColor whiteColor];
            
            cell.lblArtist.labelSpacing = 200; // distance between start and end labels
            cell.lblArtist.pauseInterval = 0.3; // seconds of pause before scrolling starts again
            cell.lblArtist.scrollSpeed = 30; // pixels per second
            cell.lblArtist.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
            cell.lblArtist.fadeLength = 12.f;
            cell.lblArtist.shadowOffset = CGSizeMake(-1, -1);
            cell.lblArtist.scrollDirection = CBAutoScrollDirectionLeft;
            
        }
    }
    
    return cell;
}


//************************************************************************//
#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int countRow;
    if (indexPath.row == 0)
        countRow = 40;
    else
        countRow = 63;
        
    return countRow;
}

//-- Action selected row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicAlbumViewController *maVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idMusicAlbumViewControllerSb"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *albumTitleArr = [[NSMutableArray alloc] init];
    NSMutableArray *albumIdArr = [[NSMutableArray alloc] init];
    MusicAlbum *tmp;
    NSInteger indexOfAlbum;
    
    if ([_dataSourceAlbum count]>0) {
        
        for (NSInteger i=0; i<[_dataSourceAlbum count]; i++)
        {
            MusicAlbum *tmp2 = (MusicAlbum *)[_dataSourceAlbum objectAtIndex:i];
            NSString *title = tmp2.name;
            NSString *abId = tmp2.albumId;
            
            [albumTitleArr addObject:title];
            [albumIdArr addObject:abId];
        }
        
        [albumTitleArr insertObject:@"Tất cả" atIndex:0];
    }

    if (indexPath.row == 0) {
        
        appDelegate.isMusicAll = YES;
        appDelegate.isMusicAlbum = NO;
        
        if ([_dataSourceAlbum count]>0) {
            tmp = (MusicAlbum *)[_dataSourceAlbum objectAtIndex:indexPath.row];
            indexOfAlbum = 0;
        }
        
    }else{
        
        appDelegate.isMusicAll = NO;
        appDelegate.isMusicAlbum = YES;
        
        if ([_dataSourceAlbum count]>0) {
            tmp = (MusicAlbum *)[_dataSourceAlbum objectAtIndex:indexPath.row-1];
            indexOfAlbum = [_dataSourceAlbum indexOfObject:tmp] + 1;
        }
    }
    
    if (tmp) {
        
        maVC.indexOfAlbum = indexOfAlbum;
        maVC.arrTracks = _dataSourceAlbum;
        maVC.segmentsArray = albumTitleArr;
    }    

    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:maVC animated:YES];
    else
        [self.navigationController pushViewController:maVC animated:NO];
}


//********************************************************************************//
#pragma mark - ACTION


-(void)back:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


//********************************************************************************//
#pragma mark - Search Album

- (void)searchMusicAlbum:(id)sender
{
    SearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idSearchViewControllerSb"];
    searchVC.searchtype = searchMusicType;
    
    [UIView animateWithDuration:0.55
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:searchVC animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}


@end
