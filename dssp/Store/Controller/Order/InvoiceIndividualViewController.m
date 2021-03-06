//
//  InvoiceIndividualViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "InvoiceIndividualViewController.h"
#import "GFAddressPicker.h"
#import "DKSKeyboardView.h"
@interface InvoiceIndividualViewController ()<GFAddressPickerDelegate,DKSKeyboardDelegate,UITextViewDelegate>
@property (nonatomic, strong) DKSKeyboardView *keyView;
@property (nonatomic, strong) GFAddressPicker *pickerView;
@property (nonatomic ,strong) NSString *province;
@property (nonatomic ,strong) NSString *city;
@property (nonatomic ,strong) NSString *area;

@property (nonatomic ,strong) UIScrollView *sc;
@property (nonatomic ,strong) UITextField *field;

@property (nonatomic, strong) UITextField *invoiceClient;
@property (nonatomic, strong) UITextField *taxNoField;
@property (nonatomic, strong) UITextField *receiverNameField;
@property (nonatomic, strong) UITextField *receiverMobileField;
@property (nonatomic, strong) UITextField *receiverZipField;
@property (nonatomic, strong) UIButton *regionField;
@property (nonatomic, strong) UITextField *AddressField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation InvoiceIndividualViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
}

- (void)setupUI {
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    bg.layer.cornerRadius = 4;
    [self.view addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(378 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(10 * WidthCoefficient);
    }];
    
    NSArray *titles = nil;
    NSArray *righttitles = nil;
    
    titles = @[@"税号",@"发票抬头",@"收货人姓名",@"移动电话",@"邮政编码",@"所在地区",@"详细地址"];
    righttitles = @[@"请填写税号",@"请填写发票抬头",@"请填写收货人姓名",@"请填写移动电话",@"请填写六位邮政编码",@"",@""];
    
    
    self.sc = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [bg addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bg).offset(UIEdgeInsetsMake(0 * HeightCoefficient, 0, 0 * HeightCoefficient, 0));
        }];
        
        UIView *contentView = [[UIView alloc] init];
        [scroll addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.width.equalTo(bg.width);
        }];
        
        UILabel *lastLabel = nil;
        UIView *lastView = nil;
        for (NSInteger i = 0 ; i < titles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = titles[i];
            label.textColor = [UIColor colorWithHexString:@"#A18E79"];
            label.font = [UIFont fontWithName:FontName size:15];
            [contentView addSubview:label];
            
            UIView *whiteV = [[UIView alloc] init];
//                        whiteV.backgroundColor = [UIColor grayColor];
            [contentView addSubview:whiteV];
            
            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
            [contentView addSubview:lineView];
            
            if (i == 0) {
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(80 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(20 *HeightCoefficient);
                    
                }];
                
                [whiteV makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(-15*WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(10*WidthCoefficient);
                    make.top.equalTo(20 *HeightCoefficient);
                }];
                
                
                [lineView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(55 * HeightCoefficient);
                    make.height.equalTo(1);
                    make.left.equalTo(15 * WidthCoefficient);
                    make.right.equalTo(-15 * WidthCoefficient);
                    
                }];
                
            } else {
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(80 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(lastLabel.bottom).offset(31*HeightCoefficient);
                }];
                
                [whiteV makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(-15*WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(10*WidthCoefficient);
                    make.top.equalTo(lastLabel.bottom).offset(31*HeightCoefficient);
                }];
                
                [lineView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastLabel.bottom).offset(15 * HeightCoefficient);
                    make.height.equalTo(1);
                    make.left.equalTo(15 * WidthCoefficient);
                    make.right.equalTo(-15 * WidthCoefficient);
                    
                }];
                
            }
            lastLabel = label;
            lastView = whiteV;
            
            
            self.field = [[UITextField alloc] init];
            _field.font = [UIFont fontWithName:FontName size:15];
            _field.textColor = [UIColor colorWithHexString:@"ffffff"];
            _field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:righttitles[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
            //            _field.userInteractionEnabled=NO;
            //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [whiteV addSubview:_field];
            [_field makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(0 * WidthCoefficient);
                make.right.equalTo(0 * WidthCoefficient);
                make.top.equalTo(0);
                
            }];

            if (i == 0) {
                _field.text = @"";
                self.taxNoField = _field;
                
            }
            else if (i == 1) {
                
                _field.text = @"";
                self.invoiceClient = _field;
                
            }else if (i == 2) {
                
                _field.text = @"";
                self.receiverNameField = _field;
                
            } else if (i == 3) {
                
                _field.text = @"";
                self.receiverMobileField = _field;
                
            }
            else if (i==4)
            {
                _field.text = @"";
                self.receiverZipField =_field;
                
            }

            else if (i == 5) {
                
                self.regionField = [UIButton buttonWithType:UIButtonTypeCustom];
             
                _regionField.titleLabel.font = [UIFont fontWithName:FontName size:16];
                [_regionField setTitle:NSLocalizedString(@"请选择省市区", nil) forState:UIControlStateNormal];
                _regionField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_regionField setTitleColor:[UIColor colorWithHexString:@"#ac0042"] forState:UIControlStateNormal];
                [_regionField addTarget:self action:@selector(regionbtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [whiteV addSubview:_regionField];
                [_regionField makeConstraints:^(MASConstraintMaker *make) {
                    //                        make.centerX.equalTo(whiteV);
                    make.left.equalTo(0 * WidthCoefficient);
                    make.width.equalTo(190 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.top.equalTo(0);
                }];
            }
            else if (i == 6) {
                
//                _field.text = @"";
//                self.AddressField = _field;
//
                
                [whiteV updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(40 * HeightCoefficient);
                }];
                
                self.textView = [[UITextView alloc] init];
                self.textView.backgroundColor = [UIColor clearColor];
                _textView.textColor = [UIColor colorWithHexString:@"#ffffff"];
                self.textView.font = [UIFont fontWithName:FontName size:15];
                self.textView.textAlignment = NSTextAlignmentLeft;
                self.textView.delegate = self;
//                self.textView.scrollEnabled = NO;
                self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                [whiteV addSubview:self.textView];
                [_textView makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(0 * WidthCoefficient);
                    make.right.equalTo(0 * WidthCoefficient);
                    make.top.equalTo(0);
                }];
                
                self.label = [[UILabel alloc] init];
                _label.text = NSLocalizedString(@"请填写详细地址", nil);
                _label.font = [UIFont fontWithName:FontName size:15];
                _label.textColor = [UIColor colorWithHexString:@"#999999"];
                //    botLabel.backgroundColor =[UIColor redColor];
                [whiteV addSubview:_label];
                [_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(0 * WidthCoefficient);
                    make.top.equalTo(0 * HeightCoefficient);
                    make.width.equalTo(150);
                    make.height.equalTo(20 * HeightCoefficient);
                }];
            
 
            }
    
        }
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastLabel.bottom).offset(0);
            
        }];
        
        scroll;
    });
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:submitBtn];
    submitBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    [submitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    submitBtn.layer.cornerRadius = 4;
    [self.view addSubview:submitBtn];
    [submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * WidthCoefficient);
        make.centerX.equalTo(self.view);
        make.top.equalTo(bg.bottom).offset(24 * WidthCoefficient);
    }];
    
    //    [_regionField.keyboardToolbar.doneBarButton setTarget:self action:@selector(genderDoneAction:)];
}

