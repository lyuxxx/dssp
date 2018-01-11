//
//  PrivacypolicyController.m
//  dssp
//
//  Created by qinbo on 2018/1/10.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "PrivacypolicyController.h"
#import <WebKit/WebKit.h>
@interface PrivacypolicyController ()<UIWebViewDelegate>
@property (nonatomic,strong) UITextView *contentlabel;
@property (nonatomic,strong) UIWebView  *webView;
@property (nonatomic,strong) WKWebView  *wkWebView;
@end



@implementation PrivacypolicyController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"条款";
    
    [self setupUI];
}

-(void)setupUI
{
//    _webView = [[UIWebView alloc] init]; // 初始化浏览器控件UIWebView
//    _webView.delegate=self;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"application" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSURL *url = [[NSURL alloc] initWithString:filePath];
////    [self.webView loadHTMLString:htmlString baseURL:url];
//
//    [self.view addSubview:self.webView];
//     [self.webView loadHTMLString:htmlString baseURL:url];
//    [_webView makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(0 * WidthCoefficient);
//                make.bottom.equalTo(0 * HeightCoefficient);
//                make.left.equalTo(0 * WidthCoefficient);
//                make.top.equalTo(0 * HeightCoefficient);;
//            }];
    
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(400.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
        UILabel *explain = [[UILabel alloc] init];
        explain.textAlignment = NSTextAlignmentCenter;
        explain.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        explain.text = NSLocalizedString(@"实名制登记服务协议", nil);
        [whiteV addSubview:explain];
        [explain makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.width.equalTo(214.5 * WidthCoefficient);
            make.height.equalTo(22.5 * HeightCoefficient);
            make.top.equalTo(20 * HeightCoefficient);
        }];
    
    self.contentlabel =[[UITextView alloc] init];

    NSString *htmlString = @"<p>服务协议</p><p>根据国家工业和信息化部《电话用户真实身份信息登记规定》（工业和信息化部令第25号）要求，开通车内上网业务需进行实名制登记。 此门户只针对持有中华人民共和国合法身份证、港澳居民来往内地通行证、台湾居民来往大陆通行证、外国人护照、军官证、警官证， 或其他有效身份证件的车主提供实名制登记服务。如果您没有上述有效证件，请发邮件到shimingzhi@cu-sc.com以完成实名制登记。</p><!--<br/>--><p>In accordance to [Regulations on Real-Name-Registration of Telecom Service Subscribers] (MIIT Doc. #25), real-name-registration must be completed before activating in-car telecommunication services. Currently only the following ID types are supported: PRC Citizen ID, Mainland Travel Permit for Hong Kong and Macao residents, Mainland Travel Permit for Taiwan Residents, foreign passport, military ID, military officer ID. If you cannot provide aforementioned IDs, please contact shimingzhi@cu-sc.com.</p>";
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil] ;
    
    
    _contentlabel.textColor = [UIColor redColor];
    _contentlabel.editable = NO;
    _contentlabel.attributedText = attributedString;
    [whiteV addSubview:_contentlabel];
    [_contentlabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15 * WidthCoefficient);
        make.bottom.equalTo(0 * HeightCoefficient);
        make.left.equalTo(15 * WidthCoefficient);
        make.top.equalTo(62.5 * HeightCoefficient);
    }];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 2;
    [nextBtn setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(24 * HeightCoefficient);
    }];
    
}

-(void)nextBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
