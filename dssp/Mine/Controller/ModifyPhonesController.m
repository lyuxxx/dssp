//
//  ModifyPhonesController.m
//  dssp
//
//  Created by qinbo on 2017/12/26.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ModifyPhonesController.h"

@interface ModifyPhonesController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField * phoneField;
@property (nonatomic, strong) UITextField * phoneCodeField;
@property (nonatomic ,strong) UIButton *authBtn;
@property (nonatomic ,strong) UIButton *determineBtn;
@end

@implementation ModifyPhonesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    
    
    self.navigationItem.title = NSLocalizedString(@"手机号", nil);
    self.view.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(359 * WidthCoefficient);
        make.height.equalTo(217 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(44 * HeightCoefficient);
    }];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"更换手机"];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    logo.backgroundColor = [UIColor redColor];
    logo.clipsToBounds=YES;
    logo.layer.cornerRadius=48 * WidthCoefficient/2;
    [self.view addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(48 * WidthCoefficient);
        make.height.equalTo(48 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    
    
    NSArray *titles = @[
                        
                        NSLocalizedString(@"手机号码", nil),
                        NSLocalizedString(@"验证码", nil)
                        ];
    
    
    
  

    UIView *lastView = nil;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        
        UIView *view1 = [[UIView alloc] init];
        view1.layer.cornerRadius = 4;
        view1.layer.borderWidth = 1;
        view1.layer.borderColor = [[UIColor colorWithHexString:@"#EFEFEF"] CGColor];
        view1.backgroundColor = [UIColor colorWithHexString:@"#F9F8F8"];
        [whiteV addSubview:view1];
    
        
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = [UIColor colorWithHexString:@"#666666"];
        lab1.font = [UIFont fontWithName:FontName size:16];
        lab1.text = titles[i];
        [view1 addSubview:lab1];
        [lab1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(80 * WidthCoefficient);
            make.height.equalTo(22.5 * HeightCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(10 * WidthCoefficient);
            
        }];
        
        UIView *lineview = [[UIView alloc] init];
        lineview.backgroundColor = [UIColor colorWithHexString:@"#D1D1D6"];
        [view1 addSubview:lineview];
        [lineview makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(1 * WidthCoefficient);
            make.height.equalTo(22.5 * HeightCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(89 * WidthCoefficient);
        }];
        
        UITextField *field = [[UITextField alloc] init];
        field.delegate = self;
        field.textColor = [UIColor colorWithHexString:@"#040000"];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        field.font = [UIFont fontWithName:FontName size:15];
        [view1 addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab1.right).offset(10*WidthCoefficient);
            make.width.equalTo(120 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.centerY.equalTo(0);
        }];
        
       
     
        if (i==0) {

            [view1 makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(327 * WidthCoefficient);
                make.height.equalTo(44 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(44 * HeightCoefficient);
            }];

        }
        else
        {
            [view1 makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(327 * WidthCoefficient);
                make.height.equalTo(44 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(lastView.bottom).offset(20 * HeightCoefficient);
            }];
        }
        lastView = view1;
        
        
        if (i==0) {
            self.phoneField =field;
        }
        if (i==1) {
            self.phoneCodeField =field;
            
            self.authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_authBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_authBtn.titleLabel setFont:[UIFont fontWithName:FontName size:16]];
            [_authBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
            [_authBtn setTitleColor:[UIColor colorWithHexString:@"#A18E79"] forState:UIControlStateNormal];
           
            [view1 addSubview:_authBtn];
            [_authBtn makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-10 *WidthCoefficient);
                make.width.equalTo(85 * WidthCoefficient);
                make.height.equalTo(22.5 * HeightCoefficient);
                make.centerY.equalTo(0);
            }];

        }
        
    }
    
 
    self.determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_determineBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _determineBtn.layer.cornerRadius = 2;
    [_determineBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [_determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _determineBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [_determineBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
    [self.view addSubview:_determineBtn];
    [_determineBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(25 * HeightCoefficient);
    }];
}

-(void)BtnClick:(UIButton *)Btn
{
    if (Btn==self.authBtn) {
        
        if (_phoneField.text.length == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"手机号不能为空", nil)];
        }
        else
        {
            
            if ([self valiMobile:_phoneField.text]){
                NSDictionary *paras = @{
                                        @"telephone":_phoneField.text,
                                        @"randomCodeType":@"login"
                                        };
                [CUHTTPRequest POST:getRandomCode parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    // LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [MBProgressHUD showText:NSLocalizedString(@"验证码已发送,请查看短信", nil)];
                        
                        _phoneCodeField.text = dic[@"data"];
                        
                    } else {
                        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                        hud.label.text = [dic objectForKey:@"msg"];
                        [hud hideAnimated:YES afterDelay:1];
                    }
                } failure:^(NSInteger code) {
                    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                    hud.label.text = NSLocalizedString(@"获取验证码失败", nil);
                    [hud hideAnimated:YES afterDelay:1];
                }];
                
                __block NSInteger time = 59; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                
                dispatch_source_set_event_handler(_timer, ^{
                    
                    if(time <= 0){ //倒计时结束，关闭
                        
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置按钮的样式
                            [self.authBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                            [self.authBtn setTitleColor:[UIColor colorWithHexString:@"#A18E79"] forState:UIControlStateNormal];
                            [_authBtn.titleLabel setFont:[UIFont fontWithName:FontName size:11]];
                            self.authBtn.userInteractionEnabled = YES;
                        });
                    }else{
                        
                        int seconds = time % 60;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置按钮显示读秒效果
                            [self.authBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2ds)", seconds] forState:UIControlStateNormal];
                            [self.authBtn setTitleColor:[UIColor colorWithHexString:@"c4b7a6"] forState:UIControlStateNormal];
                            [_authBtn.titleLabel setFont:[UIFont fontWithName:FontName size:11]];
                            self.authBtn.userInteractionEnabled = NO;
                        });
                        time--;
                    }
                });
                dispatch_resume(_timer);
            }
            else
            {
                [MBProgressHUD showText:NSLocalizedString(@"手机号有误", nil)];
            }
        }
        
    }
    
    
    if (Btn==self.determineBtn) {
     
        if (_phoneField.text.length == 0 || _phoneCodeField.text.length == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"手机号或验证码不能为空", nil)];
        }
        else
        {
            if(![self valiMobile:_phoneField.text])
            {
                [MBProgressHUD showText:NSLocalizedString(@"手机号有误", nil)];
                return;
            }
            else if(_phoneCodeField.text.length != 6)
            {
                [MBProgressHUD showText:NSLocalizedString(@"验证码有误", nil)];
                return;
            }
            else
            {
                NSDictionary *paras = @{
                                        @"telephone":_phoneField.text,
                                        @"randomCode":_phoneCodeField.text
                                        
                                        };
                MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                [CUHTTPRequest POST:telephoneLogins parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                   
                    if ([dic[@"code"] isEqualToString:@"200"]) {
                        
                    
                    }
                    else {
                        [hud hideAnimated:YES];
                        [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                        
                    }
                } failure:^(NSInteger code) {
                    [hud hideAnimated:YES];
                    [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
                }];
            }
            
        }
        
        
        
    }
    
    
}

//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile
{
    //    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
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

