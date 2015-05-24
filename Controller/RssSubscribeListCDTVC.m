//
//  RssSubscribeListCDTVC.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/16.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "RssSubscribeListCDTVC.h"
#import "RssSubscribe.h"
#import "AppDelegate.h"
#import "ArticleListCDTVCViewController.h"

@interface RssSubscribeListCDTVC ()

@end

@implementation RssSubscribeListCDTVC

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RssSubscribe" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:_managedObjectContext
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"RssSubscribeCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    RssSubscribe * obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = obj.title;
    cell.detailTextLabel.text = obj.sumary;
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Do any additional setup after loading the view.
    AppDelegate *appDelegete = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
    self.managedObjectContext = appDelegete.managedObjectContext;
}

#pragma mark - Navigation
-(void) prepareViewController:(id)vc forSegue :(UIStoryboardSegue *)segue forIndexPath:(NSIndexPath *)indexPath{
    RssSubscribe *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([vc isKindOfClass:[ ArticleListCDTVCViewController class]]) {
        //prepare vc
        ArticleListCDTVCViewController *targetVC = (ArticleListCDTVCViewController *) vc;
        targetVC.rssSubscribeURL = [NSURL URLWithString:object.url];
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
