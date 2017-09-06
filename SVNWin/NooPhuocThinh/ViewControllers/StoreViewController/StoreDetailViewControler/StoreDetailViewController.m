//
//  StoreDetailViewController.m
//  NooPhuocThinh
//
//  Created by HuntDo on 1/6/14.
//  Copyright (c) 2014 MAC_OSX. All rights reserved.
//

#import "StoreDetailViewController.h"

@interface StoreDetailViewController ()

@end

@implementation StoreDetailViewController

@synthesize store, currentIndex, arrStore, autoFullName;

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
    
    // custom webview
    [self customWebView:_webViewStoreDetail];
    
    //-- clone viewMain for many screen
   // _cloneWebViewStoreDetail = [NSKeyedArchiver archivedDataWithRootObject:_viewMain];
    
    _arrWebviews = [NSMutableArray new];
    
    //-- hidden keyboard
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    tapScroll.cancelsTouchesInView = NO;
    [_scrollViewStoreDetail addGestureRecognizer:tapScroll];

    //-- change content size scroll
    _scrollViewStoreDetail.contentSize = CGSizeMake(320*[self.arrStore count], _scrollViewStoreDetail.frame.size.height);
    
    [self setupUI];
}

-(void) setupUI
{
//    [self.btnBack addTarget:self action:@selector(onStoreBackClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeStoreHandle:)];
//    leftRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [leftRecognizer setNumberOfTouchesRequired:1];
//    [self.view addGestureRecognizer:leftRecognizer];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.screenName = @"Store Detail Screen";
    
    [super viewWillAppear:animated];
    
    //-- clone webview
    _cloneWebViewStoreDetail = [NSKeyedArchiver archivedDataWithRootObject:_viewMain];
    
    [self addMultiWebViewsWithTotalPage:[self.arrStore count]];
    
    //-- auto text with title
    Store *aStore = [self.arrStore objectAtIndex:currentIndex];
    [self autoScrollText:aStore.name];
    
    for (NSInteger i = 0; i < [self.arrStore count]; i++)
    {
        [self changeContentWithPage:i];
    }
    
    //-- scrollTo currentIndex
    [self scrollToIndex:currentIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*********************************************************************************//
#pragma mark - webview

-(void)customWebView:(UIWebView*)aWebView{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FontSize"] == nil)
        _currentFontSize = 160;
    else
        _currentFontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"FontSize"];
    
     aWebView.scrollView.scrollEnabled = NO;
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
    
}

-(void) loadHTMLString:(NSString *)body forWebView:(UIWebView *)aWebView
{
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.open();document.close();"];
   
    NSMutableString *string = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"parternStore" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] mutableCopy];
    
    [string replaceOccurrencesOfString:@"**[txtadjust]**" withString:[NSString stringWithFormat:@"%li",(long)_currentFontSize] options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"white" withString:@"black" options:0 range:NSMakeRange(0, string.length)];

    NSString *clearReadDocument = [string stringByReplacingOccurrencesOfString:@"{{ news_body }}" withString:body options:0 range:NSMakeRange(0, string.length)];
    clearReadDocument = [clearReadDocument stringByReplacingOccurrencesOfString:@"{{ news_title }}" withString:@""];
    clearReadDocument = [clearReadDocument stringByReplacingOccurrencesOfString:@"{{ news_date }}" withString:@""];

    [aWebView loadHTMLString:clearReadDocument baseURL:[NSURL URLWithString:HOST_FOR_CONTENT]];
}

//-- zoom in/out

- (IBAction)fontSizePinch:(id)sender
{
    UIWebView *webView = [_arrWebviews objectAtIndex:self.currentIndex];
    
    UIPinchGestureRecognizer *pinch = sender;
    if (pinch.state == UIGestureRecognizerStateRecognized)
    {
        [self changeFontSize:(pinch.scale > 1)?FontSizeChangeTypeIncrease:FontSizeChangeTypeDecrease forWebView:webView];
    }
}

