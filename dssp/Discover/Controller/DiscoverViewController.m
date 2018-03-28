//
//  DiscoverViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/23.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "DiscoverViewController.h"
#import <MBProgressHUD+CU.h>
#import <YYText.h>
#import <CUHTTPRequest.h>
#import <YYCategoriesSub/YYCategories.h>
#import "NoticeViewController.h"
#import "SubscribeViewController.h"
#import "UITabBar+badge.h"
#import "AppDelegate.h"
#import "VINBindingViewController.h"
@interface DiscoverViewController ()<UIScrollViewDelegate,UITabBarControllerDelegate>

@property(nonatomic,strong) UIButton *robotBtn;
@property(nonatomic,strong) UIButton *noticeBtn;
@property(nonatomic,strong) UIView *line1;
@property(nonatomic, strong) UIScrollView * scrollView;
@property(nonatomic, copy) NSString *unreadstrs;
@property(nonatomic, strong) NoticeViewController * noticeVC; //通知
@property(nonatomic, strong) SubscribeViewController * subscribeVC; //订阅
@property (nonatomic ,strong) UIViewController *currentVC;
@property (nonatomic ,strong) UILabel *bottomLabel;
@property (nonatomic ,strong) UILabel *bottomLabels;
@property (nonatomic, assign) BOOL isViewVisable;
@property (nonatomic ,strong) UIImageView *imgV;
@property (nonatomic ,strong) UIImageView *imgV1;
@end

@implementation DiscoverViewController
- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeNotification) name:@"DidReceivePayloadMsg" object:nil];

    //删除消息通知刷新消息条数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidReceiveloadMsg) name:@"DidReceiveloadMsg" object:nil];
    [self requestData];
    [self setupUI];
      
}

-(void)executeNotification
{
    if(self.isViewVisable){
        [self requestData];
        [self setupUI];
        //说明是当前页面，做些请求数据，更新页面的操作
          [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
    }
    else{
        //不是的话可能不需要做任何事情
    }
}

-(void)DidReceiveloadMsg
{
    [self requestData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PopupView" object:nil userInfo:nil];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"DiscoverViewController"];
    self.isViewVisable = YES;
    [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
    [self postCustByMobile];
    if (self.currentVC == self.noticeVC) {
        [self requestData];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isViewVisable = NO;
    
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"DiscoverViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"DiscoverViewController"];
}

- (void)postCustByMobile
{
    //    非车
    if ([kVin isEqualToString:@""]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
        [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"首页弹窗背景" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
        //            InputalertView.delegate = self;
        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview: popupView];
        
        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
            if (btn.tag == 100) {//左边按钮
                VINBindingViewController *vc=[[VINBindingViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        };
    }
    else
    {
        //非T车
        if([CuvhlTStatus isEqualToString:@"0"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
            [popupView initWithTitle:@"您当前不是T用户无法使用服务，若想使用服务，请升级为T用户!" img:@"首页弹窗背景1" type:12 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"",nil] ];
            //            InputalertView.delegate = self;
            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
            [keywindow addSubview: popupView];
            
            popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                
                
            };
            
            
        }
        else if ([CuvhlTStatus isEqualToString:@"1"])
        {
            //                    是否实名
            if([KcertificationStatus isEqualToString:@"1"])
            {
                //T车辆
                //                CarflowViewController *carflow = [[CarflowViewController alloc] init];
                //                carflow.hidesBottomBarWhenPushed = YES;
                //                [self.navigationController pushViewController:carflow animated:YES];
                
            }
            else
            {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                
                PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                [popupView initWithTitle:@"您当前还未完成实名制认证无法使用服务!" img:@"首页弹窗背景1" type:12 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"",nil] ];
                //            InputalertView.delegate = self;
                UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                [keywindow addSubview: popupView];
                
                popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                    if (btn.tag == 100) {//左边按钮
                        
                        
                        
                    }
                    
                };
                
            }
            
            
        }
        
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (_refresh) {
        [self refresh];
    }
}

-(void)requestData
{
    NSDictionary *paras = @{
                       
                            };
   NSString *NumberByVin = [NSString stringWithFormat:@"%@/%@",findUnreadNumberByVin,kVin];
    
//    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:NumberByVin parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            [hud hideAnimated:YES];
            // contract = [ContractModel yy_modelWithDictionary:dic[@"data"]];

            self.unreadstrs = [[NSString alloc] initWithFormat:@"%@", dic[@"data"]];
            self.unreadstr = _unreadstrs;
//            [(AppDelegate *)[UIApplication sharedApplication].delegate setBadgeNumber:_unreadstrs.integerValue];

            //响应事件
        } else {
            self.unreadstr = _unreadstrs;
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
          self.unreadstr = _unreadstrs;
//         [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
//        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
//        [hud hideAnimated:YES afterDelay:1];
    }];
}


-(void)setUnreadstr:(NSString *)unreadstr
{
    
    if([self isNull:unreadstr])
    {
        if([unreadstr isEqualToString:@"0"])
        {
            NSString *unreads = [[NSString stringWithFormat:@"%@",@""] stringByAppendingString:@"无未读消息"];
            _bottomLabel.text = unreads;
            
        }else
        {
            NSString *unreads = [[NSString stringWithFormat:@"%@",unreadstr] stringByAppendingString:@"条未读消息"];
            _bottomLabel.text = unreads;
            
        }
        
    }
    else
    {
        NSString *unreads = [[NSString stringWithFormat:@"%@",@""] stringByAppendingString:@"无未读消息"];
        _bottomLabel.text = unreads;
        
    }
 
}

-(BOOL)isNull:(id)object

{
    // 判断是否为空串
    
    if ([object isEqual:[NSNull null]]) {
        
        return NO;
        
    }
    
    else if ([object isKindOfClass:[NSNull class]])
        
    {
        
        return NO;
        
    }
    
    else if (object==nil){
        
        return NO;
        
    }
    
    return YES;
    
}


-(void)setupUI
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16 * WidthCoefficient, kNaviHeight - kStatusBarHeight - 37 * WidthCoefficient, 79.5 * WidthCoefficient, 30 * WidthCoefficient)];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"发现", nil);
    [self.navigationController.navigationBar addSubview:title];

    self.robotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_robotBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_robotBtn setImage:[UIImage imageNamed:@"机器人"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_robotBtn];
    [_robotBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"发现背景"];
