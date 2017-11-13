//
//  HomeViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "HomeViewController.h"
#import <MBProgressHUD+CU.h>
#import <YYCategoriesSub/YYCategories.h>
#import <YYText.h>
#import "TopImgButton.h"
#import "HomeTopView.h"
#import <NSObject+FBKVOController.h>

@interface HomeViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *robotBtn;
@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIScrollView *banner;

@end

@implementation HomeViewController

- (BOOL)needGradientImg {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    
    self.robotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_robotBtn setImage:[UIImage imageNamed:@"robot"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_robotBtn];
    [_robotBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    
    self.topView = [[HomeTopView alloc] init];
    [self.view addSubview:_topView];
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(0);
        make.height.equalTo(355 * HeightCoefficient);
    }];
    
    self.scroll = [[UIScrollView alloc] init];
    _scroll.contentInset = UIEdgeInsetsMake(355 * HeightCoefficient, 0, 0, 0);
    _scroll.scrollIndicatorInsets = UIEdgeInsetsMake(355 * HeightCoefficient, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        _scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_scroll];
    [_scroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *content = [[UIView alloc] init];
    [_scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scroll);
        make.width.equalTo(_scroll);
        make.height.equalTo(1000);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [_scroll addGestureRecognizer:tap];
    
    self.banner = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.delegate = self;
        scroll.pagingEnabled = YES;
        [content addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(359 * WidthCoefficient);
            make.height.equalTo(101.5 * HeightCoefficient);
            make.centerX.equalTo(0);
            make.top.equalTo(4 * HeightCoefficient);
        }];
        
        UIView *contentView = [[UIView alloc] init];
        [scroll addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.height.equalTo(scroll);
        }];
        
        UIView *lastView = nil;
        
        for (NSInteger i = 0 ; i < 3; i++) {
            UIImageView *view = [[UIImageView alloc] init];
            view.image = [UIImage imageNamed:@"广告"];
            [contentView addSubview:view];
            if (i == 0) {
                [view makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(contentView);
                    make.width.equalTo(scroll);
                }];
            } else {
                [view makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(contentView);
                    make.left.equalTo(lastView.right);
                    make.width.equalTo(scroll);
                }];
            }
            lastView = view;
        }
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.right);
        }];
        
        scroll;
     });
    
    [self.view insertSubview:_scroll atIndex:0];
    
    [self.KVOController observe:self.scroll keyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat newOffset = offset.y + 355 * HeightCoefficient;
        if (offset.y >= -145 * HeightCoefficient) {
            [_topView updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(-210 * HeightCoefficient);
            }];
        } else {
            [_topView updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(-newOffset);
            }];
        }
    }];
}

- (void)didTap:(UITapGestureRecognizer *)sender {
    [self.topView didTapWithPoint:[sender locationInView:_topView]];
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSInteger temPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
//    if (temPage == 0) {
//        [self.scroll setContentOffset:CGPointMake(scrollView.bounds.size.width * 3, 0) animated:NO];
//    } else if (temPage == 2) {
//        [self.scroll setContentOffset:CGPointMake(scrollView.bounds.size.width * 3, 0) animated:NO];
//    }
//}

@end
