//
//  ViewController.h
//  TestIOS
//
//  Created by Long Nguyen on 9/13/17.
//  Copyright © 2017 longnh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookEditViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, BookEditViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblBook;

- (IBAction)addNewRecord:(id)sender;

@end
