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
#import "DetailViewController.h"

@interface ArticleListCDTVCViewController () <MWFeedParserDelegate>

@property (strong,nonatomic) MWFeedParser * feedParser;
@property (strong,nonatomic) ArticleDao * articleDao;

@end

@implementation ArticleListCDTVCViewController

- (IBAction)refresh:(UIRefreshControl *)sender {
    [self parseRssFeedURL];
}

-(void)parseRssFeedURL{
    [self.refreshControl beginRefreshing];
    [self.feedParser stopParsing];//stop if already start
    [self.feedParser parse];
}

-(void)setRssSubscribeURL:(NSURL *)rssSubscribeURL{
    _rssSubscribeURL = rssSubscribeURL;
    
    _feedParser = [[MWFeedParser alloc]initWithFeedURL:self.rssSubscribeURL];
    _feedParser.feedParseType = ParseTypeFull;
    _feedParser.delegate = self;
    _feedParser.connectionType = ConnectionTypeAsynchronously;
    [self parseRssFeedURL];
}

-(void)setFetchedResultsControllerForTableView{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Article"];
    request.sortDescriptors = @[ [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO] ];
    request.predicate = [NSPredicate predicateWithFormat:@" subscribeUrl = %@",_rssSubscribeURL];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                       managedObjectContext:self.articleDao.managedObjectContext sectionNameKeyPath:nil
                                                                                  cacheName:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self setFetchedResultsControllerForTableView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"articleCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    Article * obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = obj.title;
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    dateFormat.dateFormat = @"MM.dd HH:mm";//MM.dd HH:mm
    NSString * dateString = [dateFormat stringFromDate:obj.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",dateString,obj.summary];
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
        article.isFavour = @NO;
        article.isRead = @NO;
        article.link = item.link;
        article.subscribeUrl = [self.rssSubscribeURL absoluteString];
        article.summary = item.summary;
        article.title = item.title;
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    NSLog(@"4 feedParserDidFinish with url %@",self.rssSubscribeURL);
    [self.articleDao saveContext];
    if (self.view.window) {
        [self performFetch];
    }else{
        NSLog(@"%@ is not visible now ",[self class]);
    }
    [self.refreshControl endRefreshing];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    NSLog(@"5 didFailWithError");
    [self.refreshControl endRefreshing];

    
}

-(ArticleDao *)articleDao{
    if (!_articleDao) {
        _articleDao = [[ArticleDao alloc]init];
    }
    return _articleDao;
}

#pragma mark - Navigation
-(void) prepareViewController:(id)vc forSegue :(UIStoryboardSegue *)segue forIndexPath:(NSIndexPath *)indexPath{
        Article *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([vc isKindOfClass:[ DetailViewController class]]) {
        //prepare vc
        DetailViewController *targetVC = (DetailViewController *) vc;
        targetVC.article=object;
        targetVC.title = object.title;
        targetVC.hidesBottomBarWhenPushed = YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath * indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue
                   forIndexPath:indexPath];
}


@end
