//
//  NicknameViewController.m
//  dssp
//
//  Created by qinbo on 2018/2/12.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "NicknameViewController.h"
#import "UserModel.h"
@interface NicknameViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *phoneField;
@property (nonatomic,strong)UIButton *rightBarItem;
@property(nonatomic,strong) UserModel *userModel;
@end

@implementation NicknameViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"昵称";
    [self requestData];
    [self setupUI];
}


-(void)requestData
{
    NSDictionary *paras = @{
                            
                            
                            };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryUser parameters:paras success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            NSDictionary *dic1 = dic[@"data"];
            self.userModel = [UserModel yy_modelWithDictionary:dic1];
            NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
            _phoneField.text = _userModel.nickName?_userModel.nickName:name;
//            [self.tableView reloadData];
            
        } else {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
    }];
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

    
   
    self.phoneField = [[UITextField alloc] init];
//    _phoneField.keyboardType = UIKeyboardTypePhonePad
     _phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20 * WidthCoefficient, 40 * HeightCoefficient)];
 
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    _phoneField.textColor = [UIColor whiteColor];
    _phoneField.delegate = self;
    _phoneField.backgroundColor =  [UIColor colorWithHexString:@"#120F0E"];
    _phoneField.font = [UIFont fontWithName:FontName size:15];
    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"昵称", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_phoneField];
    [_phoneField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20* HeightCoefficient );
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
//                [self.navigationController popToRootViewControllerAnimated:YES];
                UIViewController *viewCtl = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:viewCtl animated:YES];
                
             
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
