//
//  HtmlPage.h
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

//<!DOCTYPE html>
//<html lang=\"zh-CN\">
//  <head>
//      <meta charset=\"utf-8\">
//      <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
//      <meta name=\"viewport\" content=\"width=device-width initial-scale=1.0\">
//      %@
//  </head>
//  <body>
//      <a class=\"title\" href=\"%@\">%@</a>\
//      <div class=\"diver\"></div>
//      <p style=\"text-align:left;font-size:9pt;margin-left: 14px;margin-top: 10px;margin-bottom: 10px;color:#CCCCCC\">%@ 发表于  %@</p>
//      <div class=\"content\">%@</div>
//      %@
//  </body>
//</html>

#import <UIKit/UIKit.h>
#import "HtmlElement.h"

@interface HtmlPage :NSObject <HtmlString>

@property (strong,nonatomic) NSString * lang ;
@property (strong,nonatomic) NSString * head ;
@property (strong,nonatomic) NSString * body ;

@end
