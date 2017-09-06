//
//  InviteFriendViewController.m
//  NooPhuocThinh
//
//  Created by longnh on 4/16/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "EmailSMSModel.h"
#import "CustomCellinviteFriend.h"
#import "VMConstant.h"

@interface InviteFriendViewController ()

@end

@implementation InviteFriendViewController

@synthesize tableContactList;
@synthesize contactArray,listSmsToSend,listSelected;


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
    
    [self setTitle:@"Danh Sách Liên Lạc"];
    
    //-- add barbutton
    [self addBarbutton];
    
    //--set background for TableView
    [self.tableContactList setBackgroundView:nil];
    [self.tableContactList setBackgroundColor:[UIColor clearColor]];
    
    //-- alloc for contactArray
    contactArray = [[NSMutableArray alloc] init];
    listSmsToSend = [[NSMutableArray alloc] init];
    listSelected = [[NSMutableArray alloc] init];
    
    //-- get contact from iphone
    [self getListContact];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    
    self.screenName = @"Invite Friend Screen";
    
    if (contactArray.count > 0)
        [self.tableContactList reloadData];
    
    //-- add slidebar
    [self addSlideBarBaseViewController];
    
    if ([contactArray count] == 0) {
        
        //-- get contact from iphone
        [self getListContact];
    }
}

