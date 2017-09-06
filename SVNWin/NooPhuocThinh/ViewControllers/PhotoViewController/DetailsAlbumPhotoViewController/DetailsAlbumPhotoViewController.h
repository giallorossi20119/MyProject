//
//  DetailsAlbumPhotoViewController.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/26/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPRadialProgressView.h"
#import "UIImageView+WebCache.h"
#import "ListPhotosInAlbum.h"
#import "ListAlbumPhoto.h"
#import "Comment.h"
#import "CommentsNewsViewController.h"
#import "VMDataBase.h"

@interface DetailsAlbumPhotoViewController : BaseViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, BaseViewControllerDelegate,CommentsNewsViewControllerDelegate>
{
    IBOutlet UIView                 *_viewHeader;
    IBOutlet UIButton               *btnPlaySlide;
    IBOutlet UIButton               *btnDownload;
    IBOutlet UIButton               *btnComment;
    IBOutlet UIButton               *btnShare;
    IBOutlet UIButton               *btnLikePhoto;
    IBOutlet UILabel                *lblNumberComment;
    IBOutlet UILabel                *lblNumberLike;
    
    NSInteger                       _currentIndex;
    NSTimer                         *_timerAuto;
    BOOL                            _isPlaying;
    BOOL                            _isLike;
    BOOL                            _isCreateComment;
    
    UIScrollView                    *_scrollZoom;
    UIImageView                     *newPageView;
}

@property (nonatomic, assign) IBOutlet UIScrollView *scrollPhotoAlbum;
@property (nonatomic, assign) NSInteger             indexOfPhoto;
@property (nonatomic, retain) NSMutableArray        *arrayPhoto;
@property (nonatomic, retain) NSString              *idPhoto;
@property (nonatomic, retain) NSString              *albumTitle;
@property (nonatomic, assign) NSInteger             number_of_images;
@property (nonatomic, retain) JPRadialProgressView  *radialProgress;
@property (nonatomic, retain) Comment               *superComment;
@property (nonatomic,strong) NSMutableDictionary    *dictionaryLike;

@property (nonatomic, weak)  IBOutlet CBAutoScrollLabel         *autoFullName;

//--Action
- (IBAction)clickToBtnPlay:(id)sender;
- (IBAction)clickToBtnDownload:(id)sender;
- (IBAction)clickToBtnComment:(id)sender;
- (IBAction)clickToBtnShare:(id)sender;
- (IBAction)clickToBtnLikePhoto:(id)sender;


@end
