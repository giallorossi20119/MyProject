//
//  TutorialViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/2/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //--custom UI
    [self customNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom UI
- (void) redrawRightNavigartionBar:(bool) isLike totalLike:(int) totalLike
{
    //-- like button
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 20, 30);
    if (isLike)
        [btnRight setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
    else
        [btnRight setImage:[UIImage imageNamed:@"icon_like_photo.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(likeFanpage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    UILabel *numberLikers = [[UILabel alloc] initWithFrame:
                             CGRectMake(0,2,30,30)];
    numberLikers.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (totalLike<0)
        numberLikers.text = @"";
    else
        numberLikers.text = [NSString stringWithFormat:@"%d", totalLike];
    numberLikers.backgroundColor = [UIColor clearColor];
    numberLikers.font = [UIFont boldSystemFontOfSize:14];
    [numberLikers setTextColor:[UIColor whiteColor]];
    numberLikers.textAlignment = UITextAlignmentLeft;
    UIBarButtonItem *numberLikerBtn = [[UIBarButtonItem alloc] initWithCustomView:numberLikers];
    
    //    numberLikers.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *tapGesture =
    //    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendLocalLog)];
    //    [numberLikers addGestureRecognizer:tapGesture];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:numberLikerBtn,barItemRight, nil];
    
}

-(void) customNavigationBar
{
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self setTitle:@"Hướng dẫn"];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.navigationItem.leftBarButtonItem = barItemLeft;
    
    [self redrawRightNavigartionBar:false totalLike:-1];
    
}

#pragma mark - Action

- (void)back:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


@end