/**
 开始编辑
 @param textView textView
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    _label.hidden =YES;
    
    
    CGRect tmpRect= [textView.text boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    
    CGFloat contentH = tmpRect.size.height;
    NSLog(@"调整后的显示宽,显示高度:%f",contentH);
    if (contentH>30) {
        [_textView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(40* HeightCoefficient);
            make.left.equalTo(0 * WidthCoefficient);
            make.right.equalTo(0 * WidthCoefficient);
            make.top.equalTo(0);
        }];
    }
}

/**
 将要结束编辑
 
 @param textView textView
 
 @return BOOL
 */
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length <1) {
        _label.hidden =NO;
    }
    return YES;
    
}

/**
 结束编辑
 
 @param textView textView
 */
-(void)textViewDidEndEditing:(UITextView *)textView
{

    if (textView.text.length <1) {
         _label.hidden =NO;
    }
    
    CGRect tmpRect= [textView.text boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];

    CGFloat contentH = tmpRect.size.height;
    NSLog(@"调整后的显示宽,显示高度:%f",contentH);
    if (contentH>30) {
        [_textView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(40 * HeightCoefficient);
            make.left.equalTo(0 * WidthCoefficient);
            make.right.equalTo(0 * WidthCoefficient);
            make.top.equalTo(0);
        }];
    }

}


