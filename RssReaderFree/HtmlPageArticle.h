//
//  HtmlPageArticle.h
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "HtmlPage.h"
#import "Article.h"

@interface HtmlPageArticle : HtmlPage

@property (strong,nonatomic) Article *article;

@end
