//
//  NSString+VMODEV.m
//  NooPhuocThinh
//
//  Created by Sinbad Flyce on 9/25/13.
//  Copyright (c) 2013 VMODEV JSC. All rights reserved.
//

#import "NSString+VMODEV.h"

@implementation NSString (VMODEV)

#pragma mark - Initialization

+ (NSString *)stringFromInteger:(NSInteger)anInteger
{
    return [NSString stringWithFormat:@"%d",anInteger];
}

+ (NSString *)stringFromFloat:(float)aFloat
{
    return [NSNumber numberWithFloat:aFloat].stringValue;
}

+ (NSString*)stringFromDouble:(double)aDouble
{
    return [NSNumber numberWithDouble:aDouble].stringValue;
}

+ (NSString *)stringWithUUID
{
    NSString* uuidString = nil;
    CFUUIDRef newUUID = CFUUIDCreate(kCFAllocatorDefault);
    if (newUUID) {
        uuidString = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, newUUID);
        CFRelease(newUUID);
    }
    return uuidString;
}

#pragma mark - Validation

- (BOOL)isValidEmail
{
    return NO;
}

- (BOOL)isValidURI
{
    return NO;
}

#pragma mark - Removing & Trimming

- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet*)characterSet
{
    NSScanner*       cleanerScanner = [NSScanner scannerWithString:self];
    NSMutableString* cleanString    = [NSMutableString stringWithCapacity:[self length]];
    // Make sure we don't skip whitespace, which NSScanner does by default
    [cleanerScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
    
    while (![cleanerScanner isAtEnd]) {
        NSString* stringFragment;
        if ([cleanerScanner scanUpToCharactersFromSet:characterSet intoString:&stringFragment])
            [cleanString appendString:stringFragment];
        
        [cleanerScanner scanCharactersFromSet:characterSet intoString:nil];
    }
    
    return cleanString;
}

- (NSString *)stringByReplacingCharactersInSet:(NSCharacterSet*)characterSet
                                    withString:(NSString*)string
{
    NSScanner*       cleanerScanner = [NSScanner scannerWithString:self];
    NSMutableString* cleanString    = [NSMutableString stringWithCapacity:[self length]];
    // Make sure we don't skip whitespace, which NSScanner does by default
    [cleanerScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
    
    while (![cleanerScanner isAtEnd])
    {
        NSString* stringFragment;
        if ([cleanerScanner scanUpToCharactersFromSet:characterSet intoString:&stringFragment])
            [cleanString appendString:stringFragment];
        
        if ([cleanerScanner scanCharactersFromSet:characterSet intoString:nil])
            [cleanString appendString:string];
    }
    
    return cleanString;
}

- (NSString *)stringByTrimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(NSString *)stringByRemovingAmpEscapes
{
    NSMutableString* dirtyStringMutant = [NSMutableString stringWithString:self];
    [dirtyStringMutant replaceOccurrencesOfString:@"&amp;"
                                       withString:@"&"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    [dirtyStringMutant replaceOccurrencesOfString:@"&quot;"
                                       withString:@"\""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    [dirtyStringMutant replaceOccurrencesOfString:@"&lt;"
                                       withString:@"<"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    [dirtyStringMutant replaceOccurrencesOfString:@"&gt;"
                                       withString:@">"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    [dirtyStringMutant replaceOccurrencesOfString:@"&mdash;"
                                       withString:@"-"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    [dirtyStringMutant replaceOccurrencesOfString:@"&apos;"
                                       withString:@"'"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    // fix import from old Firefox versions, which exported &#39; instead of a plain apostrophe
    [dirtyStringMutant replaceOccurrencesOfString:@"&#39;"
                                       withString:@"'"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    return [dirtyStringMutant stringByRemovingCharactersInSet:[NSCharacterSet controlCharacterSet]];
}

-(NSString *)stringByAddingAmpEscapes
{
    NSMutableString* dirtyStringMutant = [NSMutableString stringWithString:self];
    [dirtyStringMutant replaceOccurrencesOfString:@"&"
                                       withString:@"&amp;"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    [dirtyStringMutant replaceOccurrencesOfString:@"\""
                                       withString:@"&quot;"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    [dirtyStringMutant replaceOccurrencesOfString:@"<"
                                       withString:@"&lt;"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    [dirtyStringMutant replaceOccurrencesOfString:@">"
                                       withString:@"&gt;"
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[dirtyStringMutant length])];
    return [NSString stringWithString:dirtyStringMutant];
}

#pragma mark - Query

- (BOOL)containsString:(NSString *)s
{
	NSRange r = [self rangeOfString:s];
	BOOL contains = r.location != NSNotFound;        
	return contains;
}

- (BOOL)containsCaseInsensitiveString:(NSString *)s
{
	NSRange r = [self rangeOfString:s options:NSCaseInsensitiveSearch];
	BOOL contains = r.location != NSNotFound;
	return contains;
}

- (BOOL)caseInsensitiveHasPrefix:(NSString *)s
{
	return [[self lowercaseString] hasPrefix:[s lowercaseString]];
}

- (BOOL)caseInsensitiveHasSuffix:(NSString *)s
{
	return [[self lowercaseString] hasSuffix:[s lowercaseString]];
}

- (BOOL)isCaseInsensitiveEqual:(NSString *)s
{
	return [self compare:s options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

@end
