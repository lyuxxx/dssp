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
//            NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
            _phoneField.text = _userModel.nickName;
//            [self.tableView reloadData];
            
        } else {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
        [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
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
    
    [_phoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    
    if (_phoneField.text.length==0) {
         [MBProgressHUD showText:@"昵称不能为空"];
    }
   
    else
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
            
            [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
        }];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    //最大长度
    NSInteger kMaxLength = 10;
    
    if (textField == self.phoneField) {
        kMaxLength = 10;
    }else{
        kMaxLength = 11;
    }
    
    
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        
        UITextRange *selectedRange = [textField markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            
            if (toBeString.length > kMaxLength) {
                
                textField.text = [toBeString substringToIndex:kMaxLength];
                [textField resignFirstResponder];
                
            }
            
        }
        
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLength) {
            
            textField.text = [toBeString substringToIndex:kMaxLength];
            
        }
        
    }
    
    
    
    
    
    
//    if (textField == self.phoneField) {
//        if (_phoneField.text.length > 10) {
//        UITextRange *markedRange = [textField markedTextRange];
//        if (markedRange) {
//                　　 return;
//                　　　 }
//            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
//            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
//            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:15];
//            textField.text = [textField.text substringToIndex:range.location];
//        }
//    }
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