- (void)changeFontSize:(FontSizeChangeType)changeType forWebView:(UIWebView*)aWebView
{
    if (changeType == FontSizeChangeTypeIncrease && _currentFontSize == 160) return;
    if (changeType == FontSizeChangeTypeDecrease && _currentFontSize == 50) return;
    if (changeType != FontSizeChangeTypeNone)
    {
        _currentFontSize = (changeType == FontSizeChangeTypeIncrease) ? _currentFontSize + 5 : _currentFontSize - 5;
        [[NSUserDefaults standardUserDefaults] setInteger:_currentFontSize forKey:@"ftsz"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",
                          (long)_currentFontSize];
    [aWebView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    ViewStoreDetail *view = [_arrWebviews objectAtIndex:aWebView.tag];
    
    if (aWebView == view.webViewStoreDetail) {
        
        CGRect frame = aWebView.frame;
        frame.size.height = 1;
        aWebView.frame = frame;
        CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        aWebView.frame = frame;
        //-- resize scrollView's content size
        view.scrollViewMain.contentSize = CGSizeMake(320, view.webViewStoreDetail.frame.origin.y + frame.size.height + 20);
    }
    
}
 
-(void)customNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                             forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Action

- (IBAction)clickToBtnBack:(id)sender
{
    checkTabValue = 2;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(![touch.view isMemberOfClass:[UITextField class]]) {
        [touch.view endEditing:YES];
    }
}

#pragma mark - segments for top menu

- (void) addMultiWebViewsWithTotalPage:(NSInteger)totalPage
{
    //-- change content size scroll
    _scrollViewStoreDetail.contentSize = CGSizeMake(320*totalPage, _scrollViewStoreDetail.frame.size.height);
    
    //-- init array contain tableviews
    for (NSInteger i=0; i< totalPage; i++){
        if (i==0)
        {
            _viewMain.webViewStoreDetail.tag = i;
            
            [_arrWebviews addObject:_viewMain];
        }
        else
        {
            //-- alloc new table view
            /*
             UIWebView *newWebView = [[UIWebView alloc] initWithFrame:_webviewProfileDetail.frame];
             */
            ViewStoreDetail *newViewMain = [NSKeyedUnarchiver unarchiveObjectWithData:_cloneWebViewStoreDetail];
            CGRect newFrame = _viewMain.frame;
            newFrame.origin.x = _viewMain.frame.size.width*i;
            newViewMain.frame = newFrame;
            newViewMain.backgroundColor = [UIColor clearColor];
            
            newViewMain.webViewStoreDetail.delegate = self;
            newViewMain.webViewStoreDetail.scrollView.scrollEnabled = NO;
            newViewMain.webViewStoreDetail.tag = i;
        
            newViewMain.scrollViewMain.delegate = self;
            
            [_scrollViewStoreDetail addSubview:newViewMain];
            [_arrWebviews addObject:newViewMain];
        }
    }
}

- (void)changeContentWithPage:(NSInteger)page
{
    __weak ViewStoreDetail *view = [_arrWebviews objectAtIndex:page];
    Store *aStore = [self.arrStore objectAtIndex:page];
    
    //-- set value for view
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *value = [numberFormatter stringFromNumber:[NSNumber numberWithInt:[aStore.priceUnit integerValue]]];
    view.lblValue.text = [NSString stringWithFormat:@"%@ VNĐ", value];
    view.lblPhone.text = aStore.phone;
    NSLog(@"Phone = %@",aStore.phone);
    view.lblCodeProduct.text = aStore.code;
    NSLog(@"Code = %@",aStore.code);
    
    //-- back button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame= CGRectMake(10, 20, 50, 50);
    [btnLeft setImage:[UIImage imageNamed:@"btn_arrowback.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(onStoreBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnLeft];
//    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
//    self.navigationItem.leftBarButtonItem=barItemLeft;
    
    //-- load html
    [self loadHTMLString:aStore.body forWebView:view.webViewStoreDetail];
    
    [view.imgViewMain setImageWithURL:[NSURL URLWithString:aStore.thumbnailImagePath] placeholderImage:[UIImage imageNamed:@"StoreDefault.png"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                if (image)
                                    [self replaceViews];
                            }];
}

- (void) replaceViews
{
    ViewStoreDetail *view = [_arrWebviews objectAtIndex:self.currentIndex];
}

- (void)autoScrollText:(NSString*)text
{
    self.autoFullName.text = text;
    [self.autoFullName setFont:[UIFont systemFontOfSize:20]];
    self.autoFullName.textColor = [UIColor blackColor];
    self.autoFullName.labelSpacing = 200; // distance between start and end labels
    self.autoFullName.pauseInterval = 0.3; // seconds of pause before scrolling starts again
    self.autoFullName.scrollSpeed = 30; // pixels per second
    self.autoFullName.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    self.autoFullName.fadeLength = 12.f;
    self.autoFullName.shadowOffset = CGSizeMake(-1, -1);
    self.autoFullName.scrollDirection = CBAutoScrollDirectionLeft;
}

#pragma mark - scrollview delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    if (page > 0 && page != self.currentIndex)
    {
        [self hiddenKeyboard];
        
        self.currentIndex = page;
        
        Store *aStore = [self.arrStore objectAtIndex:page];
        
        //-- auto text with title
        [self autoScrollText:aStore.name];
    }
    
    if (page == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)scrollToIndex:(NSInteger)index
{
    CGRect frame = _scrollViewStoreDetail.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [_scrollViewStoreDetail scrollRectToVisible:frame animated:NO];
}

 
#pragma mark - text field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidChange:(UITextField *)textField
{
    ViewStoreDetail *view = [_arrWebviews objectAtIndex:self.currentIndex];
    Store *aStore = [arrStore objectAtIndex:self.currentIndex];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 10) ? NO : YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ViewStoreDetail *view = [_arrWebviews objectAtIndex:self.currentIndex];
    return YES;
}

#pragma mark - swipe

-(void) hiddenKeyboard
{
    ViewStoreDetail *view = [_arrWebviews objectAtIndex:self.currentIndex];
}

-(void) onStoreBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
