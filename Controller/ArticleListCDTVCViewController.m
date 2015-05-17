//
//  ArticleListCDTVCViewController.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/17.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "ArticleListCDTVCViewController.h"
#import "MWFeedParser.h"
#import "Article.h"
#import "ArticleDao.h"

@interface ArticleListCDTVCViewController () <MWFeedParserDelegate>

@property (strong,nonatomic) MWFeedParser * feedParser;
@property (strong,nonatomic) ArticleDao * articleDao;

@end

@implementation ArticleListCDTVCViewController

-(void)parseRssFeedURL{
    _feedParser = [[MWFeedParser alloc]initWithFeedURL:self.rssSubscribeURL];
    _feedParser.feedParseType = ParseTypeFull;
    _feedParser.delegate = self;
    _feedParser.connectionType = ConnectionTypeAsynchronously;
    [_feedParser parse];
}

-(void)setRssSubscribeURL:(NSURL *)rssSubscribeURL{
    NSLog(@"rssSubscribeURL = %@",rssSubscribeURL);
    _rssSubscribeURL = rssSubscribeURL;
    [self parseRssFeedURL];
    [self setFetchedResultsControllerForTableView];
}

-(void)setFetchedResultsControllerForTableView{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Article"];
    request.sortDescriptors = @[ [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES] ];
    request.predicate = [NSPredicate predicateWithFormat:@" subscribeUrl = %@",_rssSubscribeURL];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                       managedObjectContext:self.articleDao.managedObjectContext sectionNameKeyPath:nil
                                                                                  cacheName:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"articleCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    Article * obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = obj.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",obj.summary];
    return cell;
}

#pragma mark MWFeedParserDelegate methods
- (void)feedParserDidStart:(MWFeedParser *)parser{
    NSLog(@"1 feedParserDidStart");
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    NSLog(@"2 didParseFeedInfo");
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    if (!item) {
        NSLog(@"No item is parsed !");
    }
    Article *article = [self.articleDao getArticleWithURL:item.link];
    if (!article) {
        article = [self.articleDao article];
        article.author = item.author;
        article.content = item.content;
        article.createDate = nil;
        article.date = item.date;
        article.identifier = item.identifier;
        article.isDisLike = nil;
        article.isFavour = NO;
        article.isRead = NO;
        article.link = item.link;
        article.subscribeUrl = [self.rssSubscribeURL absoluteString];
        article.summary = item.summary;
        article.title = item.title;
    }
    
//    article.updated = item.updated;

    
}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    NSLog(@"4 feedParserDidFinish with url %@",self.rssSubscribeURL);
    [self.articleDao saveContext];
    [self performFetch];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    NSLog(@"5 didFailWithError");

    
}

-(ArticleDao *)articleDao{
    if (!_articleDao) {
        _articleDao = [[ArticleDao alloc]init];
    }
    return _articleDao;
}

@end
