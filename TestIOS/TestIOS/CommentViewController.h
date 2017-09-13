//
//  CommentViewController.h
//  TestIOS
//
//  Created by Long Nguyen on 9/13/17.
//  Copyright © 2017 longnh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblComment;

@end
