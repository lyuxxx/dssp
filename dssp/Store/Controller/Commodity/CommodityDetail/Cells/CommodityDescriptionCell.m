//
//  CommodityDescriptionCell.m
//  dssp
//
//  Created by yxliu on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityDescriptionCell.h"
#import "NSString+Size.h"


NSString * const CommodityDescriptionCellIdentifier = @"CommodityDescriptionCellIdentifier";

@interface CommodityDescriptionCell () <WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, assign) CGFloat webViewHeight;
@property (nonatomic, assign) BOOL noNeedLoad;
@end

@implementation CommodityDescriptionCell

//- (void)dealloc {
//    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    _webView.scrollView.delegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_webView];
    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView).offset(CGPointMake(0, -2.5 * WidthCoefficient));
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(10 * WidthCoefficient);
    }];
    
    self.bg = [[UIView alloc] init];
    _bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    _bg.layer.cornerRadius = 4;
    _bg.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    _bg.layer.shadowOffset = CGSizeMake(0, 6);
    _bg.layer.shadowRadius = 7;
    _bg.layer.shadowOpacity = 0.5;
    [self.contentView addSubview:_bg];
    [_bg makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView).offset(UIEdgeInsetsMake(-10 * WidthCoefficient, -10 * WidthCoefficient, -10 * WidthCoefficient, -10 * WidthCoefficient));
//        make.top.equalTo(0);
//        make.left.equalTo(16 * WidthCoefficient);
//        make.right.equalTo(-16 * WidthCoefficient);
//        make.bottom.equalTo(-10 * WidthCoefficient);
    }];
    
    [self.contentView insertSubview:_bg atIndex:0];
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return nil;
//}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
////    _noNeedLoad = YES;
////    [_webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
////        _webViewHeight = ((NSNumber *)result).floatValue;
////        [_webView updateConstraints:^(MASConstraintMaker *make) {
////            make.height.equalTo(_webViewHeight);
////        }];
////        [self.tableView reloadData];
////    }];
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        _noNeedLoad = YES;
////        CGSize contentSize = [self.webView sizeThatFits:CGSizeZero];
//        CGSize contentSize = self.webView.scrollView.contentSize;
//        _webViewHeight = contentSize.height;
//        [_webView updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(_webViewHeight);
//        }];
////        [self.tableView reloadRowAtIndexPath:_myIndexPath withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView reloadData];
//    }
//}

//- (void)configWithCommodityDescription:(NSString *)desc {
//    if (!_noNeedLoad) {
//        [_webView loadHTMLString:desc baseURL:nil];
//    }
//}

//- (CGFloat)cellHeightWithCommodityDescription:(NSString *)desc {
//    return _webViewHeight + 25 * WidthCoefficient;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bg.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bg.bounds;
    maskLayer.path = maskPath.CGPath;
    _bg.layer.mask = maskLayer;
    _bg.layer.masksToBounds = YES;
}

@end
