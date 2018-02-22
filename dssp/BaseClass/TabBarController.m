//
//  TabBarController.m
//  dssp
//
//  Created by yxliu on 2017/10/31.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "UITabBar+badge.h"
#import "DiscoverViewController.h"
@interface TabBarController () <UINavigationControllerDelegate,UITabBarControllerDelegate>

@end

@implementation TabBarController

- (BOOL)prefersStatusBarHidden
{
    return self.selectedViewController.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.selectedViewController.preferredStatusBarStyle;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeNotification) name:@"DidReceivePayloadMsg" object:nil];
    [self setup];
}

-(void)executeNotification
{
    NSLog(@"666%@",[self.tabBar.items objectAtIndex:1])
    [self.tabBar showBadgeOnItemIndex:1];
}

- (void)setup {
    NSArray *cls = @[
                     @"HomeViewController",
                     @"DiscoverViewController",
                     @"LoveCarViewController",
                     @"MineViewController"
                     ];
    
    NSArray *titles = @[
                        NSLocalizedString(@"首页", nil),
                        NSLocalizedString(@"发现", nil),
                        NSLocalizedString(@"爱车", nil),
                        NSLocalizedString(@"账户", nil)
                        ];
    
    NSArray *imgTitles = @[
                           @"tab_home_regular_icon",
                           @"tab_find_regular_icon",
                           @"tab_car_regular_icon",
                           @"tab_user_regular_icon"
                           ];
    
    NSArray *selectedImgTitles = @[
                                   @"tab_home_icon",
                                   @"tab_find_icon",
                                   @"tab_car_icon",
                                   @"tab_user_icon"
                                   ];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < cls.count; i++) {
        UIViewController *vc = [[NSClassFromString(cls[i]) alloc] init];
        RTRootNavigationController *naVC = [[RTRootNavigationController alloc] initWithRootViewController:vc];
        naVC.delegate = self;
        naVC.tabBarItem.title = titles[i];
        [naVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ac0042"],NSFontAttributeName:[UIFont fontWithName:FontName size:11]} forState:UIControlStateSelected];
        [naVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c4b7a6"],NSFontAttributeName:[UIFont fontWithName:FontName size:11]} forState:UIControlStateNormal];
        [naVC.tabBarItem setImage:[[UIImage imageNamed:imgTitles[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [naVC.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImgTitles[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [viewControllers addObject:naVC];
        
        
        if (i == 1) {
            DiscoverViewController *discoverVC = (DiscoverViewController *)vc;
            self.delegate = discoverVC;
         
      
        }
    }
   
    self.viewControllers = viewControllers;
}

///处理iPhone X tabbar上移以及管理隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
//    NSArray *needHideCls = @[
//                             @"MapHomeViewController",
//                             @"MineViewController"
//                             @"LoginViewController"
//                             ];
//
//    BOOL needHideNavigationBar = NO;
//    for (NSString *cl in needHideCls) {
//        if ([viewController isKindOfClass:NSClassFromString(cl)]) {
//            needHideNavigationBar = YES;
//            break;
//        }
//    }
//    [viewController.navigationController setNavigationBarHidden:needHideNavigationBar animated:YES];
//    
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
