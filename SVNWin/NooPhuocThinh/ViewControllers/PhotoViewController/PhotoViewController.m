//
//  PhotoViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/4/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize tableViewAlbum,imgCover;

static CGFloat kImageOriginHight = 140.f;

//******************************************************************//
#pragma mark - Main

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //-- setup some view
    [self setViewWhenViewDidLoad];
    
    //-- load data
    [self getDataWhenViewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Photos Screen";
    
    [super viewWillAppear:animated];
    
    self.imgCover.frame = CGRectMake(0, -kImageOriginHight, self.tableViewAlbum.frame.size.width, kImageOriginHight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//-- setup view
-(void) setViewWhenViewDidLoad {
    
    [self setTitle:@"Photos"];
    [self setupBackButton];
    [self.tableViewAlbum setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableViewAlbum setSeparatorColor:COLOR_SEPARATOR_CELL];
    self.tableViewAlbum.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
    [self.tableViewAlbum addSubview:self.imgCover];
    
    //-- refresh data
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tableViewAlbum];
    [refreshControl addTarget:self action:@selector(refreshDataPhotoHome:) forControlEvents:UIControlEventValueChanged];
}

//-- load data
-(void) getDataWhenViewDidLoad {
    
    _isCacheDataSourceAlbum = YES;
    _isLoadDataSource = NO;
    _currentPage = 0;
    
    listAlbum = [[NSMutableArray alloc] init];
    _dataSourceAlbum = [[NSMutableArray alloc] init];
    
    
    //-- request get data
    [self fetchingListAlbum];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.imgCover.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.imgCover.frame = f;
    }
}


//*******************************************************************//
#pragma mark - Load Data

//-- refresh tableview
-(void) refreshDataPhotoHome:(ODRefreshControl *) refresh
{
    //-- check time
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesImageAlbumRefreshTime;
    
    if (([Setting sharedSetting].milestonesImageAlbumRefreshTime !=0) && (compeTime < [Setting sharedSetting].imageAlbumRefreshTime*60))
    {
        [refresh endRefreshing];
        return;
    }
    else
        [Setting sharedSetting].milestonesImageAlbumRefreshTime = currentDate;
    
    [_activityIndicator startAnimating];
    
    //-- request news async
    [API getAlbumOfSinglerID:SINGER_ID
               contentTypeId:ContentTypeIDPhoto
                       limit:@"200"
                        page:[NSString stringWithFormat:@"%d",_currentPage]
                   isGetBody:@"1"
                    isGetHot:@"0"
                       appID:PRODUCTION_ID
                  appVersion:PRODUCTION_VERSION
                   completed:^(NSDictionary *responseDictionary, NSError *error) {
                       
                       if (!error) {
                           
                           //-- fetching
                           [self createDataSourcePhotoInAlbum:responseDictionary];
                       }
                       
                       //-- stop indicator
                       [_activityIndicator stopAnimating];
                       
                   }];
    
    [refresh endRefreshing];
}

