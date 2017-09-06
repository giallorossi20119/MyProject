//
//  TableFanzoneViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 3/10/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "TableFanzoneViewController.h"

@interface TableFanZoneViewController ()

@end

@implementation TableFanZoneViewController

@synthesize listShoutbox;
@synthesize delegate = _delegate;
@synthesize indexSegment;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([listShoutbox count] > 0) {
        
        //-- remove lable nodata
        [self removeLableNoDataFromTableView:self.tableView withIndex:0];
        
    }else {
        
        //--set background for TableView
        [self.tableView setBackgroundView:nil];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        [self.tableView setSeparatorColor:[UIColor clearColor]];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //-- Load the news
        CGRect frame = [self.tableView frame];
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        
        //-- add lable no data
        [self addLableNoDataToTableView:self.tableView withIndex:0 withFrame:frame byTitle:TITLE_NoCommentFanZone_Default];
    }
    
    return [listShoutbox count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellListComments *cell = [self setCustomTableViewCellForWithIndexPath:indexPath];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

//-- set up table view cell for iPhone
-(CustomCellListComments *) setCustomTableViewCellForWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierLeft = @"idCustomCellListCommentsLeft";
    static NSString *identifierRight = @"idCustomCellListCommentsRight";
    
    CustomCellListComments *cell = nil;
    UITableView *currentTableView = nil;
    
    if ((indexPath.row%2) == 0){
        
        cell = [currentTableView dequeueReusableCellWithIdentifier:identifierLeft];
        if (!cell)
            cell = [CustomCellListComments cellWithCustomType:CellCustomFanZoneHomeTypeLeft];
        
    }else {
        
        cell = [currentTableView dequeueReusableCellWithIdentifier:identifierRight];
        if (!cell)
            cell = [CustomCellListComments cellWithCustomType:CellCustomFanZoneHomeTypeRight];
    }
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCellListComments" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CustomCellListComments *) currentObject;
                break;
            }
        }
    }
    
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}


-(CustomCellListComments *)setDataForTableViewCell:(CustomCellListComments *)cell withIndexPath:(NSIndexPath *)indexPath
{
    Comment *sbModel = nil;
    
    if ([listShoutbox count] > 0 && (indexPath.row < [listShoutbox count]))
        sbModel = (Comment*)[listShoutbox objectAtIndex:indexPath.row];
    
    if (sbModel) {
        
        //-- height of cell
        CGFloat heightCell = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
        
        //-- avatar postion at bottom cell
        
        CGRect frameAvatar = cell.imageAvt.frame;
        frameAvatar.origin.y = heightCell - 18 - frameAvatar.size.height;
        cell.imageAvt.frame = frameAvatar;
        //-- circle avatar image
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageAvt.layer.masksToBounds = YES;
        cell.imageAvt.layer.cornerRadius = 19;
        cell.imageAvt.layer.borderWidth = 1.0;
        cell.imageAvt.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        cell.lblNumberCmt.text = [NSString stringWithFormat:@"%@",sbModel.numberOfSubcommments];
        
        if ([sbModel.profileUser.userImage hasSuffix:NO_AVATAR])
            cell.imageAvt.image = [UIImage imageNamed:@"img_avatar_default.png"];
        //NSLog(@"userID:%@ userImage:%@",sbModel.profileUser.userId,sbModel.profileUser.userImage);
        [cell.imageAvt setImageWithURL:[NSURL URLWithString:sbModel.profileUser.userImage] placeholderImage:[UIImage imageNamed:@"img_avatar_default.png"]];
        
        //--set text
        CGSize sizeText = [Utility sizeFromString:sbModel.content sizeMax:CGSizeMake(170.0f, 480.0f) font:[UIFont systemFontOfSize:12]];
        
        //-- height for lable text
        CGRect frameContent = cell.lblContent.frame;
        frameContent.size.height = sizeText.height + 5;
        cell.lblContent.frame = frameContent;
        
        //-- size for bg, default = 36
        CGRect frameBg = cell.imageBackgroundCmt.frame;
        if (frameContent.size.height + 9 + 12 > 36)
            frameBg.size.height = frameContent.size.height + 9 + 12;
        else
            frameBg.size.height = 36;
        cell.imageBackgroundCmt.frame = frameBg;
        
        //-- repostion
        frameContent.origin.y = frameBg.origin.y+9;
        cell.lblContent.frame = frameContent;
        
        //--time postion at bottom cell
        CGRect frameTime = cell.lblTimer.frame;
        frameTime.origin.y = frameContent.origin.y + frameContent.size.height;
        cell.lblTimer.frame = frameTime;
        
        //--line postion at bottom cell
        CGRect frameLine = cell.imageLine.frame;
        frameLine.origin.y = frameBg.origin.y+ frameBg.size.height + 18;
        cell.imageLine.frame = frameLine;
        
        if ((indexPath.row % 2) != 0)
            cell.imageBackgroundCmt.image = [[UIImage imageNamed:@"img_buble_black.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        else
            cell.imageBackgroundCmt.image = [[UIImage imageNamed:@"img_buble_white.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        
        cell.lblContent.text = sbModel.content;
        
        //-- set time value
        NSDate *dateMsg = [NSDate dateWithTimeIntervalSince1970:[sbModel.timeStamp integerValue]];
        cell.lblTimer.text = [Utility relativeTimeFromDate:dateMsg];
        
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //-- pass Delegate
    [[self delegate] goToDetailFanZoneViewControllerWithListData:listShoutbox withIndexRow:indexPath.row];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *messageModel = nil;
    
    if ([listShoutbox count] > 0 && (indexPath.row < [listShoutbox count])) {

        messageModel = (Comment*)[listShoutbox objectAtIndex:indexPath.row];
    
        NSString *body = [NSString stringWithFormat:@"%@",messageModel.content];
        CGSize size = [Utility sizeFromString:body sizeMax:CGSizeMake(170.0f, 480.0f) font:[UIFont systemFontOfSize:12]];
        
        if (size.height+57 > 70)
            return size.height +57;
        else return 70;
        
    }else return 70;
}

//-- show lable no data
-(void) addLableNoDataToTableView:(UITableView *)tableview withIndex:(NSInteger) index withFrame:(CGRect) frameLable byTitle:(NSString *) titleData {
    
    UILabel *lblNodata = [[UILabel alloc] initWithFrame:frameLable];
    lblNodata.tag = index;
    lblNodata.backgroundColor = [UIColor clearColor];
    lblNodata.textColor = [UIColor whiteColor];
    lblNodata.textAlignment = UITextAlignmentCenter;
    lblNodata.lineBreakMode = NSLineBreakByWordWrapping;
    lblNodata.numberOfLines = 0;
    lblNodata.text = titleData;
    
    [tableview addSubview:lblNodata];
}

//-- remove lable no data
-(void) removeLableNoDataFromTableView:(UITableView *)tableview withIndex:(NSInteger) index {
    
    for (UIView *lblNadata in tableview.subviews) {
        
        if ([lblNadata isKindOfClass:[UILabel class]] && lblNadata.tag == index) {
            
            [lblNadata removeFromSuperview];
            break;
        }
    }
}

@end