-(void)regionbtnClick:(UIButton *)btn
{
    self.pickerView = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.pickerView updateAddressAtProvince:@"湖北省" city:@"武汉市" town:@"洪山区"];
    self.pickerView.delegate = self;
    self.pickerView.font = [UIFont boldSystemFontOfSize:16];
    //    [self.view addSubview:self.pickerView];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: self.pickerView];
}


-(void)btnClick:(UIButton *)btn
{
    
    if (!_taxNoField.text || [_taxNoField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写税号", nil)];
        return;
    }
    else if (!_invoiceClient.text || [_invoiceClient.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写发票抬头", nil)];
        return;
    }
    else if (!_receiverNameField.text || [_receiverNameField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写收货人姓名", nil)];
        return;
    } else if (!_receiverMobileField.text || [_receiverMobileField.text isEqualToString:@""]||![self valiMobile:_receiverMobileField.text]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写正确的移动电话", nil)];
        return;
    }
    else if (!self.receiverZipField.text || [self.receiverZipField.text isEqualToString:@""]||self.receiverZipField.text.length>6) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写六位邮政编码", nil)];
        return;
    }
    else if (!_province || [_province isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请选择省市区", nil)];
        return;
    }
    else if (!self.textView.text||[self.textView.text isEqualToString:@""]||self.textView.text.length <1)
    {
        [MBProgressHUD showText:NSLocalizedString(@"请填写详细地址", nil)];
        return;
        
    }
    
    NSDictionary *paras = @{
                            @"taxNo":self.taxNoField.text,
                            @"orderId":_companyID,
                            @"invoiceClient":self.invoiceClient.text,
                            @"invoiceType":@"1",
                        @"receiverZip":self.receiverZipField.text, @"receiverName":self.receiverNameField.text,
                            @"receiverMobile":self.receiverMobileField.text,
                            @"receiverState":_province,
                            @"receiverCity":_city,
                            @"receiverDistrict":_area,
                            @"receiverAddress":self.textView.text,
                            };
    [CUHTTPRequest POST:orderinvoice parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        // LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
           
           [MBProgressHUD showText:NSLocalizedString(@"发票信息提交成功", nil)];
//            
//            UIViewController *viewCtl = self.navigationController.viewControllers[1];
//            [self.navigationController popToViewController:viewCtl animated:YES];
          [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
            hud.label.text = [dic objectForKey:@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"提交失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
    }];
}


- (void)GFAddressPickerCancleAction
{
    [self.pickerView removeFromSuperview];
}

- (void)GFAddressPickerWithProvince:(NSString *)province
                               city:(NSString *)city area:(NSString *)area
{
    [self.pickerView removeFromSuperview];
    
    _province = province;
    _city = city;
    _area = area;
    [_regionField setTitle:[NSString stringWithFormat:@"%@ %@ %@",province,city,area] forState:UIControlStateNormal];
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

@end
