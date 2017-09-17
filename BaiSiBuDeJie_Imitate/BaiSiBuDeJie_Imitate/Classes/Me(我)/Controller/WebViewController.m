//
//  WebViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/17.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()

/**    webView    */
@property (strong, nonatomic) WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    WKWebView *webView = [[WKWebView alloc] init];
    
    _webView = webView;
    
    [self.contentView addSubview:_webView];
    
    // 展示网页
    [webView loadRequest:[NSURLRequest requestWithURL:_url]];
    
    
    // 监听webVIew的属性
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];


}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.webView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64 - 44);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    self.goBackItem.enabled = self.webView.canGoBack;
    self.goForwardItem.enabled = self.webView.canGoForward;
    
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = self.webView.estimatedProgress >= 1;

    self.title = self.webView.title;
}

#pragma mark - 移除监听
- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];

}
#pragma mark - 返回
- (IBAction)goBack:(UIBarButtonItem *)sender {
    
    [self.webView goBack];
    
}
#pragma mark - 前进
- (IBAction)goForward:(id)sender {
    
    [self.webView goForward];
    
}
#pragma mark - 刷新
- (IBAction)reloadData:(UIBarButtonItem *)sender {
    
    [self.webView reload];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
