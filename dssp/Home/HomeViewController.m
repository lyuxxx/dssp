//
//  HomeViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "HomeViewController.h"
#import <MBProgressHUD+CU.h>

@interface HomeViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scroll = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.delegate = self;
        scroll.pagingEnabled = YES;
        [self.view addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(kScreenHeight / 3);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.safeAreaLayoutGuideTop);
            } else {
                make.top.equalTo(self.view.top);
            }
        }];
        
        UIView *contentView = [[UIView alloc] init];
        [scroll addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.height.equalTo(scroll);
        }];
        
        NSArray *colors = @[
                            [UIColor redColor],
                            [UIColor blueColor],
                            [UIColor purpleColor]
                            ];
        
        UIView *lastView = nil;
        
        for (NSInteger i = 0 ; i < 3; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = colors[i];
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
