//
//  NSString+VMODEV.h
//  NooPhuocThinh
//
//  Created by Sinbad Flyce on 9/25/13.
//  Copyright (c) 2013 VMODEV JSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VMODEV)

// Initialization
+ (NSString *)stringFromInteger:(NSInteger)anInteger;
+ (NSString *)stringFromFloat:(float)aFloat;
+ (NSString *)stringFromDouble:(double)aDouble;
+ (NSString *)stringWithUUID;

// Validation
- (BOOL)isValidEmail;
- (BOOL)isValidURI;

// Removing & Trimming
- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet*)characterSet;
- (NSString *)stringByReplacingCharactersInSet:(NSCharacterSet*)characterSet withString:(NSString*)string;
- (NSString *)stringByTrimmingWhitespace;
- (NSString *)stringByRemovingAmpEscapes;
- (NSString *)stringByAddingAmpEscapes;

// Query
- (BOOL)containsString:(NSString *)s;
- (BOOL)containsCaseInsensitiveString:(NSString *)s;
- (BOOL)caseInsensitiveHasPrefix:(NSString *)s;
- (BOOL)caseInsensitiveHasSuffix:(NSString *)s;
- (BOOL)isCaseInsensitiveEqual:(NSString *)s;

@end
