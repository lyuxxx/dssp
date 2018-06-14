//
//  RnunbindViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/22.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RnunbindViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "InputAlertView.h"
@interface RnunbindViewController ()<InputAlertviewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITextField *vinField;
@property (nonatomic, copy) NSString *pinName;
@end

@implementation RnunbindViewController
- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"RnunbindViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"RnunbindViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"RnunbindViewController"];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"实名制解绑", nil);
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 2;
//    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
//    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    whiteV.layer.shadowOpacity = 0.2;
//    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(262 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"logo"];
    [whiteV addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(131 * WidthCoefficient);
        make.height.equalTo(99.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    UILabel *intro = [[UILabel alloc] init];
    intro.textAlignment = NSTextAlignmentCenter;
    intro.textColor = [UIColor whiteColor];
    intro.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    intro.text = NSLocalizedString(@"输入车辆VIN号", nil);
    [whiteV addSubview:intro];
    [intro makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(214.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(logo.bottom).offset(24 * HeightCoefficient);
    }];
    
    self.vinField = [[UITextField alloc] init];
    _vinField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _vinField.delegate = self;
//    _vinField.text=kVin?kVin:NSLocalizedString(@"", nil);
    _vinField.text = kVin;
    _vinField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * WidthCoefficient, 22.5 * HeightCoefficient)];
    _vinField.leftViewMode = UITextFieldViewModeAlways;
    _vinField.textColor = [UIColor colorWithHexString:@"#040000"];
    _vinField.font = [UIFont fontWithName:FontName size:16];
    _vinField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入17位VIN号" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:16]}];
    _vinField.layer.cornerRadius = 2;
    _vinField.backgroundColor = [UIColor colorWithHexString:@"#eae9e9"];
    [whiteV addSubview:_vinField];
    [_vinField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(313* WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(intro.bottom).offset(27.5 * HeightCoefficient);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 2;
    [nextBtn setTitle:NSLocalizedString(@"解绑", nil) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(30 * HeightCoefficient);
    }];
}

- (void)nextBtnClick:(UIButton *)sender {
   
    if ([KuserName isEqualToString:@"18911568274"]) {
        InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [popupView initWithTitle:@"当前您为游客账户，不能做此操作" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
        //            InputalertView.delegate = self;
        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview: popupView];
        
        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
            
            if(btn.tag ==100)
            {
                
                
            }
            
        };
        
        
    }
    else
    {
    if (_vinField.text.length !=17) {
        
        [MBProgressHUD showText:NSLocalizedString(@"请输入17位VIN号", nil)];
        
    }
    else if (_vinField.text.length == 17)
    {
        
        InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [InputalertView initWithTitle:@"请输入PIN码" img:@"警告" type:11 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"取消",@"确定", nil] ];
        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview: InputalertView];
        InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
            if (btn.tag == 100) {//左边按钮
                
            }
            if(btn.tag ==101)
            {
                
                self.pinName =str;
                InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                [InputalertView initWithTitle:@"是否解绑？" img:@"警告" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"取消",@"确定", nil] ];
                UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                [keywindow addSubview: InputalertView];
                InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                    
                    if (btn.tag == 100) {//左边按钮
                        
                    }
                    if(btn.tag ==101)
                    {
                        
                        NSDictionary *paras = @{
                                                @"vin": _vinField.text,
                                                @"pin": _pinName
                                                };
                        [CUHTTPRequest POST:removeRnrWithVhl parameters:paras success:^(id responseData) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                            
                            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                                
                                [MBProgressHUD showText:NSLocalizedString(@"实名制解绑成功", nil)];
                                
                                //实名制解绑成功，合同有效期为空
                                NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                                [defaults1 setObject:@"" forKey:@"contractStatus"];
                                [defaults1 synchronize];
                                
                              
                                
                            } else {
                                
                                [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                                
                            }
                        } failure:^(NSInteger code) {
                            [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
                        }];
                        
                    }
                    
                    //右边按钮
                    NSLog(@"666%@",str);
                    
                    
                };
            }
            
        };
        

    }
    
    }
    
    
    
//    if (![_vinField.text isEqualToString:@""]) {
//        
//        
//        
//        //         [self loadAlertView:@"请输入PIN码" contentStr:nil btnNum:2 btnStrArr:[NSArray arrayWithObjects:@"取消",@"确定", nil] type:11];
//        
//        
//        //        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"是否确定将\"光谷广场\"位置发送到车" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]}];
//        //        NSRange range = [@"是否确定将\"光谷广场\"位置发送到车" rangeOfString:@"光谷广场"];
//        //        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:172.0/255.0 green:0 blue:66.0/255.0 alpha:1] range:range];
//        InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        [InputalertView initWithTitle:@"请输入PIN码" img:@"警告" type:11 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"取消",@"确定", nil] ];
//        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
//        [keywindow addSubview: InputalertView];
//        InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
//            if (btn.tag == 100) {//左边按钮
//                
//            }
//            if(btn.tag ==101)
//            {
//                
//                self.pinName =str;
//                InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//                [InputalertView initWithTitle:@"是否解绑？" img:@"警告" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"取消",@"确定", nil] ];
//                UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
//                [keywindow addSubview: InputalertView];
//                InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
//                    
//                    if (btn.tag == 100) {//左边按钮
//                        
//                    }
//                    if(btn.tag ==101)
//                    {
//                      
//                NSDictionary *paras = @{
//                                        @"vin": _vinField.text,
//                                        @"pin": _pinName
//                                        };
//                [CUHTTPRequest POST:removeRnrWithVhl parameters:paras success:^(id responseData) {
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//                        
//                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//                               
//                      [MBProgressHUD showText:NSLocalizedString(@"实名制解绑成功", nil)];
//                        
//                        } else {
//                        
//                        [MBProgressHUD showText:[dic objectForKey:@"msg"]];
//                        
//                            }
//                        } failure:^(NSInteger code) {
//                        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
//                                }];
//
//                    }
//
//                    //右边按钮
//                    NSLog(@"666%@",str);
//                    
//                    
//                };
//            }
//            
//        };
//        
//
//    } else {
// 
//        
//        [MBProgressHUD showText:NSLocalizedString(@"请输入VIN号", nil)];
//    }
}


-(void)didClickButtonAtIndex:(NSUInteger)index password:(NSString *)password{
    switch (index) {
        case 101:
            NSLog(@"%@",password);
            
            NSLog(@"Click ok");
            break;
        case 100:
            NSLog(@"Click cancle");
            
            break;
        default:
            break;
    }
}


#pragma mark - UITextFieldDelegate -
//vin号大写
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseString]];
        return NO;
    }
    
    return YES;
}

@end
