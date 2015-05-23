//
//  HtmlPElement.h
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//
//<p> 与 </p> 之间的文本被显示为段落
//<p style=\"text-align:left;font-size:9pt;margin-left: 14px;margin-top: 10px;margin-bottom: 10px;color:#CCCCCC\">%@ 发表于  %@</p>

#import "HtmlElement.h"

@interface HtmlElementP : HtmlElement

@property (strong,nonatomic) NSString *style ;
@property (strong,nonatomic) NSString *content;

@end
