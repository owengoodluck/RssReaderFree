//
//  FavoriteListCDTVC.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/28.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "FavoriteListCDTVC.h"
#import "AppDelegate.h"
#import "Article.h"
#import "DetailViewController.h"

@interface FavoriteListCDTVC ()
@property (strong,nonatomic) NSManagedObjectContext * managedObjectContext ;
@end

@implementation FavoriteListCDTVC

-(NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        AppDelegate *appDelegete = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
        _managedObjectContext = appDelegete.managedObjectContext;
    }
    return _managedObjectContext;}

-(void)setFetchedResultsControllerForTableView{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Article"];
    request.sortDescriptors = @[ [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO] ];
    request.predicate = [NSPredicate predicateWithFormat:@" isFavour = %@",@YES];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                       managedObjectContext:self.managedObjectContext
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self setFetchedResultsControllerForTableView];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"favoriteCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    Article * obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text =obj.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",obj];
    return cell;
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
