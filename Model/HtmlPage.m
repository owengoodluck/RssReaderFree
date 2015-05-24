//
//  HtmlPage.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "HtmlPage.h"

@implementation HtmlPage

//<!DOCTYPE html>
//<html lang=\"zh-CN\">
//<head> %@ </head>
//<body> %@ </body>
//</html>
-(NSString *)htmlString{
    NSString *page =@"<!DOCTYPE html><html";

    if (self.lang) {
        page = [page stringByAppendingFormat:@" lang=\"%@\" ",self.lang];    }
    page = [page stringByAppendingString:@">"];

    if (self.head) {
        page = [page stringByAppendingFormat:@"<head> %@ </head> ",self.head];
    }
    
    if (self.body) {
        page = [page stringByAppendingFormat:@"<body> %@ </body> ",self.body];

    }
    
    page = [page stringByAppendingString:@"</html>"];
    //NSLog(@"page = %@",page);

    return page;
}

@end
