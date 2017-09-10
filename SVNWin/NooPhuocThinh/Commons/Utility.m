//
//  Utility.m
//  AGKGlobal
//
//  Created by Thuy Dao on 7/4/13.
//  Copyright (c) 2013 fountaindew. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"

static NSMutableDictionary* shareProfileDict = nil;
static NSString *created_time_save = @"";
static NSString *lastest_time_save = @"";
@implementation Utility

#pragma mark - share

+ (NSMutableDictionary*) shareProfileDict
{
    
    if (shareProfileDict == nil) {
        shareProfileDict= [[NSMutableDictionary alloc] init];
        
    }
    //    shareProfileDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FB_PROFILE_DICT_BESAFE"];
    
    return shareProfileDict;
}

+ (void)saveProfileDict
{
    //    [[NSUserDefaults standardUserDefaults] setObject:shareProfileDict forKey:@"FB_PROFILE_DICT_BESAFE"];
}

#pragma mark - fileUtility

+ (void)createCachedFile: (NSMutableArray*)arrID
{
    // Test
    if (arrID == nil) {
        arrID = [NSMutableArray new];
    }
    NSString *pathVR = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    pathVR = [pathVR stringByAppendingPathComponent:@"Cached.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathVR]) {
        
        [[NSFileManager defaultManager] createFileAtPath:pathVR contents:nil attributes:nil];
        
        NSMutableDictionary *vsDictionary = [NSMutableDictionary new];
        
        if (arrID != nil)
            [vsDictionary setObject:arrID forKey:[[NSUserDefaults standardUserDefaults]objectForKey:facebookID]];
        [vsDictionary writeToFile:pathVR atomically:YES];
    }
}

+ (void) saveCachedFile:(NSMutableArray*) arrID
{
    NSString *pathVR = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    pathVR = [pathVR stringByAppendingPathComponent:@"Cached.plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:pathVR];
    if (arrID != nil)
        [dict setObject:arrID forKey:[[NSUserDefaults standardUserDefaults]objectForKey:facebookID]];
    [dict writeToFile:pathVR atomically:NO];
}

+ (NSMutableArray*)getCachedFile
{
    NSString *pathVR = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    pathVR = [pathVR stringByAppendingPathComponent:@"Cached.plist"];
    NSLog(@"path : %@", pathVR);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:pathVR];
    
    return [dict objectForKey:[[NSUserDefaults standardUserDefaults]objectForKey:facebookID]];
}

#pragma mark - StringUtility
+ (NSString*)getStringQueryNewsFeed
{
    NSMutableArray *arrID = [Utility getCachedFile];
    if ([arrID count] != 0) {
        NSString * temp = [arrID componentsJoinedByString:@"\"AND post_id != \""];
        temp = [NSString stringWithFormat:@"AND post_id != \"%@\"",temp];
        NSLog(@"temp:\t %@",temp);
        return temp;
    }
    return @"";
}

+ (NSString*)getArticleLike:(NSString*) postID isLike:(NSInteger) isLike
{
    if (isLike == 1) {
        return [NSString stringWithFormat:@"<a class=\"touchable\" href=\"http://null/like/%@\" role=\"button\"><strong>%@</strong></a>",postID,@"Like"];
    }
    else
    {
        return [NSString stringWithFormat:@"<a class=\"touchable\" href=\"http://null/unlike/%@\" role=\"button\"><strong>%@</strong></a>",postID,@"Unlike"];
    }
}

+ (NSString*)getArticleShare:(NSString*) postID isShared:(NSInteger)isShared
{
    if (isShared == 1)
    {
        return [NSString stringWithFormat:@". <a class=\"touchable\" href=\"http://null/share/%@\" role=\"button\"><strong>Share</strong></a>",postID];
    }
    else {
        return @"";
    }
}

+ (NSString*)getHeadConfigForPost
{
    return @"<div class=\"storyStream _2v9s\"><div id=\"m_newsfeed_stream\"><section class=\"_7k7 storyStream _2v9s\">";
}

+ (NSString*)getEndConfigForPost
{
    return  @"<!--</div>--></section></div></div>";
}

+ (NSString*)adjustPhotoURL:(NSString*)photo_url
{
    NSMutableString *result = [photo_url mutableCopy];
    NSRange range = [result rangeOfString:@"_s.jpg"];
    if (range.location != NSNotFound) {
        [result replaceCharactersInRange:range withString:@"_n.jpg"];
    }
    return result;
}



#pragma mark - Validate

+ (BOOL) validateEmail:(NSString *)txfText {
    NSString *emailRegex = @"^[\\_]*([a-z0-9]+(\\.|\\_*)?)+@([a-z][a-z0-9\\-]+(\\.|\\-*\\.))+[a-z]{2,6}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:txfText];
}

