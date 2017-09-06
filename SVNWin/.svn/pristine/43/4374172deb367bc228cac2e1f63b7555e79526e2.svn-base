//
//  Utility.h
//  AGKGlobal
//
//  Created by Thuy Dao on 7/4/13.
//  Copyright (c) 2013 fountaindew. All rights reserved.
//



#import <Foundation/Foundation.h>

// key
#define facebookID                      @"facebookID"
#define facebookName                    @"facebookName"
#define facebookUrl                     @"facebookUrl"

#define CREATE_ACCOUNT_SUCCESS          @"CREAT_ACCOUNT_SUCCESS"

//-- Hoa : add check versions for iOS
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define isIphone5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

//-- Hoa : add set color
#define COLOR(r,g,b,alpha) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:alpha]

typedef enum {
    kPlatformIpad = 0,
    kPlatformIpadRetina = 3,
    kPlatformNormallyiPhone = 1,
    kPlatformNormallyiPhone5 = 2,
    kPlatformN_A = -1,
} kTypePlatform;

@interface Utility : NSObject

+ (NSMutableDictionary*) shareProfileDict;

+ (void)saveProfileDict;

+ (void)createCachedFile: (NSMutableArray*)arrID;

+ (NSMutableArray*)getCachedFile;

+ (void) saveCachedFile:(NSMutableArray*) arrID;

+ (NSString*)adjustPhotoURL:(NSString*)photo_url;

+ (NSString*)getStringQueryNewsFeed;

+ (NSString*)getStringCreated_time;

+ (NSString*)getHeadConfigForPost;

+ (NSString*)getEndConfigForPost;

+ (void)setStringCreated_time:(NSString*) created_time;

+ (NSString*)getLastestTime;

+ (void)setLastestTime:(NSString*)time;

+ (NSString*)convertDateMessageFromUnixTime:(NSTimeInterval) unix_time;

+ (NSString*)dateTimeStringForTwitterTime:(NSString*)created_at;

+ (NSString*)dateTimeStringForTwitterTimeToPush:(NSString*)created_at;

+ (NSString*)getArticleLike:(NSString*) postID isLike:(NSInteger) isLike;

+ (NSString*)getArticleShare:(NSString*) postID isShared:(NSInteger)isShared;

#pragma mar - validate

+ (BOOL) validateEmail:(NSString*)txfText;
+ (BOOL) validatePhoneNumber:(NSString*)txfText;
+ (BOOL) validateFloatNumber:(NSString*)txfText;
+ (BOOL) validateUserName:(NSString*)txfText;
+ (BOOL) validateIntegerNumber:(NSString*)txfText;
+ (BOOL) validateCardNumber:(NSString*)txfText;
+ (BOOL) validatePass:(NSString*)txfText;
+ (BOOL) validatePassContainingNumberAndCharacter:(NSString *)txfText;
+ (BOOL) string:(NSString *)text matches:(NSString *)pattern;
+ (BOOL) validateZipcode:(NSString*)txfText;
+ (BOOL) validateDigitCode:(NSString*)txfText;


#pragma mark - convert text for html

+ (NSString*)convertTextWithSharedLink:(NSString*)msg;

+ (NSString*)convertTextToHTMLText:(NSString*)text;

+ (NSString*)showTextWithCode:(NSString*)text;

+ (NSString*)convertTextInit:(NSString*)text;

+ (NSString *)decodeHTMLEntities:(NSString *)string;

+ (void)setHTMLContent:(NSString *)htmlContent forTextView:(UITextView*)aTextView;

#pragma mark - check bandWord

+ (NSArray *)checkBandWordWithString:(NSString *) str;
+ (BOOL) checkBanned:(NSString*)string withSubString:(NSString*)subString;
+ (NSString*) showBanned:(NSString*)string withArr:(NSArray*)arrBann;

#pragma mark - Utility date time

+ (NSDate*)dateFromString:(NSString*)aString;
+ (NSString*)stringFromDate:(NSDate*)aDate;
+ (NSString*)stringFullFromDate:(NSDate*)aDate;
+ (NSDate*)dateFromUnixStamp:(NSInteger)unixStamp;
+ (NSString*)stringFormatDayMonthYearFromDate:(NSDate*)aDate;
+ (NSString*)convertScheduleTime:(NSString*)dateString;
+ (NSString*)stringFormatDayMonthYearFromUnixStamp:(NSInteger)unixStamp;

//-- get image youtube_url
+(NSString *) getImageNameFromYoutube_url:(NSString *)youtube_url;

//-- get video Identifier youtube_url
+(NSString *) getVideoIdentifierFromYoutube_url:(NSString *)youtube_url;


+ (NSString*)idFromTimeStamp;
+ (NSString *)relativeTimeFromDate:(NSDate*)aDate;

# pragma mark - Set frame of Views
+ (void) setFrameOfView:(UIView *)aView withXCordinate:(CGFloat)xCord andYCordinate:(CGFloat)yCord;
+ (void) setFrameOfView:(UIView *)aView withHeightView:(CGFloat)heightView andYCordinate:(CGFloat)yCord;

+ (CGFloat)heightFromString:(NSString*)aString maxWidth:(CGFloat)maxWidth font:(UIFont*)aFont;
+ (CGSize)sizeFromString:(NSString*)aString sizeMax:(CGSize)sizeMax font:(UIFont*)aFont;
+ (CGFloat)heightForText:(NSString *)bodyText;

#pragma mark - Scale Image
//to scale images without changing aspect ratio
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

//-- resize image
+ (UIImageView *)imageViewWithImage:(UIImage*)imgResize withImageView:(UIImageView *)imageview scaledToSize:(CGSize)newSize;


/**
 * Check network wifi and wlan
 */
+(BOOL) checkNetWork;

+(NSInteger) checkNetWorkStatus;


//-- validate Insert html to DB
+(NSString *) checkAndReplaceHtmlInsertToDB:(NSString *) htmlStr;

+(NSString *) convertAndReplaceDoLaToHtml:(NSString *) htmlStr;

+(NSString *) getFileNameFromURLString:(NSString *)urlStr;

//-- Lấy đầu số và số ký tự
+(NSString *) getFirstPhoneNumberTelco:(NSString *)urlStr;

+(NSString *) getNumberOfCharPhoneNumberTelco:(NSString *)urlStr;

+(NSString *) getPhoneNumberFromURLString:(NSString *)urlStr;

//-- Checking if a File Exists
+(BOOL) checkingAFileExistsWithPath:(NSString *) filePath;

//-- get music file path
+(NSString *) getMusicFilePathWithCategoryId:(NSString *) categoryId withNodeId:(NSString *) nodeId;

//-- get Video file path
+(NSString *) getVideoFilePathWithCategoryId:(NSString *) categoryId withNodeId:(NSString *) nodeId;

@end

@interface UITableViewCell (Extension)

- (UITextField*)fieldTextWithTag:(NSInteger)tag;
- (UILabel*)labelWithTag:(NSInteger)tag;
- (UIButton*)buttonWithTag:(NSInteger)tag;
- (UIImageView*)imageViewWithTag:(NSInteger)tag;
- (UITextView*)textViewWithTag:(NSInteger) tag;
-(UITextField*)textFieldWithTag:(NSInteger) tag;

@end

@interface NSString (extention)

- (NSString*)deleteAllSpace;

@end