//
//  HomeVideoWebView.m
//  NooPhuocThinh
//
//  Created by Long Nguyen on 10/22/15.
//  Copyright (c) 2015 MAC_OSX. All rights reserved.
//

#import "HomeVideoWebView.h"

@implementation HomeVideoWebView

#pragma mark -
#pragma mark Initialization

- (HomeVideoWebView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
{
    if (self = [super init])
    {
        // Create webview with requested frame size
        self = [[HomeVideoWebView alloc]initWithFrame:frame];
        
        // HTML to embed YouTube video
        NSString *youTubeVideoHTML = @"<html><head>\
        <body style=\"margin:0\">\
        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
        width=\"%0.0f\" height=\"%0.0f\"></embed>\
        </body></html>";
        
        // Populate HTML with the URL and requested frame size
        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, frame.size.width, frame.size.height];
        
        // Load the html into the webview
        [self loadHTMLString:html baseURL:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
