//
//  HtmlElementDiv.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "HtmlElementDiv.h"

@implementation HtmlElementDiv

//<div class=\"content\">%@</div>
-(NSString *)htmlString{
    NSString * value =@"<div";
    if (self.cssClass) {
        value = [value stringByAppendingFormat:@" class=\"%@\" ",self.cssClass];
    }
    value = [value stringByAppendingString:@">"];
    
    if (self.content && self.content.length > 0) {
        value = [value stringByAppendingString: self.content];
    }

    value = [value stringByAppendingString:@"</div>"];
    return value;
}
@end
