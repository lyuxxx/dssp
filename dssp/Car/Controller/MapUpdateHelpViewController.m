//
//  MapUpdateHelpViewController.m
//  dssp
//
//  Created by yxliu on 2018/1/29.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "MapUpdateHelpViewController.h"

@interface MapUpdateHelpViewController ()

@property (nonatomic, strong) UIScrollView *scroll;

@end

@implementation MapUpdateHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"地图升级帮助", nil);
    [self setupUI];
}

- (void)setupUI {
    self.scroll = [[UIScrollView alloc] init];
    _scroll.bounces = NO;
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    [_scroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *content = [[UIView alloc] init];
    [_scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scroll);
        make.height.equalTo(_scroll);
    }];
    
    UIImageView *lastView;
    NSArray *imgTitles = @[@"step1",@"step2",@"step3",@"step4",@"step5"];
    for (NSInteger i = 0; i < imgTitles.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.clipsToBounds = YES;
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.image = [UIImage imageNamed:imgTitles[i]];
        [content addSubview:imgV];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.top.bottom.equalTo(content);
                make.height.equalTo(kScreenHeight - kNaviHeight);
                make.width.equalTo(kScreenWidth);
            } else {
                make.top.bottom.equalTo(content);
                make.left.equalTo(lastView.right);
                make.height.equalTo(kScreenHeight - kNaviHeight);
                make.width.equalTo(kScreenWidth);
            }
        }];
        lastView = imgV;
        if (i == imgTitles.count - 1) {
            imgV.userInteractionEnabled = YES;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            [imgV addSubview:btn];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imgV);
                make.height.equalTo(43 * HeightCoefficient);
                make.width.equalTo(190 * WidthCoefficient);
                make.bottom.equalTo(-70 * HeightCoefficient);
            }];
        }
    }
    
    [lastView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(content.right);
    }];
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
