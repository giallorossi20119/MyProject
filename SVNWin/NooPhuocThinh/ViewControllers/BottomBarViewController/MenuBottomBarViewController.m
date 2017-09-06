//
//  MenuBottomBarViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/9/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "MenuBottomBarViewController.h"

@interface MenuBottomBarViewController ()

@end

static MenuBottomBarViewController *sharedBottomBar = nil;

@implementation MenuBottomBarViewController
@synthesize btnChat,btnHome,btnMedia,btnMusic,btnNews;
@synthesize lblChat,lblHome,lblMedia,lblMusic,lblNews;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

+ (MenuBottomBarViewController *)sharedBottomBarCenter
{
    if (sharedBottomBar == nil) {
        static dispatch_once_t threeToken;
        dispatch_once(&threeToken, ^{
            sharedBottomBar = [[MenuBottomBarViewController alloc] init];
        });
    }
    
    return sharedBottomBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    lblHome.textColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [btnHome addTarget:self action:@selector(showHome) forControlEvents:UIControlEventTouchUpInside];
    [btnChat addTarget:self action:@selector(showChat) forControlEvents:UIControlEventTouchUpInside];
    [btnMedia addTarget:self action:@selector(showMedia) forControlEvents:UIControlEventTouchUpInside];
    [btnMusic addTarget:self action:@selector(showMusic) forControlEvents:UIControlEventTouchUpInside];
    [btnNews addTarget:self action:@selector(showNews) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showHome
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showHome" object:nil];
    screenCode = HOME_SCREEN;
    
    btnHome.selected = YES;
    btnChat.selected = NO;
    btnMedia.selected = NO;
    btnMusic.selected = NO;
    btnNews.selected = NO;
    
    lblHome.textColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    lblChat.textColor = [UIColor darkGrayColor];
    lblMedia.textColor = [UIColor darkGrayColor];
    lblMusic.textColor = [UIColor darkGrayColor];
    lblNews.textColor = [UIColor darkGrayColor];
}

-(void)showChat
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showChat" object:nil];
    screenCode = CHAT_SCREEN;
    
    btnHome.selected = NO;
    btnChat.selected = YES;
    btnMedia.selected = NO;
    btnMusic.selected = NO;
    btnNews.selected = NO;
    
    lblHome.textColor = [UIColor darkGrayColor];
    lblChat.textColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    lblMedia.textColor = [UIColor darkGrayColor];
    lblMusic.textColor = [UIColor darkGrayColor];
    lblNews.textColor = [UIColor darkGrayColor];
}

-(void)showMedia
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMedia" object:nil];
    screenCode = MEDIA_SCREEN;
    
    btnHome.selected = NO;
    btnChat.selected = NO;
    btnMedia.selected = YES;
    btnMusic.selected = NO;
    btnNews.selected = NO;
    
    lblHome.textColor = [UIColor darkGrayColor];
    lblChat.textColor = [UIColor darkGrayColor];
    lblMedia.textColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    lblMusic.textColor = [UIColor darkGrayColor];
    lblNews.textColor = [UIColor darkGrayColor];
}

-(void)showMusic
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMusic" object:nil];
    screenCode = MUSIC_SCREEN;
    
    btnHome.selected = NO;
    btnChat.selected = NO;
    btnMedia.selected = NO;
    btnMusic.selected = YES;
    btnNews.selected = NO;
    
    lblHome.textColor = [UIColor darkGrayColor];
    lblChat.textColor = [UIColor darkGrayColor];
    lblMedia.textColor = [UIColor darkGrayColor];
    lblMusic.textColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    lblNews.textColor = [UIColor darkGrayColor];
}

-(void)showNews
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showNews" object:nil];
    screenCode = NEWS_SCREEN;
    
    btnHome.selected = NO;
    btnChat.selected = NO;
    btnMedia.selected = NO;
    btnMusic.selected = NO;
    btnNews.selected = YES;
    
    lblHome.textColor = [UIColor darkGrayColor];
    lblChat.textColor = [UIColor darkGrayColor];
    lblMedia.textColor = [UIColor darkGrayColor];
    lblMusic.textColor = [UIColor darkGrayColor];
    lblNews.textColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
}

@end
