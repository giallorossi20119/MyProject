//
//  ViewController.m
//  TestIOS
//
//  Created by Long Nguyen on 9/13/17.
//  Copyright © 2017 longnh. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrBookInfo;

@property (nonatomic) int recordIDToEdit;

-(void)loadData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.sqlite"];
    
    self.tblBook.delegate = self;
    self.tblBook.dataSource = self;
    
    // Load the data.
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewRecord:(id)sender {
    self.recordIDToEdit = -1;
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"goToBookEdit" sender:self];
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from bookInfo";
    
    // Get the results.
    if (self.arrBookInfo != nil) {
        self.arrBookInfo = nil;
    }
    self.arrBookInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblBook reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrBookInfo.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
    
    NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"bookTitle"];
    NSInteger indexOfPage = [self.dbManager.arrColumnNames indexOfObject:@"bookPage"];
    NSInteger indexOfPublisher = [self.dbManager.arrColumnNames indexOfObject:@"bookPublisher"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[self.arrBookInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfTitle], [[self.arrBookInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPublisher]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Page: %@", [[self.arrBookInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPage]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property.
    self.recordIDToEdit = [[[self.arrBookInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"goToBookEdit" sender:self];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrBookInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from bookInfo where bookID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
}

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    BookEditViewController *editInfoViewController = [segue destinationViewController];
    editInfoViewController.delegate = self;
    editInfoViewController.recordIDToEdit = self.recordIDToEdit;
}

@end
