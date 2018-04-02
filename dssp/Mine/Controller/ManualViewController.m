//
//  ManualViewController.m
//  dssp
//
//  Created by qinbo on 2018/3/21.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "ManualViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
@interface ManualViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic,strong) UIWebView *v;
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation ManualViewController

- (BOOL)needGradientBg {
    return NO;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.hidesBarsOnSwipe = YES;
    self.navigationItem.title = NSLocalizedString(@"用户手册", nil);
    self.rt_disableInteractivePop = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    self.navigationItem.leftBarButtonItem = left;
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
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sit-dssp.dstsp.com:50001/static/manual/usermanual.pdf"]]];
//    http://mozilla.github.io/pdf.js/web/viewer.html
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //允许三方向旋转
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isForceLandscape = NO;
    appDelegate.isForcePortrait = NO;
    [appDelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //重点说明：离开横屏时、横屏中跳转，记得强制旋转至竖屏；如果没有及时旋转至竖屏，会导致[UIScreen mainScreen].bounds没有及时更新，从而影响其它模块的布局问题
    //强制旋转至竖屏
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isForceLandscape = NO;
    appDelegate.isForcePortrait = YES;
    [appDelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)back:(UIButton *)sender {
    UIInterfaceOrientation current = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(current)) {
        //设置屏幕的转向为竖屏
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        //刷新
        [UIViewController attemptRotationToDeviceOrientation];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
