//
//  HtmlElement.h
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HtmlString

-(NSString *)htmlString;

@end

@interface HtmlElement : NSObject <HtmlString>

@property (strong,nonatomic) NSString *cssClass;

@end
