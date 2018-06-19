//
//  QueryAlertController.m
//  dssp
//
//  Created by season on 2018/6/15.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "QueryAlertController.h"

//  第一步提示按钮的tag
#define kStepOne 100
//  第二步提示按钮的tag
#define kStepTwo 101

@interface QueryAlertController ()

/** 背景图片*/
@property (nonatomic, strong) UIImageView *backgroundView;

/** 顶部图片*/
@property (nonatomic, strong) UIImageView *topView;

/** 知道了按钮*/
@property (nonatomic, strong) UIButton *knownButton;

/** 取消按钮*/
@property (nonatomic, strong) UIButton *cancelButton;

/** 提示Label*/
@property (nonatomic, strong) UILabel *tipLabel;

/** 注意图片*/
@property (nonatomic, strong) UIImageView *attentionView;

@end

@implementation QueryAlertController

#pragma mark- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

#pragma mark- 搭建界面
- (void)setUpUI {
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        if (Is_Iphone_X) {
            make.height.mas_equalTo(240);
        }else {
            make.height.mas_equalTo(190);
        }
    }];

    [self.view addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.trailing.mas_equalTo(self.view).offset(-16);
        if (Is_Iphone_X) {
            make.top.mas_equalTo(self.view).offset(64);
        }else {
            make.top.mas_equalTo(self.view).offset(30);
        }
    }];

    [self.view addSubview:self.knownButton];
    [self.knownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(52);
        make.trailing.mas_equalTo(self.view).offset(-52);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30 - kBottomHeight);
    }];

    [self.view addSubview:self.attentionView];
    [self.attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(16);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(20);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.attentionView);
        make.leading.mas_equalTo(self.attentionView.mas_trailing).offset(10);
        make.trailing.mas_equalTo(self.view).offset(-16);
    }];
}

#pragma mark- 按钮的点击事件
- (void)dismissAction {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark- 懒加载

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"query_vc_background"]];
    }
    return _backgroundView;
}

- (UIImageView *)topView {
    if (!_topView) {
        NSString *imageName = nil;
        if (Is_Iphone_X) {
            imageName = @"query_vc_head_x";
        }else {
            imageName = @"query_vc_head";
        }
        _topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    return _topView;
}

- (UIButton *)knownButton {
    if (!_knownButton) {
        _knownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knownButton setTitle:NSLocalizedString(@"知道了", nil) forState:UIControlStateNormal];
        _knownButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _knownButton.backgroundColor = [UIColor colorWithHexString:@"#A18E79"];
        [_knownButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
        _knownButton.layer.cornerRadius = 4;
        _knownButton.layer.masksToBounds = YES;
    }
    return _knownButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"query_vc_cacel"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.numberOfLines = 0;
        NSString *text = nil;
        if (self.tag == kStepOne) {
            text = NSLocalizedString(@"如果提交的实名信息超过2个小时未成功，\n请联系400人工客服处理", nil);
        }else if (self.tag == kStepTwo) {
            text = NSLocalizedString(@"如果车辆激活超过2个小时未成功,请尝试以下操作：\n1.在户外启动车辆十分钟\n2.拨打400人工客服处理", nil);
        }else {
            
        }
        _tipLabel.text = text;
    }
    return _tipLabel;
}

- (UIImageView *)attentionView {
    if (!_attentionView) {
        _attentionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realName_tip"]];
    }
    return  _attentionView;
}


@end
