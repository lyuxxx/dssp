//
//  MaintainViewController.m
//  dssp
//
//  Created by qinbo on 2018/3/7.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "MaintainViewController.h"

@interface MaintainViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *v;
@end

@implementation MaintainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"保养登记", nil);
    
    _v = [[UIWebView alloc] init]; // 初始化浏览器控件UIWebView
    _v.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _v.delegate=self;
    _v.scrollView.showsVerticalScrollIndicator = NO;
    _v.scrollView.showsVerticalScrollIndicator = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];//创建URL

    NSURLRequest *request = [NSURLRequest requestWithURL:url]; // 定义请求地址
    [self.view addSubview:_v];
    [_v loadRequest:request]; //利用浏览器访问地址
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
