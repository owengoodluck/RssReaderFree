//
//  DetailViewController.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "DetailViewController.h"
#import "HtmlPageArticle.h"
#import "DetailBottonBar.h"
#import "Dao.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) HtmlPageArticle * htmlPageArticle;
@property (strong, nonatomic) DetailBottonBar * detailBoottonBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favBarButtonItem;
//@property (strong, nonatomic) Dao * dao;

@end

@implementation DetailViewController
- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)favoriteButton:(UIBarButtonItem *)sender {
    if ([self.article.isFavour boolValue ] == YES) {
        self.article.isFavour = @NO;
    }else{
        self.article.isFavour = @YES;
    }
    [self updateFavImage];
    [self save];
}

-(void)save{
    NSManagedObjectContext * context=self.article.managedObjectContext;
    NSError * error ;
    if (context) {
        if ([context hasChanges]) {  // TODO: EXC_BAD_ACCESS
            if (![context save:&error]) {
                NSLog(@"Error saving %@ %@, %@, %@", [self class], error, [error userInfo],[error localizedDescription]);
            }
        }else{
            NSLog(@"No object changed for saving");
        }
    }
}

-(void)setArticle:(Article *)article{
    _htmlPageArticle = [[HtmlPageArticle alloc] init];
    _htmlPageArticle.article = article;
    _article = article;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.webView loadHTMLString:[self.htmlPageArticle htmlString] baseURL:nil];
    [self updateFavImage];
}

-(void)updateFavImage{
    if ([self.article.isFavour boolValue]) {
        [self.favBarButtonItem setImage:[UIImage imageNamed:@"icoFavTrue@2x.png"]];
    }else{
        [self.favBarButtonItem setImage:[UIImage imageNamed:@"icoFavFalse@2x.png"]];
    }

}
@end