+ (BOOL) validatePhoneNumber:(NSString *)txfText {
    
    NSString *phoneRegex = @"^\\+(?:[0-9] ?){6,14}[0-9]$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:txfText];
}

+ (BOOL) validateFloatNumber:(NSString *)txfText {
    
    NSString *floatRegex = @"^(0|[1-9][0-9]*)(\\.[0-9]+)?([eE][+-]?[0-9]+)?$";
    NSPredicate *floatTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", floatRegex];
    
    return [floatTest evaluateWithObject:txfText];
}

+ (BOOL) validateUserName:(NSString *)txfText {
    
    NSString *usernameRegex = @"^[\\w\\d\\_\\.]{1,}$";
    NSPredicate *userNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    
    return [userNameTest evaluateWithObject:txfText];
}

+ (BOOL) validateIntegerNumber:(NSString *)txfText {
    
    NSString *numberRegex = @"^\\d+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:txfText];
}

+ (BOOL) validateCardNumber:(NSString*)txfText {
    
    NSString *cardNumberRegex = @"^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$";
    NSPredicate *cardNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardNumberRegex];
    return [cardNumberTest evaluateWithObject:txfText];
}

+ (BOOL) validatePass:(NSString *)txfText {
    
    NSString *passRegex = @"^[a-z0-9_-]{1,18}$";//"dung" user login with 1 character
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [passTest evaluateWithObject:txfText];
}


+ (BOOL) validatePassContainingNumberAndCharacter:(NSString *)txfText {
    
    // validate pass containing both of number and character
    
    NSString *cPattern = @"[A-Za-z_]";
    NSString *nPattern = @"[0-9]";
    
    if ([self string:txfText matches:cPattern] && [self string:txfText matches:nPattern])
        return YES;
    else
        return NO;
}


+ (BOOL)string:(NSString *)text matches:(NSString *)pattern
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    return matches.count > 0;
}


+ (BOOL) validateZipcode:(NSString *)txfText {
    NSString *passRegex = @"^[0-9]{5}(?:-[0-9]{4})?$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [passTest evaluateWithObject:txfText];
}

+ (BOOL) validateDigitCode:(NSString *)txfText {
    NSString *digitRegex = @"^[0-9]{3}$";
    NSPredicate *digitTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", digitRegex];
    return [digitTest evaluateWithObject:txfText];
}



#pragma mark - created time

+ (NSString*)getStringCreated_time
{
    if (created_time_save.length > 0) {
        return [NSString stringWithFormat:@"AND created_time < %@",created_time_save];
    }
    return @"";
}

+ (void)setStringCreated_time:(NSString*) created_time
{
    if (created_time.length > 0) {
        created_time_save = created_time;
    }
    else NSLog(@"setStringCreated_time failse");
}

+ (NSString*)getLastestTime
{
    if (lastest_time_save.length > 0) {
        return [NSString stringWithFormat:@"AND created_time > %@",created_time_save];
    }
    return @"";
}

+ (void)setLastestTime:(NSString*)time
{
    if (time.length > 0) {
        lastest_time_save = time;
    }
    else NSLog(@"setStringCreated_time failse");
}

+ (NSString*)convertDateMessageFromUnixTime:(NSTimeInterval) unix_time
{
    NSLog(@"convertDateMessageFromUnixTime:%1.0f",unix_time);
    
    NSString *result = @"date-time-stamp";
    NSDate *fb_date = [NSDate dateWithTimeIntervalSince1970:unix_time];
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval then = [fb_date timeIntervalSinceReferenceDate];
    NSTimeInterval diff = now - then;
    
    if (diff < 0 || unix_time < 1.0) {
        result = @"Posted recently";
    }
    else {
        if (diff < (24.0f*60.0f*60.0f)) {
            
            NSTimeInterval hours = diff/(60.0f*60.0f);
            
            if (hours > 0.9999999) {
                result = [NSString stringWithFormat:@"%1.0f hours ago",(hours-0.5f)];
            }
            else {
                NSTimeInterval minutes = diff/60.0f;
                result = [NSString stringWithFormat:@"%1.0f minutes ago",(minutes-0.5f)];
            }
        }
        else {
            //NSDate *curentDate = [NSDate date];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit fromDate:fb_date]; // Get necessary date components
            
            NSInteger mm = [components month];
            NSInteger day = [components day];
            //NSInteger year = [components year];
            NSInteger hh = [components hour];
            NSInteger minute = [components minute];
            NSString *ampm = @"am";
            NSInteger hour = hh;
            
            if (hh > 12) {
                hour = hh-12;
                ampm = @"pm";
            }
            
            NSString *month = @"January";
            
            switch (mm) {
                case 2:
                    month = @"February";
                    break;
                case 3:
                    month = @"March";
                    break;
                case 4:
                    month = @"April";
                    break;
                case 5:
                    month = @"May";
                    break;
                case 6:
                    month = @"June";
                    break;
                case 7:
                    month = @"July";
                    break;
                case 8:
                    month = @"August";
                    break;
                case 9:
                    month = @"September";
                    break;
                case 10:
                    month = @"October";
                    break;
                case 11:
                    month = @"November";
                    break;
                case 12:
                    month = @"December";
                    break;
                default:
                    month = [NSString stringWithFormat:@"Other:%d",mm];
                    break;
            }
            result = [NSString stringWithFormat:@"%@ %d at %d:%d%@",month,day,hour,minute,ampm];
        }
    }
    NSLog(@"convert datetime result:%@",result);
    
    return result;
}

