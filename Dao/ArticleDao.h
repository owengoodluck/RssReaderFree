//
//  ArticleDao.h
//  RssReaderFree
//
//  Created by oushunwu on 15/5/17.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "Dao.h"
#import "Article.h"

@interface ArticleDao : Dao

-(Article *)article;
-(Article *)getArticleWithURL : (NSString *)url ;

@end
