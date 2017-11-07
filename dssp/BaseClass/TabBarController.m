//
//  TabBarController.m
//  dssp
//
//  Created by yxliu on 2017/10/31.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"

@interface TabBarController () <UINavigationControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

- (void)setup {
    NSArray *cls = @[
                     @"HomeViewController",
                     @"MapViewController",
                     @"StoreViewController",
                     @"MineViewController"
                     ];
    
    NSArray *titles = @[
                        NSLocalizedString(@"车主服务", nil),
                        NSLocalizedString(@"地图服务", nil),
                        NSLocalizedString(@"在线商城", nil),
                        NSLocalizedString(@"个人中心", nil)
                        ];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < cls.count; i++) {
        UIViewController *vc = [[NSClassFromString(cls[i]) alloc] init];
        NavigationController *naVC = [[NavigationController alloc] initWithRootViewController:vc];
        naVC.delegate = self;
        naVC.tabBarItem.title = titles[i];
        [naVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        [naVC.tabBarItem setImage:[UIImage imageNamed:@""]];
        [naVC.tabBarItem setSelectedImage:[UIImage imageNamed:@""]];
        
        [viewControllers addObject:naVC];
    }
    
    self.viewControllers = viewControllers;
}

///处理iPhone X tabbar上移以及管理隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSArray *needHideCls = @[
                             @"HomeViewController",
                             @"MapViewController"
                             ];
    
    BOOL needHideNavigationBar = NO;
    for (NSString *cl in needHideCls) {
        if ([viewController isKindOfClass:NSClassFromString(cl)]) {
            needHideNavigationBar = YES;
            break;
        }
    }
    [viewController.navigationController setNavigationBarHidden:needHideNavigationBar animated:YES];
    
    if (!Is_Iphone_X) {
        return;
    }
    CGRect frame = navigationController.tabBarController.tabBar.frame;
    if (frame.origin.y < ([UIScreen mainScreen].bounds.size.height - 83)) {
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 83;
        navigationController.tabBarController.tabBar.frame = frame;
    }
    
    
}

@end
