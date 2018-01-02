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
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "SubscribeModel.h"
#import <YYCategoriesSub/YYCategories.h>
#import "NSObject+YYModel.h"
@interface SubscribeViewController ()
{
    
    NSArray *dataArray;
}
@property(nonatomic,strong) WMPageController *createPages;
@property (nonatomic, strong) NSMutableArray *titleData;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) NSArray *placeHolders;
@property (nonatomic, strong) NSMutableArray *subscribeArray;
@end

@implementation SubscribeViewController

#pragma mark 标题数组
- (NSMutableArray *)titleData {
    if (!_titleData) {
        _titleData = [[NSMutableArray alloc] init];
    }
    return _titleData;
}


- (void)viewDidLoad {
   
    [self requestData];
     self.automaticallyCalculatesItemWidths = YES;
    [super viewDidLoad];
   
   
}

-(void)requestData
{
    NSDictionary *paras = @{
                          
                        };
    
     NSString *channelInfoList = [NSString stringWithFormat:@"%@/0",findAppPushChannelInfoList];
    
//      / MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:channelInfoList parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
           
            NSArray *dataArray = dic[@"data"];
            NSMutableArray *array=[NSMutableArray array];
            _subscribeArray =[NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
            SubscribeModel *subscribe = [SubscribeModel yy_modelWithDictionary:dic];
           [self.titleData addObject:subscribe.name];
            
            }
//            [_subscribeArray addObjectsFromArray:array];
            NSLog(@"777%lu",self.titleData.count);
            [self reloadData];
            //响应事件
            
        } else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
       
    }];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    return self.titleData.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
 
    return self.titleData[index];
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
//    switch (index) {
//        case 0: return [[WMViewController alloc] init];
//        case 1: return [[WMViewController alloc] init];
//        case 2: return [[WMCollectionViewController alloc] init];
//    }
    
    
   
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
    return CGRectMake(leftMargin+0, 0, self.view.frame.size.width - 2*leftMargin, 44);
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
