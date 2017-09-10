//
//  HomeTableViewController.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/30/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

@synthesize listNews;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor redColor]];
    [self.tableView setSeparatorColor:COLOR_SEPARATOR_CELL];
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (_currentPage  == 2)
    {
        if ([listNews count] % 2 != 0)
        {
            rowCount = [listNews count]/2 + 1;
            NSLog(@"row count = %ld",(long)rowCount);
        }
        else
        {
            rowCount = [listNews count]/2;
            NSLog(@"row count = %ld",(long)rowCount);
        }
    }
    else
    {
        rowCount = [listNews count];
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if (_currentPage == 0)
    {
        if (([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedType  isEqual: @"pages_comment"]))
        {
            NSLog(@"co 2");
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedPageCellId"];
            if (cell == nil)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HomeFeedPageCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            HomeFeedPageCell *tb=(HomeFeedPageCell*)cell;
            tb.Username.text = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedUserName;
            tb.Description.text = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedTitle;
            
            tb.TimePost.text = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedTimeStamp integerValue]]];
            
            NSNumber *comment = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalComment integerValue]];
            tb.NoComment.text = [NSString stringWithFormat:@"%ld Comments",(long)[comment integerValue]];
            
            NSNumber *like = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalLike integerValue]];
            tb.NoLike.text = [NSString stringWithFormat:@"%ld Likes",(long)[like integerValue]];
            
            NSNumber *view = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalView integerValue]];
            tb.NoView.text = [NSString stringWithFormat:@"%ld Views",(long)[view integerValue]];
            
            NSNumber *share = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalShare integerValue]];
            tb.NoShare.text = [NSString stringWithFormat:@"%ld Shares",(long)[share integerValue]];
            
            [tb.UserImage setImageWithURL:[NSURL URLWithString:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedUserImage]
                         placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
            //set circle image
            tb.UserImage.layer.cornerRadius = tb.UserImage.frame.size.width / 2;
            tb.UserImage.clipsToBounds = YES;
            
            //button event
            [tb.btnLike addTarget:self action:@selector(showLikes:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).isLiked isEqual:@"1"])
            {
                [tb.btnLike setSelected:YES];
            }
            
            [tb.btnComment addTarget:self action:@selector(showComments:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnComment setBackgroundImage:[UIImage imageNamed:@"comment_active.png"] forState:UIControlStateHighlighted];
            [tb.btnShare addTarget:self action:@selector(showShares:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnShare setBackgroundImage:[UIImage imageNamed:@"share_active.png"] forState:UIControlStateHighlighted];
            
            [tb.UserImage setContentMode:UIViewContentModeScaleAspectFill];
            [tb.UserImage setClipsToBounds:YES];
            [Utility scaleImage:tb.UserImage.image toSize:CGSizeMake(30, 30)];
        }
        else if (([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedType  isEqual: @"link"]))
        {
            NSLog(@"co 3");
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedLinkCellId"];
            if (cell == nil)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HomeFeedLinkCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            HomeFeedLinkCell *tb=(HomeFeedLinkCell*)cell;
            tb.FeedTitleDetail.text = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedTitle;
            tb.Username.text = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedUserName;
            tb.Description.text = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedDescription;
            
            title4Link = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedTitle;
            url4Link = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedLink;
            tb.TimePost.text = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedTimeStamp integerValue]]];
            
            NSNumber *comment = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalComment integerValue]];
            tb.NoComment.text = [NSString stringWithFormat:@"%ld Comments",(long)[comment integerValue]];
            txtNoComment = tb.NoComment.text;
            
            NSNumber *like = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalLike integerValue]];
            tb.NoLike.text = [NSString stringWithFormat:@"%ld Likes",(long)[like integerValue]];
            txtNoLike = tb.NoLike.text;
            
            NSNumber *view = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalView integerValue]];
            tb.NoView.text = [NSString stringWithFormat:@"%ld Views",(long)[view integerValue]];
            txtNoView = tb.NoView.text;
            
            NSNumber *share = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalShare integerValue]];
            tb.NoShare.text = [NSString stringWithFormat:@"%ld Shares",(long)[share integerValue]];
            txtNoShare = tb.NoShare.text;
            
            [tb.UserImage setImageWithURL:[NSURL URLWithString:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedUserImage]
                         placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
            tb.UserImage.layer.cornerRadius = tb.UserImage.frame.size.width / 2;
            tb.UserImage.clipsToBounds = YES;
            
            //button event
            [tb.btnLike addTarget:self action:@selector(showLikes:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnLike setBackgroundImage:[UIImage imageNamed:@"like_active.png"] forState:UIControlStateHighlighted];
            
            if ([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).isLiked isEqual:@"1"])
            {
                [tb.btnLike setBackgroundImage:[UIImage imageNamed:@"like_active.png"] forState:UIControlStateNormal];
            }
            
            [tb.btnComment addTarget:self action:@selector(showComments:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnComment setBackgroundImage:[UIImage imageNamed:@"comment_active.png"] forState:UIControlStateHighlighted];
            [tb.btnShare addTarget:self action:@selector(showShares:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnShare setBackgroundImage:[UIImage imageNamed:@"share_active.png"] forState:UIControlStateHighlighted];
            
            [tb.UserImage setContentMode:UIViewContentModeScaleAspectFill];
            [tb.UserImage setClipsToBounds:YES];
            [Utility scaleImage:tb.UserImage.image toSize:CGSizeMake(30, 30)];
            
            [tb.FeedImage setImageWithURL:[NSURL URLWithString:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedImage]
                         placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
            
            [tb.FeedImage setContentMode:UIViewContentModeScaleAspectFill];
            [tb.FeedImage setClipsToBounds:YES];
            image4Link = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedImage;
            
            linkData = [[NSMutableArray alloc]init];
            NSString *indexP = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            
            NSArray *arrLinkData = [[NSArray alloc]initWithObjects:title4Link,image4Link,url4Link,txtNoComment,txtNoLike,txtNoShare,txtNoView,indexP,nil];
            [linkData addObjectsFromArray:arrLinkData];
            
            [tb.btnImage addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnTitle addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnDescription addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedType  isEqual: @"video"]))
        {
            NSLog(@"co 4");
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedVideoCellId"];
            if (cell == nil)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HomeFeedVideoCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            HomeFeedVideoCell *tb=(HomeFeedVideoCell*)cell;
            tb.Username.text = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedUserName;
            tb.Description.text = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedTitle;
            
            tb.TimePost.text = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedTimeStamp integerValue]]];
            
            NSNumber *comment = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalComment integerValue]];
            tb.NoComment.text = [NSString stringWithFormat:@"%ld Comments",(long)[comment integerValue]];
            
            NSNumber *like = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalLike integerValue]];
            tb.NoLike.text = [NSString stringWithFormat:@"%ld Likes",(long)[like integerValue]];
            
            NSNumber *view = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalView integerValue]];
            tb.NoView.text = [NSString stringWithFormat:@"%ld Views",(long)[view integerValue]];
            
            NSNumber *share = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalShare integerValue]];
            tb.NoShare.text = [NSString stringWithFormat:@"%ld Shares",(long)[share integerValue]];
            
            //youtube url
            HomeVideoWebView *wvVideo = [[HomeVideoWebView alloc]initWithStringAsURL:@"https://www.youtube.com/watch?v=EUauCrwuO4I" frame:CGRectMake(0, 0, 300, 210)];
            [tb.wvImage addSubview:wvVideo];
            tb.wvImage.userInteractionEnabled = YES;
            
            [tb.UserImage setImageWithURL:[NSURL URLWithString:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedUserImage]
                         placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
            tb.UserImage.layer.cornerRadius = tb.UserImage.frame.size.width / 2;
            tb.UserImage.clipsToBounds = YES;
            
            //button event
            [tb.btnLike addTarget:self action:@selector(showLikes:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnLike setBackgroundImage:[UIImage imageNamed:@"like_active.png"] forState:UIControlStateSelected];
            
            if ([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).isLiked isEqual:@"1"])
            {
                [tb.btnLike setBackgroundImage:[UIImage imageNamed:@"like_active.png"] forState:UIControlStateNormal];
            }
            
            [tb.btnComment addTarget:self action:@selector(showComments:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnComment setBackgroundImage:[UIImage imageNamed:@"comment_active.png"] forState:UIControlStateHighlighted];
            [tb.btnShare addTarget:self action:@selector(showShares:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnShare setBackgroundImage:[UIImage imageNamed:@"share_active.png"] forState:UIControlStateHighlighted];
        }
        else if (([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedType  isEqual: @"photo"]))
        {
            NSString *tempStringCellId = [NSString stringWithFormat:@"HomeFeedPhoto%luCellId",(unsigned long)((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto];
            NSString *tempStringCell = [NSString stringWithFormat:@"HomeFeedPhoto%luCell",(unsigned long)((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto];
            
            if (((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto > 0 && ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto <= 5)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:tempStringCellId];
                if (cell == nil)
                {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:tempStringCell owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
            }
            else if(((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto > 5)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedPhoto5CellId"];
                if (cell == nil)
                {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HomeFeedPhoto5Cell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
            }
            else
            {}
            
            NSLog(@"index path %ld",(long)indexPath.row);
            HomeFeedPhotoCell *tb=(HomeFeedPhotoCell*)cell;
            tb.Username.text = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedUserName;
            tb.Description.text = ((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedTitle;
            
            tb.TimePost.text = [Utility relativeTimeFromDate:[Utility dateFromUnixStamp:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedTimeStamp integerValue]]];
            
            NSNumber *comment = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalComment integerValue]];
            tb.NoComment.text = [NSString stringWithFormat:@"%ld Comments",(long)[comment integerValue]];
            
            NSNumber *like = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalLike integerValue]];
            tb.NoLike.text = [NSString stringWithFormat:@"%ld Likes",(long)[like integerValue]];
            
            NSNumber *view = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalView integerValue]];
            tb.NoView.text = [NSString stringWithFormat:@"%ld Views",(long)[view integerValue]];
            
            NSNumber *share = [NSNumber numberWithInteger:[((ListFeedData*)[listNews objectAtIndex:indexPath.row]).snsTotalShare integerValue]];
            tb.NoShare.text = [NSString stringWithFormat:@"%ld Shares",(long)[share integerValue]];
            
            [tb.UserImage setImageWithURL:[NSURL URLWithString:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedUserImage]
                         placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
            tb.UserImage.layer.cornerRadius = tb.UserImage.frame.size.width / 2;
            tb.UserImage.clipsToBounds = YES;
            
            //button event
            [tb.btnLike addTarget:self action:@selector(showLikes:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnLike setBackgroundImage:[UIImage imageNamed:@"like_active.png"] forState:UIControlStateHighlighted];
            
            if ([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).isLiked isEqual:@"1"])
            {
                [tb.btnLike setBackgroundImage:[UIImage imageNamed:@"like_active.png"] forState:UIControlStateNormal];
            }
            
            [tb.btnComment addTarget:self action:@selector(showComments:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnComment setBackgroundImage:[UIImage imageNamed:@"comment_active.png"] forState:UIControlStateHighlighted];
            tb.btnComment.enabled = NO;
            [tb.btnShare addTarget:self action:@selector(showShares:) forControlEvents:UIControlEventTouchUpInside];
            [tb.btnShare setBackgroundImage:[UIImage imageNamed:@"share_active.png"] forState:UIControlStateHighlighted];
            
            [tb.UserImage setContentMode:UIViewContentModeScaleAspectFill];
            [tb.UserImage setClipsToBounds:YES];
            [Utility scaleImage:tb.UserImage.image toSize:CGSizeMake(30, 30)];
            
            //load photo feed data
            photoData = [[NSMutableArray alloc]init];
            NSLog(@"album id la %@",((ListFeedData*)[listNews objectAtIndex:indexPath.row]).albumId);
            
            if (((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto == 1)
            {
                NSLog(@"6");
                photoData = [VMDataBase getAllPhotoFeeds:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).albumId];
                NSLog(@"index path %ld",(long)indexPath.row);
                NSString *indexP = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                if ([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).albumId isEqual:@"0"])
                {
                    for (NSInteger i = 0; i < photoData.count; i++)
                    {
                        if ([((PhotoListFeedData*)[photoData objectAtIndex:i]).indexcell isEqual:indexP])
                        {
                            [tb.FeedImage1 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:i]).imagePath]
                                          placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                            
                            [tb.FeedImage1 setContentMode:UIViewContentModeScaleAspectFill];
                            [tb.FeedImage1 setClipsToBounds:YES];
                            
                            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                            [singleTap setNumberOfTapsRequired:1];
                            [tb.FeedImage1 addGestureRecognizer:singleTap];
                            tb.FeedImage1.userInteractionEnabled = YES;
                        }
                    }
                }
            }
            else if (((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto == 2)
            {
                photoData = [VMDataBase getAllPhotoFeeds:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).albumId];
                
                NSInteger j = 0;
                
                [tb.FeedImage21 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage21 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage21 setClipsToBounds:YES];
                
                [tb.FeedImage22 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+1]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage22 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage22 setClipsToBounds:YES];
                
                UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap1 setNumberOfTapsRequired:1];
                
                [tb.FeedImage21 addGestureRecognizer:singleTap];
                tb.FeedImage21.tag = j;
                tb.FeedImage21.userInteractionEnabled = YES;
                
                [tb.FeedImage22 addGestureRecognizer:singleTap1];
                tb.FeedImage22.tag = j+1;
                tb.FeedImage22.userInteractionEnabled = YES;
                
            }
            else if (((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto == 3)
            {
                photoData = [VMDataBase getAllPhotoFeeds:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).albumId];
                
                NSInteger j = 0;
                
                [tb.FeedImage31 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage31 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage31 setClipsToBounds:YES];
                
                [tb.FeedImage32 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+1]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage32 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage32 setClipsToBounds:YES];
                
                [tb.FeedImage33 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+2]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage33 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage33 setClipsToBounds:YES];
                
                UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap1 setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap2 setNumberOfTapsRequired:1];
                
                [tb.FeedImage31 addGestureRecognizer:singleTap];
                tb.FeedImage31.tag = j;
                tb.FeedImage31.userInteractionEnabled = YES;
                
                [tb.FeedImage32 addGestureRecognizer:singleTap1];
                tb.FeedImage32.tag = j+1;
                tb.FeedImage32.userInteractionEnabled = YES;
                
                [tb.FeedImage33 addGestureRecognizer:singleTap2];
                tb.FeedImage33.tag = j+2;
                tb.FeedImage33.userInteractionEnabled = YES;
            }
            else if (((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto == 4)
            {
                photoData = [VMDataBase getAllPhotoFeeds:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).albumId];
                
                NSInteger j = 0;
                
                [tb.FeedImage41 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage41 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage41 setClipsToBounds:YES];
                
                [tb.FeedImage42 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+1]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage42 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage42 setClipsToBounds:YES];
                
                [tb.FeedImage43 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+2]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage43 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage43 setClipsToBounds:YES];
                
                [tb.FeedImage44 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+3]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage44 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage44 setClipsToBounds:YES];
                
                UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap1 setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap2 setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap3 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap3 setNumberOfTapsRequired:1];
                
                [tb.FeedImage41 addGestureRecognizer:singleTap];
                tb.FeedImage41.tag = j;
                tb.FeedImage41.userInteractionEnabled = YES;
                
                [tb.FeedImage42 addGestureRecognizer:singleTap1];
                tb.FeedImage42.tag = j+1;
                tb.FeedImage42.userInteractionEnabled = YES;
                
                [tb.FeedImage43 addGestureRecognizer:singleTap2];
                tb.FeedImage43.tag = j+2;
                tb.FeedImage43.userInteractionEnabled = YES;
                
                [tb.FeedImage44 addGestureRecognizer:singleTap3];
                tb.FeedImage44.tag = j+3;
                tb.FeedImage44.userInteractionEnabled = YES;
            }
            else if (((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto >= 5)
            {
                photoData = [VMDataBase getAllPhotoFeeds:((ListFeedData*)[listNews objectAtIndex:indexPath.row]).albumId];
                
                NSInteger j = 0;
                
                [tb.FeedImage51 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage51 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage51 setClipsToBounds:YES];
                
                [tb.FeedImage52 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+1]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage52 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage52 setClipsToBounds:YES];
                
                [tb.FeedImage53 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+2]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage53 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage53 setClipsToBounds:YES];
                
                [tb.FeedImage54 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+3]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage54 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage54 setClipsToBounds:YES];
                
                [tb.FeedImage55 setImageWithURL:[NSURL URLWithString:((PhotoListFeedData*)[photoData objectAtIndex:j+4]).imagePath]
                               placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
                
                [tb.FeedImage55 setContentMode:UIViewContentModeScaleAspectFill];
                [tb.FeedImage55 setClipsToBounds:YES];
                
                UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap3 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap setNumberOfTapsRequired:1];
                
                UITapGestureRecognizer *singleTap4 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTappingPhotoFeed:)];
                [singleTap setNumberOfTapsRequired:1];
                
                [tb.FeedImage51 addGestureRecognizer:singleTap];
                tb.FeedImage51.tag = j;
                tb.FeedImage51.userInteractionEnabled = YES;
                
                [tb.FeedImage52 addGestureRecognizer:singleTap1];
                tb.FeedImage52.tag = j+1;
                tb.FeedImage52.userInteractionEnabled = YES;
                
                [tb.FeedImage53 addGestureRecognizer:singleTap2];
                tb.FeedImage53.tag = j+2;
                tb.FeedImage53.userInteractionEnabled = YES;
                
                [tb.FeedImage54 addGestureRecognizer:singleTap3];
                tb.FeedImage54.tag = j+3;
                tb.FeedImage54.userInteractionEnabled = YES;
                
                [tb.FeedImage55 addGestureRecognizer:singleTap4];
                tb.FeedImage55.tag = j+4;
                tb.FeedImage55.userInteractionEnabled = YES;
                
                if (((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto > 5)
                {
                    tb.MorePhoto.hidden = NO;
                    tb.MorePhoto.text = [NSString stringWithFormat:@"+%lu",(unsigned long)((ListFeedData*)[listNews objectAtIndex:indexPath.row]).NoPhoto-5];
                }
                else
                {
                    tb.MorePhoto.hidden = YES;
                }
            }
        }
        //set border for cell
        UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3,cell.frame.size.width,4)];
        additionalSeparator.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
        [cell addSubview:additionalSeparator];
    }
    else if (_currentPage == 1)
    {
        NSLog(@"co 8");
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCalendarCellId"];
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HomeCalendarCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        HomeCalendarCell *tb=(HomeCalendarCell*)cell;
        
        [tb.imvCalendar setImageWithURL:[NSURL URLWithString:((Schedule*)[listNews objectAtIndex:indexPath.row]).imageFilePath]
                       placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
        
        tb.lblTitle.text = ((Schedule*)[listNews objectAtIndex:indexPath.row]).name;
        tb.lblLocation.text = ((Schedule*)[listNews objectAtIndex:indexPath.row]).locationEventAddress;
        
        NSArray* foo = [((Schedule*)[listNews objectAtIndex:indexPath.row]).startDate componentsSeparatedByString: @" "];
        NSString* firstBit = [foo objectAtIndex: 0];
        NSString* secondBit = [foo objectAtIndex: 1];
        
        tb.lblDatetime.text = [NSString stringWithFormat:@"%@ %@",secondBit,firstBit];
        
        UITapGestureRecognizer *singleTap1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventClicked:)];
        [singleTap1 setNumberOfTapsRequired:1];
        
        tb.imvCalendar.userInteractionEnabled = YES;
        [tb.imvCalendar addGestureRecognizer:singleTap1];
        
        UITapGestureRecognizer *singleTap2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventClicked:)];
        [singleTap2 setNumberOfTapsRequired:1];
        
        tb.lblTitle.userInteractionEnabled = YES;
        [tb.lblTitle addGestureRecognizer:singleTap2];
        
        //set border for cell
        UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height,cell.frame.size.width,1)];
        additionalSeparator.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
        [cell addSubview:additionalSeparator];
    }
    else if (_currentPage == 2)
    {
        NSLog(@"co 9");
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomeProductCellId"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HomeProductCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        NSInteger index = indexPath.row * 2;
        NSLog(@"index path %ld",(long)indexPath.row);
        NSLog(@"index %ld",(long)index);
        
        HomeProductCell *tb=(HomeProductCell*)cell;
        
        if (index < listNews.count)
        {
            [tb.imvProduct1 setImageWithURL:[NSURL URLWithString:((Store*)[listNews objectAtIndex:index]).thumbnailImagePath]
                           placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];
            
            UITapGestureRecognizer *sender1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productClicked:)];
            
            tb.imvProduct1.userInteractionEnabled = YES;
            [tb.imvProduct1 addGestureRecognizer:sender1];
            tb.imvProduct1.tag = index;
            
            tb.lblTitle1.text = ((Store*)[listNews objectAtIndex:index]).name;
            //decimal for price unit
            NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSString *value1 = [numberFormatter stringFromNumber:[NSNumber numberWithLong:[((Store*)[listNews objectAtIndex:index]).priceUnit integerValue]]];
            tb.lblPrice1.text = [NSString stringWithFormat:@"%@ VNĐ", value1];
            tb.lblPrice1.textColor = [UIColor redColor];
            
            [tb.imvProduct2 setImageWithURL:[NSURL URLWithString:((Store*)[listNews objectAtIndex:index+1]).thumbnailImagePath]placeholderImage:[UIImage imageNamed:@"NewDefault.png"]];;
            
            UITapGestureRecognizer *sender2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productClicked:)];
            tb.imvProduct2.userInteractionEnabled = YES;
            [tb.imvProduct2 addGestureRecognizer:sender2];
            tb.imvProduct2.tag = index+1;
            
            tb.lblTitle2.text = ((Store*)[listNews objectAtIndex:index+1]).name;
            
            NSString *value2 = [numberFormatter stringFromNumber:[NSNumber numberWithLong:[((Store*)[listNews objectAtIndex:index+1]).priceUnit integerValue]]];
            tb.lblPrice2.text = [NSString stringWithFormat:@"%@ VNĐ", value2];
            tb.lblPrice2.textColor = [UIColor redColor];
            
            //set custom separator for cell
            UIView * additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-1,cell.frame.size.width,1)];
            additionalSeparator.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
            [cell addSubview:additionalSeparator];
        }
        else if (index >= listNews.count)
        {
            NSLog(@"no more product");
        }
    }
    NSLog(@"co 10");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"dau ma");
    if (cell == nil) {
        return [[UITableViewCell alloc] init];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowheight=0;
    if (_currentPage == 0)
    {
        if (([((ListFeedData*)[listNews objectAtIndex:indexPath.row]).feedType  isEqual: @"pages_comment"]))
        {
            rowheight = 200;
        }
        else
        {
            rowheight = 400;
        }
    }
    else if (_currentPage == 1)
    {
        rowheight = 140;
    }
    else if (_currentPage == 2)
    {
        rowheight = 200;
    }
    
    return rowheight;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dech");
}

