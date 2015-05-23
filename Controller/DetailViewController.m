//
//  DetailViewController.m
//  RssReaderFree
//
//  Created by oushunwu on 15/5/23.
//  Copyright (c) 2015年 oushunwu. All rights reserved.
//

#import "DetailViewController.h"
#import "HtmlPageArticle.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) HtmlPageArticle * htmlPageArticle;

@end

@implementation DetailViewController

-(void)setArticle:(Article *)article{
    _htmlPageArticle = [[HtmlPageArticle alloc] init];
    _htmlPageArticle.article = article;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadHTMLString:[self.htmlPageArticle htmlString]
                         baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
