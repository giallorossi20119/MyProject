//
//  ProfileDetailViewController.m
//  NooPhuocThinh
//
//  Created by HuntDo on 1/6/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "ProfileDetailViewController.h"

@interface ProfileDetailViewController ()

@end


@implementation ProfileDetailViewController


@synthesize currentIndexSegments, arrSegments, arrUsers;

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
    
    //--custom navigation bar
    [self customNavigationBar];
    
    //-- set background for view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    // custom webview
    [self customWebView:_webviewProfileDetail];
    
    
    _arrWebviews = [NSMutableArray new];
    
    //-- top menu
    [self setTopMenuWithTitles:self.arrUsers];
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    self.screenName = @"Profile Detail Screen";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - webview


-(void)customWebView:(UIWebView*)aWebView{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FontSize"] == nil)
        _currentFontSize = 160;
    else
        _currentFontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"FontSize"];
    
   // aWebView.scrollView.scrollEnabled = NO;
    //-- remove background of webView and disable scroll view of webview
    [aWebView setOpaque:NO];
    [aWebView setBackgroundColor:[UIColor clearColor]];
    for (UIView* subView in [aWebView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            //-- disable scroll view of webview
            // ((UIScrollView *)(subView)).scrollEnabled = NO;
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                    [shadowView setHidden:YES];
            }
        }
    }
    //-- set attribute for webview
    aWebView.delegate=self;
    aWebView.scalesPageToFit = YES;
    aWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);


    //-- clone webview
    _cloneWebViewProfileDetail = [NSKeyedArchiver archivedDataWithRootObject:_webviewProfileDetail];
    
}

-(void) loadHTMLString:(NSString *)body forWebView:(UIWebView *)aWebView
{
    /*
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.open();document.close();"];
   
    NSMutableString *string = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"parternForIphone" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] mutableCopy];
    
    [string replaceOccurrencesOfString:@"**[txtadjust]**" withString:[NSString stringWithFormat:@"%i",_currentFontSize] options:0 range:NSMakeRange(0, string.length)];
    
    NSString *clearReadDocument = [string stringByReplacingOccurrencesOfString:@"**body**" withString:body options:0 range:NSMakeRange(0, string.length)];
    
    [aWebView loadHTMLString:clearReadDocument baseURL:[NSURL URLWithString:@"http://test1.bome.vn/gom_services"]];
    */
    
    
    [aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:body]]];
}

//-- zoom in/out

- (IBAction)fontSizePinch:(id)sender
{
    UIPinchGestureRecognizer *pinch = sender;
    if (pinch.state == UIGestureRecognizerStateRecognized)
    {
        [self changeFontSize:(pinch.scale > 1)?FontSizeChangeTypeIncrease:FontSizeChangeTypeDecrease];
    }
}

- (void)changeFontSize:(FontSizeChangeType)changeType
{
    if (changeType == FontSizeChangeTypeIncrease && _currentFontSize == 160) return;
    if (changeType == FontSizeChangeTypeDecrease && _currentFontSize == 50) return;
    if (changeType != FontSizeChangeTypeNone)
    {
        _currentFontSize = (changeType == FontSizeChangeTypeIncrease) ? _currentFontSize + 5 : _currentFontSize - 5;
        [[NSUserDefaults standardUserDefaults] setInteger:_currentFontSize forKey:@"ftsz"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                          _currentFontSize];
    [_webviewProfileDetail stringByEvaluatingJavaScriptFromString:jsString];
}


-(void)customNavigationBar
{
    [self setTitle:@"Nâng cấp loại user"];
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"imgNavigationBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    // back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(15, 0, 30, 30);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(clickToBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barItemLeft;
}

#pragma mark - Action

- (IBAction)clickToBtnBack:(id)sender
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)clickToUpgradeUser:(id)sender
{
    DLog(@"upgrade user");
    
}

#pragma mark - segments for top menu