+ (NSString*)dateTimeStringForTwitterTime:(NSString*)created_at
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    // see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
    [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    
    NSDate *tweet_date = [dateFormatter dateFromString:created_at];
    NSDate *date = [NSDate date];
    NSLog(@"dateTimeStringForTwitterTime:%@",created_at);
    NSLog(@"tweet_date=%@",tweet_date);
    NSLog(@"date=%@",date);
    
    NSString *result = @"date-time-stamp";
    NSTimeInterval now = [date timeIntervalSinceReferenceDate];
    NSTimeInterval then = [tweet_date timeIntervalSinceReferenceDate];
    NSTimeInterval diff = now - then;
    NSTimeInterval minutes = diff/60.0f;
    NSTimeInterval hours = diff/(60.0f*60.0f);
    NSTimeInterval days = diff/(24.0f*60.0f*60.0f);
    
    if (diff < 0) {
        if (minutes<1) {
            result = @"Just now";
        }
        result = @"Just now";
    } else {
        if (minutes<1) {
            result = @"Just now";
        }else if (diff < (24.0f*60.0f*60.0f)) {
            if (hours > 0.9999999) {
                result = [NSString stringWithFormat:@"%1.0fh",(hours-0.5f)];
            } else {
                result = [NSString stringWithFormat:@"%1.0fm",(minutes-0.5f)];
            }
        }else if (diff < (7*24.0f*60.0f*60.0f)){
            if (days > 0.9999999) {
                result = [NSString stringWithFormat:@"%1.0fd",(days-0.5f)];
            } else {
                result = [NSString stringWithFormat:@"%1.0fh",(hours-0.5f)];
            }
        }else {
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit fromDate:tweet_date]; // Get necessary date components
            
            NSInteger mm = [components month];
            NSInteger day = [components day];
            
            NSInteger year = [components year];
            NSString *yearStr = [NSString stringWithFormat:@"%d", year];
            
            NSString *charFormat = [[NSString alloc] initWithString:yearStr];
            charFormat = [charFormat stringByReplacingOccurrencesOfString:@"20" withString:@""];
            
            NSInteger hh = [components hour];
            //NSInteger minute = [components minute];
            NSString *ampm = @"am";
            NSInteger hour = hh;
            if (hh > 12) {
                hour = hh-12;
                ampm = @"pm";
            }
            
            NSString *month = @"1";
            switch (mm) {
                case 2:
                    month = @"2";
                    break;
                case 3:
                    month = @"3";
                    break;
                case 4:
                    month = @"4";
                    break;
                case 5:
                    month = @"5";
                    break;
                case 6:
                    month = @"6";
                    break;
                case 7:
                    month = @"7";
                    break;
                case 8:
                    month = @"8";
                    break;
                case 9:
                    month = @"9";
                    break;
                case 10:
                    month = @"10";
                    break;
                case 11:
                    month = @"11";
                    break;
                case 12:
                    month = @"12";
                    break;
                default:
                    month = [NSString stringWithFormat:@"Other:%d",mm];
                    break;
            }
            result = [NSString stringWithFormat:@"%@/%d/%@",month,day,charFormat];
        }
    }
    
    return result;
}


