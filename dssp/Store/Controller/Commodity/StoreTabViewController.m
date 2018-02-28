//
//  StoreTabViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/6.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreTabViewController.h"
#import "StorePageController.h"
#import "OrderPageController.h"

@interface StoreTabViewController () <UITabBarDelegate>
@property (nonatomic, strong) StorePageController *homeVC;
@property (nonatomic, strong) OrderPageController *orderVC;
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) UITabBar *tabBar;
@end

@implementation StoreTabViewController

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"商城", nil);
    
    self.homeVC = [[StorePageController alloc] init];
    self.homeVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight - kTabbarHeight - 1 + kNaviHeight);//高度会自动减一个导航栏高度,原因未知...
    [self addChildViewController:_homeVC];
    //addChildViewController 会调用 [child willMoveToParentViewController:self] 方法，但是不会调用 didMoveToParentViewController:方法，官方建议显示调用
    [_homeVC didMoveToParentViewController:self];

    self.orderVC = [[OrderPageController alloc] init];
    self.orderVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight - kTabbarHeight - 1);//TabBar ShadowImage高度1

    [self.view addSubview:self.homeVC.view];
    self.currentVC = self.homeVC;
    
    [self setupTabBar];
}

- (void)setupTabBar {
    self.tabBar = [[UITabBar alloc] init];
    [_tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#040000"]]];
    _tabBar.shadowImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"#2f2726"] size:CGSizeMake(kScreenWidth, 1)];
    _tabBar.delegate = self;
    NSArray *titles = @[
                        NSLocalizedString(@"首页", nil),
                        NSLocalizedString(@"订单", nil)
                        ];
    
    NSArray *imgTitles = @[
                           @"store_tab_normal",
                           @"order_tab_normal"
                           ];
    
    NSArray *selectedImgTitles = @[
                                   @"store_tab_selected",
                                   @"order_tab_selected"
                                   ];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
    for (NSInteger i = 0; i < titles.count; i++) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titles[i] image:[[UIImage imageNamed:imgTitles[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImgTitles[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        item.tag = 100 + i;
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#a18e79"],NSFontAttributeName:[UIFont fontWithName:FontName size:11]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ac0042"],NSFontAttributeName:[UIFont fontWithName:FontName size:11]} forState:UIControlStateSelected];
        [items addObject:item];
    }
    _tabBar.items = items;
    [self.view addSubview:_tabBar];
    [_tabBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(kTabbarHeight);
    }];
    _tabBar.selectedItem = items[0];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 100) {
        if (self.currentVC == self.orderVC) {
            [self replaceController:self.currentVC newController:self.homeVC];
            self.navigationItem.title = NSLocalizedString(@"商城", nil);
        }
    } else {
        if (self.currentVC == self.homeVC) {
            [self replaceController:self.currentVC newController:self.orderVC];
            self.navigationItem.title = NSLocalizedString(@"订单", nil);
        }
    }
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.1 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
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

#pragma mark - lazy load -

- (StorePageController *)homeVC {
    if (!_homeVC) {
        _homeVC = [[StorePageController alloc] init];
    }
    return _homeVC;
}

- (OrderPageController *)orderVC {
    if (!_orderVC) {
        _orderVC = [[OrderPageController alloc] init];
    }
    return _orderVC;
}

@end
