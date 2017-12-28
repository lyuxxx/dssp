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
@interface DiscoverViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIButton *robotBtn;
@property(nonatomic,strong) UIButton *noticeBtn;
@property(nonatomic,strong) UIView *line1;
@property(nonatomic, strong) UIScrollView * scrollView;
@property(nonatomic, strong) NoticeViewController * noticeVC; //通知
@property(nonatomic, strong) SubscribeViewController * subscribeVC; //订阅
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
    [self setupUI];
}


-(void)requestData
{
    
    NSDictionary *paras = @{
                       
                            };
    
    
   NSString *NumberByVin = [NSString stringWithFormat:@"%@/VF7CAPSA000000002",findUnreadNumberByVin];
    

    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:NumberByVin parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            //            contract = [ContractModel yy_modelWithDictionary:dic[@"data"]];
            //            [_tableView reloadData];
            
            //响应事件
            
        } else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
    }];
}


-(void)setupUI
{
    self.navigationItem.title = NSLocalizedString(@"发现", nil);
    self.robotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_robotBtn setImage:[UIImage imageNamed:@"robot"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_robotBtn];
    [_robotBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"个人中心"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(74*HeightCoefficient+kStatusBarHeight);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
        make.height.equalTo(36 * HeightCoefficient);
         make.width.equalTo(1 * HeightCoefficient);
      
        
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
    UILabel *lastLabels = nil;

    for(int i = 0;i < placeHolders.count;i++)
    {
        self.noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [noticeBtn setImage:[UIImage imageNamed:@"robot"] forState:UIControlStateNormal];
        
//        _noticeBtn.backgroundColor=[UIColor redColor];
        
        _noticeBtn.tag = 100+i;
        [_noticeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_noticeBtn];
        
        
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.layer.cornerRadius = 36 * HeightCoefficient/2;
        imgV.layer.masksToBounds =YES;
        imgV.backgroundColor=[UIColor redColor];
        imgV.image = [UIImage imageNamed:imgArray[i]];
        [_noticeBtn addSubview:imgV];
       
        
        UILabel *label = [[UILabel alloc] init];
        label.text = placeHolders[i];
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = [UIFont fontWithName:FontName size:16];
        [_noticeBtn addSubview:label];
        
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.text = placeHolders[i];
        bottomLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        bottomLabel.font = [UIFont fontWithName:FontName size:13];
        [_noticeBtn addSubview:bottomLabel];
      
        
        if (i == 0) {
            [_noticeBtn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(0);
            make.height.equalTo(74*HeightCoefficient+kStatusBarHeight);
                make.width.equalTo(374.5*WidthCoefficient/2);
            }];
            
            [imgV makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(36 * HeightCoefficient);
                make.height.equalTo(36 * HeightCoefficient);
                make.left.equalTo(32 * WidthCoefficient);
                make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
            }];
            
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(65 * WidthCoefficient);
                make.height.equalTo(22.5 * WidthCoefficient);
            make.left.equalTo(imgV.right).offset(10*WidthCoefficient);
                make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
            }];
            
            [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(77.5 * WidthCoefficient);
                make.height.equalTo(13 * WidthCoefficient);
            make.left.equalTo(imgV.right).offset(10*WidthCoefficient);
          make.top.equalTo(label.bottom).offset(0.5*HeightCoefficient);
            }];
           
            
        } else {
            
            [_noticeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastBtn.right).offset(1*WidthCoefficient);
            make.top.equalTo(0);
            make.height.equalTo(74 * HeightCoefficient+kStatusBarHeight);
            make.width.equalTo(374.5 * WidthCoefficient/2);
            }];
            
            [imgV makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(36 * HeightCoefficient);
                make.height.equalTo(36 * HeightCoefficient);
            make.left.equalTo(lastimg.right).offset(152.5*WidthCoefficient);
                make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
            }];
            
            
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(65 * WidthCoefficient);
                make.height.equalTo(22.5 * WidthCoefficient);
            make.left.equalTo(imgV.right).offset(10*WidthCoefficient);
                make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
            }];
            
            [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(77.5 * WidthCoefficient);
                make.height.equalTo(13 * WidthCoefficient);
                make.left.equalTo(imgV.right).offset(10*WidthCoefficient);
               make.top.equalTo(label.bottom).offset(0.5*HeightCoefficient);
            }];
        }
        lastBtn = _noticeBtn;
        lastimg =imgV;
        lastLabel = label;
        lastLabels = bottomLabel;
      }

    
    
   
    self.line1 = [[UIView alloc] init];
    _line1.backgroundColor = [UIColor colorWithHexString:@"#C4B7A6"];
    [self.view addSubview:_line1];
    [_line1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.bottom.equalTo(_noticeBtn.bottom).offset(0);
        make.height.equalTo(3 * HeightCoefficient);
        make.width.equalTo(375 * WidthCoefficient / 2 );
    }];
    
    
    
      [self loadNoticeVC];
