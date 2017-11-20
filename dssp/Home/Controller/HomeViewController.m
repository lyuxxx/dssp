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
#import "VINBindingViewController.h"
#import <CUHTTPRequest.h>

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
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"检测到您未绑定车辆信息,请绑定！"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件
        VINBindingViewController *vc=[[VINBindingViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
//    [self postCustByMobile];
    [self setupUI];
   
}

- (void)postCustByMobile
{
//    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    NSDictionary *paras = @{
                            @"userId": @"",
                            @"userName": @"",
                            
                            };
    [CUHTTPRequest POST:queryCustByMobile parameters:paras response:^(id responseData) {
        if (responseData) {
            
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//        CarInfoModel *CarInfo = [CarInfoModel yy_modelWithDictionary:dic];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            [hud hideAnimated:YES];
            
    
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
            message:@"检测到您未绑定车辆信息,请绑定！"
            preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                //响应事件
                VINBindingViewController *vc=[[VINBindingViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                
            }];
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
//            hud.label.text = [dic objectForKey:@"msg"];
//            [hud hideAnimated:YES afterDelay:1];
        }
            
        }
    }];
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
    _scroll.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        _scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_scroll];
    [_scroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, kTabbarHeight, 0));
    }];
    
    UIView *content = [[UIView alloc] init];
    [_scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scroll);
        make.width.equalTo(_scroll);
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
    
    UILabel *reportLabel = [[UILabel alloc] init];
    reportLabel.textColor = [UIColor colorWithHexString:@"#040000"];
    reportLabel.font = [UIFont fontWithName:FontName size:16];
    reportLabel.text = NSLocalizedString(@"行车报告", nil);
    [content addSubview:reportLabel];
    [reportLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(71.2 * WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.top.equalTo(_banner.bottom).offset(20 * HeightCoefficient);
        make.left.equalTo(7.5 * WidthCoefficient);
    }];
    
    UIImageView *reportImgV = [[UIImageView alloc] init];
    reportImgV.layer.cornerRadius = 4;
    reportImgV.backgroundColor = [UIColor colorWithHexString:@"#4d443e"];
    [content addSubview:reportImgV];
    [reportImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(359 * WidthCoefficient);
        make.height.equalTo(158 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(reportLabel.bottom).offset(10 * HeightCoefficient);
        make.bottom.equalTo(content.bottom).offset(-40 * HeightCoefficient);
    }];
    
    UILabel * innerLabel = [[UILabel alloc] init];
    innerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    innerLabel.textColor = [UIColor whiteColor];
    innerLabel.font = [UIFont fontWithName:FontName size:14];
    innerLabel.numberOfLines = 0;
    innerLabel.text = @"驾驶行为周\n2017-12-07";
    [reportImgV addSubview:innerLabel];
    [innerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(152.5 * WidthCoefficient);
        make.height.equalTo(50 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.layer.cornerRadius = 11 * HeightCoefficient;
    [detailBtn setTitle:NSLocalizedString(@"查看详细", nil) forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    detailBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
    [reportImgV addSubview:detailBtn];
    [detailBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(75 * WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.left.equalTo(9.5 * WidthCoefficient);
        make.top.equalTo(73 * HeightCoefficient);
    }];
    
    [self.view insertSubview:_scroll atIndex:0];
    
    [self.KVOController observe:self.scroll keyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
//        CGFloat newOffset = offset.y + 355 * HeightCoefficient;
        CGFloat newOffset = offset.y + 92 * WidthCoefficient + 53 * HeightCoefficient + 210 * HeightCoefficient;
        if (offset.y >= -(92 * WidthCoefficient + 53 * HeightCoefficient)) {
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
