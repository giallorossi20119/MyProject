//
//  TableStoreViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 3/18/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "TableStoreViewController.h"

@interface TableStoreViewController ()

@end

@implementation TableStoreViewController

@synthesize delegate;
@synthesize listStore,arrangeProduct;

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
    
    //--set background for TableView
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - tableview

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //-- remove lable nodata
    [self removeLableNoDataFromTableView:self.tableView withIndex:0];
    
    NSInteger rowCount;
    
    if ([listStore count] == 0)
    {
        //-- Load the news
        CGRect frame = [self.tableView frame];
        frame.origin.x = 0.0f + frame.size.width/2;
        frame.origin.y = 0.0f + frame.size.height/2;
        frame = CGRectInset(frame, 100.0f, 50.0f);
        
        //-- add lable no data
        [self addLableNoDataToTableView:self.tableView withIndex:0 withFrame:frame byTitle:TITLE_NoData_Default];
    }
    if ([listStore count] % 2 != 0)
    {
        rowCount = [listStore count]/2 + 1;
    }
    else
    {
        rowCount = [listStore count]/2;
    }
    
    return rowCount;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellCustomStoreId";
    CellCustomStore *cell = (CellCustomStore *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CellCustomStore" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CellCustomStore *) currentObject;
                break;
            }
        }
    }
    
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}


-(CellCustomStore *)setDataForTableViewCell:(CellCustomStore *)cell withIndexPath:(NSIndexPath *)indexPath
{
    Store *aStore=nil;
    NSInteger index = indexPath.row * 2;

    if (index < listStore.count)
    {
        aStore = (Store *)[listStore objectAtIndex:indexPath.row];
        
        [cell.imvProduct1 setImageWithURL:[NSURL URLWithString:((Store*)[listStore objectAtIndex:index]).thumbnailImagePath]
                         placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
        
        UITapGestureRecognizer *sender1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productClicked:)];
        
        cell.imvProduct1.userInteractionEnabled = YES;
        [cell.imvProduct1 addGestureRecognizer:sender1];
        cell.imvProduct1.tag = index;
        
        cell.lblTitle1.text = ((Store*)[listStore objectAtIndex:index]).name;
        //decimal for price unit
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSString *value1 = [numberFormatter stringFromNumber:[NSNumber numberWithLong:[((Store*)[listStore objectAtIndex:index]).priceUnit integerValue]]];
        cell.lblPrice1.text = [NSString stringWithFormat:@"%@ VNĐ", value1];
        cell.lblPrice1.textColor = [UIColor redColor];
        
        [cell.imvProduct2 setImageWithURL:[NSURL URLWithString:((Store*)[listStore objectAtIndex:index+1]).thumbnailImagePath]placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];;
        
        UITapGestureRecognizer *sender2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productClicked:)];
        cell.imvProduct2.userInteractionEnabled = YES;
        [cell.imvProduct2 addGestureRecognizer:sender2];
        cell.imvProduct2.tag = index+1;
        
        cell.lblTitle2.text = ((Store*)[listStore objectAtIndex:index+1]).name;
        
        NSString *value2 = [numberFormatter stringFromNumber:[NSNumber numberWithLong:[((Store*)[listStore objectAtIndex:index+1]).priceUnit integerValue]]];
        cell.lblPrice2.text = [NSString stringWithFormat:@"%@ VNĐ", value2];
        cell.lblPrice2.textColor = [UIColor redColor];
        
        //set custom separator for cell
        UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3,cell.frame.size.width,5)];
        additionalSeparator.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
        [cell addSubview:additionalSeparator];
    }
    else if (index >= listStore.count)
    {
        NSLog(@"no more product");
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    //-- pass Delegate
    [[self delegate] goToDetailStoreViewControllerWithListData:listStore withIndexRow:(int)indexPath.row];
}

#pragma mark - Add or Remove label Nodata

//-- show lable no data
-(void) addLableNoDataToTableView:(UITableView *)tableview withIndex:(NSInteger) index withFrame:(CGRect) frameLable byTitle:(NSString *) titleData
{
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

//-- product click
-(void)productClicked:(UITapGestureRecognizer*)sender
{
    NSInteger indexOfProduct = [sender view].tag;
    NSLog(@"%s index:%ld", __func__,(long)indexOfProduct);
    [[self delegate] goToDetailStoreViewControllerWithListData:listStore withIndexRow:(int)indexOfProduct];
}

@end
