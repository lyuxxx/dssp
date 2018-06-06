//
//  UserprotocolViewController.m
//  dssp
//
//  Created by qinbo on 2018/5/23.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "UserprotocolViewController.h"

@interface UserprotocolViewController ()
@property (nonatomic,strong) UITextView *contentlabel;
@end

@implementation UserprotocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"用户协议", nil);
    self.view.clipsToBounds = YES;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.8,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];
    [self setupUI];
}

- (void)setupUI {
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15 * WidthCoefficient);
        make.height.equalTo(kScreenHeight - kNaviHeight-kTabbarHeight-kStatusBarHeight-10);
        make.left.equalTo(15 * WidthCoefficient);
        make.top.equalTo(24 * HeightCoefficient);
    }];
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.textAlignment = NSTextAlignmentCenter;
    botLabel.text = NSLocalizedString(@"DS车联网服务协议", nil);
    
    botLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    botLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    //    botLabel.backgroundColor =[UIColor redColor];
    [line addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(10 * HeightCoefficient);
        make.width.equalTo(180);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ds_service_protocols" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    self.contentlabel =[[UITextView alloc] init];
    _contentlabel.textColor = [UIColor whiteColor];
    _contentlabel.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    _contentlabel.editable = NO;
    //        _contentlabel.attributedText = attributedString;
    _contentlabel.text= content;
    [line addSubview:_contentlabel];
    [_contentlabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0 * WidthCoefficient);
        make.bottom.equalTo(0);
        make.left.equalTo(0 * WidthCoefficient);
        make.top.equalTo(50 * HeightCoefficient);
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
