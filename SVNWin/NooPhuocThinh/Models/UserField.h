//
//  UserField.h
//  NooPhuocThinh
//
//  Created by MAC_OSX on 12/19/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserField : NSObject
/*
 "user_field": {
 "user_id": "7",
 "first_name": null,
 "last_name": null,
 "signature": null,
 "signature_clean": null,
 "designer_style_id": "0",
 "total_comment": "0",
 "total_view": "0",
 "total_friend": "0",
 "total_post": "0",
 "total_profile_song": "0",
 "total_score": "0.00",
 "total_rating": "0",
 "total_user_change": "0",
 "total_full_name_change": "0",
 "country_child_id": "0",
 "city_location": null,
 "postal_code": null,
 "subscribe_id": "0",
 "dob_setting": "0",
 "birthday_range": "2507",
 "rss_count": "0",
 "css_hash": null,
 "newsletter_state": "0",
 "in_admincp": "0",
 "default_currency": null,
 "total_blog": "0",
 "total_video": "0",
 "total_poll": "0",
 "total_quiz": "0",
 "total_event": "0",
 "total_song": "0",
 "total_listing": "0",
 "total_photo": "0",
 "total_pages": "0",
 "brute_force_locked_at": null,
 "relation_data_id": "0",
 "relation_with": "0",
 "cover_photo": "0",
 "cover_photo_top": null,
 "use_timeline": "0",
 "landing_page": null,
 "location_latlng": null
 }
 */

@property (nonatomic, retain) NSString          *userId;
@property (nonatomic, retain) NSString          *firstName;
@property (nonatomic, retain) NSString          *lastName;
@property (nonatomic, retain) NSString          *signature;
@property (nonatomic, retain) NSString          *signatureClean;
@property (nonatomic, retain) NSString          *designerStyleId;
@property (nonatomic, retain) NSString          *totalComment;
@property (nonatomic, retain) NSString          *totalView;
@property (nonatomic, retain) NSString          *totalFriend;
@property (nonatomic, retain) NSString          *totalPost;
@property (nonatomic, retain) NSString          *totalprofileSong;
@property (nonatomic, retain) NSString          *totalScore;
@property (nonatomic, retain) NSString          *totalRating;
@property (nonatomic, retain) NSString          *totalUserChange;
@property (nonatomic, retain) NSString          *totalFullNameChange;
@property (nonatomic, retain) NSString          *countryChildId;
@property (nonatomic, retain) NSString          *cityLocation;
@property (nonatomic, retain) NSString          *postalCode;
@property (nonatomic, retain) NSString          *subcribeId;
@property (nonatomic, retain) NSString          *dobSetting;
@property (nonatomic, retain) NSString          *birthdayRange;
@property (nonatomic, retain) NSString          *rssCount;
@property (nonatomic, retain) NSString          *cssHash;
@property (nonatomic, retain) NSString          *newsLetterState;
@property (nonatomic, retain) NSString          *inAdminCp;
@property (nonatomic, retain) NSString          *defaultCurrency;
@property (nonatomic, retain) NSString          *totalBlog;
@property (nonatomic, retain) NSString          *totalVideo;
@property (nonatomic, retain) NSString          *totalPoll;
@property (nonatomic, retain) NSString          *totalQuiz;
@property (nonatomic, retain) NSString          *totalEvent;
@property (nonatomic, retain) NSString          *totalSong;
@property (nonatomic, retain) NSString          *totalListing;
@property (nonatomic, retain) NSString          *totalPhoto;
@property (nonatomic, retain) NSString          *totalPages;
@property (nonatomic, retain) NSString          *bruteForceLockedAt;
@property (nonatomic, retain) NSString          *relationDataId;
@property (nonatomic, retain) NSString          *relationWith;
@property (nonatomic, retain) NSString          *coverPhoto;
@property (nonatomic, retain) NSString          *coverPhotoTop;
@property (nonatomic, retain) NSString          *userTimeline;
@property (nonatomic, retain) NSString          *landingPage;
@property (nonatomic, retain) NSString          *locationLatLong;
@property (nonatomic, retain) NSMutableArray    *userFieldArray;



@end
