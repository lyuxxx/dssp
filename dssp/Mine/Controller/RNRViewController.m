//
//  RNRViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RNRViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "RNRPhotoViewController.h"
#import "RNRInput.h"
#import <MBProgressHUD+CU.h>
#import <IQUIView+IQKeyboardToolbar.h>

@interface RNRViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *genderField;
@property (nonatomic, strong) UITextField *ownercerttypeField;
@property (nonatomic, strong) UITextField *ownercertidField;
@property (nonatomic, strong) UITextField *ownercertaddrField;
@property (nonatomic, strong) UITextField *servnumberField;

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSArray<NSString *> *genders;
@property (nonatomic, strong) NSArray<NSString *> *certtypes;

@property (nonatomic, strong) NSArray *typeid;
@property (nonatomic, strong) NSArray *mfid;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UITextField *selectedField;

@property (nonatomic, copy) NSString *selectedStr;

@end

@implementation RNRViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    
    _typeid = @[
                NSLocalizedString(@"IDCARD", nil),
                NSLocalizedString(@"OTHERLICENCE", nil),
                NSLocalizedString(@"PASSPORT", nil),
                NSLocalizedString(@"PLA", nil),
                NSLocalizedString(@"POLICEPAPER", nil),
                NSLocalizedString(@"TAIBAOZHENG", nil),
                NSLocalizedString(@"UNITCREDITCODE", nil),
                
                ];
    
    _mfid = @[
                NSLocalizedString(@"M", nil),
                NSLocalizedString(@"F", nil),
               
                ];
    

    
    
    self.navigationItem.title = NSLocalizedString(@"实名制", nil);
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowRadius = 7;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 *WidthCoefficient);
        make.height.equalTo(405 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20.5 * HeightCoefficient);
    }];
    
    UILabel *intro = [[UILabel alloc] init];
    intro.textAlignment = NSTextAlignmentCenter;
    intro.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    intro.text = NSLocalizedString(@"请完成实名制认证", nil);
    [whiteV addSubview:intro];
    [intro makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(214.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    NSArray<NSString *> *titles = @[NSLocalizedString(@"姓名", nil),NSLocalizedString(@"性别", nil),NSLocalizedString(@"证件类型", nil),NSLocalizedString(@"证件号码", nil),NSLocalizedString(@"电话号码", nil),NSLocalizedString(@"证件地址", nil)];
    NSArray *placeHolders = @[NSLocalizedString(@"请填写姓名", nil),NSLocalizedString(@"未选择", nil),NSLocalizedString(@"请选择证件类型", nil),NSLocalizedString(@"请填写证件号码", nil),NSLocalizedString(@"请填写电话号码", nil),NSLocalizedString(@"请填写证件地址", nil)];
    for (NSInteger i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titles[i];
        label.textColor = [UIColor colorWithHexString:@"#040000"];
        label.font = [UIFont fontWithName:FontName size:15];
        [whiteV addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(15 * WidthCoefficient);
            make.top.equalTo((66.5 + 49 * i) * HeightCoefficient);
        }];
        
        UITextField *field = [[UITextField alloc] init];
        field.textColor = [UIColor colorWithHexString:@"#040000"];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        field.font = [UIFont fontWithName:FontName size:15];
        [whiteV addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(label);
            make.left.equalTo(label.right).offset(30 * WidthCoefficient);
            make.width.equalTo(190 * WidthCoefficient);
        }];
        
        if (i < titles.count - 1) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
            [whiteV addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(313 * WidthCoefficient);
                make.height.equalTo(1 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(label.bottom).offset(14 * HeightCoefficient);
            }];
        }
        
        if (i == 0) {
            self.usernameField = field;
        } else if (i == 1) {
            self.genderField = field;
            self.genderField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ac0042"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        } else if (i == 2) {
            self.ownercerttypeField = field;
        } else if (i == 3) {
            self.ownercertidField = field;
        } else if (i == 4) {
            self.servnumberField = field;
        } else if (i == 5) {
            self.ownercertaddrField = field;
        }
    }
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 2;
    [nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
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
    
    self.picker = [[UIPickerView alloc] init];
    _picker.dataSource = self;
    _picker.delegate = self;
    _genderField.inputView = _picker;
    _ownercerttypeField.inputView = _picker;
    
    _genderField.delegate = self;
    _ownercerttypeField.delegate = self;
    
    [_genderField.keyboardToolbar.doneBarButton setTarget:self action:@selector(genderDoneAction:)];
    [_ownercerttypeField.keyboardToolbar.doneBarButton setTarget:self action:@selector(certtypeDoneAction:)];
}