//-- add bar button
-(void) addBarbutton
{
    //-- back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(0, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(selectedButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- show Send button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(SendSMSContact)];
    rightButton.tintColor = COLOR_HOME_CELL_BOLD;
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

//-- go back sreen
-(IBAction)selectedButtonBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//************************************************************************//
#pragma mark - get list contact

- (void) getListContact
{
    ABAddressBookRef allPeople = ABAddressBookCreate();
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(allPeople);
    CFIndex numberOfContacts  = ABAddressBookGetPersonCount(allPeople);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(allPeople, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted)
    {
        for(int i=0; i <numberOfContacts; i++)
        {
            EmailSMSModel *emailSmsMD = [[EmailSMSModel alloc] init];
            
            ABRecordRef aPerson = CFArrayGetValueAtIndex(allContacts, i);
            ABMultiValueRef fnameProperty = ABRecordCopyValue(aPerson, kABPersonFirstNameProperty);
            ABMultiValueRef lnameProperty = ABRecordCopyValue(aPerson, kABPersonLastNameProperty);
            
            ABMultiValueRef phoneProperty = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);
            ABMultiValueRef emailProperty = ABRecordCopyValue(aPerson, kABPersonEmailProperty);
            
            CFDataRef imageData = ABPersonCopyImageData(aPerson);
            UIImage *imageAvatar = [UIImage imageWithData:(__bridge NSData *)imageData];
            if (!imageAvatar) {
                imageAvatar = [UIImage imageNamed:@"icon_Person.png"];
            }
            
            NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
            NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
            
            //save values in tempContactDic
            if ([emailArray count] > 0 && [phoneArray count] > 0)
            {
                if (fnameProperty != nil)
                {
                    emailSmsMD.firstName = [NSString stringWithFormat:@"%@",fnameProperty];
                    
                    if (lnameProperty != nil)
                    {
                        emailSmsMD.lastName = [NSString stringWithFormat:@"%@",lnameProperty];
                        
                        emailSmsMD.fullName = [NSString stringWithFormat:@"%@ %@",fnameProperty,lnameProperty];
                    }else
                    {
                        emailSmsMD.fullName = emailSmsMD.firstName;
                    }
                    
                    emailSmsMD.fullInfo = [NSString stringWithFormat:@"%@$",emailSmsMD.fullName];
                    
                    if ([emailArray count] > 1)
                    {
                        for (int k = 0; k < [emailArray count]; k++)
                        {
                            if (![[emailArray objectAtIndex:k] isEqualToString:@""] || [[emailArray objectAtIndex:k] length] > 0)
                            {
                                emailSmsMD.fullInfo = [emailSmsMD.fullInfo stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:k]]];
                            }
                        }
                    }else
                    {
                        if (![[emailArray objectAtIndex:0] isEqualToString:@""] || [[emailArray objectAtIndex:0] length] > 0)
                        {
                            emailSmsMD.fullInfo = [emailSmsMD.fullInfo stringByAppendingString:[NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]]];
                        }
                    }
                    
                    emailSmsMD.fullInfo = [NSString stringWithFormat:@"%@$",emailSmsMD.fullInfo];
                    
                    if ([phoneArray count] > 1)
                    {
                        for (int j = 0; j < [phoneArray count]; j++)
                        {
                            if (![[phoneArray objectAtIndex:j] isEqualToString:@""] || [[phoneArray objectAtIndex:j] length] > 0)
                            {
                                emailSmsMD.fullInfo = [emailSmsMD.fullInfo stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:j]]];
                            }
                        }
                    }else
                    {
                        if (![[phoneArray objectAtIndex:0] isEqualToString:@""] || [[phoneArray objectAtIndex:0] length] > 0)
                        {
                            emailSmsMD.fullInfo = [emailSmsMD.fullInfo stringByAppendingString:[NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]]];
                        }
                    }
                    
                    emailSmsMD.imgContactList = imageAvatar;
                    
                    //-- add list contact
                    [contactArray addObject:emailSmsMD];
                }
            }
            else if ([emailArray count] > 0 && [phoneArray count] == 0)
            {
                if (fnameProperty != nil)
                {
                    emailSmsMD.firstName = [NSString stringWithFormat:@"%@",fnameProperty];
                    
                    if (lnameProperty != nil)
                    {
                        emailSmsMD.lastName = [NSString stringWithFormat:@"%@",lnameProperty];
                        
                        emailSmsMD.fullName = [NSString stringWithFormat:@"%@ %@",fnameProperty,lnameProperty];
                    }else
                    {
                        emailSmsMD.fullName = emailSmsMD.firstName;
                    }
                    
                    emailSmsMD.fullInfo = [NSString stringWithFormat:@"%@$",emailSmsMD.fullName];
                    
                    if ([emailArray count] > 1)
                    {
                        for (int k = 0; k < [emailArray count]; k++)
                        {
                            if (![[emailArray objectAtIndex:k] isEqualToString:@""] || [[emailArray objectAtIndex:k] length] > 0)
                            {
                                emailSmsMD.fullInfo = [emailSmsMD.fullInfo stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:k]]];
                            }
                        }
                    }else
                    {
                        if (![[emailArray objectAtIndex:0] isEqualToString:@""] || [[emailArray objectAtIndex:0] length] > 0)
                        {
                            emailSmsMD.fullInfo = [emailSmsMD.fullInfo stringByAppendingString:[NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]]];
                        }
                    }
                    
                    emailSmsMD.fullInfo = [NSString stringWithFormat:@"%@$",emailSmsMD.fullInfo];
                    emailSmsMD.imgContactList = imageAvatar;
                    
                    //-- add list contact
                    [contactArray addObject:emailSmsMD];
                }
            }
            else if([emailArray count] == 0 && [phoneArray count] > 0)
            {
                if (fnameProperty != nil)
                {
                    emailSmsMD.firstName = [NSString stringWithFormat:@"%@",fnameProperty];
                    
                    if (lnameProperty != nil)
                    {
                        emailSmsMD.lastName = [NSString stringWithFormat:@"%@",lnameProperty];
                        
                        emailSmsMD.fullName = [NSString stringWithFormat:@"%@ %@",fnameProperty,lnameProperty];
                    }else
                    {
                        emailSmsMD.fullName = emailSmsMD.firstName;
                    }
                    
                    emailSmsMD.fullInfo = [NSString stringWithFormat:@"%@$$",emailSmsMD.fullName];
                    
                    if ([phoneArray count] > 1)
                    {
                        for (int j = 0; j < [phoneArray count]; j++)
                        {
                            if (![[phoneArray objectAtIndex:j] isEqualToString:@""] || [[phoneArray objectAtIndex:j] length] > 0)
                            {
                                emailSmsMD.fullInfo = [emailSmsMD.fullInfo stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:j]]];
                            }
                        }
                    }else
                    {
                        if (![[phoneArray objectAtIndex:0] isEqualToString:@""] || [[phoneArray objectAtIndex:0] length] > 0)
                        {
                            emailSmsMD.fullInfo = [emailSmsMD.fullInfo stringByAppendingString:[NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]]];
                        }
                    }
                    
                    emailSmsMD.imgContactList = imageAvatar;
                    
                    //-- add list contact
                    [contactArray addObject:emailSmsMD];
                }
            }
        }
        
        if ([contactArray count]>0)
        {
            NSSortDescriptor *sorter = [[NSSortDescriptor alloc]
                                        initWithKey:@"firstName"
                                        ascending:YES
                                        selector:@selector(localizedCaseInsensitiveCompare:)];
            
            [contactArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
            
        }
        
        //-- reload data
        [tableContactList reloadData];
    }
}


