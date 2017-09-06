//
//  HomeTableViewController.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/30/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "HomeFeedPageCell.h"
#import "HomeFeedLinkCell.h"
#import "HomeFeedVideoCell.h"
#import "HomeCalendarCell.h"
#import "HomeProductCell.h"
#import "ListFeedData.h"
#import "HomeVideoWebView.h"
#import "VMDataBase.h"
#import "PhotoListFeedData.h"
#import "HomeFeedPhotoCell.h"

@protocol HomeTableViewControllerDelegate<NSObject>

@optional

-(void) goToDetailHomeLinkFeed:(NSMutableArray *)linkData withIndex:(NSString *)linkIndex;
-(void) goToDetailHomePhotoFeed:(NSString *)indexCell withIdPhoto:(long)idPhoto;
-(void) goToDetailHomeStoreFeed:(NSMutableArray *)storeData withIdProduct:(long)idProduct;
-(void) goToDetailHomeEventFeed:(NSMutableArray *)eventData withIdEvent:(long)idEvent;
-(void) goToLike:(int) indexPath withSender:(id)sender;
-(void) goToShare: (int) indexPath withSender:(id)sender;
-(void) goToComment: (int) indexPath withSender:(id)sender;
-(void) reachTop:(BOOL)done;
-(void) reachBottom:(BOOL)done;
-(void) scrolldownBigScroll;
-(void) testthu:(BOOL)done;

@end

@interface HomeTableViewController : UITableViewController<UITableViewDelegate>
{
    id<HomeTableViewControllerDelegate> delegate;
    BOOL check;
    float touchDistance;
    NSString *title4Link;
    NSString *url4Link;
    NSString *image4Link;
    NSString *txtNoView;
    NSString *txtNoLike;
    NSString *txtNoComment;
    NSString *txtNoShare;
    NSInteger arrangeProduct;
    
    NSMutableArray *linkData;
    NSMutableArray *photoData;
    NSDictionary *tempPhotoData;
    NSInteger rowCount;
}

@property (nonatomic, retain) NSMutableArray *listNews;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) id <HomeTableViewControllerDelegate> delegate;

@end


