//
//  SubscribeViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/18.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "SubscribeViewController.h"
#import "WMViewController.h"
#import "WMCollectionViewController.h"



@interface SubscribeViewController ()
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) NSArray *placeHolders;
@end

@implementation SubscribeViewController

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 44, self.view.frame.size.width, 2.0)];
        _redView.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    }
    return _redView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
        [self.view addSubview:self.redView];
    }
    
    self.automaticallyCalculatesItemWidths = YES;
    self.placeHolders = @[
                              NSLocalizedString(@"品牌", nil),
                              NSLocalizedString(@"新品发布", nil),
                              NSLocalizedString(@"服务", nil),
                              NSLocalizedString(@"DS精神", nil),
                              NSLocalizedString(@"金融活动", nil),
                              NSLocalizedString(@"推广", nil)
                              ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    switch (self.menuViewStyle) {
//        case WMMenuViewStyleFlood: return 3;
//        case WMMenuViewStyleSegmented: return 3;
        default: return 6;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
   switch (index) {
        case 0: return @"品牌";
        case 1: return @"新品发布";
        case 2: return @"服务";
        case 3: return @"DS精神";
        case 4: return @"金融活动";
        case 5: return @"推广";
      
   }
   return @"NONE";
    
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[WMViewController alloc] init];
        case 1: return [[WMViewController alloc] init];
        case 2: return [[WMCollectionViewController alloc] init];
    }
   return [[WMViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 16;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        return CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    }
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
//    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin+10, 0, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    }
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
        originY += self.redView.frame.size.height;
    }
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
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