+ (NSString*)dateTimeStringForTwitterTimeToPush:(NSString*)created_at
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    // see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
    [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    
    NSDate *tweet_date = [dateFormatter dateFromString:created_at];
    NSDate *date = [NSDate date];
    
    NSString *result = @"date-time-stamp";
    NSTimeInterval now = [date timeIntervalSinceReferenceDate];
    NSTimeInterval then = [tweet_date timeIntervalSinceReferenceDate];
    NSTimeInterval diff = now - then;
    if (diff < 0) {
        NSLog(@"posted recently");
        result = @"Posted recently";
    } else {
        NSLog(@"diff 2");
        //NSDate *curentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit fromDate:tweet_date]; // Get necessary date components
        
        NSInteger mm = [components month];
        NSInteger day = [components day];
        NSInteger year = [components year];
        NSString *yearStr = [NSString stringWithFormat:@"%d", year];
        
        NSString *yearFormat = [[NSString alloc] initWithString:yearStr];
        yearFormat = [yearFormat stringByReplacingOccurrencesOfString:@"20" withString:@""];
        
        NSInteger hh = [components hour];
        
        NSInteger minute = [components minute];
        NSString *minuteStr = nil;
        if (minute<10) {
            minuteStr = [NSString stringWithFormat:@"0%d",minute];
        }else{
            minuteStr = [NSString stringWithFormat:@"%d",minute];
        }
        
        NSString *ampm = @"AM";
        NSInteger hour = hh;
        if (hh > 12) {
            hour = hh-12;
            ampm = @"PM";
        }
        
        NSString *month = @"1";
        switch (mm) {
            case 2:
                month = @"2";
                break;
            case 3:
                month = @"3";
                break;
            case 4:
                month = @"4";
                break;
            case 5:
                month = @"5";
                break;
            case 6:
                month = @"6";
                break;
            case 7:
                month = @"7";
                break;
            case 8:
                month = @"8";
                break;
            case 9:
                month = @"9";
                break;
            case 10:
                month = @"10";
                break;
            case 11:
                month = @"11";
                break;
            case 12:
                month = @"12";
                break;
            default:
                month = [NSString stringWithFormat:@"Other:%d",mm];
                break;
        }
        result = [NSString stringWithFormat:@"%@/%d/%@, %d:%@ %@",month,day,yearFormat,hour,minuteStr,ampm];
    }
    
    return result;
}



#pragma mark - convert text for html

