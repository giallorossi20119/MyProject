//
//  PhotoAlbumViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/26/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "PhotoAlbumViewController.h"

@interface PhotoAlbumViewController ()

@end

@implementation PhotoAlbumViewController

@synthesize listPhoto, indexOfAlbum, albumId, arrPhotos, arrTitle;
@synthesize autoFullName;


//***************************************************************************//
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
    NSLog(@"%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //-- setup view
    [self setviewWhenViewDidLoad];
    
    //-- load data
    [self getDataWhenViewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    self.screenName = @"Photo Album Screen";
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationItem.hidesBackButton=YES;
    
    if (listPhoto.count > 0) {
        
        //-- reload data tableview
        [self.tableViewPhotoInAlbum reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    [super viewDidAppear:animated];
}


//-- setup view
-(void) setviewWhenViewDidLoad {
    NSLog(@"%s", __func__);
    
    //-- custom navigation bar
    [self customNavigationBar];
}

//-- custom navigation bar
-(void) customNavigationBar
{
    NSLog(@"%s", __func__);
    //-- set album title
    NSString *title = [arrTitle objectAtIndex:indexOfAlbum];
    [self autoScrollTitle:title];
    
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
}

- (void)autoScrollTitle:(NSString*)text
{
    self.autoFullName.text = text;
    [self.autoFullName setFont:[UIFont systemFontOfSize:18]];
    self.autoFullName.textColor = [UIColor whiteColor];
    self.autoFullName.labelSpacing = 200; // distance between start and end labels
    self.autoFullName.pauseInterval = 0.3; // seconds of pause before scrolling starts again
    self.autoFullName.scrollSpeed = 30; // pixels per second
    self.autoFullName.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    self.autoFullName.fadeLength = 12.f;
    self.autoFullName.shadowOffset = CGSizeMake(-1, -1);
    self.autoFullName.scrollDirection = CBAutoScrollDirectionLeft;
}

//-- load data
-(void) getDataWhenViewDidLoad {
    NSLog(@"%s", __func__);
    
    _isCacheDataSourceAlbum = YES;
    _currentPage = 0;
    listPhoto = [[NSMutableArray alloc] init];
    _dataSourcePhotos = [[NSMutableArray alloc] init];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (dataCenter.isPhotoAll)
        [self fetchingAllPhoto];
    else {
        
        //-- get album id
        if (indexOfAlbum > 0) {
            albumId = ((ListAlbumPhoto *)[arrPhotos objectAtIndex:indexOfAlbum -1]).albumId;
        }
        
        [self fetchingPhotoInAlbum:albumId];
    }
}



#pragma mark - Call API

- (void)fetchingAllPhoto
{
    NSLog(@"%s", __func__);
    //-- remove objects
    [listPhoto removeAllObjects];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"AllPhotosID"]) {
        
        //-- request API get all photo
        [self callAPIGetAllPhoto];
        
    }else {
        
        //-- check Network
        BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
        
        if (!isErrorNetWork) {
            
            //-- read in cache
            _dataSourcePhotos = [VMDataBase getAllPhotoInAlbumByAlbumId:nil];
            
            //-- check list data
            if ([_dataSourcePhotos count] > 0) {
                
                _isCacheDataSourceAlbum = NO;
                
                //-- remove lable nodata
                [self removeLableNoDataFromTableView:_tableViewPhotoInAlbum withIndex:0];
                
                //-- reload data tableview
                [self.tableViewPhotoInAlbum reloadData];
            }else {
                
                //--set background for TableView
                [_tableViewPhotoInAlbum setBackgroundView:nil];
                [_tableViewPhotoInAlbum setBackgroundColor:[UIColor clearColor]];
                [_tableViewPhotoInAlbum setSeparatorColor:[UIColor clearColor]];
                
                //-- Load the news
                CGRect frame = [_tableViewPhotoInAlbum frame];
                frame.origin.x = 0.0f;
                frame.origin.y = 0.0f;
                frame = CGRectInset(frame, 0.0f, 0.0f);
                
                //-- add lable no data
                [self addLableNoDataToTableView:_tableViewPhotoInAlbum withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
            }
            
        }else {
            
            //-- check data
            _dataSourcePhotos = [VMDataBase getAllPhotoInAlbumByAlbumId:nil];
            
            if (_dataSourcePhotos.count > 0) {
             
                NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
                NSInteger compeTime= currentDate - [Setting sharedSetting].milestonesImageRefreshTime;
                
                if (([Setting sharedSetting].milestonesImageRefreshTime != 0) && (compeTime < [Setting sharedSetting].imageRefreshTime*60)) {
                    
                     _isCacheDataSourceAlbum = NO;
                    
                    //-- remove lable nodata
                    [self removeLableNoDataFromTableView:_tableViewPhotoInAlbum withIndex:0];
                    
                    //-- reload data tableview
                    [self.tableViewPhotoInAlbum reloadData];
                    
                    return;
                }
                else
                    [Setting sharedSetting].milestonesImageRefreshTime = currentDate;
            }
            
            //-- request API get all photo
            [self callAPIGetAllPhoto];
        }
    }
}


//-- request API get all photo
-(void) callAPIGetAllPhoto {
    NSLog(@"%s", __func__);
    
    //-- start loading
    [_activityIndicator startAnimating];
    
    //-- request musics async
    [API getAllMusicAndVideoOfSinglerID:SINGER_ID
                          contentTypeId:ContentTypeIDPhoto
                                  limit:@"200"
                                   page:[NSString stringWithFormat:@"%d",_currentPage]
                              isHotNode:@"0"
                                 months:@""
                                  appID:PRODUCTION_ID
                             appVersion:PRODUCTION_VERSION
                              completed:^(NSDictionary *responseDictionary, NSError *error) {
                                  
                                  //-- request server API success
                                  if (!error && responseDictionary) {
                                      [self createDatasourceAllPhoto:responseDictionary];
                                  }
                                  
                                  //-- stop indicator
                                  [_activityIndicator stopAnimating];
                                  
                              }];
}


- (void)fetchingPhotoInAlbum:(NSString *)abId
{
    NSLog(@"%s", __func__);
    //-- remove objects
    //[listPhoto removeAllObjects];
    NSInteger countData = [self getPhotoFromDB:abId];
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    
    if (isErrorNetWork) {
        
        //-- check time
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
        NSInteger compeTime = currentDate - [[Setting sharedSetting] milestonesImageRefreshTimeForAlbumId:abId];
        
        if (([[Setting sharedSetting] milestonesImageRefreshTimeForAlbumId:abId] != 0) && (compeTime < [Setting sharedSetting].imageRefreshTime*60) && (countData >0)) {
            
            return;
        }
        else
            [[Setting sharedSetting] setMilestonesImageRefreshTime:currentDate albumId:abId];
        
        //-- start loading
        [_activityIndicator startAnimating];
        
        [API getNodeByAlbum:abId
              contentTypeId:ContentTypeIDPhoto
                      limit:@"100"
                       page:[NSString stringWithFormat:@"%d",_currentPage]
                  isHotNode:@"0"
                      appID:PRODUCTION_ID
                 appVersion:PRODUCTION_VERSION
                  completed:^(NSDictionary *responseDictionary, NSError *error) {
                      
                      //-- request server API success
                      if (!error && responseDictionary) {
                          [self createDatasourcePhotoInAlbum:responseDictionary withAbId:abId];
                      }
                      
                      //-- stop indicator
                      [_activityIndicator stopAnimating];
                      
                  }];
        
    }
}


- (NSInteger)getPhotoFromDB:(NSString*)abId
{
    NSLog(@"%s", __func__);
    NSInteger countData = 0;
    //-- read in cache
    _dataSourcePhotos = [VMDataBase getAllPhotoInAlbumByAlbumId:abId];
    
    //-- check list data
    if ([_dataSourcePhotos count] > 0) {
        
        countData = _dataSourcePhotos.count;
        
        _isCacheDataSourceAlbum = NO;
        
        //-- reload data tableview
        [self.tableViewPhotoInAlbum reloadData];
        
    }
    
    return countData;
}


-(void)createDatasourcePhotoInAlbum:(NSDictionary *)aDictionary withAbId:(NSString *)abId
{
    NSLog(@"%s", __func__);
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"album_list"];
    if ([arrSinger count] > 0)
    {
        //-- remove objects
        [listPhoto removeAllObjects];
        
        listPhoto = [[arrSinger objectAtIndex:0] objectForKey:@"node_list"];
        _nodeTotal = [[arrSinger objectAtIndex:0] objectForKey:@"node_total"];
        
        if ([listPhoto count] > 0)
        {
            [VMDataBase deleteAllPhotoInAlbumByAlbumId:abId];
            for (NSInteger i = 0; i < [listPhoto count]; i++)
            {
                ListPhotosInAlbum *listPhotos = [[ListPhotosInAlbum alloc] init];
                
                listPhotos.albumCreatedDate = [[listPhoto objectAtIndex:i] objectForKey:@"album_created_date"];
                listPhotos.albumDescription = [[listPhoto objectAtIndex:i] objectForKey:@"album_description"];
                listPhotos.albumId = [[listPhoto objectAtIndex:i] objectForKey:@"album_id"];
                listPhotos.albumImageFilePath = [[listPhoto objectAtIndex:i] objectForKey:@"album_image_file_path"];
                listPhotos.albumLastUpdate = [[listPhoto objectAtIndex:i] objectForKey:@"album_last_update"];
                listPhotos.albumName = [[listPhoto objectAtIndex:i] objectForKey:@"album_name"];
                listPhotos.createDate = [[listPhoto objectAtIndex:i] objectForKey:@"create_date"];
                listPhotos.imagePath = [[listPhoto objectAtIndex:i] objectForKey:@"image_path"];
                listPhotos.thumbnailImagePath = [NSString stringWithFormat:@"%@_thumbnail.%@", listPhotos.imagePath.stringByDeletingPathExtension, listPhotos.imagePath.pathExtension];
                NSLog(@"image = %@ (pathWithoutExt=%@, ext=%@)--> thumbnail=%@", listPhotos.imagePath, listPhotos.imagePath.stringByDeletingPathExtension, listPhotos.imagePath.pathExtension, listPhotos.thumbnailImagePath);

                listPhotos.name = [[listPhoto objectAtIndex:i] objectForKey:@"name"];
                listPhotos.nodeId = [[listPhoto objectAtIndex:i] objectForKey:@"node_id"];
                NSString *numberComment = [NSString stringWithFormat:@"%@",[[listPhoto objectAtIndex:i] objectForKey:@"sns_total_comment"]];
                NSString *numberLike = [NSString stringWithFormat:@"%@",[[listPhoto objectAtIndex:i] objectForKey:@"sns_total_like"]];
                NSString *isLiked = [NSString stringWithFormat:@"%@",[[listPhoto objectAtIndex:i] objectForKey:@"is_liked"]];
                listPhotos.snsTotalComment = numberComment;
                listPhotos.snsTotalLike = numberLike;
                listPhotos.isLiked = isLiked;
                listPhotos.snsTotalDisLike = [[listPhoto objectAtIndex:i] objectForKey:@"sns_total_dislike"];
                listPhotos.snsTotalShare = [[listPhoto objectAtIndex:i] objectForKey:@"sns_total_share"];
                listPhotos.snsTotalView = [[listPhoto objectAtIndex:i] objectForKey:@"sns_total_view"];
                
                //[_dataSourcePhotos addObject:listPhotos];
                //-- insert into DB
                [VMDataBase insertPhotoInAlbumoBySinger:listPhotos];
            }
            //capnhat tong so photo
            [VMDataBase updateAlbumTotalPhotoBySinger:abId totalPhoto:listPhoto.count];
            [self getPhotoFromDB:abId];
        }
    }
}


- (void)createDatasourceAllPhoto:(NSDictionary *)dict
{
    NSLog(@"%s", __func__);
    NSDictionary *dictData = [dict objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"singer_list"];
    
    if ([arrSinger count] > 0)
    {
        //-- remove objects
        [listPhoto removeAllObjects];
        
        listPhoto = [[arrSinger objectAtIndex:0] objectForKey:@"node_list"];
        _nodeTotal = [[arrSinger objectAtIndex:0] objectForKey:@"node_total"];
        
        if ([listPhoto count] > 0)
        {
            //-- remove lable nodata
            [self removeLableNoDataFromTableView:_tableViewPhotoInAlbum withIndex:0];
            
            //-- saved NSdefalut for All Song
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"AllPhotosID"]) {
                
                [[NSUserDefaults standardUserDefaults] setValue:@"AllPhotos" forKey:@"AllPhotosID"];
            }
            
            for (NSInteger i = 0; i < [listPhoto count]; i++)
            {
                ListPhotosInAlbum *listPhotos = [[ListPhotosInAlbum alloc] init];
                
                listPhotos.albumCreatedDate = [[listPhoto objectAtIndex:i] objectForKey:@"album_created_date"];
                listPhotos.albumDescription = [[listPhoto objectAtIndex:i] objectForKey:@"album_description"];
                listPhotos.albumId = [[listPhoto objectAtIndex:i] objectForKey:@"album_id"];
                listPhotos.albumImageFilePath = [[listPhoto objectAtIndex:i] objectForKey:@"album_image_file_path"];
                listPhotos.albumLastUpdate = [[listPhoto objectAtIndex:i] objectForKey:@"album_last_update"];
                listPhotos.albumName = [[listPhoto objectAtIndex:i] objectForKey:@"album_name"];
                listPhotos.createDate = [[listPhoto objectAtIndex:i] objectForKey:@"create_date"];
                listPhotos.imagePath = [[listPhoto objectAtIndex:i] objectForKey:@"image_path"];
                listPhotos.thumbnailImagePath = [NSString stringWithFormat:@"%@_thumbnail.%@", listPhotos.imagePath.stringByDeletingPathExtension, listPhotos.imagePath.pathExtension];
                NSLog(@"image = %@ --> thumbnail=%@", listPhotos.imagePath, listPhotos.thumbnailImagePath);
                listPhotos.name = [[listPhoto objectAtIndex:i] objectForKey:@"name"];
                listPhotos.nodeId = [[listPhoto objectAtIndex:i] objectForKey:@"node_id"];
                NSString *numberComment = [NSString stringWithFormat:@"%@",[[listPhoto objectAtIndex:i] objectForKey:@"sns_total_comment"]];
                NSString *numberLike = [NSString stringWithFormat:@"%@",[[listPhoto objectAtIndex:i] objectForKey:@"sns_total_like"]];
                NSString *isLiked = [NSString stringWithFormat:@"%@",[[listPhoto objectAtIndex:i] objectForKey:@"is_liked"]];
                listPhotos.snsTotalComment = numberComment;
                listPhotos.snsTotalLike = numberLike;
                listPhotos.isLiked = isLiked;
                listPhotos.snsTotalDisLike = [[listPhoto objectAtIndex:i] objectForKey:@"sns_total_dislike"];
                listPhotos.snsTotalShare = [[listPhoto objectAtIndex:i] objectForKey:@"sns_total_share"];
                listPhotos.snsTotalView = [[listPhoto objectAtIndex:i] objectForKey:@"sns_total_view"];
                
                //[_dataSourcePhotos addObject:listPhotos];
                
                
                ListPhotosInAlbum *sss = [VMDataBase getAPhotoAlbumByNodeId:listPhotos.albumId];
                
                if (sss.albumId) {
                    
                    //-- neu mTrackFromDB.snsTotalComment < mTrack.snsTotalComment thi update vao Db
                    if ([sss.snsTotalComment integerValue] > [listPhotos.snsTotalComment integerValue]) {
                        
                        listPhotos.snsTotalComment = sss.snsTotalComment;
                    }
                    
                    //-- neu mTrackFromDB.snsTotalLike < mTrack.snsTotalLike thi update vao Db
                    if ([sss.snsTotalLike integerValue] > [listPhotos.snsTotalLike integerValue]) {
                        
                        listPhotos.snsTotalLike = sss.snsTotalLike;
                    }
                    
                    //-- update a Track by nodeId
                    [VMDataBase updatePhotoInAlbumBySinger:listPhotos];
                    
                }else {
                    //-- insert into DB
                    [VMDataBase insertPhotoInAlbumoBySinger:listPhotos];
                }
                
                [self getPhotoFromDB:nil];
            }
        }else {
            
            //--set background for TableView
            [_tableViewPhotoInAlbum setBackgroundView:nil];
            [_tableViewPhotoInAlbum setBackgroundColor:[UIColor clearColor]];
            [_tableViewPhotoInAlbum setSeparatorColor:[UIColor clearColor]];
            
            //-- Load the news
            CGRect frame = [_tableViewPhotoInAlbum frame];
            frame.origin.x = 0.0f;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 0.0f, 0.0f);
            
            //-- add lable no data
            [self addLableNoDataToTableView:_tableViewPhotoInAlbum withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
        }
    }
}


