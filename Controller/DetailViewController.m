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

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) HtmlPageArticle * htmlPageArticle;
@property (strong, nonatomic) DetailBottonBar * detailBoottonBar;

@end

@implementation DetailViewController

-(void)setArticle:(Article *)article{
    _htmlPageArticle = [[HtmlPageArticle alloc] init];
    _htmlPageArticle.article = article;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_detailBoottonBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailBottonBar class]) owner:nil options:nil] lastObject];
    
    //CGRect frame = CGRectMake(0, (self.view.bounds.size.height-20), 20, self.view.bounds.size.width);
    //_detailBoottonBar.frame  = frame ;
   // self.webView.frame.size.height = @(10); // = (self.view.bounds.size.height-20) ;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.webView loadHTMLString:[self.htmlPageArticle htmlString] baseURL:nil];
}

@end