//    [self.view addSubview:self.scrollView];
    
//     CGFloat height =  kScreenHeight -(74 * HeightCoefficient+kStatusBarHeight)-kNaviHeight-kTabbarHeight;
//    self.noticeVC.view.frame = CGRectMake(0, 74 * HeightCoefficient+kStatusBarHeight, kScreenWidth, height);
//    [self addChildViewController:self.noticeVC];
//    [self.view addSubview:self.noticeVC.view];
//
//    self.subscribeVC.view.frame = CGRectMake(kScreenWidth, 74 * HeightCoefficient+kStatusBarHeight, kScreenWidth, height);
//    [self addChildViewController:self.subscribeVC];
//    [self.view addSubview:self.subscribeVC.view];

}


////通知
//- (NoticeViewController *)noticeVC{
//    if (_noticeVC == nil) {
//        _noticeVC = [[NoticeViewController alloc] init];
//    }
//    return _noticeVC;
//}
//
////订阅
//- (SubscribeViewController *)subscribeVC{
//    if (_subscribeVC == nil) {
//        _subscribeVC = [[SubscribeViewController alloc] init];
//    }
//    return _subscribeVC;
//}

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
   if(sender.tag==100)
   {
      [self loadNoticeVC];
      [_line1 updateConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(0);
       }];
   }
    else
    {
        [self loadSubscribeVC];
        [_line1 updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(375/2);
        }];
        [self.view layoutIfNeeded];
    }
}

-(void)loadNoticeVC
{
    _noticeVC = [[NoticeViewController alloc] init];
    CGFloat height =  kScreenHeight -(74 * HeightCoefficient+kStatusBarHeight)-kNaviHeight-kTabbarHeight;
    self.noticeVC.view.frame = CGRectMake(0, 74 * HeightCoefficient+kStatusBarHeight, kScreenWidth, height);

    [self.view addSubview:self.noticeVC.view];
    [self addChildViewController:self.noticeVC];
    [_subscribeVC.view removeFromSuperview];
}


-(void)loadSubscribeVC
{
    CGFloat height =  kScreenHeight -(74 * HeightCoefficient+kStatusBarHeight)-kNaviHeight-kTabbarHeight;
    _subscribeVC = [[SubscribeViewController alloc] init];
    self.subscribeVC.view.frame = CGRectMake(0, 74 * HeightCoefficient+kStatusBarHeight, kScreenWidth, height);
  
    [self.view addSubview:self.subscribeVC.view];
    [self addChildViewController:self.subscribeVC];
    [_noticeVC.view removeFromSuperview];
    
//    _subscribeVC = [[SubscribeViewController alloc] init];
//    _subscribeVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 400);
//    [self addChildViewController:_subscribeVC];
//     [_scrollView addSubview:_subscribeVC.view];
////    [_subscribeVC.view makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(kScreenWidth);
////        make.top.equalTo(_noticeBtn.bottom).offset(0);
//////        make.height.equalTo(kScreenHeight-kTabbarHeight);
////        make.width.equalTo(kScreenWidth);
////        make.bottom.equalTo(self.view).offset(kTabbarHeight);
////    }];
//    NSLog(@"101");
//
    
}

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
