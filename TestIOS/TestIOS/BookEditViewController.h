//
//  BookEditViewController.h
//  TestIOS
//
//  Created by Long Nguyen on 9/13/17.
//  Copyright © 2017 longnh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookEditViewControllerDelegate

-(void)editingInfoWasFinished;

@end

@interface BookEditViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic) int recordIDToEdit;

@property (weak, nonatomic) IBOutlet UITextField *txtBookTitle;

@property (weak, nonatomic) IBOutlet UITextField *txtBookPage;

@property (weak, nonatomic) IBOutlet UITextField *txtBookPublisher;

@property (nonatomic, strong) id<BookEditViewControllerDelegate> delegate;

@end
