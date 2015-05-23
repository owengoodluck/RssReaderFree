	//
//  HtmlPageArticle.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "HtmlPageArticle.h"
#import "HtmlElementLink.h"
#import "HtmlElementDiv.h"
#import "HtmlElementP.h"

@interface HtmlPageArticle ()

@end
@implementation HtmlPageArticle


//<a class=\"title\" href=\"%@\">%@</a>\
//<div class=\"diver\"></div>
//<p style=\"text-align:left;font-size:9pt;margin-left: 14px;margin-top: 10px;margin-bottom: 10px;color:#CCCCCC\">%@ 发表于 %@</p>
//<div class=\"content\">%@</div>
//
-(void)setArticle:(Article *)article{
        _article = article;
        //get head
        self.head = [self getMetaString];
        self.head = [self.head stringByAppendingString:[self getCssDefinationString]];
        
        //get body
        HtmlElementLink *a =[[HtmlElementLink alloc]init];
        a.cssClass =@"title";
        a.href = self.article.link;
        a.content = self.article.title;
        self.body = [a htmlString];
        
        HtmlElementDiv *div1 = [HtmlElementDiv new];
        div1.cssClass = @"diver";
        self.body = [self.body stringByAppendingString:[div1 htmlString]];
        
        HtmlElementP *p = [HtmlElementP new];
        p.style = @"text-align:left;font-size:9pt;margin-left: 14px;margin-top: 10px;margin-bottom: 10px;color:#CCCCCC";
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"MM.dd HH:mm"];
        [dateFormat stringFromDate:self.article.date];
        p.content = [NSString stringWithFormat:@"%@ 发表于 %@",self.article.author, [dateFormat stringFromDate:self.article.date]];
        self.body = [self.body stringByAppendingString:[p htmlString]];
        
        HtmlElementDiv *divContent = [HtmlElementDiv new];
        divContent.cssClass = @"content";
        divContent.content = self.article.content ? self.article.content : self.article.summary ;
        self.body = [self.body stringByAppendingString:[divContent htmlString]];
}

-(NSString *)getMetaString{
    return @"<meta charset=\"utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width initial-scale=1.0\">";
}
-(NSString *)getCssDefinationString{
    NSString * cssFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"css.html"];
    return [NSString stringWithContentsOfFile:cssFilePath
                                     encoding:NSUTF8StringEncoding
                                        error:NULL];
}

@end
