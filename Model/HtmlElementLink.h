//
//  HtmlLinkElement.h
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "HtmlElement.h"

@interface HtmlElementLink : HtmlElement
@property(strong,nonatomic) NSString *href ;
@property(strong,nonatomic) NSString *content ;
@end
