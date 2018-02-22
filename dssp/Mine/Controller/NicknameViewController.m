//
//  NicknameViewController.m
//  dssp
//
//  Created by qinbo on 2018/2/12.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "NicknameViewController.h"

@interface NicknameViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *phoneField;
@property (nonatomic,strong)UIButton *rightBarItem;
@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"昵称";
    [self setupUI];
}

-(void)setupUI
{
    self.rightBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBarItem setTitle:@"保存" forState: UIControlStateNormal];
//    [_rightBarItem setTitle:@"完成" forState: UIControlStateSelected];
    _rightBarItem.titleLabel.font = [UIFont fontWithName:FontName size:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarItem];
    [_rightBarItem addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarItem makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(64 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
    }];

    
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    self.phoneField = [[UITextField alloc] init];
//    _phoneField.keyboardType = UIKeyboardTypePhonePad
     _phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20 * WidthCoefficient, 40 * HeightCoefficient)];
    _phoneField.text = name;
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    _phoneField.textColor = [UIColor grayColor];
    _phoneField.delegate = self;
    _phoneField.backgroundColor =  [UIColor whiteColor];
    _phoneField.font = [UIFont fontWithName:FontName size:15];
    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"昵称", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_phoneField];
    [_phoneField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(60* HeightCoefficient );
        make.left.equalTo(0 * WidthCoefficient);
        make.height.equalTo(40 * HeightCoefficient);
        make.right.equalTo(0 * WidthCoefficient);
    }];
   
}

-(void)BtnClick
{
        NSDictionary *paras = @{
                               @"nickName":_phoneField.text
                                };
        [CUHTTPRequest POST:updateNickNameByUserName parameters:paras success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_phoneField.text forKey:@"nickName"];
                [defaults synchronize];
                
                [MBProgressHUD showText:@"保存成功"];
             
            } else {
                
                [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                
            }
        } failure:^(NSInteger code) {
            
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
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
