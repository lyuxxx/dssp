//
//  AgreementViewController.m
//  dssp
//
//  Created by qinbo on 2018/3/21.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "AgreementViewController.h"
#import "RegisterViewController.h"
@interface AgreementViewController ()
@property (nonatomic,strong) UITextView *contentlabel;
@end

@implementation AgreementViewController

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"用户协议", nil);
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = NSLocalizedString(@"用户协议", nil);
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont fontWithName:@"SFProDisplay-Medium" size:20];
    topLabel.textColor = [UIColor colorWithHexString:@"#A18E79"];
    //    botLabel.backgroundColor =[UIColor redColor];
    [self.view addSubview:topLabel];
    [topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(30 * HeightCoefficient);
        make.width.equalTo(120);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
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
        make.height.equalTo(kScreenHeight - kNaviHeight-kTabbarHeight-kStatusBarHeight-50);
        make.left.equalTo(15 * WidthCoefficient);
        make.top.equalTo(84 * HeightCoefficient);
        
        
    }];
    
    
    UILabel *botLabel = [[UILabel alloc] init];
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
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 2;
    [nextBtn setTitle:NSLocalizedString(@"同意", nil) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(line.bottom).offset(30 * HeightCoefficient);
    }];
    
}

-(void)nextBtnClick:(UIButton *)btn
{

    [self dismissViewControllerAnimated:NO completion:^{
        self.callBackBlocks(@"同意");
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
