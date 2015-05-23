//
//  HtmlLinkElement.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "HtmlElementLink.h"

@implementation HtmlElementLink

//<a href="#tips">有用的提示</a>
-(NSString *)htmlString{
    
    NSString *htmlString = @"<a";
    if (self.href && self.href.length > 0 ) {
        htmlString = [htmlString stringByAppendingFormat:@" href=\" %@ \" ",self.href ] ;
    }
    htmlString = [htmlString stringByAppendingString:@">"];
    
    if (self.content && self.content.length >0 ) {
        htmlString = [htmlString stringByAppendingString:self.content];
    }
    
    htmlString = [htmlString stringByAppendingString:@"</a>"];
    return htmlString;
}
@end
