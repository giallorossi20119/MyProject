//
//  webviewPurview.h
//  NooPhuocThinh
//
//  Created by longnh on 2/26/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webviewPurview : UIView
{
    
}

//-- Dieu Khoan
@property (nonatomic, retain) IBOutlet UIView *viewDieuKhoan;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UITextView *txtMessage;
@property (nonatomic, retain) IBOutlet UILabel *lblToiDongY;
@property (nonatomic, retain) IBOutlet UIButton *btnlinkWebview;
@property (nonatomic, retain) IBOutlet UIButton *btnCheckBox;
@property (nonatomic, retain) IBOutlet UIButton *btnDongY;
@property (nonatomic, retain) IBOutlet UIButton *btnHuy;

@end
