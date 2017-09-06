//
//  VideoViewController.m
//  NooPhuocThinh
//
//  Created by HunDo on 12/12/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@property (nonatomic, strong) NSMutableIndexSet *collapsedSections;

@end

@implementation VideoViewController

@synthesize listSectionCategories,dataSourceVideo,_tableViewVideos;


//*************************************************************************//
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
    
    [self setTitle:@"Video"];
    
    //-- load view
    [self setViewWhenViewDidLoad];
    
    //-- load Data
    [self setDataWhenViewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Video Screen";
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//*************************************************************************//
#pragma mark - Set View

-(void) setViewWhenViewDidLoad {
    
    [self setupBackButton];
}


//*************************************************************************//
#pragma mark - Get Data

-(void) setDataWhenViewDidLoad {
    NSLog(@"%s", __func__);
    listSectionCategories = [[NSMutableArray alloc] init];
    
    //-- add section Tất Cả
    ContentTypeList *contentTypeList = [ContentTypeList new];
    contentTypeList.content_type_id = [NSString stringWithFormat:@"%d",ContentTypeIDAllVideo];
    contentTypeList.content_type_name = [NSString stringWithFormat:@"Tất Cả"];
    
    [listSectionCategories addObject:contentTypeList];
    
    
    //-- init data source
    dataSourceVideo = [[NSMutableArray alloc] init];
    
    self.collapsedSections = [NSMutableIndexSet indexSet];
    [self.collapsedSections addIndex:0];
    
    //-- fetching data
    [self fetchingVideo];
}


//*************************************************************************//
#pragma mark - Call API

- (void)fetchingVideo
{
    NSLog(@"%s", __func__);

    //-- remove list
    [dataSourceVideo removeAllObjects];
    
    //-- check Network
    BOOL isErrorNetWork = [self checkAndShowErrorNoticeNetwork];
    
    if (!isErrorNetWork) {
        
        //-- save data defaultCategoriesByVideo offline
        NSUserDefaults *defaultCategoriesByVideo = [NSUserDefaults standardUserDefaults];
        
        //-- get CategoriesByVideoOffline
        NSDictionary *responseDictionary = [defaultCategoriesByVideo valueForKey:@"CategoriesByVideoOffline"];
        [self createDatasourceVideo:responseDictionary];
        
        //-- get CategoriesByVideoUnOffline
        NSDictionary *responseDictionaryUnOffline = [defaultCategoriesByVideo valueForKey:@"CategoriesByVideoUnOffline"];
        [self createDatasourceVideo:responseDictionaryUnOffline];
        
    }else {
        
        //-- check data
        NSDictionary *responseDictionary            = [userDefault valueForKey:@"CategoriesByVideoOffline"];
        NSDictionary *responseDictionaryUnOffline   = [userDefault valueForKey:@"CategoriesByVideoUnOffline"];
        
        //-- check time
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
        NSInteger compeTime = currentDate - [Setting sharedSetting].milestonesVideoCategoryRefreshTime;
        
        if (([Setting sharedSetting].milestonesVideoCategoryRefreshTime != 0) && (compeTime < [Setting sharedSetting].videoCategoryRefreshTime*60) && responseDictionary && responseDictionaryUnOffline)
        {
            //-- get CategoriesByVideoOffline
            [self createDatasourceVideo:responseDictionary];
            
            //-- get CategoriesByVideoUnOffline
            [self createDatasourceVideo:responseDictionaryUnOffline];
            
            return;
        }
        else
            [Setting sharedSetting].milestonesVideoCategoryRefreshTime = currentDate;
        
        //-- request Video async
        [API getCategoryBySinger:SINGER_ID
                   contentTypeId:ContentTypeIDVideo
                           appID:PRODUCTION_ID
                      appVersion:PRODUCTION_VERSION
                       completed:^(NSDictionary *responseDictionary, NSError *error) {
                           
                           if (!error) {
                               
                               //-- save data defaultCategoriesByVideo offline
                               NSUserDefaults *defaultCategoriesByVideo = [NSUserDefaults standardUserDefaults];
                               [defaultCategoriesByVideo setValue:responseDictionary forKey:@"CategoriesByVideoOffline"];
                               [defaultCategoriesByVideo synchronize];
                               
                               [self createDatasourceVideo:responseDictionary];
                               
                           }else {
                               
                               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                               NSString *messageError = [userDefaults valueForKey:Key_Message_System_Error];
                               
                               [self showMessageWithType:VMTypeMessageOk withMessage:messageError withFriendName:nil needDelegate:NO withTag:6];
                           }
                           
                       }];
        
        //-- request Unofficial Video async
        [self performSelector:@selector(getUnofficialVideoAPI) withObject:nil afterDelay:0.5];
    }
}

-(void) getUnofficialVideoAPI {
    NSLog(@"%s", __func__);

    //-- request Unofficial Video async
    [API getCategoryBySinger:SINGER_ID
               contentTypeId:ContentTypeIDUnofficialVideo
                       appID:PRODUCTION_ID
                  appVersion:PRODUCTION_VERSION
                   completed:^(NSDictionary *responseDictionary, NSError *error) {
                       
                       if (!error) {
                           
                           //-- save data defaultCategoriesByVideo offline
                           NSUserDefaults *defaultCategoriesByVideo = [NSUserDefaults standardUserDefaults];
                           [defaultCategoriesByVideo setValue:responseDictionary forKey:@"CategoriesByVideoUnOffline"];
                           [defaultCategoriesByVideo synchronize];
                           
                           [self createDatasourceVideo:responseDictionary];
                       }
                       
                   }];
}

- (void)createDatasourceVideo:(NSDictionary *)aDictionary
{
    NSLog(@"%s", __func__);
    NSDictionary *dictData = [aDictionary objectForKey:@"data"];
    NSMutableArray *arrSinger = [dictData objectForKey:@"singer_list"];
    
    if (arrSinger.count > 0) {
        NSDictionary *dictSinger = [arrSinger objectAtIndex:0];
        NSMutableArray *arrContentType = [dictSinger objectForKey:@"content_type_list"];
        
        if (arrContentType.count > 0) {
            
            NSDictionary *dictContentType = [arrContentType objectAtIndex:0];
            NSMutableArray *arrCategory = [dictContentType objectForKey:@"category_list"];
            
            ContentTypeList *contentTypeList = [ContentTypeList new];
            contentTypeList.content_type_id = [dictContentType objectForKey:@"content_type_id"];
            contentTypeList.content_type_name = [dictContentType objectForKey:@"content_type_name"];
            contentTypeList.current_page = [dictContentType objectForKey:@"current_page"];
            contentTypeList.node_total = [dictContentType objectForKey:@"node_total"];
            contentTypeList.paging_total = [dictContentType objectForKey:@"paging_total"];
            
            //-- add section categories
            [listSectionCategories addObject:contentTypeList];
            
            //-- add categories
            if ([arrCategory count] > 0)
            {   [VMDataBase deleteAllCategoriesByVideoForContentTypeId:ContentTypeIDAllVideo];
                for (NSDictionary *tmpDict in arrCategory)
                {
                    CategoryBySinger *aCategory         = [CategoryBySinger new];
                    aCategory.contentTypeId             = [dictContentType objectForKey:@"content_type_id"];
                    aCategory.categoryId                = [tmpDict objectForKey:@"category_id"];
                    aCategory.bigIconImageFilePath      = [tmpDict objectForKey:@"big_icon_image_file_path"];
                    aCategory.countryId                 = [tmpDict objectForKey:@"country_id"];
                    aCategory.countryName               = [tmpDict objectForKey:@"country_name"];
                    aCategory.demographicDescription    = [tmpDict objectForKey:@"demographic_description"];
                    aCategory.demographicId             = [tmpDict objectForKey:@"demographic_id"];
                    aCategory.demographicName           = [tmpDict objectForKey:@"demographic_name"];
                    aCategory.description               = [tmpDict objectForKey:@"description"];
                    aCategory.forumLink                 = [tmpDict objectForKey:@"forum_link"];
                    aCategory.iconImageFilePath         = [tmpDict objectForKey:@"icon_image_file_path"];
                    aCategory.name                      = [tmpDict objectForKey:@"name"];
                    aCategory.order                     = [[tmpDict objectForKey:@"order"] integerValue];
                    aCategory.parentId                  = [tmpDict objectForKey:@"parent_id"];
                    aCategory.thumbnailImagePath        = [tmpDict objectForKey:@"thumbnail_image_path"];
                    
                    //-- insert into DB
                    [VMDataBase insertCategoryByVideo:aCategory];
                    
                    //-- add into arr
                    [dataSourceVideo addObject:aCategory];
                }
            }
        }
    }
    
    //-- reload tableview
    [_tableViewVideos reloadData];
}


//********************************************************************************//
#pragma mark - Tableview

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [listSectionCategories count];
}