- (void)genderDoneAction:(UIBarButtonItem *)barButton {
    _genderField.text = self.genders[[self.picker selectedRowInComponent:0]];
    
    
}

- (void)certtypeDoneAction:(UIBarButtonItem *)barButton {
    _ownercerttypeField.text = self.certtypes[[self.picker selectedRowInComponent:0]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedField = textField;
    if (textField == _genderField) {
        self.dataSource = self.genders;
        [self.picker reloadAllComponents];
    } else if (textField == _ownercerttypeField) {
        self.dataSource = self.certtypes;
        [self.picker reloadAllComponents];
    }
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataSource[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:self.dataSource[row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)nextBtnClick:(UIButton *)sender {
    if (!self.usernameField.text || [self.usernameField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写姓名", nil)];
        return;
    } else if (!self.genderField.text || [self.genderField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请选择性别", nil)];
        return;
    } else if (!self.ownercerttypeField.text || [self.ownercerttypeField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请选择证件类型", nil)];
        return;
    } else if (!self.ownercertidField.text || [self.ownercertidField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写证件号码", nil)];
        return;
    } else if (!self.servnumberField.text || [self.servnumberField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写电话码", nil)];
        return;
    } else if (!self.ownercertaddrField.text || [self.ownercertaddrField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写证件地址", nil)];
        return;
    }
    RNRInput *rnrInfo = [[RNRInput alloc] init];
    rnrInfo.username = self.usernameField.text;
    rnrInfo.vin = _bingVin;
    rnrInfo.gender = [_mfid objectAtIndex:[self.genders indexOfObject:self.genderField.text]];
    
//    rnrInfo.gender = [NSString stringWithFormat:@"%ld",[self.genders indexOfObject:self.genderField.text]];
    

//    rnrInfo.ownercerttype = [NSString stringWithFormat:@"%ld",[self.certtypes indexOfObject:self.ownercerttypeField.text] + 1];
    
    rnrInfo.ownercerttype = [_typeid objectAtIndex:[self.certtypes indexOfObject:self.ownercerttypeField.text]];
    
    rnrInfo.ownercertid = self.ownercertidField.text;
    rnrInfo.ownercertaddr = self.ownercertaddrField.text;
    rnrInfo.servnumber = self.servnumberField.text;
    RNRPhotoViewController *vc = [[RNRPhotoViewController alloc] init];
    vc.rnrInfo = rnrInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray<NSString *> *)genders {
    if (!_genders) {
        _genders = @[
                     NSLocalizedString(@"男", nil),
                     NSLocalizedString(@"女", nil)
                     ];
    }
    return _genders;
}

- (NSArray<NSString *> *)certtypes {
    if (!_certtypes) {
        _certtypes = @[
                       NSLocalizedString(@"身份证", nil),
                       NSLocalizedString(@"其他", nil),
                       NSLocalizedString(@"护照", nil),
                       NSLocalizedString(@"军官证", nil),
                       NSLocalizedString(@"警官证", nil),
                       NSLocalizedString(@"台湾居民来往大陆通行证", nil),
                       NSLocalizedString(@"统一社会信用代码", nil)
                     
                       ];
    }
    return _certtypes;
}

//- (NSArray<NSString *> *)typeid {
//    if (!_typeid) {
//        _typeid = @[
//                       NSLocalizedString(@"IDCARD", nil),
//                       NSLocalizedString(@"OTHERLICENCE", nil),
//                       NSLocalizedString(@"PASSPORT", nil),
//                       NSLocalizedString(@"PLA", nil),
//                       NSLocalizedString(@"POLICEPAPER", nil),
//                       NSLocalizedString(@"TAIBAOZHENG", nil),
//                       NSLocalizedString(@"UNITCREDITCODE", nil),
//
//                       ];
//    }
//    return _typeid;
//}


- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

@end