//************************************************************************//
#pragma mark - UITableViewDelegate

//-- set height for the row
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellinviteFriend *cell = [self setCustomTableViewCellWithCellForiPhonewithIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //-- set color background for cell
    if ((indexPath.row%2) == 0)
        cell.imgBgCell.backgroundColor = COLOR_HOME_CELL_BOLD;
    else
        cell.imgBgCell.backgroundColor = COLOR_HOME_CELL_REGULAR;
    
    //-- set Accesssory
    if ([listSelected containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"generic_chkbox_yes.png"]];
        cell.accessoryView = checkmark;
        
    } else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (CustomCellinviteFriend *)setCustomTableViewCellWithCellForiPhonewithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellinviteFriend";
    CustomCellinviteFriend *cell = (CustomCellinviteFriend *) [tableContactList dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCellinviteFriend" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (CustomCellinviteFriend *) currentObject;
                break;
            }
        }
    }
    
    [self setDataForTableViewCell:cell withIndexPath:indexPath];
    
    return cell;
}


-(CustomCellinviteFriend *) setDataForTableViewCell:(CustomCellinviteFriend *) cell withIndexPath:(NSIndexPath *)indexPath
{
    if ([contactArray count]>0)
    {
        //---get the user info --//
        EmailSMSModel *emailSmsMD = [contactArray objectAtIndex:[indexPath row]];
        
        //-- extract the relevant state from the states object --//
        NSString *cellValue = [NSString stringWithFormat:@"%@",emailSmsMD.fullName];
        
        //-- setup scrolling label
        cell.lblUserName.text = cellValue;
        cell.lblUserName.textColor = [UIColor whiteColor];
        cell.lblUserName.font = [UIFont systemFontOfSize:16];
        cell.lblUserName.labelSpacing = 200; // distance between start and end labels
        cell.lblUserName.pauseInterval = 0.3; // seconds of pause before scrolling starts again
        cell.lblUserName.scrollSpeed = 30; // pixels per second
        cell.lblUserName.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
        cell.lblUserName.fadeLength = 12.f;
        cell.lblUserName.shadowOffset = CGSizeMake(-1, -1);
        cell.lblUserName.scrollDirection = CBAutoScrollDirectionLeft;
        
        
        if (emailSmsMD.imgContactList)
            cell.imgAvatar.image = emailSmsMD.imgContactList;
    }
    
    return cell;
}


//-- set the number of rows in each section --//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactArray.count;
}


//-- Making a seclection in a table view --//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellinviteFriend *cell = (CustomCellinviteFriend *) [tableContactList cellForRowAtIndexPath:indexPath];
    
    //---get the user info --//
    EmailSMSModel *emailSmsMD = [contactArray objectAtIndex:[indexPath row]];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        
        [listSelected addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
        
        NSString *phoneNumberStr = [Utility getPhoneNumberFromURLString:emailSmsMD.fullInfo];
        [listSmsToSend addObject:phoneNumberStr];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"generic_chkbox_yes.png"]];
        cell.accessoryView = checkmark;
        
    } else {
        
        [listSelected removeObject:[NSString stringWithFormat:@"%d",indexPath.row]];
        
        NSString *phoneNumberStr = [Utility getPhoneNumberFromURLString:emailSmsMD.fullInfo];
        [listSmsToSend removeObject:phoneNumberStr];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
}


//*************************************************************************//
#pragma mark - Send SMS

-(void) SendSMSContact {
    
    if (listSmsToSend.count > 0) {
        
        NSUserDefaults *dataDefault = [NSUserDefaults standardUserDefaults];
        NSString *smsContent = nil;
        
        if ([dataDefault valueForKey:Key_Invite_Message_Default])
            smsContent = [dataDefault valueForKey:Key_Invite_Message_Default];
        else
            smsContent = [NSString stringWithFormat:@"Download app from http://myidol.info"];
        
        [self sendSMS:smsContent recipientList:listSmsToSend];
        
    }else {
        
        [self showMessageWithType:VMTypeMessageOk withMessage:TITLE_SendSMSEmtry withFriendName:nil needDelegate:NO withTag:6];
    }
}

//result send Message
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"%s", __func__);
    [self dismissModalViewControllerAnimated:YES];
}

//-- title & content of SMS
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}


@end