//---get the section header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    ContentTypeList *contentTypeList = [self.listSectionCategories objectAtIndex:section];
    return contentTypeList.content_type_name;
}

//--- setup header view
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"%s", __func__);
    ContentTypeList *contentTypeList = [self.listSectionCategories objectAtIndex:section];
    
    //---returns the items in that section as an array
    BOOL isExistSubCategory = NO;
    for (int i = 0; i < dataSourceVideo.count; i++) {
        
        CategoryBySinger *aCategory = [dataSourceVideo objectAtIndex:i];
        
        if ([aCategory.contentTypeId isEqualToString:contentTypeList.content_type_id]) {
            
            isExistSubCategory = YES;
            break;
        }
    }
    
    //-- section text as a label
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,50)];
    headerView.backgroundColor = COLOR_BG_CELL_FORMAL;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.frame.size.width-15, headerView.frame.size.height)];
    headerLabel.textAlignment = UITextAlignmentLeft;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = contentTypeList.content_type_name;
    
    //-- add button drop down
    CGRect frameimgdrop = CGRectMake(0, 0, 300, 50);
    
    UIButton *dropdownBtn = [[UIButton alloc] initWithFrame:frameimgdrop];
    dropdownBtn.tag = section;
    dropdownBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    //-- check image drop down button
    UIImage* imagedrop = [UIImage imageNamed:@"arrow_down.png"];
    if (isExistSubCategory == YES) {
        
        if ([self.collapsedSections containsIndex:section]) {
            // section is collapsed
            imagedrop = [UIImage imageNamed:@"icon_cell_detail.png"];
        } else {
            // section is expanded
            imagedrop = [UIImage imageNamed:@"arrow_down.png"];
        }
        
        //-- add action
        [dropdownBtn addTarget:self action:@selector(dropDownSelected:)
              forControlEvents:UIControlEventTouchUpInside];
        
    }else {
        
        imagedrop = [UIImage imageNamed:@"icon_cell_detail.png"];
        
        //-- add action
        [dropdownBtn addTarget:self action:@selector(sectionDetailSelected:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    [dropdownBtn setImage:imagedrop forState:UIControlStateNormal];
    
    //-- add Image line
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
    imgLine.backgroundColor = [UIColor grayColor];
    
    [headerView addSubview:imgLine];
    [headerView addSubview:headerLabel];
    [headerView addSubview:dropdownBtn];
    
    return headerView;
}

//-- height for header
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


//-- dropdown header view
-(IBAction)dropDownSelected:(id)sender {
    NSLog(@"%s", __func__);
    
    UIButton *btnDropDown = (UIButton *) sender;
    NSInteger section = btnDropDown.tag;
    
    if ([self.collapsedSections containsIndex:section]) {
        // section is collapsed
        [self.collapsedSections removeIndex:section];
    } else {
        // section is expanded
        [self.collapsedSections addIndex:section];
    }
    
    [_tableViewVideos beginUpdates];
    [_tableViewVideos reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableViewVideos endUpdates];
}

//-- go to video list screen
-(IBAction)sectionDetailSelected:(id)sender {
    NSLog(@"%s", __func__);
    
    UIButton *btnSectionAction = (UIButton *) sender;
    NSInteger section = btnSectionAction.tag;
    
    ContentTypeList *contentTypeList = [listSectionCategories objectAtIndex:section];
    
    VideoListViewController *listVideoVC = (VideoListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"showListVideos"];
    
    //-- get list segment
    listVideoVC.segmentsArrayCategories = nil;
    listVideoVC.listCategoriesVideo = nil;
    listVideoVC.indexOfCategories = 0;
    
    //-- Video Official or UnOfficial
    listVideoVC.videoTypeId = [contentTypeList.content_type_id integerValue];
    
    listVideoVC.title = contentTypeList.content_type_name;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController pushViewController:listVideoVC animated:YES];
    else
        [self.navigationController pushViewController:listVideoVC animated:NO];
}

//--set height for the row
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%s", __func__);
    //-- if section is collapsed
    if ([self.collapsedSections containsIndex:section])
        return 0;
    
    //-- if section is expanded
    //---check the current sectionStr based on the section index
    ContentTypeList *contentTypeList = [self.listSectionCategories objectAtIndex:section];
    
    //---returns the items in that section as an array
    NSMutableArray *itemsSection = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataSourceVideo.count; i++) {
        
        CategoryBySinger *aCategory = [dataSourceVideo objectAtIndex:i];
        
        if ([aCategory.contentTypeId isEqualToString:contentTypeList.content_type_id]) {
            
            if (itemsSection.count == 0)
                [itemsSection addObject:@"Tất Cả"];
            
            [itemsSection addObject:[dataSourceVideo objectAtIndex:i]];
        }
    }
    
    //---return the number of items for that section as the number of rows in that
    return [itemsSection count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"VideoHomeCell";
    VideosCustomCell  * cell = (VideosCustomCell *)[_tableViewVideos dequeueReusableCellWithIdentifier:identifier];
    
    //---check the current sectionStr based on the section index
    ContentTypeList *contentTypeList = [self.listSectionCategories objectAtIndex:[indexPath section]];
    
    //---returns the items in that section as an array
    NSMutableArray *itemsSection = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataSourceVideo.count; i++) {
        
        CategoryBySinger *aCategory = [dataSourceVideo objectAtIndex:i];
        
        if ([aCategory.contentTypeId isEqualToString:contentTypeList.content_type_id]) {
            
            if (itemsSection.count == 0)
                [itemsSection addObject:@"Tất Cả"];
            
            [itemsSection addObject:[dataSourceVideo objectAtIndex:i]];
        }
    }
    
    if (indexPath.row == 0) {
        
        cell.lblCategoryVideo.text = [itemsSection objectAtIndex:indexPath.row];;
    }else {
        CategoryBySinger *aCategory = [itemsSection objectAtIndex:indexPath.row];
        cell.lblCategoryVideo.text = aCategory.name;
    }
    
    cell.contentView.backgroundColor = COLOR_BG_CELL_INFORMAL;
    [cell.lblCategoryVideo setFont:[UIFont systemFontOfSize:14]];
    cell.imgViewSeparatorCell.alpha = 1;
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __func__);
    if ([segue.identifier isEqualToString:@"showListVideos"])
    {
        //-- selected cell and pass value to CategoryTableViewController
        VideosCustomCell *cell = (VideosCustomCell *) sender;
        NSIndexPath *indexpth = [_tableViewVideos indexPathForCell:cell];
        
        //-- get data
        VideoListViewController *listVideoVC = (VideoListViewController *)[segue destinationViewController];
        
        //---check the current sectionStr based on the section index
        ContentTypeList *contentTypeList = [self.listSectionCategories objectAtIndex:[indexpth section]];
        
        //---returns the items in that section as an array
        NSMutableArray *itemsSection = [[NSMutableArray alloc] init];
        NSMutableArray *segmentsArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < dataSourceVideo.count; i++) {
            
            CategoryBySinger *aCategory = [dataSourceVideo objectAtIndex:i];
            
            if ([aCategory.contentTypeId isEqualToString:contentTypeList.content_type_id]) {
                
                if (itemsSection.count == 0) {
                    [itemsSection addObject:@"Tất Cả"];
                    [segmentsArray addObject:@"Tất Cả"];
                }
                
                [itemsSection addObject:aCategory];
                [segmentsArray addObject:aCategory.name];
            }
        }
        
        //-- get list segment
        listVideoVC.segmentsArrayCategories = segmentsArray;
        listVideoVC.listCategoriesVideo = itemsSection;
        
        listVideoVC.indexOfCategories = indexpth.row;
        
        //-- Video Official or UnOfficial
        listVideoVC.videoTypeId = [contentTypeList.content_type_id integerValue];
        
        listVideoVC.title = contentTypeList.content_type_name;
    }
}

@end
