//
//  SubscribeViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/18.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "SubscribeViewController.h"
#import "WMViewController.h"
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "SubscribeModel.h"
#import <YYCategoriesSub/YYCategories.h>
#import "NSObject+YYModel.h"
#import "StoreObject.h"
@interface SubscribeViewController ()<WMPageControllerDelegate,WMPageControllerDataSource>
{
    NSArray *dataArray;
}
@property(nonatomic,strong) WMPageController *createPages;
@property (nonatomic, strong) NSMutableArray *titleData;
@property (nonatomic, strong) NSMutableArray *idData;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) NSArray *placeHolders;
@property (nonatomic, strong) NSMutableArray *subscribeArray;
@property (nonatomic, strong) WMViewController *wmView;
@property (nonatomic, strong) NSMutableArray<WMViewController *> *viewcontrollers;
@end

@implementation SubscribeViewController

#pragma mark 标题数组

- (NSMutableArray<WMViewController *> *)viewcontrollers {
    if (!_viewcontrollers) {
        _viewcontrollers = [NSMutableArray array];
    }
    return _viewcontrollers;
}

- (NSMutableArray *)titleData {
    if (!_titleData) {
        _titleData = [[NSMutableArray alloc] init];
    }
    return _titleData;
}

- (NSMutableArray *)idData {
    if (!_idData) {
        _idData = [[NSMutableArray alloc] init];
    }
    return _idData;
}

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeNotification) name:@"SubscribeVCneedRefresh" object:nil];
    [super viewDidLoad];
    self.automaticallyCalculatesItemWidths = YES;
    
    self.view.clipsToBounds = YES;
    
     CGFloat height = kScreenHeight -(70 * HeightCoefficient)-kTabbarHeight-kNaviHeight;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, height);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.8,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];

    [self doAskTitleArray];
}

-(void)executeNotification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self doAskTitleArray];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     [self doAskTitleArray];
}

-(void)doAskTitleArray
{
    NSDictionary *paras = @{
                          };
     NSString *channelInfoList = [NSString stringWithFormat:@"%@/0",findAppPushChannelInfoList];
    
    [CUHTTPRequest POST:channelInfoList parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
           
            NSArray *dataArray = dic[@"data"];
            _subscribeArray =[NSMutableArray array];
            NSMutableArray *idDatas =[NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
            SubscribeModel *subscribe = [SubscribeModel yy_modelWithDictionary:dic];
           [self.subscribeArray addObject:subscribe.name];
           [idDatas addObject:subscribe.subscribeId];
            }
            self.titleData =_subscribeArray;
            self.idData = idDatas;
          
            NSLog(@"777%@",self.idData);
            //响应事件
            
            [self reloadData];
        } else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
    }];
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
     self.menuViewStyle = WMMenuViewStyleLine;
    return self.titleData.count;
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15.5;
    self.titleColorNormal = [UIColor colorWithHexString:@"#999999"];
    self.titleColorSelected = [UIColor colorWithHexString:GeneralColorString];
//    JCYJKTitleModel  * model = [self.titleArray  objectAtIndex:index];
//    NSString * titleString = model.titleString;
    return self.titleData[index];
}


- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
    self.postNotification = YES;
    self.delegate = self;
    NSLog(@"%@",info);
   
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {

    
//   NSArray *controllerArray = [NSArray arrayWithObjects:[ViewController class], [ViewController2 class], nil nil];
//    WMViewController  * controller = [self.controllerArray  objectAtIndex:index];
//    return controller;

    self.scrollView.backgroundColor = [UIColor clearColor];
    WMViewController *wmView = [[WMViewController alloc] init];
    NSString *ids =self.idData[index];
    wmView.indexs = ids;
    
    return wmView;
}

//- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
//    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
//    return width + 16;
//}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
   
    self.progressHeight = 3 * WidthCoefficient;
    self.progressViewCornerRadius = 1.5;
    return CGRectMake(0, 0, kScreenWidth, 44 * WidthCoefficient);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
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