// find link in msg and show link by hyperlink
+ (NSString*)convertTextWithSharedLink:(NSString*)msg
{
    msg = [Utility convertTextInit:msg];
    msg = [NSString stringWithFormat:@"%@ ",msg];
    
    NSArray *arrString = [msg componentsSeparatedByString:@" "];
    
    for(int i=0; i<arrString.count;i++){
        // check link
        if([[arrString objectAtIndex:i] rangeOfString:@"http://"].location != NSNotFound || [[arrString objectAtIndex:i] rangeOfString:@"https://"].location != NSNotFound)
        {
            NSArray *arrNewString = [[arrString objectAtIndex:i]  componentsSeparatedByString:@"\""];
            
            NSString *link = [arrString objectAtIndex:i];
            BOOL checkSubLink = FALSE;
            
            // check truong hop abcdfdfdf("http://abc")
            
            for(int ii=0; ii<arrNewString.count;ii++){
                
                if([[arrNewString objectAtIndex:ii] rangeOfString:@"http://"].location != NSNotFound || [[arrString objectAtIndex:i] rangeOfString:@"https://"].location != NSNotFound)
                {
                    checkSubLink = TRUE;
                    link = [arrNewString objectAtIndex:ii];
                    NSString* newlink = [NSString stringWithFormat:@"<a href=\"http://null/shareLink/%@\" style=\"text-decoration:none;\">%@</a>",link,link];
                    
                    msg = [msg stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ ",link] withString:newlink];
                }
            }
            
            // end check
            
            if (!checkSubLink) {
                NSString* newlink = [NSString stringWithFormat:@"<a href=\"http://null/shareLink/%@\" style=\"text-decoration:none;\">%@</a>",link,link];
                
                msg = [msg stringByReplacingOccurrencesOfString:link withString:newlink];
            }
        }
        // check #string
        
        NSString* firtString = @"";
        
        if ([[arrString objectAtIndex:i] length] > 0) {
            firtString = [[arrString objectAtIndex:i] substringToIndex:1];
        }
        
        if([firtString isEqualToString:@"#"] && ![[arrString objectAtIndex:i] isEqualToString:@"#"])
        {
            NSString *link = [arrString objectAtIndex:i];
            NSString* newlink = [NSString stringWithFormat:@"<a href=\"http://null/shareLink/%@\" style=\"text-decoration:none;\">%@</a>",link,link];
            
            msg = [msg stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ ",link] withString:newlink];
        }
    }
    return msg;
}

+ (NSString*)convertTextToHTMLText:(NSString*)text
{
    text  = [text stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    text  = [text stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    //    text  = [text stringByReplacingOccurrencesOfString:@"\''" withString:@"\\'"];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSArray *arr = [text componentsSeparatedByString:@"<br>"];
    NSMutableArray *arrNew = [[NSMutableArray alloc] init];
    for (NSString *aStr in arr) {
        [arrNew addObject:[aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    NSString* textConverted = [arrNew componentsJoinedByString:@" <br> "];
    
    return textConverted;
}

+ (NSString*)showTextWithCode:(NSString*)text
{
    text = [text stringByReplacingOccurrencesOfString:@"<script>" withString:@"<xmp><script>"];
    text = [text stringByReplacingOccurrencesOfString:@"</script>" withString:@"</script></xmp>"];
    return text;
}

+ (NSString*)convertTextInit:(NSString*)text
{
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@" <br>"];
    NSArray *arr = [text componentsSeparatedByString:@"<br>"];
    NSMutableArray *arrNew = [[NSMutableArray alloc] init];
    for (NSString *aStr in arr) {
        [arrNew addObject:[aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    NSString* textConverted = [arrNew componentsJoinedByString:@" <br> "];
    
    return textConverted;
}

+ (NSString *)decodeHTMLEntities:(NSString *)string {
    // Reserved Characters in HTML
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    // ISO 8859-1 Symbols
    string = [string stringByReplacingOccurrencesOfString:@"&iexcl;" withString:@"¡"];
    string = [string stringByReplacingOccurrencesOfString:@"&cent;" withString:@"¢"];
    string = [string stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
    string = [string stringByReplacingOccurrencesOfString:@"&curren;" withString:@"¤"];
    string = [string stringByReplacingOccurrencesOfString:@"&yen;" withString:@"¥"];
    string = [string stringByReplacingOccurrencesOfString:@"&brvbar;" withString:@"¦"];
    string = [string stringByReplacingOccurrencesOfString:@"&sect;" withString:@"§"];
    string = [string stringByReplacingOccurrencesOfString:@"&uml;" withString:@"¨"];
    string = [string stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordf;" withString:@"ª"];
    string = [string stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    string = [string stringByReplacingOccurrencesOfString:@"&not;" withString:@"¬"];
    string = [string stringByReplacingOccurrencesOfString:@"&shy;" withString:@"    "];
    string = [string stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];
    string = [string stringByReplacingOccurrencesOfString:@"&macr;" withString:@"¯"];
    string = [string stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    string = [string stringByReplacingOccurrencesOfString:@"&plusmn;" withString:@"±       "];
    string = [string stringByReplacingOccurrencesOfString:@"&sup2;" withString:@"²"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup3;" withString:@"³"];
    string = [string stringByReplacingOccurrencesOfString:@"&acute;" withString:@"´"];
    string = [string stringByReplacingOccurrencesOfString:@"&micro;" withString:@"µ"];
    string = [string stringByReplacingOccurrencesOfString:@"&para;" withString:@"¶"];
    string = [string stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    string = [string stringByReplacingOccurrencesOfString:@"&cedil;" withString:@"¸"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup1;" withString:@"¹"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordm;" withString:@"º"];
    string = [string stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"»"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac14;" withString:@"¼"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac12;" withString:@"½"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac34;" withString:@"¾"];
    string = [string stringByReplacingOccurrencesOfString:@"&iquest;" withString:@"¿"];
    string = [string stringByReplacingOccurrencesOfString:@"&times;" withString:@"×"];
    string = [string stringByReplacingOccurrencesOfString:@"&divide;" withString:@"÷"];
    
    // ISO 8859-1 Characters
    string = [string stringByReplacingOccurrencesOfString:@"&Agrave;" withString:@"À"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aacute;" withString:@"Á"];
    string = [string stringByReplacingOccurrencesOfString:@"&Acirc;" withString:@"Â"];
    string = [string stringByReplacingOccurrencesOfString:@"&Atilde;" withString:@"Ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&Auml;" withString:@"Ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aring;" withString:@"Å"];
    string = [string stringByReplacingOccurrencesOfString:@"&AElig;" withString:@"Æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ccedil;" withString:@"Ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&Egrave;" withString:@"È"];
    string = [string stringByReplacingOccurrencesOfString:@"&Eacute;" withString:@"É"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ecirc;" withString:@"Ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&Euml;" withString:@"Ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&Igrave;" withString:@"Ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iacute;" withString:@"Í"];
    string = [string stringByReplacingOccurrencesOfString:@"&Icirc;" withString:@"Î"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iuml;" withString:@"Ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&ETH;" withString:@"Ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ntilde;" withString:@"Ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ograve;" withString:@"Ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oacute;" withString:@"Ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ocirc;" withString:@"Ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&Otilde;" withString:@"Õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ouml;" withString:@"Ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oslash;" withString:@"Ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ugrave;" withString:@"Ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uacute;" withString:@"Ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ucirc;" withString:@"Û"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uuml;" withString:@"Ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&Yacute;" withString:@"Ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&THORN;" withString:@"Þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&szlig;" withString:@"ß"];
    string = [string stringByReplacingOccurrencesOfString:@"&agrave;" withString:@"à"];
    string = [string stringByReplacingOccurrencesOfString:@"&aacute;" withString:@"á"];
    string = [string stringByReplacingOccurrencesOfString:@"&acirc;" withString:@"â"];
    string = [string stringByReplacingOccurrencesOfString:@"&atilde;" withString:@"ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&auml;" withString:@"ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&aring;" withString:@"å"];
    string = [string stringByReplacingOccurrencesOfString:@"&aelig;" withString:@"æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ccedil;" withString:@"ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&egrave;" withString:@"è"];
    string = [string stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"é"];
    string = [string stringByReplacingOccurrencesOfString:@"&ecirc;" withString:@"ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&euml;" withString:@"ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&igrave;" withString:@"ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&iacute;" withString:@"í"];
    string = [string stringByReplacingOccurrencesOfString:@"&icirc;" withString:@"î"];
    string = [string stringByReplacingOccurrencesOfString:@"&iuml;" withString:@"ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&eth;" withString:@"ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&ntilde;" withString:@"ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ograve;" withString:@"ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&oacute;" withString:@"ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&ocirc;" withString:@"ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&otilde;" withString:@"õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ouml;" withString:@"ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&oslash;" withString:@"ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&ugrave;" withString:@"ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&uacute;" withString:@"ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&ucirc;" withString:@"û"];
    string = [string stringByReplacingOccurrencesOfString:@"&uuml;" withString:@"ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&yacute;" withString:@"ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&thorn;" withString:@"þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&yuml;" withString:@"ÿ"];
    string = [string stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
    return string;
}

+ (void)setHTMLContent:(NSString *)htmlContent forTextView:(UITextView*)aTextView
{
    //-- set Description
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        NSString *stringFormat = [NSString stringWithFormat:@"%@",htmlContent];
        NSAttributedString *aStr = [[NSAttributedString alloc] initWithData:[stringFormat dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                              NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                         documentAttributes:nil error:nil];

        aTextView.attributedText = aStr;
    }
    else
    {
        [aTextView setValue:htmlContent forKey:@"contentToHTMLString"];
    }
    
}


#pragma mark - check bandWord

+ (NSArray *)checkBandWordWithString:(NSString *) str
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    NSMutableArray *arrBan = [[NSMutableArray alloc] initWithObjects:@"xxx",@"hehe", nil];
    NSArray *arrTemp = [str componentsSeparatedByString:@" "];
    if (arrBan.count < arrTemp.count) {
        for (NSString* strBan in arrBan) {
            if ([arrTemp containsObject:strBan]) {
                [res addObject:strBan];
            }
        }
    }
    else {
        for (NSString* strNew in arrTemp) {
            if ([arrBan containsObject:strNew]) {
                [res addObject:strNew];
            }
        }
    }
    return res;
}

+ (BOOL) checkBanned:(NSString*)string withSubString:(NSString*)subString
{
    NSRange textRange = [[string lowercaseString] rangeOfString:[subString lowercaseString]];
    
    if(textRange.location != NSNotFound)
    {
        //Does contain the substring
        
        return YES;
    }
    else
        return NO;
}

+ (NSString*) showBanned:(NSString*)string withArr:(NSArray*)arrBann
{
    NSMutableArray *banArr = [[NSMutableArray alloc] init];
    NSString *banWord = @"" ;
    for (NSString *a in arrBann) {
        NSLog(@"string in array %@",a);
        if([Utility checkBanned:string withSubString:a] )
        {
            [banArr addObject:a];
            banWord = [NSString stringWithFormat:@"%@ %@",banWord,a];
        }
        
    }
    
    return banWord;
    
}

#pragma mark - date time

+ (NSDate*) dateFromString: (NSString*) aString
{
    NSLog(@"date string:%@",aString);
    //longnh fix bug tra ve gia tri nil khi setting gio iOS la OFF 24h
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [dateFormatter setDateFormat:@"HH:mm:ss dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:aString];
    NSLog(@"date return:%@",dateFromString);
    return  dateFromString;
}


+ (NSString*)stringFromDate:(NSDate*)aDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss dd-MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:aDate];
    
    return (dateString);
}

+ (NSString*)stringFullFromDate:(NSDate*)aDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss dd-MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:aDate];

    return (dateString);
}

+ (NSDate *)dateFromUnixStamp:(NSInteger)unixStamp
{
    return [NSDate dateWithTimeIntervalSince1970:unixStamp];
}

+ (NSString *)stringFormatDayMonthYearFromDate:(NSDate*)aDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:aDate];
    return (dateString);
}

+ (NSString*)convertScheduleTime:(NSString*)dateString
{
    NSDate *dateC = [self dateFromString:dateString];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:MM a dd-MM-yyyy"];
    NSString *timerConvert = [dateFormat stringFromDate:dateC];
    
    return (timerConvert);
}

+ (NSString *)stringFormatDayMonthYearFromUnixStamp:(NSInteger)unixStamp
{
    NSString *dateString = [Utility stringFormatDayMonthYearFromDate:[Utility dateFromUnixStamp:unixStamp]];
    return (dateString);
}

//-- get image youtube_url
+(NSString *) getImageNameFromYoutube_url:(NSString *)youtube_url
{
    //request
    NSString *videoIdentifier = [self getVideoIdentifierFromYoutube_url:youtube_url];
    
    return  [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoIdentifier];
}

//-- get video Identifier youtube_url
+(NSString *) getVideoIdentifierFromYoutube_url:(NSString *)youtube_url
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=watch\\?v=|/videos/|embed\\/)[^#\\&\\?]*"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:youtube_url
                                                    options:0
                                                      range:NSMakeRange(0, [youtube_url length])];
    NSString *substringForFirstMatch;
    if (match) {
        NSRange videoIDRange = [match rangeAtIndex:0];
        substringForFirstMatch = [youtube_url substringWithRange:videoIDRange];
    }
    return substringForFirstMatch;
}




//-- Hoa add
+ (NSString*)idFromTimeStamp
{
    NSDate *aDate = [NSDate date];
    return [NSString stringWithFormat:@"%.0f",[aDate timeIntervalSince1970]];
}

//-- Hoa add
+ (NSString *)relativeTimeFromDate:(NSDate*)aDate
{
    NSDate *now = [NSDate date];
    NSTimeInterval seconds = [now timeIntervalSinceDate:aDate];
    NSString *relativeTime = @"";
    
    if (seconds < 5)
    {
        relativeTime = [NSString stringWithFormat:@"vừa xong"];
    }
    else if ((seconds < 60) && (seconds > 5)) // x seconds ago
    {
        relativeTime = [NSString stringWithFormat:@"%.0f giây trước", seconds];
    }
    else if (seconds/60 < 60) // floor(x/60) minutes ago
    {
        relativeTime = [NSString stringWithFormat:@"%.0f phút trước", seconds/60];
    }
    else if (seconds/(60*60) < 24) // floor(x/(60*60) hours ago
    {
        relativeTime = [NSString stringWithFormat:@"%.0f giờ trước",seconds/(60*60)];
    }
    else if ( (seconds/(24*60*60) >= 1) && (seconds/(24*60*60) < 2) ) // floor(x(24*60*60) days ago
    {
        relativeTime = [NSString stringWithFormat:@"Hôm qua"];
    }
    else if (seconds/(24*60*60) < 7) // floor(x(24*60*60) days ago
    {
        relativeTime = [NSString stringWithFormat:@"%.0f ngày trước",seconds/(24*60*60)];
    }
    else if (seconds/(24*60*60) == 7) // floor(x(24*60*60) a week ago
    {
        relativeTime = [NSString stringWithFormat:@"1 tuần trước"];
    }
    else
        relativeTime = [Utility stringFullFromDate:aDate];
    
    return relativeTime;
}

# pragma mark - Set frame of Views
+ (void) setFrameOfView:(UIView *)aView withXCordinate:(CGFloat)xCord andYCordinate:(CGFloat)yCord
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    aView.frame = CGRectMake(xCord,yCord, aView.frame.size.width, aView.frame.size.height);
    [UIView commitAnimations];
}

+ (void) setFrameOfView:(UIView *)aView withHeightView:(CGFloat)heightView andYCordinate:(CGFloat)yCord
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    aView.frame = CGRectMake(0,yCord, aView.frame.size.width, heightView);    
    [UIView commitAnimations];

}

+ (CGFloat)heightFromString:(NSString*)aString maxWidth:(CGFloat)maxWidth font:(UIFont*)aFont
{
    CGSize constraintSize = CGSizeMake(maxWidth, 999999);
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        CGSize sz = [aString sizeWithFont:aFont constrainedToSize:constraintSize
                            lineBreakMode:NSLineBreakByWordWrapping];
        return sz.height;
    }
    else
    {
#ifdef __AVAILABILITY_INTERNAL__IPHONE_7_0
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:aFont,NSFontAttributeName,NSLineBreakByWordWrapping, nil];
        
        CGSize labelSize = [aString boundingRectWithSize:constraintSize
                                                  options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                               attributes:stringAttributes context:nil].size;
        CGFloat height = labelSize.height;
        return height;
#endif
    }
}


//-- Long Nguyen 19.12.2013

+ (CGSize)sizeFromString:(NSString*)aString sizeMax:(CGSize)sizeMax font:(UIFont*)aFont
{
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        CGSize size = [aString sizeWithFont:aFont constrainedToSize:sizeMax
                            lineBreakMode:NSLineBreakByWordWrapping];
        return size;
    }
    else
    {
#ifdef __AVAILABILITY_INTERNAL__IPHONE_7_0
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:aFont,NSFontAttributeName,NSLineBreakByWordWrapping, nil];
        
        CGSize size = [aString boundingRectWithSize:sizeMax
                                                 options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                              attributes:stringAttributes context:nil].size;
        return size;
#endif
    }
}


//-- get height for row item
+ (CGFloat)heightForText:(NSString *)bodyText
{
    UIFont *cellFont = [UIFont systemFontOfSize:12.0f];
    CGSize constraintSize = CGSizeMake(270, MAXFLOAT);
    CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = labelSize.height;
    
    return height;
}


#pragma mark - Scale Image

//to scale images without changing aspect ratio
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

//-- resize image
+ (UIImageView *)imageViewWithImage:(UIImage*)imgResize withImageView:(UIImageView *)imageview scaledToSize:(CGSize)newSize
{
    CGSize imageSize = imgResize.size;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    
    CGRect frame = imageview.frame;
    if (newSize.width / aspectRatio <= newSize.height) {
        frame.size.width = newSize.width;
        frame.size.height = frame.size.width / aspectRatio;
    } else {
        frame.size.height = newSize.height;
        frame.size.width = frame.size.height * aspectRatio;
    }
    imageview.frame = frame;
    
    return imageview;
}

/**
 * Check network wifi and wlan
 */
+(BOOL) checkNetWork
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus intenetStatus = [r currentReachabilityStatus];
    
    if ((intenetStatus != ReachableViaWiFi) && (intenetStatus != ReachableViaWWAN))
    {
        return NO;
    }
    return YES;
}

+(NSInteger) checkNetWorkStatus {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        return 0;
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        return 1;
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        return 2;
    }
    
    return 0;
}

//-- validate Insert html to DB
+(NSString *) checkAndReplaceHtmlInsertToDB:(NSString *) htmlStr {
    
    //-- validate content
    NSString *tempContent = [htmlStr stringByReplacingOccurrencesOfString:@"\'" withString:@"$$$"];
 
    return tempContent;
}

+(NSString *) convertAndReplaceDoLaToHtml:(NSString *) htmlStr {
    
    //-- validate content
    NSString *tempContent = [htmlStr stringByReplacingOccurrencesOfString:@"$$$" withString:@"\'"];
    
    return tempContent;
}


+(NSString *) getFileNameFromURLString:(NSString *)urlStr
{
    int numberOfOccurences = [[urlStr componentsSeparatedByString:@","] count]-1;
    
    if (numberOfOccurences == 0)
        return urlStr;
    else
    {
        NSString *formatStr = [NSString stringWithFormat:@",%@",urlStr];
        //request
        NSArray *listURL = [formatStr componentsSeparatedByString:@","];
        return  [listURL objectAtIndex:[listURL count]-(numberOfOccurences+1)];
    }
}

//-- Lấy đầu số và số ký tự
+(NSString *) getFirstPhoneNumberTelco:(NSString *)urlStr
{
    //request
    NSArray *listStr = [urlStr componentsSeparatedByString:@"-"];
    return  [listStr objectAtIndex:[listStr count]-2];
}

+(NSString *) getNumberOfCharPhoneNumberTelco:(NSString *)urlStr
{
    //request
    NSArray *listStr = [urlStr componentsSeparatedByString:@"-"];
    return  [listStr objectAtIndex:[listStr count]-1];
}

+(NSString *) getPhoneNumberFromURLString:(NSString *)urlStr
{
    //request
    NSArray *listURL = [urlStr componentsSeparatedByString:@"$"];
    return  [listURL objectAtIndex:[listURL count]-1];
}

//-- Checking if a File Exists
+(BOOL) checkingAFileExistsWithPath:(NSString *) filePath {
    
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:filePath] == YES)
        return YES;
    else
        return NO;
}

//-- get music file path
+(NSString *) getMusicFilePathWithCategoryId:(NSString *) categoryId withNodeId:(NSString *) nodeId {
    
    //-- get folder path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Music/%@/%@.mp3",categoryId,nodeId]];
    
    return filePath;
}

//-- get Video file path
+(NSString *) getVideoFilePathWithCategoryId:(NSString *) categoryId withNodeId:(NSString *) nodeId {
    
    //-- get folder path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Video/%@/%@.mp4",categoryId,nodeId]];
    
    return filePath;
}

@end

@implementation NSString (extention)

- (NSString*)deleteAllSpace
{
    [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return self;
}

@end
