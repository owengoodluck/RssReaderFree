//
//  ArticleDao.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/17.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "ArticleDao.h"
#import "Article.h"

@implementation ArticleDao

-(Article *)article{
    Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article"
                                                     inManagedObjectContext:self.managedObjectContext];
    return article;
}

-(Article *)getArticleWithURL : (NSString *)url{
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Article"];
    request.predicate = [NSPredicate predicateWithFormat:@"link = %@", url];
    NSError * error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error ] ;
    if (array && [array count]==1) {
        return array[0];
    }else{
        return nil;
    }
}

@end