//    bgImgV.backgroundColor =[UIColor redColor];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(70*HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    

    NSArray *placeHolders = @[
                              NSLocalizedString(@"通知", nil),
                              NSLocalizedString(@"订阅", nil),
                           
                              ];

    NSArray *imgArray = @[
                            NSLocalizedString(@"通知_icon", nil),
                              NSLocalizedString(@"订阅_icon", nil),
                              
                              ];
    
    
    
    UIButton *lastBtn = nil;
    UIImageView *lastimg = nil;
    UILabel *lastLabel = nil;
//    UILabel *lastLabels = nil;

    for(int i = 0;i < placeHolders.count;i++)
    {
        self.noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [noticeBtn setImage:[UIImage imageNamed:@"robot"] forState:UIControlStateNormal];
        
//        _noticeBtn.backgroundColor=[UIColor redColor];
        
        _noticeBtn.tag = 100+i;
        [_noticeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_noticeBtn];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.text = placeHolders[i];
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = [UIFont fontWithName:FontName size:16];
        [_noticeBtn addSubview:label];
        
        
        if (i==0) {
            
            self.imgV = [[UIImageView alloc] init];
            _imgV.image = [UIImage imageNamed:@"通知选中_icon"];
            [_noticeBtn addSubview:_imgV];
            [_imgV makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(36 * HeightCoefficient);
                make.height.equalTo(36 * HeightCoefficient);
                make.left.equalTo(32 * WidthCoefficient);
                make.centerY.equalTo(0);
            }];
            
        }
        else
        {
            
            self.imgV1 = [[UIImageView alloc] init];
            _imgV1.image = [UIImage imageNamed:imgArray[i]];
            [_noticeBtn addSubview:_imgV1];
            [_imgV1 makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(36 * HeightCoefficient);
                make.height.equalTo(36 * HeightCoefficient);
           make.left.equalTo(32 * WidthCoefficient);
                make.centerY.equalTo(0);
            }];
            
            
        }
        
        
        
      
        if (i == 0) {
            [_noticeBtn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(0);
                make.height.equalTo(70*HeightCoefficient);
                make.width.equalTo(374.5*WidthCoefficient/2);
            }];
            
           
            
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(65 * WidthCoefficient);
                make.height.equalTo(22.5 * WidthCoefficient);
                make.left.equalTo(_imgV.right).offset(10*WidthCoefficient);
                make.centerY.equalTo(0);
            }];
            
//            [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(77.5 * WidthCoefficient);
//                make.height.equalTo(13 * WidthCoefficient);
//            make.left.equalTo(imgV.right).offset(10*WidthCoefficient);
//          make.top.equalTo(label.bottom).offset(0.5*HeightCoefficient);
//            }];
            
        } else {
            
            [_noticeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastBtn.right).offset(1*WidthCoefficient);
            make.top.equalTo(0);
            make.height.equalTo(70 * HeightCoefficient);
            make.width.equalTo(374.5 * WidthCoefficient/2);
            }];
            
          
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(65 * WidthCoefficient);
                make.height.equalTo(22.5 * WidthCoefficient);
            make.left.equalTo(_imgV1.right).offset(10*WidthCoefficient);
                make.centerY.equalTo(0);
            }];
            
            
