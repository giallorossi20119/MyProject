//
//  BookEditViewController.m
//  TestIOS
//
//  Created by Long Nguyen on 9/13/17.
//  Copyright © 2017 longnh. All rights reserved.
//

#import "BookEditViewController.h"
#import "DBManager.h"

@interface BookEditViewController ()

-(void)loadInfoToEdit;
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation BookEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the navigation bar tint color.
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    
    self.txtBookTitle.delegate = self;
    self.txtBookPage.delegate = self;
    self.txtBookPublisher.delegate = self;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.sqlite"];
    
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveInfo:(id)sender {
    // Prepare the query string.
    NSString *query;
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into bookInfo (bookID, bookTitle, bookPage, bookPublisher) values (null, '%@', '%d', '%@')", self.txtBookTitle.text, [self.txtBookPage.text intValue], self.txtBookPublisher.text];
    }
    else{
        query = [NSString stringWithFormat:@"update bookInfo set (bookTitle,bookPage,bookPublisher) = ('%@', '%d', '%@') where bookID=%d", self.txtBookTitle.text, self.txtBookPage.text.intValue, self.txtBookPublisher.text, self.recordIDToEdit];
    }
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
        [self.delegate editingInfoWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from bookInfo where bookID=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Set the loaded data to the textfields.
    self.txtBookTitle.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"bookTitle"]];
    self.txtBookPublisher.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"bookPublisher"]];
    self.txtBookPage.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"bookPage"]];
}

- (IBAction)viewCommentTapped:(id)sender {
    // Perform the segue.
    [self performSegueWithIdentifier:@"goToViewComment" sender:self];
}

@end
