//
//  TableTopUserViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 1/5/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "TableTopUserViewController.h"

@interface TableTopUserViewController ()

@end

@implementation TableTopUserViewController

@synthesize listTopUser;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - Main

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//****************************************************************************//
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"listTopUser: %d",listTopUser.count);
    return listTopUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellTopUser *cell = [self setCustomTableViewCellForWithIndexPath:indexPath];
    
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

//-- set up table view cell for iPhone
-(CustomCellTopUser *) setCustomTableViewCellForWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sbCustomCellTopUserId";
    CustomCellTopUser *cell = (CustomCellTopUser *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCellTopUser" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CustomCellTopUser *) currentObject;
                break;
            }
        }
    }
    
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}

-(CustomCellTopUser *)setDataForTableViewCell:(CustomCellTopUser *)cell withIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //-- set color background for cell
    if ((indexPath.row%2) == 0)
        cell.contentView.backgroundColor = COLOR_SCHEDULE_CELL_BOLD;
    else
        cell.contentView.backgroundColor = COLOR_SCHEDULE_CELL_REGULAR;
    
    if ([listTopUser count]>0) {
        
        TopUser *topUser = (TopUser*)[listTopUser objectAtIndex:indexPath.row];
        
        cell.lblNumber.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        cell.lblFullName.text = topUser.fullName;
        cell.lblPoints.text = [NSString stringWithFormat:@"%@ points",topUser.point];
        
        cell.imgAvt.layer.masksToBounds = YES;
        cell.imgAvt.layer.cornerRadius = 17.5f;
        cell.imgAvt.layer.borderWidth = 1.0;
        
        cell.imgAvt.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        //-- fix size
        [cell.imgAvt setContentMode:UIViewContentModeScaleAspectFill];
        [cell.imgAvt setClipsToBounds:YES];
        [Utility scaleImage:cell.imgAvt.image toSize:CGSizeMake(90, 90)];
        
        //-- download image
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:topUser.userImage] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        }];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //-- pass Delegate
    [[self delegate] goToDetailProfileViewControllerWithListData:listTopUser withIndexRow:indexPath.row];
    
    //longnh add
    TopUser *topUser = (TopUser*)[listTopUser objectAtIndex:indexPath.row];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"read_top_user"  // Event action (required)
                                                           label:topUser.fullName
                                                           value:nil] build]];

}


@end