//*********************************************************************************//
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount;
    if ([_dataSourcePhotos count] %3 != 0)
        rowCount = [_dataSourcePhotos count]/3 + 1;
    else
        rowCount = [_dataSourcePhotos count]/3;
    
    return rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellPhotoAlbum *cell = (CustomCellPhotoAlbum *)[self setTableViewCellWithIndexPath:indexPath];
    
    return cell;
}

//-- set up table view cell for iPhone
-(CustomCellPhotoAlbum *) setTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    static NSString *identifierHome = @"sbCustomCellPhotoAlbumId";
    
    CustomCellPhotoAlbum *cell = [self.tableViewPhotoInAlbum dequeueReusableCellWithIdentifier:identifierHome];
    
    //-- set data for cell
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}

-(CustomCellPhotoAlbum *)setDataForTableViewCell:(CustomCellPhotoAlbum *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //-- image name holder
    NSString *imgBgCell = @"LichdienDefault.png";
    
    NSInteger index = indexPath.row * 3;
    
    if ([_dataSourcePhotos count]>0)
    {
        //-- Cell 1 in Row
        if (index < [_dataSourcePhotos count])
        {
            cell.imageLeft.hidden = NO;
            
            //-- start loading
//            [cell.indicatorLeft startAnimating];
            //-- add action for photo
            [cell.imageLeft setUserInteractionEnabled:YES];
            
            //-- add tap gesture
            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhoto:)];
            [singleTap setNumberOfTapsRequired:1];
            [cell.imageLeft addGestureRecognizer:singleTap];
            cell.imageLeft.tag = index;
            
            ListPhotosInAlbum *listInfo = [_dataSourcePhotos objectAtIndex:index];
            NSLog(@"Load %ld Left %@", (long)index, listInfo.thumbnailImagePath);
            //-- get image post
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:listInfo.thumbnailImagePath] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 if(image !=nil)
                     cell.imageLeft.image = image;
                 
             }];
            
        }else {
            
            cell.imageLeft.hidden = YES;
        }
        
        
        //-- Cell 2 in Row
        if (index + 1 < [_dataSourcePhotos count])
        {
            cell.imageCenter.hidden = NO;
            
            //-- start loading
//            [cell.indicatorCenter startAnimating];
            //-- add action for photo
            [cell.imageCenter setUserInteractionEnabled:YES];
            
            //-- add tap gesture
            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhoto:)];
            [singleTap setNumberOfTapsRequired:1];
            [cell.imageCenter addGestureRecognizer:singleTap];
            cell.imageCenter.tag = index + 1;
            
            ListPhotosInAlbum *postInfo = [_dataSourcePhotos objectAtIndex:index +1];
            NSLog(@"Load %ld Center %@", (long)index, postInfo.thumbnailImagePath);
            
            //-- get image post
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:postInfo.thumbnailImagePath] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 if(image !=nil)
                     cell.imageCenter.image = image;
             }];
            
        }else {
            
            cell.imageCenter.hidden = YES;
        }
        
        
        //-- Cell 3 in Row
        if (index + 2 < [_dataSourcePhotos count]) {
            
            cell.imageRight.hidden = NO;
            
            //-- start loading
//            [cell.indicatorRight startAnimating];
            //-- add action for photo
            [cell.imageRight setUserInteractionEnabled:YES];
            
            //-- add tap gesture
            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhoto:)];
            [singleTap setNumberOfTapsRequired:1];
            [cell.imageRight addGestureRecognizer:singleTap];
            cell.imageRight.tag = index + 2;
            
            ListPhotosInAlbum *postInfo = [_dataSourcePhotos objectAtIndex:index +2];
            NSLog(@"Load %ld Right %@", (long)index, postInfo.thumbnailImagePath);
    
            //-- get image post
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:postInfo.thumbnailImagePath] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 if(image !=nil)
                     cell.imageRight.image = image;
             }];
            
        }else {
            
            cell.imageRight.hidden = YES;
        }
    }
    
    return cell;
}