//-- fetching data
- (void)fetchingListAlbum
{
    //-- remove all object
    [listAlbum removeAllObjects];
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    
    if (!isErrorNetWork) {
        
        //-- remove lable no data
        [self removeLableNoDataFromTableView:tableViewAlbum withIndex:0];
        
        //-- read cache
        _dataSourceAlbum = [VMDataBase getAllAlbumPhotoForContentType:ContentTypeIDPhoto];
        
        if (_dataSourceAlbum.count > 0) {
            
            //-- reload tableview
            [self.tableViewAlbum reloadData];
            
        }else {
            
            //-- Load the photo view.
            CGRect frame = [tableViewAlbum frame];
            frame.origin.x = 0.0f;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            //-- add lable no data
            [self addLableNoDataToTableView:tableViewAlbum withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
        }
        
    }else {
        
        //-- check data
        _dataSourceAlbum = [VMDataBase getAllAlbumPhotoForContentType:ContentTypeIDPhoto];
        
        if (_dataSourceAlbum.count > 0) {
            
            NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
            NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesImageAlbumRefreshTime;
            NSLog(@"%s timeout=%f crr=%d, prv=%f", __func__, [Setting sharedSetting].imageAlbumRefreshTime*60, currentDate, [Setting sharedSetting].milestonesImageAlbumRefreshTime);

            if (([Setting sharedSetting].milestonesImageAlbumRefreshTime !=0) && (compeTime < [Setting sharedSetting].imageAlbumRefreshTime*60)) {
                
                //-- reload tableview
                [self.tableViewAlbum reloadData];
                return;
            }
            else
                [Setting sharedSetting].milestonesImageAlbumRefreshTime = currentDate;
        }
        
        
        [_activityIndicator startAnimating];
        
        //-- request news async
        [API getAlbumOfSinglerID:SINGER_ID
                   contentTypeId:ContentTypeIDPhoto
                           limit:@"200"
                            page:[NSString stringWithFormat:@"%d",_currentPage]
                       isGetBody:@"1"
                        isGetHot:@"0"
                           appID:PRODUCTION_ID
                      appVersion:PRODUCTION_VERSION
                       completed:^(NSDictionary *responseDictionary, NSError *error) {
                           
                           if (!error) {
                               
                               //-- fetching
                               [self createDataSourcePhotoInAlbum:responseDictionary];
                           }
                           
                           //-- stop indicator
                           [_activityIndicator stopAnimating];
                           
                       }];
    }
}


//-- hanle data json
- (void)createDataSourcePhotoInAlbum:(NSDictionary *)dict
{
    //-- remove lable no data
    [self removeLableNoDataFromTableView:tableViewAlbum withIndex:0];
    
    NSDictionary *dictData = [dict objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"singer_list"];
    
    if ([arrSinger count] > 0)
    {
        listAlbum = [[arrSinger objectAtIndex:0] objectForKey:@"album_list"];
        _totalAlbum = [listAlbum count];
        
        if ([listAlbum count] > 0)
        {
            //-- delete cache
            NSLog(@"%s page=%d", __func__, _currentPage);

            if (_currentPage == 0)
            {
                [VMDataBase deleteAllAlbumPhotoFromDB];
                [VMDataBase deleteAllPhotoInAlbumByAlbumId:nil];
                [_dataSourceAlbum removeAllObjects];
            }
            
            for (NSInteger i = 0; i < [listAlbum count]; i++)
            {
                ListAlbumPhoto *aAlbums = [[ListAlbumPhoto alloc] init];
                
                aAlbums.albumId = [[listAlbum objectAtIndex:i] objectForKey:@"album_id"];
                aAlbums.name = [[listAlbum objectAtIndex:i] objectForKey:@"name"];
                aAlbums.thumbImagePath = [[listAlbum objectAtIndex:i] objectForKey:@"thumbnail_image_path"];
                aAlbums.albumThumbnailImagePath = [NSString stringWithFormat:@"%@_thumbnail.%@", aAlbums.thumbImagePath.stringByDeletingPathExtension, aAlbums.thumbImagePath.pathExtension];

                aAlbums.description = [[listAlbum objectAtIndex:i] objectForKey:@"description"];
                aAlbums.order = [[listAlbum objectAtIndex:i] objectForKey:@"order"];
                aAlbums.totalPhoto = [[listAlbum objectAtIndex:i] objectForKey:@"total_photo"];
                aAlbums.photoList = [[listAlbum objectAtIndex:i] objectForKey:@"photo_list"];
                NSString *numberComment = [NSString stringWithFormat:@"%d",[[[listAlbum objectAtIndex:i] objectForKey:@"sns_total_comment"] intValue]];
                NSString *numberLike = [NSString stringWithFormat:@"%d",[[[listAlbum objectAtIndex:i] objectForKey:@"sns_total_like"] intValue]];
                aAlbums.snsTotalComment = numberComment;
                aAlbums.snsTotalLike = numberLike;
                aAlbums.snsTotalDisLike = [[listAlbum objectAtIndex:i] objectForKey:@"sns_total_dislike"];
                aAlbums.snsTotalShare = [[listAlbum objectAtIndex:i] objectForKey:@"sns_total_share"];
                aAlbums.snsTotalView = [[listAlbum objectAtIndex:i] objectForKey:@"sns_total_view"];
                
                [_dataSourceAlbum addObject:aAlbums];
                
                //-- insert into DB
                [VMDataBase insertAlbumPhotoBySinger:aAlbums];
            }
            
        }else {
            
            //-- Load the photo view.
            CGRect frame = [tableViewAlbum frame];
            frame.origin.x = 0.0f;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            //-- add lable no data
            [self addLableNoDataToTableView:tableViewAlbum withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
        }
        
    }else {
        
        //-- Load the photo view.
        CGRect frame = [tableViewAlbum frame];
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable no data
        [self addLableNoDataToTableView:tableViewAlbum withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
    }
    
    //--turn off read from DB
    _isLoadDataSource = NO;
    
    //-- stop loading
    [self.tableViewAlbum.infiniteScrollingView stopAnimating];
    
    [self.tableViewAlbum reloadData];
}


-(void)loadMoreAlbums
{
    NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesImageAlbumRefreshTime;
    NSLog(@"%s timeout=%f crr=%d, prv=%f", __func__, [Setting sharedSetting].imageAlbumRefreshTime*60, currentDate, [Setting sharedSetting].milestonesImageAlbumRefreshTime);
    if (([Setting sharedSetting].milestonesImageAlbumRefreshTime != 0) && (compeTime < [Setting sharedSetting].imageAlbumRefreshTime*60)) {
        [self.tableViewAlbum.infiniteScrollingView stopAnimating];
        return;
    }
    else
        [Setting sharedSetting].milestonesImageAlbumRefreshTime = currentDate;
    
    //-- change state to loading api.
    _isLoadDataSource = YES;
    
    if (_totalAlbum == 0)
    {
        [self performSelector:@selector(fetchingListAlbum) withObject:nil afterDelay:0.5];
    }
    else if (_totalAlbum > 0 && [_dataSourceAlbum count] < _totalAlbum)
    {
        _currentPage++;
        NSLog(@"%s Next page=%d", __func__, _currentPage);
        [self performSelector:@selector(fetchingListAlbum) withObject:nil afterDelay:0.5];
    }
    else
        [self.tableViewAlbum.infiniteScrollingView stopAnimating];
}


-(void) refreshDatasource:(ODRefreshControl *) refreshControl
{
    //-- change state to loading api.
    _isLoadDataSource = YES;
    
    [refreshControl beginRefreshing];
    [self.tableViewAlbum reloadData];
    [refreshControl endRefreshing];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceAlbum count]+1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    CustomCellAlbumPhoto *cell = (CustomCellAlbumPhoto *)[self setTableViewCellWithIndexPath:indexPath];
    
    return cell;
}


//-- set up table view cell for iPhone
-(CustomCellAlbumPhoto *) setTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"sbCustomCellAlbumPhotoId";
    
    CustomCellAlbumPhoto *cell = (CustomCellAlbumPhoto *)[self.tableViewAlbum dequeueReusableCellWithIdentifier:identifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_dataSourceAlbum count] > 0)
    {
        if (indexPath.row == 0) {
            cell.lblAlbumTitle.frame = CGRectMake(10, 10, 200, 20);
            cell.lblAlbumTitle.text = @"Tất cả";
            cell.lblAlbumNumber.text = @"";
            cell.imgArrow.frame = CGRectMake(300, 15, 8, 16);
            cell.imgArrow.image = [UIImage imageNamed:@"iconNextComment.png"];
            cell.imgCover.alpha = 0;
            
            cell.contentView.backgroundColor = COLOR_HOME_ALBUM_CELL_BOLD;
        }else{
            ListAlbumPhoto *msAlbumPhoto = (ListAlbumPhoto *)[_dataSourceAlbum objectAtIndex:indexPath.row-1];
            
            //-- set color background for cell
            if ((indexPath.row%2) == 0)
                cell.contentView.backgroundColor = COLOR_HOME_ALBUM_CELL_BOLD;
            else
                cell.contentView.backgroundColor = COLOR_HOME_ALBUM_CELL_REGULAR;
            
            //-- set image cover
            cell.imgCover.alpha = 1;
            //NSLog(@"Load thumbnail cover=%@", msAlbumPhoto.albumThumbnailImagePath);
            //-- download image
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:msAlbumPhoto.albumThumbnailImagePath] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if(image !=nil) {
                    cell.imgCover.image = image;
                }
                else
                    cell.imgCover.image = [UIImage imageNamed:@"PhotoDefault.png"];
                
                [cell.imgCover setContentMode:UIViewContentModeScaleAspectFill];
                [cell.imgCover setClipsToBounds:YES];
                [Utility scaleImage:cell.imgCover.image toSize:CGSizeMake(80, 50)];
                
            }];
            
            //-- set album title
            cell.lblAlbumTitle.frame = CGRectMake(64, 15, 200, 20);
            cell.lblAlbumTitle.text =  msAlbumPhoto.name;
            
            cell.lblAlbumNumber.text = [NSString stringWithFormat:@"(%@)",msAlbumPhoto.totalPhoto];
            cell.imgArrow.image = [UIImage imageNamed:@"iconNextComment.png"];
        }
        
        cell.lblAlbumTitle.textColor = [UIColor whiteColor];
        cell.lblAlbumTitle.labelSpacing = 200; // distance between start and end labels
        cell.lblAlbumTitle.pauseInterval = 0.3; // seconds of pause before scrolling starts again
        cell.lblAlbumTitle.scrollSpeed = 30; // pixels per second
        cell.lblAlbumTitle.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
        cell.lblAlbumTitle.fadeLength = 12.f;
        cell.lblAlbumTitle.shadowOffset = CGSizeMake(-1, -1);
        cell.lblAlbumTitle.scrollDirection = CBAutoScrollDirectionLeft;
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int countRow;
    if (indexPath.row == 0)
        countRow = 44;
    else
        countRow = 55;
    
    return countRow;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoAlbumViewController *maVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbPhotoAlbumViewControllerId"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *albumTitleArr = [[NSMutableArray alloc] init];
    ListAlbumPhoto *abP;
    NSInteger indexOfAlbum;
    if (indexPath.row==0) //close "Tat ca"
        return;
    if ([_dataSourceAlbum count]>0) {
        
        for (NSInteger i=0; i<[_dataSourceAlbum count]; i++) {
            ListAlbumPhoto *tmp2 = (ListAlbumPhoto *)[_dataSourceAlbum objectAtIndex:i];
            NSString *title = tmp2.name;
            
            [albumTitleArr addObject:title];
        }
        [albumTitleArr insertObject:@"Tất cả" atIndex:0];
    }
    
    if (indexPath.row == 0) {
        appDelegate.isPhotoAll = YES;
        appDelegate.isPhotoAlbum = NO;
        if ([_dataSourceAlbum count]>0) {
            abP = (ListAlbumPhoto *)[_dataSourceAlbum objectAtIndex:indexPath.row];
            indexOfAlbum = 0;
        }
    }else{
        appDelegate.isPhotoAll = NO;
        appDelegate.isPhotoAlbum = YES;
        if ([_dataSourceAlbum count]>0) {
            abP = (ListAlbumPhoto *)[_dataSourceAlbum objectAtIndex:indexPath.row-1];
            indexOfAlbum = [_dataSourceAlbum indexOfObject:abP] + 1;
        }
    }
    
    if (abP) {
        maVC.indexOfAlbum = indexOfAlbum;
        maVC.arrPhotos = _dataSourceAlbum;
        maVC.arrTitle = albumTitleArr;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:maVC animated:YES];
    else
        [self.navigationController pushViewController:maVC animated:NO];
}



@end