//-- open home link feed
-(void)openLink:(id)sender
{
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    NSString *strInt = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    //-- pass Delegate
    [[self delegate] goToDetailHomeLinkFeed:listNews withIndex:strInt];
}

//-- open photo link feed
- (void)singleTappingPhotoFeed:(UIGestureRecognizer *)sender
{
    //-- get index of photo
    NSInteger indexOfPhoto = [sender view].tag;
    NSLog(@"%s index:%ld", __func__,(long)indexOfPhoto);
    
    //-- get index cell
    UIView *parentCell = sender.view.superview;
    
    while (![parentCell isKindOfClass:[UITableViewCell class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentCell = parentCell.superview;
    }
    
    UIView *parentView = parentCell.superview;
    
    while (![parentView isKindOfClass:[UITableView class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentView = parentView.superview;
    }
    
    
    UITableView *tableView = (UITableView *)parentView;
    NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)parentCell];
    
    NSLog(@"indexPath = %ld", (long)indexPath.row);
    NSString *indexCell = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [[self delegate] goToDetailHomePhotoFeed:indexCell withIdPhoto:indexOfPhoto];
}

//-- product click
-(void)productClicked:(UITapGestureRecognizer*)sender
{
    NSInteger indexOfProduct = [sender view].tag;
    NSLog(@"%s index:%ld", __func__,(long)indexOfProduct);
    [[self delegate] goToDetailHomeStoreFeed:listNews withIdProduct:indexOfProduct];
}

//-- event click
-(void)eventClicked:(UITapGestureRecognizer*)sender
{
    NSInteger indexOfEvent = [sender view].tag;
    NSLog(@"%s index:%ld", __func__,(long)indexOfEvent);
    [[self delegate] goToDetailHomeEventFeed:listNews withIdEvent:indexOfEvent];
}

-(void) showLikes:(id)sender
{
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    [[self delegate] goToLike:(int)indexPath.row withSender:sender];
}

-(void) showComments:(id)sender
{
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    [[self delegate] goToComment:(int)indexPath.row withSender:sender];
}

-(void) showShares:(id)sender
{
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    [[self delegate] goToShare:(int)indexPath.row withSender:sender];
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
    return [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        NSLog(@"van dag scroll bag scrollview table");
        if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height))
        {
            NSLog(@"scrollview offset y %f",scrollView.contentOffset.y);
            NSLog(@"scrollview distance y %f",scrollView.contentSize.height - scrollView.frame.size.height);
            NSLog(@"BOTTOM REACHED");
            [[self delegate] reachBottom:YES];
        }
        else if(scrollView.contentOffset.y <= 0.0)
        {
            NSLog(@"TOP REACHED");
            [[self delegate] reachTop:YES];
            
            //call bigScroll to auto scroll down
            [[self delegate] scrolldownBigScroll];
        }
    }
}

@end
