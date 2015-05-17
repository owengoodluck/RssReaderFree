//
//  ArticleListCDTVCViewController.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/17.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "ArticleListCDTVCViewController.h"

@interface ArticleListCDTVCViewController ()

@end

@implementation ArticleListCDTVCViewController

-(void)setRssSubscribeURL:(NSURL *)rssSubscribeURL{
    _rssSubscribeURL = rssSubscribeURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"articleCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    NSObject * obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = @"title";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",obj];
    return cell;
}

@end