- (void) addMultiWebViewsWithTotalPage:(NSInteger)totalPage
{
    //-- change content size scroll
    _scrollViewProfileDetail.contentSize = CGSizeMake(_webviewProfileDetail.frame.size.width*totalPage, _webviewProfileDetail.frame.size.height);
    
    //-- init array contain tableviews
    for (NSInteger i=0; i< totalPage; i++){
        if (i==0)
        {
            [_arrWebviews addObject:_webviewProfileDetail];
        }
        else
        {
            //-- alloc new table view
            /*
            UIWebView *newWebView = [[UIWebView alloc] initWithFrame:_webviewProfileDetail.frame];
             */
            
            UIWebView *newWebView = [NSKeyedUnarchiver unarchiveObjectWithData:_cloneWebViewProfileDetail];
            CGRect newFrame = _webviewProfileDetail.frame;
            newFrame.origin.x = _webviewProfileDetail.frame.size.width*i;
            newWebView.frame = newFrame;
            newWebView.delegate=self;
            newWebView.backgroundColor = [UIColor clearColor];
            // custom webview
         
            [_scrollViewProfileDetail addSubview:newWebView];
            [_arrWebviews addObject:newWebView];
        }
    }
}

-(void) setTopMenuWithTitles:(NSMutableArray *)categories
{
    //-- create pages
    self.arrSegments = [categories valueForKey:@"userTypeName"];
    
    [self addMultiWebViewsWithTotalPage:[categories count]];
    
    //-- Segmented control with scrolling
    _segmentControl = [[HMSegmentedControlOriginal alloc] initWithSectionTitles:self.arrSegments];
    _segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _segmentControl.selectionStyle = HMSegmentedControlOriginalSelectionStyleFullWidthStripe;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlOriginalSelectionIndicatorLocationDown;
    _segmentControl.scrollEnabled = YES;
    _segmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [_segmentControl setFrame:CGRectMake(0, 0 , 320, 45)];
    [_segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [_segmentControl setFont:[UIFont systemFontOfSize:16]];
    _segmentControl.backgroundColor = COLOR_BG_MENU;
    _segmentControl.textColor = [UIColor grayColor];
    _segmentControl.selectedTextColor = [UIColor whiteColor];
    _segmentControl.selectionIndicatorHeight = 5;
    
    [self.view addSubview:_segmentControl];
    
    _segmentControl.selectedSegmentIndex = self.currentIndexSegments;
    
    // show content
    [self changeContentWithPage:self.currentIndexSegments];
}

//-- segment category Selected
- (void)segmentedControlChangedValue:(HMSegmentedControlOriginal *)segmentedControl
{
    if (_segmentControl.selectedSegmentIndex != self.currentIndexSegments)
        
        self.currentIndexSegments = _segmentControl.selectedSegmentIndex;
        [self scrollToIndex:self.currentIndexSegments];
        [self changeContentWithPage:_segmentControl.selectedSegmentIndex];
}

- (void) changeContentWithPage:(NSInteger)page
{
    UIWebView *aWebView = [_arrWebviews  objectAtIndex:page];
    UserType  *userType = [self.arrUsers objectAtIndex:self.currentIndexSegments];
    
    //-- load html
    [self loadHTMLString:userType.userTypeDescription forWebView:aWebView];
}

#pragma mark - scrollview delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollViewProfileDetail)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = floor(fractionalPage);
        
        //NSLog(@"webview %d", self.currentIndexSegments);
        //NSLog(@"at x: %.0f", _scrollViewProfileDetail.contentOffset.x);
        
        if (self.currentIndexSegments != page)
        {
            self.currentIndexSegments = page;
            _segmentControl.selectedSegmentIndex = page;
            [self changeContentWithPage:page];
        }
    }
}

-(void)scrollToIndex:(NSInteger)indexOfPage
{
    [UIView animateWithDuration:0.35 animations:^{
        
        CGRect frame = _scrollViewProfileDetail.frame;
        frame.origin.x = frame.size.width * indexOfPage;
        //frame.origin.y = 0;
        [_scrollViewProfileDetail scrollRectToVisible:frame animated:NO];
        
    }];
}


@end
