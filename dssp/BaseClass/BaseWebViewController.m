//
//  BaseWebViewController.m
//  dssp
//
//  Created by yxliu on 2018/3/21.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>
#import <MJRefresh.h>
#import "AppDelegate.h"

@interface BaseWebViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progress;

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;
@end

@implementation BaseWebViewController

- (BOOL)prefersStatusBarHidden {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL)needGradientBg {
    return YES;
}

- (instancetype)initWithURL:(NSString *)str {
    self = [super init];
    if (self) {
        _urlString = str;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addObserver];
    [self loadRequest];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView stopLoading];
    //    _wkWebView.UIDelegate = nil;
    _wkWebView.navigationDelegate = nil;
}


- (void)setupUI {
    [self showLeftBarButtonItem];
    [self.view addSubview:self.wkWebView];
    [self.wkWebView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.progress];
    [self.progress makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(2 * WidthCoefficient);
    }];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidRotate) name:UIDeviceOrientationDidChangeNotification object:nil];//设备旋转
}

- (void)loadRequest {
    if (![self.urlString hasPrefix:@"http"]) {
        self.urlString = [NSString stringWithFormat:@"http://%@",self.urlString];
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]];
    [self.wkWebView loadRequest:request];
}

- (void)showLeftBarButtonItem {
    self.navigationItem.leftBarButtonItems = nil;
    if ([self.wkWebView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeBarButtonItem];
        [self.backBarButtonItem.customView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(24 * WidthCoefficient);
        }];
        [self.closeBarButtonItem.customView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(50 * WidthCoefficient);
            make.height.equalTo(24 * WidthCoefficient);
        }];
    } else {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem];
        [self.backBarButtonItem.customView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(24 * WidthCoefficient);
        }];
    }
}

- (void)wkWebViewReload {
    [self.wkWebView reload];
}

// 进入全屏
-(void)begainFullScreen
{
    //允许三方向旋转
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isForceLandscape = NO;
    appDelegate.isForcePortrait = NO;
    [appDelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

// 退出全屏
-(void)endFullScreen
{
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

//更新状态栏
- (void)videoDidRotate {
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - 导航按钮 -

- (void)back:(UIButton *)item {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close:(UIButton *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - estimatedProgress KVO -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progress setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progress.progress;
        [self.progress setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progress setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progress setProgress:0.0f animated:NO];
            }];
        }
    }
}

#pragma mark - WKNavigationDelegate -

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progress.hidden = NO;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        self.navigationItem.title = result;
    }];
    
    [self showLeftBarButtonItem];
    [self.wkWebView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

//返回内容是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {

}

#pragma mark - WKUIDelegate -

//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//
//}
//
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
//
//}
//
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
//
//}

#pragma mark - WKScriptMessageHandler -
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);
    //    // 方法名
    //    NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
    //    SEL selector = NSSelectorFromString(methods);
    //    // 调用方法
    //    if ([self respondsToSelector:selector]) {
    //        [self performSelector:selector withObject:message.body];
    //    } else {
    //        NSLog(@"未实行方法：%@", methods);
    //    }

    if([message.name isEqualToString:@"jsCallOc"]){
        // do something
    }
}

#pragma mark - lazy load -

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.selectionGranularity = YES;
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"jsCallOC"];
        
        if (self.jsString) {
            WKUserScript *jsString = [[WKUserScript alloc] initWithSource:self.jsString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
            [userContentController addUserScript:jsString];
        }
        configuration.userContentController = userContentController;
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
//        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        
        if (_canDownRefresh) {
            _wkWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(wkWebViewReload)];
        }
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _wkWebView;
}

- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progress.trackTintColor = [UIColor clearColor];
        _progress.progressTintColor = _loadingProgressColor ? _loadingProgressColor : [UIColor colorWithHexString:@"#ac0042"];
    }
    return _progress;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24 * WidthCoefficient]];
//        [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24 * WidthCoefficient]];
        [button setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24 * WidthCoefficient]];
//        [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24 * WidthCoefficient]];
        [button setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        _closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _closeBarButtonItem;
}

@end