//            [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(77.5 * WidthCoefficient);
//                make.height.equalTo(13 * WidthCoefficient);
//                make.left.equalTo(imgV.right).offset(10*WidthCoefficient);
//               make.top.equalTo(label.bottom).offset(0.5*HeightCoefficient);
//            }];
        }
        lastBtn = _noticeBtn;
        lastimg =_imgV;
        lastLabel = label;
//        lastLabels = bottomLabel;
      }

    
    
    CGFloat height = kScreenHeight -(70 * HeightCoefficient);
    self.noticeVC = [[NoticeViewController alloc] init];
    [self.noticeVC.view setFrame:CGRectMake(0, 70*HeightCoefficient, kScreenWidth, height)];
    [self addChildViewController:self.noticeVC];


    _subscribeVC = [[SubscribeViewController alloc] init];
    [self.subscribeVC.view setFrame:CGRectMake(0, 70*HeightCoefficient, kScreenWidth, height)];

    // 默认,第一个视图
    [self.view addSubview:self.noticeVC.view];
    self.currentVC = self.noticeVC;
    

}


//scrollView
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        
        _scrollView = [[UIScrollView alloc] init];
        //        _scrollView.backgroundColor=[UIColor redColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        CGFloat height = kScreenHeight -(74 * HeightCoefficient+kStatusBarHeight)-kNaviHeight-kTabbarHeight;
        _scrollView.frame = CGRectMake(0, 74 * HeightCoefficient+kStatusBarHeight, kScreenWidth,height);
        //        _scrollView.backgroundColor=[UIColor yellowColor];
        _scrollView.contentSize = CGSizeMake(kScreenWidth *2, height);
        
        _scrollView.delegate = self;
        //        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.pagingEnabled = true;
    }
    return _scrollView;
}


-(void)BtnClick:(UIButton *)sender
{

    if ((self.currentVC == self.noticeVC && sender.tag == 100)||(self.currentVC == self.subscribeVC && sender.tag == 101)) {
        return;
    }else{
        if(sender.tag==100)
        {
            
            _imgV.image = [UIImage imageNamed:@"通知选中_icon"];
            _imgV1.image = [UIImage imageNamed:@"订阅_icon"];
            [self replaceController:self.currentVC newController:self.noticeVC];
            [_line1 updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
            }];
        }
        else if(sender.tag==101)
        {

             _imgV1.image = [UIImage imageNamed:@"订阅选中_icon"];
             _imgV.image = [UIImage imageNamed:@"通知_icon"];
            [self replaceController:self.currentVC newController:self.subscribeVC];
            [_line1 updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(375 *WidthCoefficient/2);
            }];
            [self.view layoutIfNeeded];
        }
        else if (self.robotBtn == sender)
        {
            
//            if ([KuserName isEqualToString:@"18911568274"]) {
//
//                [MBProgressHUD showText:NSLocalizedString(@"当前为游客模式，无此操作权限", nil)];
//
//            }
//            else
//            {
            
            UIViewController *vc = [[NSClassFromString(@"InformationCenterViewController") alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
//            }
        }
        
    }
    
}

// 切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *  着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的子视图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.5 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
            
        }
    }];
}



//-(void)loadNoticeVC
//{
//    _noticeVC = [[NoticeViewController alloc] init];
//    [self.view addSubview:self.noticeVC.view];
//    [self addChildViewController:self.noticeVC];
//    [_subscribeVC.view removeFromSuperview];
//    [self.noticeVC.view makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_noticeBtn.bottom).offset(0);
//            make.width.equalTo(kScreenWidth);
//            make.bottom.equalTo(-kTabbarHeight);
//           }];
//}
//
//-(void)loadSubscribeVC
//{
//    _subscribeVC = [[SubscribeViewController alloc] init];
//    [self.view addSubview:self.subscribeVC.view];
//    [self addChildViewController:self.subscribeVC];
//    [_noticeVC.view removeFromSuperview];
//    [self.subscribeVC.view makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_noticeBtn.bottom).offset(0);
//        make.width.equalTo(kScreenWidth);
//        make.bottom.equalTo(-kTabbarHeight);
//    }];
//
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_line1 updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.contentOffset.x/2);
        
    }];
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