//*************************************************************************************//
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}


//*************************************************************************************//
#pragma mark - Action

- (IBAction)singleTappingPhoto:(UIGestureRecognizer *)sender
{
    NSInteger indexOfPhoto = [sender view].tag;
    NSLog(@"%s index:%d", __func__,indexOfPhoto);
    
    if ([_dataSourcePhotos count]>0) {
        
        DetailsAlbumPhotoViewController *maVC = (DetailsAlbumPhotoViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"sbDetailsAlbumPhotoViewControllerId"];
        
        ListPhotosInAlbum *abP = (ListPhotosInAlbum *)[_dataSourcePhotos objectAtIndex:indexOfPhoto];
        
        if (abP) {
            maVC.indexOfPhoto = indexOfPhoto;
            maVC.arrayPhoto = _dataSourcePhotos;
            maVC.number_of_images = _dataSourcePhotos.count;
            maVC.albumTitle = [arrTitle objectAtIndex:indexOfAlbum];
        }
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
            [self.navigationController pushViewController:maVC animated:YES];
        else
            [self.navigationController pushViewController:maVC animated:NO];
    }
}

//-- crop image
-(UIImage*)crop:(UIImageView*)imgView withFrame:(CGRect)frame
{
    // Find the scalefactors  UIImageView's widht and height / UIImage width and height
    CGFloat widthScale = imgView.bounds.size.width / imgView.frame.size.width;
    CGFloat heightScale = imgView.bounds.size.height / imgView.frame.size.height;
    
    // Calculate the right crop rectangle
    frame.origin.x = frame.origin.x * (1 / widthScale);
    frame.origin.y = frame.origin.y * (1 / heightScale);
    frame.size.width = frame.size.width * (1 / widthScale);
    frame.size.height = frame.size.height * (1 / heightScale);
    
    // Create a new UIImage
    CGImageRef imageRef = CGImageCreateWithImageInRect(imgView.image.CGImage, frame);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}


@end
