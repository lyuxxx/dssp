//
//  ManualViewController.m
//  dssp
//
//  Created by qinbo on 2018/3/21.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "ManualViewController.h"
#import <WebKit/WebKit.h>
@interface ManualViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong) UIWebView *v;
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation ManualViewController

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"用户手册", nil);
    self.webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dssp.dstsp.com/ow/#/UserManual"]]];
    
     [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mozilla.github.io/pdf.js/web/viewer.html"]]];
//    http://mozilla.github.io/pdf.js/web/viewer.html
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
