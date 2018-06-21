//
//  查询 QueryViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/28.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "QueryViewController.h"
#import "MineViewController.h"
#import "QueryModel.h"
#import "ContractModel.h"
#import "NSArray+Sudoku.h"
#import "QueryAlertView.h"
#import "QueryAlertController.h"
#import "QueryTipView.h"
#import <MJRefresh.h>

//  第一步提示按钮的tag
#define kStepOne 100
//  第二步提示按钮的tag
#define kStepTwo 101

@interface QueryViewController () <QueryTipViewDelegate>

@property (nonatomic,strong)QueryModel *queryModel;
@property (nonatomic,strong)ContractModel *contract;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation QueryViewController

#pragma mark- 重写方法
- (BOOL)needGradientBg {
    return YES;
}

#pragma mark- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"实名制结果查询", nil);
    
    self.rt_disableInteractivePop = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 24 * WidthCoefficient, 24 * WidthCoefficient);
    [btn addTarget:self action:@selector(backToHome1) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = left;
    
    //  添加scrollView
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.frame;
    
    //  scrollView的下拉刷新Block
    __weak typeof(self) weakSelf = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
        
        //  延时操作
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.scrollView.mj_header endRefreshing];
        });
        
    }];
    
    [self requestData];
  
}

- (void)backToHome1 {
   
    if ([self.types isEqualToString:@"2"]) {
//        for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
//            UIViewController *vc = self.navigationController.viewControllers[i];
//            if ([vc isKindOfClass:NSClassFromString(@"StoreTabViewController")]) {
//                //            StoreTabViewController *tabVC = (StoreTabViewController *)vc;
//                //            OrderPageController *pageController = [tabVC gotoOrderPageController];
//                //            if (pageController.selectIndex != 0) {
//                //                [pageController.menuView selectItemAtIndex:0];
//                //            }
//
//
//                [self.navigationController popToViewController:vc animated:YES];
//            }
//        }
        
         //从实名制与T服务结果查询进来的，就返回第二个界面
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        
      
    }
    else
    {
        // SearchresultViewController Push过来的就直接返回
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

#pragma mark- 网络请求状态
-(void)requestData
{
    NSDictionary *paras = @{
                             @"vin": _vin
                           };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryBindAndRNRStatus parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        [hud hideAnimated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
           _queryModel =[QueryModel yy_modelWithDictionary:dic[@"data"]];
            NSLog(@"%@",_queryModel.vhlStatus);
            [self setupUI];
        } else {
            [MBProgressHUD showText:[dic objectForKey:@"msg"]];
            [self setupUI];
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
        [self setupUI];
        [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
    }];
}

#pragma mark- 搭建界面
- (void)setupUI {
    
    // 用上面这个方法 连下拉加载的view也干掉了 不行
    //[[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 干掉子空间 然后重新布局
    for (UIView *subView in self.scrollView.subviews) {
        if (!([subView isKindOfClass:[MJRefreshNormalHeader class]])) {
            [subView removeFromSuperview];
        }
    }
    
    // 返回首页
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 2;
    [nextBtn setTitle:NSLocalizedString(@"返回首页", nil) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.scrollView addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(297 * HeightCoefficient);
    }];
    
    // 虚线背景
    UIImageView *logoImg =[[UIImageView alloc] init];
    logoImg.image =[UIImage imageNamed:@"Rectangle"];
    [self.scrollView addSubview:logoImg];
    [logoImg makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.mas_equalTo(self.view).offset(-(60*HeightCoefficient+kBottomHeight));
        make.width.equalTo (343*WidthCoefficient);
        make.height.equalTo (111*HeightCoefficient);
        make.centerX.equalTo(self.scrollView);
        make.top.mas_equalTo(nextBtn).offset(135 * HeightCoefficient);
    }];

    //  审核状态说明
    UILabel *lab = [[UILabel alloc] init];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor colorWithHexString:@"#A18E79"];
    lab.font = [UIFont fontWithName:FontName size:13];
    lab.text = NSLocalizedString(@"执行状态查询说明", nil);
    [logoImg addSubview:lab];
    [lab makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(180 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.left.equalTo(10*WidthCoefficient);
        make.top.equalTo(10*WidthCoefficient);
    }];

    //  状态的4个Label
    NSArray *title = @[
                       NSLocalizedString(@"执行成功", nil),
                       NSLocalizedString(@"执行中", nil),
                       NSLocalizedString(@"执行失败", nil),
                       NSLocalizedString(@"未执行", nil)
                       ];

    NSMutableArray<UIView *> *viewArray = [NSMutableArray arrayWithCapacity:title.count];

    for (NSInteger i = 0 ; i < title.count; i++) {

        UIView *views = [[UIView alloc] init];
        [logoImg addSubview:views];
        [viewArray addObject:views];


        UIImageView *logo = [[UIImageView alloc] init];

        [views addSubview:logo];
        [logo makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(18 * WidthCoefficient);
            make.height.equalTo(18 * WidthCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(0 *WidthCoefficient);
        }];


        UILabel *lab1 = [[UILabel alloc] init];
        lab1.textAlignment = NSTextAlignmentLeft;

        lab1.font = [UIFont fontWithName:FontName size:13];
        lab1.text = title[i];
        [views addSubview:lab1];
        [lab1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(150 * WidthCoefficient);
            make.height.equalTo(22.5 * HeightCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(logo.right).offset(10*WidthCoefficient);

        }];

        if (i==0) {
            lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
            logo.image = [UIImage imageNamed:@"认证成功_icon"];
        }
        if (i==1) {

            lab1.textColor = [UIColor colorWithHexString:@"#E2CD8D"];
            logo.image = [UIImage imageNamed:@"审核中_icon"];
        }
        if (i==2) {
            lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
            logo.image = [UIImage imageNamed:@"失败_icon"];
        }
        if (i==3) {
            lab1.textColor = [UIColor colorWithHexString:@"#999999"];
            logo.image = [UIImage imageNamed:@"认证中_icon"];
        }

    }

    //  流水布局
    [viewArray mas_distributeSudokuViewsWithFixedItemWidth:100*WidthCoefficient fixedItemHeight:20* HeightCoefficient warpCount:2 topSpacing:47 * HeightCoefficient bottomSpacing:12 * HeightCoefficient leadSpacing:10 * WidthCoefficient tailSpacing:100 * WidthCoefficient];

    //  最下面的一段话
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.textAlignment = NSTextAlignmentLeft;
    [lab2 setNumberOfLines:0];
    lab2.textColor = [UIColor colorWithHexString:@"#ffffff"];
    lab2.text = @"*如果超过半小时车辆还未激活成功，请联系人工客服处理";
    CGRect tmpRect= [lab2.text boundingRectWithSize:CGSizeMake(343*WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:FontName size:13]} context:nil];

    CGFloat contentH = tmpRect.size.height;
    lab2.font = [UIFont fontWithName:FontName size:13];
    [self.scrollView addSubview:lab2];
    [lab2 makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(contentH+1);
        make.top.equalTo(logoImg.bottom).offset(10*HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
        make.right.equalTo(-16*WidthCoefficient);
    }];
    
    
    //  状态列表的布局
    NSArray *titles = @[
                        NSLocalizedString(@"实名制认证", nil),
                        NSLocalizedString(@"车辆激活", nil),
                        NSLocalizedString(@"T服务套餐开通", nil),
                        NSLocalizedString(@"完成", nil)
                        ];
    
    

    UIView *lastView = nil;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        
        //  外约束层
        UIView *view1 = [[UIView alloc] init];
        view1.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:view1];
        
        
        if (i==0) {
            
            [view1 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(19 * WidthCoefficient);
                make.height.equalTo(22 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(41 * HeightCoefficient);
            }];
            
        } else {
            [view1 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(19 * WidthCoefficient);
                make.height.equalTo(22 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(lastView.bottom).offset(42.5 * HeightCoefficient);
            }];
        }
        
        lastView = view1;
        
        //  图标
        UIImageView *logo = [[UIImageView alloc] init];
        [view1 addSubview:logo];
        [logo makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(18 * WidthCoefficient);
            make.height.equalTo(18 * WidthCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(0);
        }];
        
        //  文字
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.text = titles[i];
        lab1.font = [UIFont fontWithName:FontName size:16];
        [view1 addSubview:lab1];
        [lab1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(22.5 * HeightCoefficient);
            make.centerY.equalTo(view1);
            make.left.equalTo(logo.right).offset(18*WidthCoefficient);
            
        }];
        
        //  竖线的布局
        UIView *lineview = [[UIView alloc] init];
        lineview.backgroundColor = [UIColor colorWithHexString:@"#D1D1D6"];
        [self.scrollView addSubview:lineview];
        [lineview makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(1 * WidthCoefficient);
            make.height.equalTo(49 * HeightCoefficient);
            make.left.equalTo(28 * WidthCoefficient);
            make.top.equalTo(logo.bottom).offset(0);
        }];
        
        //  提示按钮
        UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tipButton.frame = CGRectMake(0, 0, 20 * WidthCoefficient, 20 * HeightCoefficient);
        [tipButton setImage:[UIImage imageNamed:@"realName_tip"] forState:UIControlStateNormal];
        [tipButton setImage:[UIImage imageNamed:@"realName_tip"] forState:UIControlStateHighlighted];
        [tipButton addTarget:self action:@selector(tipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        tipButton.hidden = YES;
        
        
        if (i==0) {
            
            //  第一步的提示按钮的布局
            [view1 addSubview:tipButton];
            tipButton.tag = kStepOne;
            [tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(lab1.trailing).offset(5 * WidthCoefficient);
                make.centerY.mas_equalTo(view1);
            }];
            
            if ([_queryModel.rnrStatus isEqualToString:@"0"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                lab1.text = @"未提交实名认证";
                logo.image = [UIImage imageNamed:@"认证中_icon"];

            } else if ([_queryModel.rnrStatus isEqualToString:@"1"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#E2CD8D"];
                logo.image = [UIImage imageNamed:@"审核中_icon"];
                lab1.text = [lab1.text stringByAppendingString: @" ——— 人工审核中"];
                
                //  执行中 不隐藏 提示按钮
                //tipButton.hidden = NO;
                //[self queryAlertControllerPresentWithTag:kStepOne];
                logoImg.hidden = true;
                lab2.hidden = true;
                [self setUpQueryTipViewWithNextBtn:nextBtn tag:kStepOne];
            } else if ([_queryModel.rnrStatus isEqualToString:@"2"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                lab1.text = @"实名制认证成功";
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
            } else if ([_queryModel.rnrStatus isEqualToString:@"3"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                lab1.text = @"未提交实名认证";
                logo.image = [UIImage imageNamed:@"认证中_icon"];
                
            } else if ([_queryModel.rnrStatus isEqualToString:@"4"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                lab1.text = @"实名制认证失败,请重新提交";
                logo.image = [UIImage imageNamed:@"失败_icon"];
                
                //  执行失败 不隐藏 提示按钮
                //tipButton.hidden = NO;
                //[self queryAlertControllerPresentWithTag:kStepOne];
                logoImg.hidden = true;
                lab2.hidden = true;
                [self setUpQueryTipViewWithNextBtn:nextBtn tag:kStepOne];
            } else {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            
        }
        if (i==1) {
            
            //  第二步的提示按钮的布局
            [view1 addSubview:tipButton];
            tipButton.tag = kStepTwo;
            [tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(lab1.trailing).offset(5 * WidthCoefficient);
                make.centerY.mas_equalTo(view1);
            }];
            
            if ([_queryModel.rcStatus isEqualToString:@"0"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            } else if ([_queryModel.rcStatus isEqualToString:@"1"]) {
                
                lab1.textColor = [UIColor colorWithHexString:@"#E2CD8D"];
                lab1.text = @"车辆配置中";
                logo.image = [UIImage imageNamed:@"审核中_icon"];
                
                //  执行中 不隐藏 提示按钮
                //tipButton.hidden = NO;
                //[self queryAlertControllerPresentWithTag:kStepTwo];
                logoImg.hidden = true;
                lab2.hidden = true;
                [self setUpQueryTipViewWithNextBtn:nextBtn tag:kStepTwo];
            } else if ([_queryModel.rcStatus isEqualToString:@"2"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                lab1.text = @"车辆激活成功";
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
            } else if ([_queryModel.rcStatus isEqualToString:@"3"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                lab1.text = @"车辆激活失败";
                logo.image = [UIImage imageNamed:@"失败_icon"];
                
                //  执行失败 不隐藏 提示按钮
                //tipButton.hidden = NO;
                //[self queryAlertControllerPresentWithTag:kStepTwo];
                logoImg.hidden = true;
                lab2.hidden = true;
                [self setUpQueryTipViewWithNextBtn:nextBtn tag:kStepTwo];
            } else {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            
        }
        if (i==2) {
            
            if ([_queryModel.simStatus isEqualToString:@"0"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            } else if ([_queryModel.simStatus isEqualToString:@"1"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                lab1.text = @"T服务开通成功";
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
            } else if ([_queryModel.simStatus isEqualToString:@"2"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                lab1.text = @"T服务开通失败";
                logo.image = [UIImage imageNamed:@"失败_icon"];
            } else {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            
        }
        if (i==3) {
            
           if ([_queryModel.rnrStatus isEqualToString:@"2"]&&[_queryModel.rcStatus isEqualToString:@"2"]&&[_queryModel.simStatus isEqualToString:@"1"])
            {
                
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
                
                NSDictionary *paras = @{
                                        @"vin": kVin,
                                        @"currentPage":@"1",
                                        @"pageSize":@"5"
                                        };
                [CUHTTPRequest POST:queryContractForApp parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        NSArray *dataArray =dic[@"data"][@"result"];
                        
                        for (NSDictionary *dic in dataArray) {
                            _contract = [ContractModel yy_modelWithDictionary:dic];
                        }
                        
                        if ([_contract.contractStatus isEqualToString:@"1"]) {
                            NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                            [defaults1 setObject:_contract.contractStatus forKey:@"contractStatus"];
                            [defaults1 synchronize];
                        }
                        else
                        {
                            NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                            [defaults1 setObject:@"" forKey:@"contractStatus"];
                            [defaults1 synchronize];
                            
                        }
                        
                        NSLog(@"5543%@",_contract.contractStatus);
                        
                    } else {
                        
                        
                    }
                } failure:^(NSInteger code) {
                    
                }];
                
                
                NSString *certificationStatus = @"1";
                NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
                [defaults3 setObject:certificationStatus forKey:@"certificationStatus"];
                [defaults3 synchronize];
                
            }
            else
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            lineview.hidden = YES;
        }
    }
 }

#pragma mark- 按钮的点击事件


/**
 下一步按钮的点击
 */
-(void)nextBtnClick
{
    UIViewController *viewCtl = self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:viewCtl animated:YES];
}

/**
 提示按钮的点击
 */
- (void)tipButtonAction:(UIButton *)button {
    //[self alertShow:button];
    [self queryAlertControllerPresentWithTag:button.tag];
}

#pragma mark- 打电话的方法
- (void)contactCustomerService {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",kphonenumber]] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",kphonenumber]]];
    }
}


#pragma mark- 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
    }
    return  _scrollView;
}

#pragma mark- 新的弹窗方法
- (void)alertShow:(UIButton *)button {
    QueryAlertView *alertView = [[QueryAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) tag:button.tag];
    [alertView show];
}

#pragma mark- 旧的弹窗方法
- (void)oldAlertShow:(UIButton *)button {
    NSString *title = @"";
    if (button.tag == kStepOne) {
        NSLog("第一步的提示按钮点击");
        title = @"如果提交的实名信息超过2个小时未成功,请联系人工客服处理";
    }else if (button.tag == kStepTwo) {
        NSLog("第二步的提示按钮点击");
        title = @"如果车辆激活超过2个小时未成功,请尝试一下操作:\n1.在户外启动车辆十分钟\n2.拨打人工客服处理";
    }else {
        
    }
    
    //  type 9 是单个选项按钮
    //  type 10 是双选项按钮
    //  type 11 是输入框
    InputAlertView *inputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    inputalertView.tag = button.tag;
    [inputalertView initWithTitle:title img:@"电话_icon" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"取消",@"联系客服",nil] ];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: inputalertView];
    
    inputalertView.clickBlock = ^(UIButton *btn, NSString *str) {
        //   100 是左边的按钮 101 是右边的按钮
        if (btn.tag == 101) {
            [self contactCustomerService];
        }
    };
}

#pragma mark- alertController present
- (void) queryAlertControllerPresentWithTag:(NSInteger)tag {
    QueryAlertController *queryAlerVC = [QueryAlertController new];
    queryAlerVC.tag = tag;
    [self presentViewController:queryAlerVC animated:true completion:nil];
}
    
#pragma mark- QueryTipView的创建与布局
- (void)setUpQueryTipViewWithNextBtn:(UIButton *)nextBtn tag:(NSInteger)tag  {
    QueryTipView *tipView = [[QueryTipView alloc] initWithTag:tag];
    [self.scrollView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo (343*WidthCoefficient);
        //make.height.equalTo (155*HeightCoefficient);
        make.centerX.equalTo(self.scrollView);
        make.top.mas_equalTo(nextBtn).offset(108 * HeightCoefficient);
    }];
    tipView.delegate = self;
}

#pragma mark- QueryTipView的代理
- (void)queryTipView:(QueryTipView *)queryTipView callButtonAction:(UIButton *)button {
    [self contactCustomerService];
}

@end
