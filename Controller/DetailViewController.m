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
    [self resizeImage];
    NSLog([self.htmlPageArticle htmlString]);
    [self.webView loadHTMLString:[self.htmlPageArticle htmlString] baseURL:nil];
    //[self resizeImage];
    [self updateFavImage];
    //[self getImageUrl];
}

-(void)getImageUrl{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTouchesRequired = 2;
    [self.webView addGestureRecognizer:doubleTap];
}

-(void) doubleTap :(UITapGestureRecognizer*) sender
{
    //  <Find HTML tag which was clicked by user>
    //  <If tag is IMG, then get image URL and start saving>
    int scrollPositionY = [[self.webView stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
    int scrollPositionX = [[self.webView stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] intValue];
    
    int displayWidth = [[self.webView stringByEvaluatingJavaScriptFromString:@"window.outerWidth"] intValue];
    CGFloat scale = self.webView.frame.size.width / displayWidth;
    
    CGPoint pt = [sender locationInView:self.webView];
    pt.x *= scale;
    pt.y *= scale;
    pt.x += scrollPositionX;
    pt.y += scrollPositionY;
    
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", pt.x, pt.y];
    NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
    if ([tagName isEqualToString:@"img"]) {
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
        //NSLog(@"image url=%@", urlToSave);
    }
}

-(void)resizeImage{
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=20;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];

    NSString *js_result = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('q')[0].value='朱祁林';"];
    NSLog(@"js_result = %@",js_result);
}


-(void)updateFavImage{
    if ([self.article.isFavour boolValue]) {
        [self.favBarButtonItem setImage:[UIImage imageNamed:@"icoFavTrue@2x.png"]];
    }else{
        [self.favBarButtonItem setImage:[UIImage imageNamed:@"icoFavFalse@2x.png"]];
    }

}
@end
