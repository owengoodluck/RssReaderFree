//
//  HtmlPElement.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "HtmlElementP.h"

@implementation HtmlElementP

//<p>My first paragraph.</p>
-(NSString *)htmlString{
    
    NSString *value =@"<p";
    if (self.style && self.style.length > 0) {
        value = [value stringByAppendingFormat:@" style=\"%@\" ",self.style];
    }
    value =[value stringByAppendingString:@">"];
    
    
    if (self.content && self.content.length > 0) {
        value = [value stringByAppendingString: self.content];
    }
    
    return [value stringByAppendingString:@"</p>"];
}

@end
