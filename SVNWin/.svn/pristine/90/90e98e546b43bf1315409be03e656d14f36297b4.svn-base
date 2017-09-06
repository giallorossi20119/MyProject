//
//  TableDetailScheduleViewController.m
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/30/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import "TableDetailScheduleViewController.h"

@interface TableDetailScheduleViewController ()

@end

@implementation TableDetailScheduleViewController

@synthesize listSchedule;
@synthesize delegate = _delegate;
@synthesize listCellImage;
@synthesize schedule;

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
    
    stringSinger = @"Trấn Thành, Phương Mỹ Chi, Đàm Vĩnh Hưng, NSND Lệ Thuỷ, \nLê Văn Long, Tuấn Hưng, Thoả Đại Ka, Ưng Hoàng Phúc ...";
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
    return listCellImage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellDetailSchedule *cell = [self setCustomTableViewCellForWithIndexPath:indexPath];
    
    [tableView setSeparatorColor:[UIColor clearColor]];
    tableView.backgroundColor =  [UIColor clearColor];
    
    return cell;
}

//-- set up table view cell for iPhone
-(CustomCellDetailSchedule *) setCustomTableViewCellForWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sbCustomCellDetailScheduleId";
    CustomCellDetailSchedule *cell = (CustomCellDetailSchedule *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCellDetailSchedule" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CustomCellDetailSchedule *) currentObject;
                break;
            }
        }
    }
    
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}

-(CustomCellDetailSchedule *)setDataForTableViewCell:(CustomCellDetailSchedule *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NSString *phoneStr = schedule.phone;
    //-- set color background for cell
    if ((indexPath.row%2) == 0)
        cell.contentView.backgroundColor = COLOR_SCHEDULE_CELL_BOLD;
    else
        cell.contentView.backgroundColor = COLOR_SCHEDULE_CELL_REGULAR;
    
    if ([listSchedule count]>0) {
        
        switch (indexPath.row) {
            case 0:
                cell.txvCell.alpha = 0;
                cell.lblCell.text = schedule.startDate;
                cell.imgIcon.image = [UIImage imageNamed:[listCellImage objectAtIndex:0]];
                break;
                
            case 1:
                cell.txvCell.alpha = 0;
                cell.lblCell.text = schedule.locationEventAddress;
                cell.lblCell.font = [UIFont systemFontOfSize:12.0f];
                cell.imgIcon.image = [UIImage imageNamed:[listCellImage objectAtIndex:1]];
                break;
                
            case 2:
                cell.lblCell.alpha = 0;                
                cell.txvCell.text = stringSinger;
                cell.imgIcon.image = [UIImage imageNamed:[listCellImage objectAtIndex:2]];
                CGFloat heightSingers = [Utility heightFromString:stringSinger maxWidth:270 font:[UIFont systemFontOfSize:12.0f]] + 10;
                cell.txvCell.frame = CGRectMake(cell.txvCell.frame.origin.x, cell.txvCell.frame.origin.y, cell.txvCell.frame.size.width, heightSingers);
                
                break;
                
            case 3:
                cell.lblCell.alpha = 0;
                cell.imgIcon.image = [UIImage imageNamed:[listCellImage objectAtIndex:3]];
                
                cell.txvCell.text = schedule.price;
                CGFloat heightTV = [Utility heightFromString:schedule.price maxWidth:275 font:[UIFont systemFontOfSize:12.0f]] + 10;
                if (heightTV < 30)
                    cell.txvCell.frame = CGRectMake(cell.txvCell.frame.origin.x, cell.txvCell.frame.origin.y, cell.txvCell.frame.size.width, heightTV);
                else
                    cell.txvCell.frame = CGRectMake(cell.txvCell.frame.origin.x, cell.txvCell.frame.origin.y, cell.txvCell.frame.size.width, heightTV + 10);
                
                break;
                
            case 4:
                cell.txvCell.alpha = 0;
                if (![phoneStr isKindOfClass:[NSNull class]] || ![phoneStr isEqualToString:@"null"] || ![phoneStr length])
                    cell.lblCell.text = phoneStr;
                else
                    cell.lblCell.text = @"19006130";
                
                cell.imgIcon.image = [UIImage imageNamed:[listCellImage objectAtIndex:4]];
                
                break;
                
            case 5:
                cell.txvCell.alpha = 1;
                cell.lblCell.alpha = 0;
                cell.imgIcon.image = [UIImage imageNamed:[listCellImage objectAtIndex:5]];
                cell.imgIcon.frame = CGRectMake(cell.imgIcon.frame.origin.x, cell.imgIcon.frame.origin.y, 17, 17);
                
                //-- lyric content
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    
                    NSString *stringFormat = [NSString stringWithFormat:@"<div style=\"color: #fff; text-align: left; font-size: 12px; \">%@ </div>",schedule.cityDescription];
                    NSAttributedString *aStr = [[NSAttributedString alloc] initWithData:[stringFormat dataUsingEncoding:NSUTF8StringEncoding]
                                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                          NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                     documentAttributes:nil error:nil];
                    
                    cell.txvCell.attributedText = aStr;
                }else{
                    [cell.txvCell setValue:schedule.cityDescription forKey:@"contentToHTMLString"];
                }
                
                CGFloat heightTxv = [Utility heightFromString:schedule.cityDescription maxWidth:275 font:[UIFont systemFontOfSize:12.0f]];
                cell.txvCell.frame = CGRectMake(cell.txvCell.frame.origin.x, cell.txvCell.frame.origin.y, cell.txvCell.frame.size.width, heightTxv);
                
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger heightRow;
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4) {
        heightRow = 50;
    }else{
        if (indexPath.row == 5) {
            CGFloat height = [Utility heightFromString:schedule.cityDescription maxWidth:275 font:[UIFont systemFontOfSize:12.0f]];
            heightRow = height;
        }
        
        if (indexPath.row == 2) {
            CGFloat heightSingers = [Utility heightFromString:stringSinger maxWidth:275 font:[UIFont systemFontOfSize:12.0f]] + 10;
            heightRow = heightSingers;
        }
        
        if (indexPath.row == 3) {
            CGFloat heightPrice = [Utility heightFromString:schedule.price maxWidth:275 font:[UIFont systemFontOfSize:12.0f]];
            if (heightPrice > 30)
                heightRow = heightPrice + 10;
            else
                heightRow = 40;
            
        }
    }
    
    return heightRow;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}



#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self resignFirstResponder];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self resignFirstResponder];
}

@end
